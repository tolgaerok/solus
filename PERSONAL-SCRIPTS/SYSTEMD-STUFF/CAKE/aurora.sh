#!/bin/bash
# Tolga Erok
# systemd to force CAKE onto any active network interface.
# 19 Oct 2024

YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m"

# Detect any active network interface (uplink or wireless) and trim leading/trailing spaces
interface=$(ip link show | awk -F: '$0 ~ "^[2-9]:|^[1-9][0-9]: " && $0 ~ "UP" && $0 !~ "LOOPBACK|NO-CARRIER" {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}')

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
echo "alias cake2='interface=\$(ip link show | awk -F: '\''\$0 ~ \"wlp|wlo|wlx\" && !(\$0 ~ \"NO-CARRIER\") {gsub(/^[ \t]+|[ \t]+$/, \"\", \$2); print \$2; exit}'\''); sudo systemctl daemon-reload && sudo systemctl restart apply-cake-qdisc.service && sudo tc -s qdisc show dev \$interface && sudo systemctl status apply-cake-qdisc.service'" >> ~/.bashrc

echo -e "${YELLOW}Alias 'cake2' added to .bashrc. You can use it to quickly apply CAKE settings.${NC}"
