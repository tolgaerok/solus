#!/bin/bash
# Tolga Erok
# WTF GITHUB SETUP

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
git rebase --continue
git pull origin main
git push origin main

# git commit --amend


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
# Step 1: Configure Git with User Details
git config --global user.email "kingtolga@gmail.com"
git config --global user.name "Tolga Erok"
cd /home/tolga/Documents/MyGit
git remote set-url origin git@github.com:tolgaerok/solus.git

# Navigate to the Git directory
GIT_DIR="/home/tolga/Documents/MyGit"
cd "$GIT_DIR" || { echo "Cannot change directory to $GIT_DIR"; exit 1; }

# Check if Git repository is already initialized
if [ ! -d ".git" ]; then
    # Step 2: Initialize Git if not already initialized
    git init
    
    # Step 3: Set Default Branch Name
    git config --global init.defaultBranch main
    
    # Step 4: Add and Commit Files
    # For demonstration purposes, let's create a sample file and commit it
    echo "Initial commit" > README.md
    git add -A   # Add all files
    git commit -m "Initial commit"
fi

# Step 5: Check for SSH Key
if [ ! -f ~/.ssh/id_ed25519 ]; then
    # Generate a new SSH key pair
    ssh-keygen -t ed25519 -C "kingtolga@gmail.com" -f ~/.ssh/id_ed25519 -q -N ""
    
    # Start SSH agent if not running
    eval "$(ssh-agent -s)"
    
    # Add SSH private key to SSH agent
    ssh-add ~/.ssh/id_ed25519
    
    # Output the public key
    cat ~/.ssh/id_ed25519.pub
    
    # Inform user to add SSH key to GitHub
    echo "Please add the above SSH key to your GitHub account."
fi

# Step 6: Ensure Remote 'origin' exists and set URL to SSH
if ! git remote | grep -q '^origin$'; then
    # Add remote 'origin' with SSH URL
    git remote add origin git@github.com:tolgaerok/solus.git
fi

# Step 7: Push to Remote Repository
# Set upstream and push to 'main' branch
echo "Pushing changes to remote repository..."
git push -u origin main

# Step 8: Verify on GitHub
# Automatically open GitHub repository in default web browser
xdg-open https://github.com/tolgaerok/solus.git
