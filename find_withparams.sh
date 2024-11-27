#!/bin/bash

# Constants
REMOTE="user@remote_server"       # username and remote
SSH_KEY="~/.ssh/id_rsa"           # Path to your SSH private key
START_DIR="/path/to/start"        # Directory to start the search
MAX_FILES=21                      # Maximum number of files to retain + the symlink to latest

# Array of search strings
SEARCH_STRINGS=("search_string1" "search_string2" "search_string3")

# Function to process each search string
process_search_string() {
    local search_string="$1"

    # SSH command to delete oldest files if count exceeds MAX_FILES
    ssh -i "${SSH_KEY}" "${REMOTE}" "
        while [ \$(find ${START_DIR} -type f -name '*${search_string}*' | wc -l) -gt ${MAX_FILES} ]; do
            OLDEST_FILE=\$(find ${START_DIR} -type f -name '*${search_string}*' -printf '%T@ %p\n' | sort -n | head -n 1 | awk '{print \$2}');
            echo \"Deleting: \$OLDEST_FILE\";
            rm -f \"\$OLDEST_FILE\";
        done
    " || {
        echo "Failed to execute the command for search string: ${search_string}."
        exit 1
    }
}

# Iterate through each search string
for search_string in "${SEARCH_STRINGS[@]}"; do
    echo "Processing files matching: *${search_string}*"
    process_search_string "${search_string}"
done
