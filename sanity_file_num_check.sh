#!/bin/bash

# Set the overarching directory to the script's location
HOME_DIR="$(dirname "$(realpath "$0")")"

echo "Using overarching directory: $HOME_DIR"

DATA_DIR="$HOME_DIR/BraTS2025_TrainingData/MICCAI-LH-BraTS2025-MET-Challenge-Training/"

# Count the number of folders excluding 'UCSD - Training'
folder_count=$(find "$DATA_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "UCSD - Training" | wc -l)
echo "Number of folders in (excluding 'UCSD - Training'): $folder_count"
echo "Total cases officially: 1296"
echo "Total UCSD cases officially: 646"
echo "So we HAVE all the cases: 1296 - $(($folder_count)) = 646"

# Iterate over each folder, excluding 'UCSD - Training'
for dir in "$DATA_DIR"/*/; do
    folder_name=$(basename "$dir")

    # Skip the 'UCSD - Training' folder
    if [[ "$folder_name" == "UCSD - Training" ]]; then
        continue
    fi

    # Check for the five required files ending with specific suffixes
    required_suffixes=("seg.nii.gz" "t1c.nii.gz" "t1n.nii.gz" "t2f.nii.gz" "t2w.nii.gz")
    missing_files=()

    for suffix in "${required_suffixes[@]}"; do
        if ! ls "$dir"*"$suffix" &>/dev/null; then
            missing_files+=("$suffix")
        fi
    done

    # Report missing files for this folder, if any
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        echo "❌ $folder_name is missing: ${missing_files[*]}"
    fi
done