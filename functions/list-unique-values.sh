#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")

display_rows() {
    local n=1
    local options=()
    while read -r lines
    do
         options+=("${n}" "${lines}")
        ((n++))
    done < <(head -n 1 "$file" | tr "," "\n")
    choice=$(whiptail --title "Get unique item" --menu "Choose catagory" 20 70 15 "${options[@]}" 3>&1 1>&2 2>&3)
}

display_rows