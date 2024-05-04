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
    export choice=$(whiptail --title "Get unique item" --menu "Choose catagory" 15 80 6 "${options[@]}" 3>&1 1>&2 2>&3)
}

get_unique_values() {
    values=$(awk -F '[,;]' -v choice="$choice" 'NR > 1 {print $choice}' "$file" | sort -n)
    n=0
    counter=1
    temp=$(head -n 1 <<< "$values")
    export unique_values=()
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

    #echo "${unique_values[@]}"
}

display_unique_values() {
    detail=$(whiptail --title "Unique value/s for ${choice}" --menu "Select for detail" 15 80 6 "${unique_values[@]}" 3>&1 1>&2 2>&3)
}

display_rows
get_unique_values
display_unique_values