#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")

display_cols() {
    local n=1
    local options=()
    while read -r lines
    do
         options+=("${n}" "${lines}")
        ((n++))
    done < <(head -n 1 "$file" | tr "," "\n")
    whiptail --title "COLUMN NAMES" --msgbox "List of columns:\n\n${options[*]}" 15 80
}

display_cols
