#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")
output_file="$script_dir/../output/output.txt"

sort_file_based_on_column() {
    local file="$1"
    local max_cols=$(head -n 1 "$file" | tr ',' '\n' | wc -l)

    export choice=$(whiptail --title "Sort based on column" --inputbox "Enter column number (1-$max_cols):" 10 60 3>&1 1>&2 2>&3)

    # Check if the user canceled or didn't input anything
    if [ $? -eq 0 ]; then
        # Check if the choice is within the valid range
        if [ "$choice" -ge 1 ] && [ "$choice" -le "$max_cols" ]; then
            local sorted_file=$(sort -t',' -k"$choice" -n "$file")
            echo -e "$sorted_file\n" >> "$output_file"
        else
            whiptail --title "Error" --msgbox "Invalid column number. Please enter a number between 1 and $max_cols." 10 60
        fi
    else
        echo "You canceled."
    fi
}
    sort_file_based_on_column "$file"
  