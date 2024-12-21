#!/bin/bash
# Tolga Erok

USER_NAME=$(whoami)
SUBUID_FILE="/etc/subuid"
SUBGID_FILE="/etc/subgid"

# Set up /etc/subuid and /etc/subgid with default values for the current user
sudo eopkg install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.github.dvlv.boxbuddyrs
sudo eopkg it docker distrobox
sudo systemctl start docker.service
sudo systemctl enable docker.service
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
sudo groupadd docker
sudo usermod -aG docker $USER
sudo flatpak override io.github.dvlv.boxbuddyrs --filesystem=home
wget https://mega.nz/linux/repo/Fedora_40/x86_64/megasync-Fedora_40.x86_64.rpm && sudo dnf install "$PWD/megasync-Fedora_40.x86_64.rpm"
sudo eopkg it podman

flatpak install flathub com.wps.Office
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Set permissions for newuidmap and newgidmap
echo "Setting setuid for /usr/bin/newuidmap and /usr/bin/newgidmap..."
sudo chmod u+s /usr/bin/newuidmap
sudo chmod u+s /usr/bin/newgidmap

# Create /etc/subuid if it doesn't exist
if [ ! -f "$SUBUID_FILE" ]; then
    echo "Creating /etc/subuid with user mappings..."
    echo "$USER_NAME:100000:65536" | sudo tee -a /etc/subuid
else
    echo "/etc/subuid already exists."
fi

# Create /etc/subgid if it doesn't exist
if [ ! -f "$SUBGID_FILE" ]; then
    echo "Creating /etc/subgid with group mappings..."
    echo "$USER_NAME:100000:65536" | sudo tee -a /etc/subgid
else
    echo "/etc/subgid already exists."
fi

# Migrate podman system to apply changes
echo "Running 'podman system migrate'..."
podman system migrate

# Tolga Erok
# 15 Oct 2024

# Variables for paths
DESKTOP_ENTRY_PATH="$HOME/.config/autostart/megasync.desktop"
SCRIPT_PATH="$HOME/start_megasync.sh"

# Create the start_megasync.sh script
cat <<'EOF' >"$SCRIPT_PATH"
#!/bin/bash
# Tolga Erok
# 15 Oct 2024

# Detect and export the correct display session for KDE (X11/Wayland)
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    export WAYLAND_DISPLAY="wayland-0"
else
    export DISPLAY=":0"
fi

# Launch MEGAsync inside distrobox f40
distrobox-enter --name f40 -- megasync &
EOF

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Create the .desktop entry
mkdir -p "$(dirname "$DESKTOP_ENTRY_PATH")" # Ensure the autostart directory exists
cat <<EOF >"$DESKTOP_ENTRY_PATH"
[Desktop Entry]
Type=Application
Exec=$SCRIPT_PATH
Hidden=false
NoDisplay=false
X-KDE-Autostart-enabled=true
Name=MEGAsync
EOF

# Make the .desktop entry executable
chmod +x "$DESKTOP_ENTRY_PATH"

echo "Scripts created and made executable at:"
echo "$SCRIPT_PATH"
echo "$DESKTOP_ENTRY_PATH"

# Tolga Erok
# 23 oct 2024
# Personal Solus setup script...

### Install Linuxbrew on Solus ###
### Thanks to Brian Fransico

sudo pip3 install eopkg3p
sudo eopkg install -c system.devel
sudo eopkg install solbuild

# Install Linuxbrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# Shell Configuration
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.bashrc
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.bashrc
echo >>/home/tolga/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/tolga/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc
brew install direnv

distrobox-create --image fedora:40 --name f40

sudo bash -c "<(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)"

atuin register -u tolga -e kingtolga@gmail.com
atuin key
atuin sync -f
atuin login -u tolga -p ibm450
atuin sync -f
atuin import auto
atuin import bash

brew install lolcat fortune
sudo eopkg install gimp vscode

sudo systemctl enable --now smb
sudo systemctl enable --now nmb
sudo systemctl restart smb
sudo systemctl restart nmb

sudo systemctl enable nmb smb
sudo systemctl restart nmb smb
sudo systemctl restart smb.service nmb.service
sudo systemctl enable wsdd.service
sudo systemctl restart wsdd.service
sudo systemctl daemon-reload
sudo systemctl status wsdd.service

echo "Setup complete! You can now create a distrobox container."

#######################################
# only inside of distro box
#######################################
# echo "source /etc/profile" >> ~/.bashrc
# sudo mkdir -p /usr/share/defaults/etc
# sudo ln -s /etc/profile /usr/share/defaults/etc/profile

# alias cake1="interface=\$(ip link show | awk -F: '\$0 ~ /^[2-9]:|^[1-9][0-9]:/ && \$0 ~ /UP/ && \$0 !~ /LOOPBACK/ {gsub(/^[ \t]+|[ \t]+$/, \"\", \$2); print \$2; exit}'); sudo systemctl daemon-reload; sudo systemctl restart apply-cake-qdisc.service; sudo tc -s qdisc show dev \$interface; nmcli device status && echo "" && sudo systemctl status apply-cake-qdisc.service"
#
