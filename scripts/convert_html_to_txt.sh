#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_folder output_folder"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Function to convert HTML to Plain Text
convert_html_to_txt() {
    local html_file="$1"
    local output_file="$OUTPUT_DIR/${html_file#$INPUT_DIR/}"
    local txt_file="${output_file%.html}.txt"

    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$txt_file")"

    echo "Converting $html_file to $txt_file..."
    pandoc -f html -t plain "$html_file" -o "$txt_file"
}

# Export the function and variables for use with 'find'
export -f convert_html_to_txt
export INPUT_DIR
export OUTPUT_DIR

# Find all HTML files in the input directory and convert them
find "$INPUT_DIR" -type f -name "*.html" -exec bash -c 'convert_html_to_txt "$0"' {} \;

# Usage example:
# ./convert_html_to_txt.sh /Users/og/development/projects/personal/jsxgraph-1/tmp/docs /path/to/output_folder
