#!/bin/bash
# Tolga Erok
# 21 Jun 2024
# Personal Solus setup script for Samba

# curl -sL https://raw.githubusercontent.com/tolgaerok/solus/main/PERSONAL-SCRIPTS/NETWORK-RELATED/SAMBA/setup-samba.sh | sudo bash
clear

GREEN='\e[1;32m'
NC='\e[0m'
YELLOW='\e[1;33m'

# Function to display messages
display_message() {
    clear
    echo -e "\n                  Tolga's Personal Solus setup\n"
    echo -e "\e[34m|--------------------\e[33m Currently configuring:\e[34m-------------------|"
    echo -e "|${YELLOW}==>${NC}  $1"
    echo -e "\e[34m|--------------------------------------------------------------|\e[0m"
    echo ""
}

apply_samba() {
    display_message "[${GREEN}✔${NC}] Setting up smb and nmb for system"
    echo -e "\\033[34;1mCreate SMB user and SMB group\\033[0m"
    echo -e "\\033[34;1mBy \\033[33mTolga Erok\\033[0m"

    # Function to read user input and ensure it's not empty
    prompt_input() {
        while true; do
            read -p "$1" value
            if [[ -n "$value" ]]; then
                echo "$value"
                break
            else
                echo -e "${RED}Input cannot be empty. Please try again.${NC}"
            fi
        done
    }

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

# execute
apply_samba