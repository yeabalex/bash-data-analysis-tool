#!/bin/bash

#Column counter
fileAdress=tempAdd.txt
counter=0
while  read -r line;
do
        ((counter++))
done < file.txt

echo "$counter"

