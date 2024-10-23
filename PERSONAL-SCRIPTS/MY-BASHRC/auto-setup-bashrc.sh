#!/bin/bash
# Tolga Erok
# version 2

GITHUB_BASHRC_URL="https://raw.githubusercontent.com/tolgaerok/solus/main/PERSONAL-SCRIPTS/MY-BASHRC/bashrc"
LOCAL_BASHRC="$HOME/.bashrc"
TMP_BASHRC="/tmp/tolga_github_bashrc/bashrc"

mkdir -p /tmp/tolga_github_bashrc

# Download the bashrc from GitHub
echo "Downloading bashrc from GitHub..."
curl -sL $GITHUB_BASHRC_URL -o $TMP_BASHRC

# Check if the download was successful
if [ -f "$TMP_BASHRC" ]; then
    echo "Download successful. Checking differences..."

    # Check for diff between local bashrc and GitHub bashrc
    if ! diff "$TMP_BASHRC" "$LOCAL_BASHRC" >/dev/null 2>&1; then
        echo "Differences found. Appending GitHub bashrc to the local .bashrc..."

        # Append to the user's local .bashrc
        cat "$TMP_BASHRC" >>"$LOCAL_BASHRC"

        echo "Appended successfully to $LOCAL_BASHRC."
    else
        echo "No differences found. The local .bashrc is up to date."
    fi

    # Source the updated .bashrc to load the new settings
    echo "Sourcing the updated .bashrc..."
    source "$LOCAL_BASHRC" || {
        echo "Failed to source .bashrc"
        exit 1
    }
    echo "bashrc sourced successfully."
else
    echo "Failed to download the bashrc from GitHub!"
    exit 1
fi
