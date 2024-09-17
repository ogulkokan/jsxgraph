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

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Find all text files in the input directory and concatenate them into a single output file
echo "Merging all text files from $INPUT_DIR into $OUTPUT_FILE..."

find "$INPUT_DIR" -type f -name "*.txt" -print0 | while IFS= read -r -d '' file; do
    echo "Processing: $file"
    # Remove empty lines and reduce multiple consecutive newlines to a single newline
    sed '/^$/d' "$file" | sed -e '/./b' -e :n -e 'N;s/\n$//;tn' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"  # Add a single newline between files
done

# Remove any trailing newlines at the end of the file
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$OUTPUT_FILE"

# Check if the merged file is empty and notify the user
if [ ! -s "$OUTPUT_FILE" ]; then
    echo "No text files were found to merge, or all files were empty."
else
    echo "Merge complete: $OUTPUT_FILE"
    echo "Total size: $(du -h "$OUTPUT_FILE" | cut -f1)"
fi

# Usage example:
# ./merge_txt_files.sh ./input_folder ./output_folder/merged.txt