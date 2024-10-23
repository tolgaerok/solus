#!/bin/bash
# Tolga Erok
# Version 2

GITHUB_BASHRC_URL="https://raw.githubusercontent.com/tolgaerok/solus/main/PERSONAL-SCRIPTS/MY-BASHRC/bashrc"
LOCAL_BASHRC="$HOME/.bashrc"
TMP_BASHRC="/tmp/tolga_github_bashrc/bashrc"

# Create temporary directory for the downloaded bashrc
mkdir -p /tmp/tolga_github_bashrc

# Download the bashrc from GitHub
echo "Downloading bashrc from GitHub..."
curl -sL $GITHUB_BASHRC_URL -o $TMP_BASHRC

# Check if the download was successful
if [ -f "$TMP_BASHRC" ]; then
    echo "Download successful. Checking if it's already in the local .bashrc..."

    # Check if the GitHub bashrc content is already in the user's local .bashrc
    if ! grep -Fxq "$(cat $TMP_BASHRC)" "$LOCAL_BASHRC"; then
        echo "Content not found in local .bashrc. Appending..."

        # Append user's local .bashrc
        cat "$TMP_BASHRC" >> "$LOCAL_BASHRC"

        echo "Appended successfully to $LOCAL_BASHRC."
    else
        echo "Content already exists in the local .bashrc. No changes made."
    fi

    # Source the updated .bashrc to load the new settings
    echo "Sourcing the updated .bashrc..."
    source "$LOCAL_BASHRC" || { echo "Failed to source .bashrc"; exit 1; }
    echo "bashrc sourced successfully."
else
    echo "Failed to download the bashrc from GitHub!"
    exit 1
fi
