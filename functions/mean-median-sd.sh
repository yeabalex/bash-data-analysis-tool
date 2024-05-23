#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")

file=$(echo "$file" | tr -d '[:space:]')
output_file="$script_dir/../output/output.txt"

# Function to display numeric columns
display_numeric_columns() {

    declare -a allcols=()
    declare -a numeric_columns=()

    cols=$(awk -F '["'\'',;\t]' '{for (i=1; i<=NF; i++) print $i}' "$file" | awk '!seen[$0]++')
    vals=$(awk -F '["'\'',;\t]' 'NR==2 {for (i=1; i<=NF; i++) print $i}' "$file")

    while read -r column; do
        allcols+=( "$column" )
    done <<< "$cols"

    flag=0
    export idkWhatToNameThis=()

    while read -r val; do
        val=$(echo "$val" | tr -d '[:space:]')
        if [[ $val =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            idkWhatToNameThis+=("$flag")
        fi
        ((flag++))
    done <<< "$vals"

    n=0
    for idk in "${idkWhatToNameThis[@]}"; do
        corresponding_columns="${idkWhatToNameThis[n]}"
        ((corresponding_columns++))
        numeric_columns+=("$corresponding_columns" "${allcols[idk]}")
        ((n++))
    done

    export choice_for_detail=$(whiptail --title "All Numeric Columns" --menu "Select a column to get mean and median" 15 60 6 "${numeric_columns[@]}" 3>&1 1>&2 2>&3) 
}

# Function to calculate the mean of the selected numeric column
# Function to calculate the mean of the selected numeric column
get_mean() {
    # Calculate mean using awk
    mean_and_count=$(awk -F '["'\'',;\t]' -v choice="$choice_for_detail" 'NR>1 {sum+=$choice; count++} END {print sum/count, count, sum}' "$file")
    # Extract mean, count, and sum for other purposes
    mean=$(echo "$mean_and_count" | awk '{printf "%.5f", $1}')
    count=$(echo "$mean_and_count" | awk '{print $2}')
    sum=$(echo "$mean_and_count" | awk '{print $3}')

    # Check if count is zero to avoid division by zero error
    if [ "$count" -eq 0 ]; then
        echo "0"
    else
        echo "$mean"
    fi
}

# Function to calculate the median of the selected numeric column
get_median() {
    median=0
    # Check if count is zero to avoid division by zero error
    if [ "$count" -eq 0 ]; then
        echo "0"
        return
    fi

    # Check if count is even or odd
    if [ $((count % 2)) -eq 0 ]; then
        half=$((count/2))
        half_1=$((half+1))
        # Calculate median for even count
        m1=$(awk -F '["'\'',;\t]' -v choice=$choice_for_detail 'NR>1 {print $choice}' "$file" | sort -n | head -n "$half" | tail -n 1 | tr -d '[:space:]')
        m2=$(awk -F '["'\'',;\t]' -v choice=$choice_for_detail 'NR>1 {print $choice}' "$file" | sort -n | head -n "$half_1" | tail -n 1 | tr -d '[:space:]')
        median=$(echo "scale=5; ($m1 + $m2) / 2" | bc -l)
    else
        # Calculate median for odd count
        half=$(( (count+1) / 2 ))
        median=$(awk -F '["'\'',;\t]' -v choice=$choice_for_detail 'NR>1 {print $choice}' "$file" | sort -n | head -n "$half" | tail -n 1)
    fi

    echo "$median"
}

# Function to calculate the standard deviation of the selected numeric column
get_std_dv() {
    # Calculate the sum of squares of differences from the mean
    sqsm=$(awk -F '["'\'',;\t]' -v choice="$choice_for_detail" 'NR>1 {val=$choice; gsub(/[[:space:]]/, "", val); sum+=(val)^2; count++} END {print sum/count}' "$file")

    # Check if count is zero to avoid division by zero error
    if [ "$count" -eq 0 ]; then
        echo "0"
        return
    fi

    # Calculate standard deviation
    std_dev=$(echo "scale=5; sqrt($sqsm - ($mean)^2)" | bc)
    echo "$std_dev"
}


# Function to display calculated values
display_values() {
    local mean="$1"
    local median="$2"
    local std_dev="$3"

    whiptail --msgbox "Mean: $mean\nMedian: $median\nStandard Deviation: $std_dev" 12 40
    echo -e "Mean: $mean\nMedian: $median\nStandard Deviation: $std_dev\n" >> "$output_file"
}

#CALL DEM
while true; do
    display_numeric_columns
    if [ -z "$choice_for_detail" ]; then
        break
        exit 0
    fi
    get_mean
    get_median
    std_dev=$(get_std_dv)

    display_values "$mean" "$median" "$std_dev"
done