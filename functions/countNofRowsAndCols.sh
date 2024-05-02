#!/bin/bash

# Define the function to count columns
script_dir="$(dirname "$0")"
link=$(<"$script_dir/tempAdd.txt")
column_counter() {
    counter=0
    # Read the file line by line
    while read -r; 
    do
        # Increment the counter for each line
        ((counter++))
    done < "$link"
    # Output the counter value
    echo "$counter"
}

# Define the function to count rows
row_counter() {
	row_count=$(cat $link | head -n 1 | grep -o -E '[,;]' | wc -l)
	if [ $row_count -eq 0 ]; then
		row_count=$(cat $link | head -n 1 | grep -o -E '[\t]' | wc -l)
	fi
	((row_count++))
	echo $row_count
}

# Call the function and print the result
echo "The number of columns: $(column_counter)"
echo "The number of rows: $(row_counter)"

