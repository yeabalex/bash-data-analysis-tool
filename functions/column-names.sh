script_dir="$(dirname "$0")"
file=$(<"$script_dir/tempAdd.txt")
output_file="$script_dir/../output/output.txt"

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

  # Improved redirection to capture column names line by line:
  while IFS= read -r col_name; do
    echo "$col_name" >> "$output_file"
  done < <(head -n 1 "$file" | tr "," "\n")
  echo -e "\n"
}

display_cols
