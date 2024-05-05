#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")

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
    min_val=$(awk -F '[,;]' -v choice=$choice_for_detail 'NR>1 {print $choice}' "$file" | sort -n | head -n 1)
    max_val=$(awk -F '[,;]' -v choice=$choice_for_detail 'NR>1 {print $choice}' "$file" | sort -n | tail -n 1)
    
    whiptail --msgbox "Minimum value: $min_val\nMaximum value: $max_val" 10 40
}


display_numeric_columns
display_min_and_max_values
