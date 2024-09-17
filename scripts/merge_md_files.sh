#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_folder output_file"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_FILE="$2"

# Ensure the output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Find all Markdown files in the input directory and concatenate them into a single output file
echo "Merging all Markdown files from $INPUT_DIR into $OUTPUT_FILE..."

find "$INPUT_DIR" -type f -name "*.md" -exec cat {} + > "$OUTPUT_FILE"

# Check if the merged file is empty and notify the user
if [ ! -s "$OUTPUT_FILE" ]; then
    echo "No Markdown files were found to merge, or all files were empty."
else
    echo "Merge complete: $OUTPUT_FILE"
fi

#./merge_md_files.sh ./output_folder2 ./output_folder2/merged.md