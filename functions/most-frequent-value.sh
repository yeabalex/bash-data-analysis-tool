#!/bin/bash

script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")

# Function to display categories in a menu
display_rows() {
    local n=1
    local options=()

    while read -r lines
    do
         options+=("${n}" "${lines}")
        ((n++))
    done < <(head -n 1 "$file" | tr "," "\n")

    export choice=$(whiptail --title "Get most frequent value" --menu "Choose category" 15 80 6 "${options[@]}" 3>&1 1>&2 2>&3)
}

# Function to find the most frequent value in the chosen category
get_most_frequent_value(){
    frequency=0
    temp_freq=0
    most_frequent_value=""

    values=$(awk -F '[,;]' -v choice="$choice" 'NR > 1 {print $choice}' "$file" | sort -n)
    temp=$(head -n 1 <<< "$values")

    # Iterate over the sorted values and find the most frequent one
    while read -r value; do
        if [ "$value" == "$temp" ]; then
            ((temp_freq++))
        else
            if [ "$temp_freq" -gt "$frequency" ]; then
                frequency=$temp_freq
                most_frequent_value=$temp
            fi
            temp_freq=1
            temp=$value
        fi
    done<<<"$values"

    whiptail --msgbox "Most frequent value is: $most_frequent_value\nFrequency: $frequency" 10 50
}


display_rows
get_most_frequent_value