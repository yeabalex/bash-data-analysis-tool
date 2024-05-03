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
    # Count the number of commas or semicolons in the first line
    row_count=$(cat "$link" | head -n 1 | grep -o -E '[,;]' | wc -l)

    # If no commas or semicolons are found, count the number of tabs instead
    if [ $row_count -eq 0 ]; then
        row_count=$(cat "$link" | head -n 1 | grep -o -E '[\t]' | wc -l)
    fi

    # Increment the row count by 1
    ((row_count++))

    # Output the final row count
    echo "$row_count"
}


# Call the function and print the result
number_of_cols=$(column_counter)
number_of_rows=$(row_counter)

whiptail --msgbox "Number of rows: $number_of_rows\nNumber of column: $number_of_cols" 10 40

