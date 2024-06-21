#!/bin/bash

# Ensure we're in the correct directory
cd /home/tolga/Documents/MyGit || exit

# Initialize Git repository if not already initialized
if [ ! -d ".git" ]; then
    git init
    echo "# MyGit Project" >> README.md
    git add README.md
    git commit -m "Initial commit"
    git remote add origin git@github.com:tolgaerok/solus.git
fi

# Check and add SSH key to the SSH agent
if ! ssh-add -l | grep -q "id_ed25519"; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# Set permissions and ownership for .ssh directory and files
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chown tolga:tolga ~/.ssh/config
chown tolga:tolga ~/.ssh/id_ed25519
chown tolga:tolga ~/.ssh/id_ed25519.pub

# Set Git remote to SSH URL
git remote set-url origin git@github.com:tolgaerok/solus.git

# Test SSH connection to GitHub
ssh -T git@github.com

# Fetch the latest changes from the remote repository
echo "Fetching latest changes from remote repository..."
git fetch origin

# Check if the local branch is tracking the remote branch
if [ -z "$(git config --get branch.main.remote)" ]; then
    echo "Setting upstream for the main branch..."
    git branch --set-upstream-to=origin/main main
fi

# Pull the latest changes from the remote repository
echo "Pulling latest changes from remote repository..."
git pull --rebase

# Add, commit, and push changes to remote repository
echo "Pushing changes to remote repository..."
git add .
git commit -m "(ツ)_/¯ Edit: $(date)"
git push origin main
