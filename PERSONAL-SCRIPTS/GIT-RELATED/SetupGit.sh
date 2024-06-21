#!/bin/bash
# MyGitSetup.sh

# Define variables
REPO_DIR="/home/tolga/Documents/MyGit"
SSH_KEY="~/.ssh/id_ed25519"
GITHUB_REPO="git@github.com:tolgaerok/solus.git"
EMAIL="kingtolga@gmail.com"
USERNAME="Tolga Erok"

# Ensure we're in the correct directory
cd "$REPO_DIR" || { echo "Cannot change directory to $REPO_DIR"; exit 1; }

# Initialize Git repository if not already initialized
if [ ! -d ".git" ]; then
    git init
    echo "# MyGit Project" >> README.md
    git add README.md
    git commit -m "Initial commit"
    git remote add origin "$GITHUB_REPO"
fi

# Set permissions and ownership for .ssh directory and files
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chown tolga:tolga ~/.ssh/config
chown tolga:tolga ~/.ssh/id_ed25519
chown tolga:tolga ~/.ssh/id_ed25519.pub

# Check and add SSH key to the SSH agent
if ! ssh-add -l | grep -q "id_ed25519"; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# Test SSH connection to GitHub
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "SSH connection to GitHub successful."
else
    echo "SSH connection to GitHub failed. Please check your SSH key and permissions."
    exit 1
fi

# Fetch the latest changes from the remote repository
echo "Fetching latest changes from remote repository..."
git fetch origin

# Check if there are conflicts after fetch
if git status | grep -q "Unmerged paths"; then
    echo "Merge conflicts detected after fetch. Please resolve conflicts manually."
    exit 1
fi

# Ensure we are on the main branch
git checkout main

# Handle ongoing rebase if detected
if [ -d ".git/rebase-merge" ]; then
    echo "Existing rebase in progress. Cleaning up..."
    git rebase --abort
fi

# Attempt to pull the latest changes from the remote repository
echo "Pulling latest changes from remote repository..."
if ! git pull --rebase; then
    # Check if pull failed due to conflicts
    if git status | grep -q "Unmerged paths"; then
        echo "Merge conflicts detected during pull. Please resolve conflicts manually."
        exit 1
    else
        echo "Error: Failed to pull changes."
        exit 1
    fi
fi

# Add, commit, and push changes to remote repository
echo "Pushing changes to remote repository..."
git add .
git commit -m "(ツ)_/¯ Edit: $(date)"
git push origin main

# Configure Git with User Details
git config --global user.email "$EMAIL"
git config --global user.name "$USERNAME"

# Ensure Remote 'origin' exists and set URL to SSH
if ! git remote | grep -q '^origin$'; then
    git remote add origin "$GITHUB_REPO"
fi

# Push to Remote Repository
echo "Pushing changes to remote repository..."
git push -u origin main

# Open GitHub repository in default web browser
xdg-open https://github.com/tolgaerok/solus.git

