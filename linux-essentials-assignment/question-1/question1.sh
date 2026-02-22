#!/bin/bash


LOG_FILE="/tmp/directory_log.txt"

PARENT_DIR="$1"

if [ -z "$PARENT_DIR" ]; then
    echo "Please provide parent directory"
    exit 1
fi

if [ ! -d "$PARENT_DIR" ]; then
    echo "Directory does not exist"
    exit 1
fi

echo "Logging started at $(date)" > "$LOG_FILE"

for dir in "$PARENT_DIR"/*/; do
    if [ -d "$dir" ]; then
        echo "Directory: $dir" >> "$LOG_FILE"
        ls "$dir" >> "$LOG_FILE"
        echo "-------------------" >> "$LOG_FILE"
    fi
done

echo "Logging completed"
