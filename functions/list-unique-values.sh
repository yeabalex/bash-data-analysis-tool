#!/bin/bash

# Source the main script containing the menu function
#source ../app.sh

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")
output_file="$script_dir/../output/output.txt"

# Function to display rows (categories) to choose from
display_rows() {
    local n=1
    local options=()

    while read -r lines
    do
         options+=("${n}" "${lines}")
        ((n++))
    done < <(head -n 1 "$file" | tr "," "\n")

    export choice=$(whiptail --title "Get unique item" --menu "Choose category" 15 80 6 "${options[@]}" 3>&1 1>&2 2>&3)
}

# Function to extract unique values for the chosen category
get_unique_values() {
    # Extract values for the chosen category and sort them
    values=$(awk -F '[,;]' -v choice="$choice" 'NR > 1 {print $choice}' "$file" | sort -n)
    n=0
    counter=1
    temp=$(head -n 1 <<< "$values")
    export unique_values=()

    # Loop through the values to find unique ones
    while read -r value
    do
        if [ "$n" -eq 0 ]; then
            ((n++))
        else
            if [ "$temp" != "$value" ] && [ "$n" -eq 1 ]; then
                unique_values+=("${counter}" "$temp")
                temp=$value
                n=1
                ((counter++))
            elif [ "$temp" != "$value" ]; then
                n=1
                temp="$value"
            else
                ((n++))
            fi
        fi
    done <<< "$values"
   

    last=$(tail -n 1 <<< "$values")
    last1=$(tail -n 2 <<< "$values" | head -n 1)
    
    if [ $last != $last1 ]; then
	    unique_values+=("${counter}" "$last")
    fi
}

# Function to display unique values for the chosen category
display_unique_values() {
    detail=$(whiptail --title "Unique value/s for ${choice}" --menu "Select for detail" 15 80 6 "${unique_values[@]}" 3>&1 1>&2 2>&3)
    echo -e "${unique_values[@]}\n" >> "$output_file"
}

while true; do
    display_rows

    # Check if the user canceled the operation
    if [ -z "$choice" ]; then
        break
    fi

    get_unique_values
    display_unique_values
done
