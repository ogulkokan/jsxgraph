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

# Function to convert HTML to Markdown
convert_html_to_md() {
    local html_file="$1"
    local output_file="$OUTPUT_DIR/${html_file#$INPUT_DIR/}"
    local md_file="${output_file%.html}.md"

    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$md_file")"

    echo "Converting $html_file to $md_file..."
    pandoc -f html -t markdown "$html_file" -o "$md_file"
}

# Export the function and variables for use with 'find'
export -f convert_html_to_md
export INPUT_DIR
export OUTPUT_DIR

# Find all HTML files in the input directory and convert them
find "$INPUT_DIR" -type f -name "*.html" -exec bash -c 'convert_html_to_md "$0"' {} \;

#./convert_html_to_md.sh /Users/og/development/projects/personal/jsxgraph-1/tmp/docs ./output_folder