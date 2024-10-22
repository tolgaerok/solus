#!/bin/bash
# Tolga Erok

USER_NAME=$(whoami)
SUBUID_FILE="/etc/subuid"
SUBGID_FILE="/etc/subgid"

echo "Setting setuid for /usr/bin/newuidmap and /usr/bin/newgidmap..."
sudo chmod u+s /usr/bin/newuidmap
sudo chmod u+s /usr/bin/newgidmap

if [ ! -f "$SUBUID_FILE" ]; then
    echo "Creating /etc/subuid with user mappings..."
    echo "$USER_NAME:100000:65536" | sudo tee -a /etc/subuid
else
    echo "/etc/subuid already exists."
fi

if [ ! -f "$SUBGID_FILE" ]; then
    echo "Creating /etc/subgid with group mappings..."
    echo "$USER_NAME:100000:65536" | sudo tee -a /etc/subgid
else
    echo "/etc/subgid already exists."
fi

echo "Running 'podman system migrate'..."
podman system migrate
sudo groupadd docker
sudo usermod -aG docker $USER

echo "Setup complete! You can now create a distrobox container."

# only inside of distro box
# echo "source /etc/profile" >> ~/.bashrc
# sudo mkdir -p /usr/share/defaults/etc
# sudo ln -s /etc/profile /usr/share/defaults/etc/profile
