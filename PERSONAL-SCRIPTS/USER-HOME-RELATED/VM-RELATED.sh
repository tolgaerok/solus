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
atuin register



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

# tolga erok

# curl -sL https://raw.githubusercontent.com/tolgaerok/solus/main/PERSONAL-SCRIPTS/IO-SCHEDULER/io-scheduler.sh | sudo bash

# Create the systemd service file for setting the I/O scheduler
echo "[Unit]
Description=Set I/O Scheduler on boot

[Service]
Type=simple
ExecStart=/bin/bash -c 'echo kyber | sudo tee /sys/block/vda/queue/scheduler; printf \"I/O Scheduler set to: \"; cat /sys/block/vda/queue/scheduler'

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/io-scheduler.service

# Reload systemd, enable, and start the service
sudo systemctl daemon-reload
sudo systemctl enable io-scheduler.service
sudo systemctl start io-scheduler.service
sudo systemctl status io-scheduler.service

# Tolga Erok
# systemd to force CAKE onto any active network interface.
# 26 Oct 2024

YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

# Detect any active network interface (uplink or wireless) and trim leading/trailing spaces
interface=$(ip link show | awk -F: '$0 ~ "^[2-9]:|^[1-9][0-9]: " && $0 ~ "UP" && $0 !~ "LOOPBACK" {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}')

if [ -z "$interface" ]; then
    echo -e "${RED}No active network interface found. Exiting.${NC}"
    exit 1
fi

echo -e "${BLUE}Detected active network interface: ${interface}${NC}"

SERVICE_NAME="apply-cake-qdisc.service"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"

echo -e "${BLUE}Creating systemd service file at ${SERVICE_FILE}...${NC}"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Apply CAKE qdisc to $interface
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/sbin/tc qdisc replace dev $interface root cake bandwidth 1Gbit
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

echo -e "${BLUE}Reloading systemd daemon...${NC}"
sudo systemctl daemon-reload

echo -e "${BLUE}Starting the service...${NC}"
sudo systemctl start $SERVICE_NAME

echo -e "${BLUE}Enabling the service to start at boot...${NC}"
sudo systemctl enable $SERVICE_NAME

echo -e "${BLUE}Verifying qdisc configuration for ${interface}:${NC}"
sudo tc qdisc show dev "$interface"

echo -e "${YELLOW}CAKE qdisc should be applied to ${interface} now.${NC}"

# Show detailed qdisc status for the interface
sudo tc -s qdisc show dev "$interface"

# Check the status of the systemd service
sudo systemctl status apply-cake-qdisc.service

# Add alias to .bashrc for easier access
echo 'alias cake1="interface=\$(ip link show | awk -F: '\''\$0 ~ /^[2-9]:|^[1-9][0-9]:/ && \$0 ~ /UP/ && \$0 !~ /LOOPBACK/ {gsub(/^[ \t]+|[ \t]+$/, \"\", \$2); print \$2; exit}'\''); sudo systemctl daemon-reload; sudo systemctl restart apply-cake-qdisc.service; sudo tc -s qdisc show dev \$interface; sudo systemctl status apply-cake-qdisc.service"' >> ~/.bashrc

echo -e "${YELLOW}Alias 'cake2' added to .bashrc. You can use it to quickly apply CAKE settings.${NC}"

# Tolga Erok
# 15 Oct 2024

# Variables for paths
DESKTOP_ENTRY_PATH="$HOME/.config/autostart/megasync.desktop"
SCRIPT_PATH="$HOME/start_megasync.sh"

# Create the start_megasync.sh script
cat << 'EOF' > "$SCRIPT_PATH"
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
cat << EOF > "$DESKTOP_ENTRY_PATH"
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



distrobox-create --image fedora:40 --name f40

echo "Setup complete! You can now create a distrobox container."

#######################################
# only inside of distro box
#######################################
# echo "source /etc/profile" >> ~/.bashrc
# sudo mkdir -p /usr/share/defaults/etc
# sudo ln -s /etc/profile /usr/share/defaults/etc/profile

