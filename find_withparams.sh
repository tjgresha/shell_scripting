#!/bin/bash

# Constants
REMOTE_USER="user"                # Replace with the remote username
REMOTE_HOST="remote_server"       # Replace with the remote server hostname or IP
SSH_KEY="~/.ssh/id_rsa"           # Path to your SSH private key
START_DIR="/path/to/start"        # Directory to start the search
SEARCH_STRING="search_string"     # String to search for in file names

# Execute the find command on the remote server and get the oldest file
ssh -i "${SSH_KEY}" "${REMOTE_USER}@${REMOTE_HOST}" "
    find ${START_DIR} -type f -name '*${SEARCH_STRING}*' -printf '%T@ %p\n' | 
    sort -n | 
    head -n 1 | 
    awk '{print \$2}'
" || {
    echo "Failed to execute the command on the remote server."
    exit 1
}
