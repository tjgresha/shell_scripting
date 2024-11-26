#!/bin/bash

# Remote execution to find and sort files by pattern
PATTERNS=("*.txt" "*.log" "*error*")
REMOTE_HOST="user@remote_host"
FOLDER="/path/to/folder"

for PATTERN in "${PATTERNS[@]}"; do
    echo "Processing pattern: $PATTERN"

    # Get sorted list of matching files for the pattern
    OUTPUT=$(ssh $REMOTE_HOST "find $FOLDER -type f -name '$PATTERN' -printf '%T@ %p\n' 2>/dev/null | sort -n")
    
    # Convert OUTPUT into an array of file paths
    FILES=($(echo "$OUTPUT" | awk '{print $2}'))
    
    # Check the current number of matching files
    FILE_COUNT=${#FILES[@]}
    echo "Found $FILE_COUNT files for pattern $PATTERN."

    # Delete files until only 21 remain
    for ((i=0; i<FILE_COUNT-21; i++)); do
        echo "Deleting: ${FILES[i]}"
        ssh $REMOTE_HOST "rm -f '${FILES[i]}'"
    done

    # Confirm remaining files
    REMAINING=$(ssh $REMOTE_HOST "find $FOLDER -type f -name '$PATTERN' | wc -l")
    echo "$REMAINING files remain for pattern $PATTERN."
    echo
done

echo "File pruning complete."
