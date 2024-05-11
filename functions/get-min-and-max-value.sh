#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")
source ../app.sh
# Function to display numeric columns
display_numeric_columns() {
    # Declare arrays to store all columns and numeric columns
    declare -a allcols=() 
    declare -a numeric_columns=()

    # Read the column names from the first line of the file
    cols=$(head -n 1 "$file" | tr "," "\n")
    # Read the values of the second line of the file
    vals=$(sed -n 2p "$file" | tr "," "\n")

    # Populate the array with column names
    while read -r column; do
        allcols+=( "$column" )
    done <<< "$cols"

    # Initialize flag and an array to store the indices of numeric columns
    flag=0
    export idkWhatToNameThis=()

    # Loop through values, check if numeric, and store the index if numeric
    while read -r val; do
        val=$(echo "$val" | tr -d '[:space:]')
        if [[ $val =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            idkWhatToNameThis+=("$flag")
        fi
        ((flag++))
    done <<< "$vals"

    # Loop through the indices of numeric columns and store their names and indices
    n=0
    for idk in "${idkWhatToNameThis[@]}"; do
        corresponding_columns="${idkWhatToNameThis[n]}"
        ((corresponding_columns++))
        numeric_columns+=("$corresponding_columns" "${allcols[idk]}")
        ((n++))
    done

    # Display a menu to select a numeric column
    export choice_for_detail=$(whiptail --title "All Numeric Columns" --menu "Select a column" 15 60 6 "${numeric_columns[@]}" 3>&1 1>&2 2>&3) 
}

# Function to display minimum and maximum values of the selected numeric column
display_min_and_max_values() {
    # Get all values for the selected numeric column
    all_values=$(awk -F '[,;]' -v choice="$choice_for_detail" 'NR>1 {print $choice}' "$file" | sort -n)

    # Find the first non-empty value
    min_val=""
    for val in $all_values; do
        if [ -n "$val" ]; then
            min_val="$val"
            break
        fi
    done

    # If min_val is still empty, there are no non-empty values
    if [ -z "$min_val" ]; then
        whiptail --msgbox "No valid numeric values found for the selected column." 10 40
        return
    fi

    # Get the maximum value
    max_val=$(echo "$all_values" | tail -n 1)

    whiptail --msgbox "Minimum value: $min_val\nMaximum value: $max_val" 10 40
}

export -f display_numeric_columns

while true; do
    display_numeric_columns
    if [ -z "$choice_for_detail" ]; then
        display_menu
        exit 0
    fi
    display_min_and_max_values
done