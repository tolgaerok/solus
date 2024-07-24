# solus
Personal Solus repo
#
Setup git - very painful

```bash
# Generate an SSH key
ssh-keygen -t rsa -b 4096 -C "kingtolga@gmail.com"

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the SSH key to the SSH agent
ssh-add ~/.ssh/id_rsa

# Copy the SSH key to clipboard
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

# Test the SSH connection to GitHub
ssh -T git@github.com

# Set the default branch name to 'main'
git config --global init.defaultBranch main

# Rename the current branch to 'main'
git branch -m main

# Add a remote repository
git remote add origin git@github.com:tolgaerok/solus.git

# Verify the remote URL
git remote -v

```


### About
- Contained in this repo are a collection of my personal scripts to setup and tweak the current solus installation

Run setup-solus.sh located in: 

```bash
PERSONAL-SCRIPTS/USER-HOME-RELATED/setup-solus.sh
```

- To install Flatpak, run the following command in the terminal
```bash
sudo eopkg install flatpak xdg-desktop-portal-gtk
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```
- Install Chrome for solus
```bash
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/web/browser/google-chrome-stable/pspec.xml
sudo eopkg it google-chrome-*.eopkg
```
