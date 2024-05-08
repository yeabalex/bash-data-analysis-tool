file=$(whiptail --inputbox "Enter file path: " 8 70 --title "WELCOME TO BASH DATA ANALYST" 3>&1 1>&2 2>&3)

if [ ! -f "$file" ]; then
        echo "File not found"
else
        touch "functions/tempAdd.txt"
        echo "$file" > "functions/tempAdd.txt"
        
# Display the menu
display_menu(){
while true; do
        choice=$(whiptail --title "Please Enter Your Choice" --menu "Choose options you want to perform: " 20 80 6  "1" "Displaying the number of rows and columns in the CSV file." \
                   "2" "Listing unique values in a specified column." \
                   "3" "Column names (header)." \
                   "4" "Minimum and maximum values for numeric columns." \
                   "5" "The most frequent value for categorical columns." \
                   "6" "Calculating summary statistics (mean, median, standard deviation) for numeric columns." \
                   "7" "Filtering and extracting rows and column based on user-defined conditions." \
                   "8" "Sorting the CSV file based on a specific column." \
                   3>&1 1>&2 2>&3)

    if [ -z "$choice" ]; then
        break
        exit 0
    fi
    case ${choice} in
        1)
            bash functions/count-nof-rows-and-cols.sh;;
        2)
            bash functions/list-unique-values.sh;;
        3)
            bash functions/column-names.sh;;
        4)
            bash functions/get-min-and-max-value.sh;;
        5)
            bash functions/most-frequent-value.sh;;
        6)
            echo 6;;
        7)
            echo 7;;
        8)
            echo 8;;
        *)
            break;;
    esac
    done
}
fi
export -f display_menu
display_menu
