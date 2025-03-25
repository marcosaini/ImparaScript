# CloudSync

CloudSync is a simple bash script that synchronizes your local folders with your cloud storage.

### Description
This bash script automatically synchronizes a specified local folder with a cloud storage destination whenever a change is detected. It uses `inotifywait` to monitor events such as modifications, creations, deletions, or moves within the local directory. Once an event is detected, the script waits for a defined interval (to allow multiple changes to accumulate) before triggering the synchronization process using `rclone`.

### Requirements
- **rclone:** Must be installed and configured to access your cloud storage.
- **inotify-tools:** Must be installed (e.g., via `sudo apt-get install inotify-tools`) to monitor file system events.
