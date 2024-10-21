#!/bin/bash
# Tolga Erok


# Set up /etc/subuid and /etc/subgid with default values for the current user
USER_NAME=$(whoami)
SUBUID_FILE="/etc/subuid"
SUBGID_FILE="/etc/subgid"

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
sudo groupadd docker; sudo usermod -aG docker $USER

echo "Setup complete! You can now create a distrobox container."

# only inside of distro box
# echo "source /etc/profile" >> ~/.bashrc
# sudo mkdir -p /usr/share/defaults/etc
# sudo ln -s /etc/profile /usr/share/defaults/etc/profile