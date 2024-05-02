#!/bin/bash

read -p "Enter file Path: " file

if [ ! -f "$file" ]; then
	echo "File not found"
else
    	echo -e "\t \nWELCOME TO BASH DATA ANALYST :)"

	echo -e "\n 1. Displaying the number of rows and columns in the CSV file. \n 2. Listing unique values in a specified column. \n 3. Column names (header) \n 4. Minimum and maximum values for numeric columns \n 5. The most frequent value for categorical columns \n 6. Calculating summary statistics (mean, median, standard deviation) for 
numeric columns. \n 7. Filtering and extracting rows and column based on user-defined 
conditions. \n 8. Sorting the CSV file based on a specific column. \n"

	read -p "Choose options you want to perform: " choice

case $choice in
	1)
		echo 1;;
	2)
		echo 2;;
	3)
		echo 3;;
	4)
		echo 4;;
	5)
		echo 5;;
	6)
		echo 6;;
	7)
		echo 7;;
	8)
		echo 8;;
esac

fi
