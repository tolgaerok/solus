#!/bin/bash

# Define the remote server IP
REMOTE_SERVER="192.168.0.17"

# Interactive prompt for password
echo -n "Enter password for admin@${REMOTE_SERVER}: "
read -s PASSWORD
echo

# Search for image and ISO files on the remote server
sshpass -p "$PASSWORD" ssh admin@$REMOTE_SERVER << EOF
  echo "Searching for image and ISO files on $REMOTE_SERVER:"
  busybox find /path/to/search \( -iname "*.iso" -o -iname "*.img" \)
EOF
