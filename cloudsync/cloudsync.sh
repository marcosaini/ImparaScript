#!/bin/bash
# Script to automatically synchronize a local folder with the cloud
# every time a change is detected.
#
# Requirements:
# - rclone installed and configured
# - inotify-tools installed (sudo apt-get install inotify-tools)
#
# Attention!: bisync is in beta 
#
# Set the path of the local folder to monitor
LOCAL_DIR="/home/marco/ProtonDrive"
# Set the remote (remote_name:remote_folder, e.g., "google_drive:backup")
REMOTE_DIR="ProtonDrive:"
# Options for rclone
RCLONE_OPTIONS="--progress --verbose"
# Wait time before syncing to accumulate multiple changes together.
TIME=10

rclone sync   $RCLONE_OPTIONS "$REMOTE_DIR" "$LOCAL_DIR"
rclone bisync $RCLONE_OPTIONS "$LOCAL_DIR" "$REMOTE_DIR" --resync

echo "Monitoring changes in: $LOCAL_DIR"
echo "Waiting for events..."

# Infinite loop that waits for modification, creation, deletion, or movement events
while inotifywait -r -e modify,create,delete,move "$LOCAL_DIR"; do
    echo "Change detected, waiting a moment for additional modifications..."
    sleep $TIME
    echo "Starting synchronization..."
    rclone bisync $RCLONE_OPTIONS "$LOCAL_DIR" "$REMOTE_DIR"
    if [ $? -eq 0 ]; then
        echo "Synchronization completed successfully!"
    else
        echo "Error during synchronization."
    fi
done

