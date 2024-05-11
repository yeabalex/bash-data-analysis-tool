#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")

display_cols() {
    if [ ! -f "$file" ]; then
        whiptail --title "Error" --msgbox "File containing column names not found. Please make sure the file 'tempAdd.txt' exists." 10 70
        exit 1
    elif [ ! -r "$file" ]; then
        whiptail --title "Error" --msgbox "Cannot read from the file containing column names. Please check file permissions." 10 70
        exit 1
    fi

    local n=1
    local options=()
    while read -r lines
    do
        options+=("${n}" "${lines}")
        ((n++))
    done < <(head -n 1 "$file" | tr "," "\n")
    whiptail --title "COLUMN NAMES" --msgbox "List of columns:\n\n${options[*]}\n" 15 80
}
display_cols
