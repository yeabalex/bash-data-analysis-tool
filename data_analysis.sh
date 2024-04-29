#!/bin/bash
#hello
read -p "Enter file Path: " file

if [ ! -f "$file" ]; then
    echo "File not found"
else
    head -10 "$file"
    IFK=","
    echo "File found. IFK is now set to '$IFK'."
fi
