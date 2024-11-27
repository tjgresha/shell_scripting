#!/bin/bash

# Check if the required parameters are provided
if [[ $# -ne 4 ]]; then
    echo "Usage: $0 <user> <remote_host> <start_dir> <search_string>"
    exit 1
fi

# Assign input parameters to variables
REMOTE_USER="$1"
REMOTE_HOST="$2"
START_DIR="$3"
SEARCH_STRING="$4"

# Execute the find command on the remote server and get the oldest file
ssh "${REMOTE_USER}@${REMOTE_HOST}" "
    find ${START_DIR} -type f -name '*${SEARCH_STRING}*' -printf '%T@ %p\n' | 
    sort -n | 
    head -n 1 | 
    awk '{print \$2}'
" || {
    echo "Failed to execute the command on the remote server."
    exit 1
}
