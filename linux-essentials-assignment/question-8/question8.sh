#!/bin/bash

SEARCH="$1"
REPLACE="$2"
DIR="$3"

if [ -z "$SEARCH" ] || [ -z "$REPLACE" ] || [ -z "$DIR" ]; then
    echo "Usage: ./question8.sh <search> <replace> <directory>"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist"
    exit 1
fi

echo "Searching for '$SEARCH' in $DIR..."

FILES=$(grep -rl "$SEARCH" "$DIR")

if [ -z "$FILES" ]; then
    echo "No matches found."
    exit 0
fi

for file in $FILES; do
    sed -i '' "s|$SEARCH|$REPLACE|g" "$file"
    echo "Modified: $file"
done

echo "Replacement completed successfully."