#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")

display_cols() {
    local n=1
    local options=()

    while read -r line; do
        options+=("${n}" "${line}")
        ((n++))
    done < <(head -n 1 "$file" | tr "," "\n")

    export choice=$(whiptail --title "Extract row from col" --menu "Choose category(Only Numeric)" 15 80 6 "${options[@]}" 3>&1 1>&2 2>&3)
}

process_data() {
    if [ -z "$choice" ]; then
        whiptail --msgbox "No columns selected!" 8 30
        exit 1
    fi

    # Get user input for filter condition (column and value)
    cond=$(whiptail --inputbox "Enter condition to filter by:" 8 40 3>&1 1>&2 2>&3)

    if [ -z "$cond" ]; then
        whiptail --msgbox "No value entered!" 8 30
        exit 1
    fi

    # Filter and extract data using awk
    filtered_data=$(awk -F ',' -v choice="$choice" -v cond="$cond" 'NR > 1 { if ($choice '"$cond"') { print $choice } }' "$file" | sort -n)

    if [ -z "$filtered_data" ]; then
        whiptail --msgbox "No data found matching your criteria!" 8 30
    else
        formatted_data=$(echo "$filtered_data" | awk '{print NR".",$0}')
        count=$(wc -l <<< "$formatted_data" | awk '{print $1}')

        # Sort cors_rows according to the selected column
        sorted_file=$(sort -t',' -k"$choice" -n "$file")

        # Extract names based on the sorted file
        cors_rows=$(echo "$sorted_file" | awk -F',' 'NR>1 {print $1}')

        # Split formatted_data and cors_rows into arrays
        IFS=$'\n' read -r -d '' -a formatted_data_array <<< "$formatted_data"
        IFS=$'\n' read -r -d '' -a cors_rows_array <<< "$cors_rows"

        # Loop through both arrays and print in the desired format
        for ((i=0; i<count; i++)); do
            echo "${formatted_data_array[$i]} - ${cors_rows_array[$i]}"
        done
    fi
}
while true; do
        display_cols
        if [ -z "$choice" ]; then
            break
            exit 0
        fi
        process_data
done