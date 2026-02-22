#!/bin/bash

REMOTE_USER="ec2-user"
REMOTE_IP="13.127.219.49"
KEY="devi-linux.pem"

REMOTE_DIR="/home/$REMOTE_USER/Downloads"
LOCAL_DOWNLOAD_DIR="/Users/deviprasadreddyp-kickdrum/Downloads/linux-essentials-assignment/question-5"

if [ -z "$1" ]; then
    echo "Usage: ./transfer.sh <folder_name>"
    exit 1
fi

LOCAL_DIR="$1"

if [ ! -d "$LOCAL_DIR" ]; then
    echo "Error: Directory '$LOCAL_DIR' does not exist"
    exit 1
fi

ARCHIVE="$(basename "$LOCAL_DIR").tar.gz"

echo "Compressing folder: $LOCAL_DIR"
tar -czvf "$ARCHIVE" "$LOCAL_DIR"

echo "Creating remote directory if not exists..."
ssh -i "$KEY" "$REMOTE_USER@$REMOTE_IP" "mkdir -p $REMOTE_DIR"

echo "Uploading to EC2..."
scp -i "$KEY" "$ARCHIVE" "$REMOTE_USER@$REMOTE_IP:$REMOTE_DIR"

echo "Downloading back to local..."
scp -i "$KEY" "$REMOTE_USER@$REMOTE_IP:$REMOTE_DIR/$ARCHIVE" "$LOCAL_DOWNLOAD_DIR"

echo "Transfer completed successfully!"