#!/bin/bash


script_dir="$(dirname "$0")"


output_file="$script_dir/../output.txt"
node_script="$script_dir/date.js"

# Capture the output of the Node.js script
FILENAME=$(node "$node_script")


touch "${FILENAME}.txt"


cat "$output_file" > "${FILENAME}.txt"
