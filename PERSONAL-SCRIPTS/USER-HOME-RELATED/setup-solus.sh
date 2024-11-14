#!/bin/bash
# Tolga Erok
# 21 Jun 2024
# Personal Solus setup script...

clear

# Assign a color variable based on the RANDOM number
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
ORANGE='\e[1;93m'
NC='\e[0m'
YELLOW='\e[1;33m'
NC='\e[0m'

# Template
# display_message "[${GREEN}✔${NC}]
# display_message "[${RED}✘${NC}]

# Function to display messages
display_message() {
    clear
    echo -e "\n                  Tolga's Personal Solus setup\n"
    echo -e "\e[34m|--------------------\e[33m Currently configuring:\e[34m-------------------|"
    echo -e "|${YELLOW}==>${NC}  $1"
    echo -e "\e[34m|--------------------------------------------------------------|\e[0m"
    echo ""

}

display_message "Extra fonts for VSCODE terminal..."
mkdir -p ~/.local/share/fonts
ln -s ~/.local/share/fonts/ ~/.fonts
cd ~/.fonts 
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
tar -xvf Hack.tar.xz

# 'Cascadia Code', 'Droid Sans Mono', 'monospace','Hack Nerd Font',monospace

sleep 3

# Function to append content to a file if it doesn't exist
append_if_not_exists() {
    local file="$1"
    local content="$2"

    # Check if the content exists in the file
    if ! grep -qF "$content" "$file"; then
        echo "$content" >>"$file"
    fi
}

# Function to apply CAKE qdisc to an interface
apply_cake_qdisc() {
    local interface=$1
    local bandwidth=$2
    echo -e "${BLUE}Configuring interface ${interface} with bandwidth ${bandwidth}...${NC}"
    if sudo tc qdisc replace dev "$interface" root cake bandwidth "$bandwidth"; then
        echo -e "${YELLOW}Successfully configured CAKE qdisc on ${interface} with bandwidth ${bandwidth}.${NC}"
    else
        echo -e "${RED}Failed to configure CAKE qdisc on ${interface}.${NC}"
    fi
}

apply_templates() {
    # Define the template directory
    TEMPLATE_DIR="$HOME/Templates"

    # Create the template directory if it doesn't exist
    mkdir -p "$TEMPLATE_DIR"

    # Create blank text document
    touch "$TEMPLATE_DIR/Document.txt"

    # Create blank Word document
    touch "$TEMPLATE_DIR/Document.docx"

    # Create blank Excel spreadsheet
    touch "$TEMPLATE_DIR/Spreadsheet.xlsx"

    # Create blank configuration file
    touch "$TEMPLATE_DIR/Config.conf"

    # Create blank markdown file
    touch "$TEMPLATE_DIR/Document.md"

    # Create blank shell script
    touch "$TEMPLATE_DIR/Script.sh"

    # Create blank Python script
    touch "$TEMPLATE_DIR/Script.py"

    # Create blank JSON file
    touch "$TEMPLATE_DIR/Document.json"

    # Create blank YAML file
    touch "$TEMPLATE_DIR/Document.yaml"

    # Create blank HTML file
    touch "$TEMPLATE_DIR/Document.html"

    # Create blank CSS file
    touch "$TEMPLATE_DIR/Document.css"

    # Create blank JavaScript file
    touch "$TEMPLATE_DIR/Document.js"

    # Print a message indicating completion
    echo "Template documents created in $TEMPLATE_DIR"

}

apply_samba() {
    display_message "[${GREEN}✔${NC}] Setting up smb and nmb for system"
    echo -e "\\033[34;1mCreate SMB user and SMB group\\033[0m"
    echo -e "\\033[34;1mBy \\033[33mTolga Erok\\033[0m"

    # Function to read user input and prompt for input
    prompt_input() {
        read -p "$1" value
        echo "$value"
    }

    # Create user/group

    # Prompt for the desired username and group for Samba
    sambausername=$(prompt_input $'\nEnter the USERNAME to add to Samba: ')
    sambagroup=$(prompt_input $'\nEnter the GROUP name to add username to Samba: ')

    echo ""

    # Create Samba user and group
    sudo groupadd "$sambagroup"
    sudo useradd -m "$sambausername"
    sudo smbpasswd -a "$sambausername"
    sudo usermod -aG "$sambagroup" "$sambausername"
    sudo smbpasswd -e "$sambausername"

    sleep 1
    # Location of private Samba folder
    shared_folder="/home/SolusOS"
    echo ""

    # Create and configure the shared folder
    echo -e "\\033[34;1m ¯\_(ツ)_/¯ \\033[0m Setting up private Samba folder \n"

    sudo mkdir -p "$shared_folder"
    sudo chgrp "$sambagroup" "$shared_folder"
    sudo chmod 0757 "$shared_folder"
    sudo chown -R "$sambausername":"$sambagroup" "$shared_folder"

    # Pause and continue
    echo -e "\nContinuing..."
    read -r -n 1 -s -t 1
    sleep 1
    sudo systemctl enable --now smb
    sudo systemctl enable --now nmb
    sudo systemctl restart smb
    sudo systemctl restart nmb

}

apply_solus_tweaks() {

    clear

    display_message "[${GREEN}✔${NC}] Setting up tweaks for Solus"

    # Install lsd dependencies
    sudo eopkg up
    sudo eopkg it lsd

    display_message "[${GREEN}✔${NC}] Setting up bore scheduler"
    sudo sysctl -w kernel.sched_bore=1
    sudo mkdir -p /etc/sysctl.d
    echo "kernel.sched_bore=1" | sudo tee /etc/sysctl.d/85-bore.conf
    sleep 2

    # Check zram
    if [ -e /dev/zram0 ]; then
        echo
        echo "Zram is active."
        sleep 1
    else
        echo
        echo "Zram is not active."
        sleep 2
    fi

    echo

    # Check zswap parameters
    zswap_enabled=$(cat /sys/module/zswap/parameters/enabled)
    echo "zswap.enabled = $zswap_enabled"
    echo "Checking zswap status"
    if [ "$zswap_enabled" = "Y" ]; then
        echo "Zswap is active."
        sleep 2
        echo
    else
        echo "Zswap is not active."
        echo
        sleep 2
    fi

    display_message "[${GREEN}✔${NC}]Setting up kernel tweaks"
    sleep 2

    KERNEL_PARAMS="io_delay=none rootdelay=0 iomem=relaxed mitigations=off"

    # Personal conf file to be created
    KERNEL_PARAMS_FILE="/etc/kernel/cmdline.d/custom-kernel-parm.conf"

    # Check if the file custom-kernel-parm.conf exists
    if [ ! -f "$KERNEL_PARAMS_FILE" ]; then

        # If file custom-kernel-parm.conf doesn't exist, create it and add kernel parameters
        echo "$KERNEL_PARAMS" | sudo tee "$KERNEL_PARAMS_FILE" >/dev/null
        echo "Kernel parameters added to $KERNEL_PARAMS_FILE."

    else
        # If file custom-kernel-parm.conf exists, check if parameters are already present
        if grep -q "$KERNEL_PARAMS" "$KERNEL_PARAMS_FILE"; then
            echo "Kernel parameters are already present in $KERNEL_PARAMS_FILE."
            sleep 1.5
        else
            # Append KERNEL_PARAMS varible / parameters if not already present
            echo "$KERNEL_PARAMS" | sudo tee -a "$KERNEL_PARAMS_FILE" >/dev/null
            echo "Kernel parameters appended to $KERNEL_PARAMS_FILE."
            sleep 2
        fi
    fi

    # Change file permissions to 777
    sudo chmod 777 "$KERNEL_PARAMS_FILE"

    # Update Solus clr-boot-manager
    sudo clr-boot-manager update

    # Have to reboot
    display_message "[${GREEN}✔${NC}]Reboot to see changes"
    echo "Kernel parameters updated. YOU MUST REBBOT to see changes"
    echo "After reboot, in terminal, type:"
    echo "cat /proc/cmdline"
    echo
    echo "You should see something similar to mine:"
    echo
    echo "initrd=\EFI\com.solus-project\initrd-com.solus-project.current.6.8.12-293 root=PARTUUID=da153e7e-871c-4e58-baee-d755786b0d63 quiet splash rw nvidia-drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1 nvidia.NVreg_TemporaryFilePath=/var/tmp io_delay=none rootdelay=0 threadirqs irqaffinity noirqdebug iomem=relaxed mitigations=off zswap.enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=10 zswap.zpool=zsmalloc"

    sleep 3

    # Apply sysctl changes
    sudo clr-boot-manager set-timeout 3
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    sudo sysctl --system

    # Update clr-boot-manager
    sudo clr-boot-manager update

    echo
    cat /sys/block/sda/queue/scheduler
    echo
    sysctl net.ipv4.tcp_congestion_control
    echo
    display_message "[${GREEN}✔${NC}]Finished, reboot"
    echo "Solus configuration files created and changes applied. You may need to reboot for the changes to take effect."
}

apply_solus_tweaks
apply_samba
apply_templates

# Colors for output
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo "Script executed successfully.
Thankyou for using my script"
sleep 3
