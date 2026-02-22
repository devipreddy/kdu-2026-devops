#!/bin/bash

TARGET_DIR="$1"

find "$TARGET_DIR" -type f ! -name "*.sh" -exec chmod 444 {} \;

find "$TARGET_DIR" -type d -exec chmod 700 {} \;

find "$TARGET_DIR" -type f -name "*.sh" -exec chmod 755 {} \;

echo "Completed Successfully"