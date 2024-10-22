#!/bin/bash
# Tolga Erok

# curl -sL https://raw.githubusercontent.com/tolgaerok/solus/main/PERSONAL-SCRIPTS/MY-BASHRC/auto-setup-ram-bashrc.sh | sudo bash

# insert into .bashrc
BASHRC_CONTENT=$(cat << 'EOF'
# Configuration for loading bashrc from RAM
GITHUB_BASHRC_URL="https://raw.githubusercontent.com/tolgaerok/solus/main/PERSONAL-SCRIPTS/MY-BASHRC/bashrc"
RAM_BASHRC="/tmp/tolga_github_bashrc/bashrc"  # Location in RAM, make sure you have setup tmpfs in fstab or system has tmp
mkdir -p /tmp/tolga_github_bashrc
# Download bashrc from my GitHub
echo "Downloading bashrc from GitHub..."
curl -sL $GITHUB_BASHRC_URL -o $RAM_BASHRC
# Source the bashrc from RAM
if [ -f "$RAM_BASHRC" ]; then
    echo "Sourcing bashrc..."
    source "$RAM_BASHRC" || { echo "Failed to source bashrc"; exit 1; }
    echo "Bashrc sourced successfully."
else
    echo "Bashrc file not found in RAM!"
    exit 1
fi
EOF
)

# Define the user's .bashrc file path
USER_BASHRC="$HOME/.bashrc"

# Check for duplication
if ! grep -Fxq "$BASHRC_CONTENT" "$USER_BASHRC"; then
    # Append tto .bashrc
    echo "$BASHRC_CONTENT" >> "$USER_BASHRC"
    echo "The specified alia's have been added to $USER_BASHRC."
else
    echo "The specified alias's already exist in $USER_BASHRC."
fi
