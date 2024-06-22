#!/bin/bash
# Tolga Erok
# 21 Jun 2024
# Personal Solus setup script..

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

# Ask for the username
display_message "[${GREEN}✔${NC}] User-name required"
echo ""
read -p "Nix package manager wants a username to install the nix package manager to.
Enter Name: " username

# setup nix pkgs on solus
cd /home/$username

display_message "[${GREEN}✔${NC}] Downloading nix pgk manager"

sh <(curl -L https://nixos.org/nix/install) --no-daemon
. /home/$username/.nix-profile/etc/profile.d/nix.sh

display_message "[${GREEN}✔${NC}] Setting up profile PATHS"

# Add the following lines to append export statements to .bashrc
echo "export PATH=\"/home/$username/.nix-profile/bin:\$PATH\"" >>/home/$username/.bashrc
echo ". /home/$username/.nix-profile/etc/profile.d/nix.sh" >>/home/$username/.bashrc

# Try to detect system locale and set locale variables into bashrc
system_locale=$(locale | grep "LANG" | cut -d '=' -f 2)
# echo "export LC_ALL=$system_locale" >> /home/$username/.bashrc
# echo "export LANG=$system_locale" >> /home/$username/.bashrc

sleep 1

display_message "[${GREEN}✔${NC}] Setting up default.nix in $HOME"

# Create a default.nix file in the home directory
echo '{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell { buildInputs = [ pkgs.gum pkgs.direnv pkgs.duf pkgs.fortune pkgs.lolcat ]; }' >/home/$username/default.nix

# Source the modified .bashrc to apply changes without restarting the shell
source /home/$username/.bashrc

nix-env -iA nixpkgs.direnv
nix-env -iA nixpkgs.lolcat
nix-env -iA nixpkgs.fortune
nix-env -iA nixpkgs.duf

sleep 1

display_message "[${GREEN}✔${NC}] Finished"

echo ""
echo "Nix package manager setup and Done"
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

    # Create sysctl configuration file
    # echo 'net.ipv4.tcp_congestion_control = westwood' | sudo tee /etc/sysctl.d/99-custom.conf

    display_message "[${GREEN}✔${NC}] Setting up I/O Scheduler for SSD"

    # Create udev rule for I/O scheduler
    sudo mkdir -p /etc/udev/rules.d/

    # Create udev rule for I/O scheduler
    echo 'ACTION=="add|change", KERNEL=="sda", ATTR{queue/scheduler}="none"' | sudo tee /etc/udev/rules.d/60-scheduler.rules
    sleep 1.5

    # Enable zswap in clr-boot-manager configuration
    # echo 'zswap.enabled=1' | sudo tee -a /etc/kernel/cmdline
    display_message "[${GREEN}✔${NC}]Setting up kernel tweaks"
    sleep 2

    KERNEL_PARAMS="io_delay=none rootdelay=0 threadirqs irqaffinity noirqdebug iomem=relaxed mitigations=off zswap.enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=10 zswap.zpool=zsmalloc"

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

# My personal .bashrc
bashrc_content=$(
    cat <<'EOF'
source /usr/share/defaults/etc/profile

eval "$(direnv hook bash)"
###---------- ALIASES ----------###
# source ~/.bashrc

# echo "" && fortune && echo ""

alias tolga-alert='notify-send --urgency=low "$(history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//")"'
alias tolga-tolga='sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/TolgaFedora39.sh)"'

alias tolga-systcl="sudo /home/tolga/scripts/systcl.sh"

###---------- my tools ----------###
alias tolga-htos="sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh"
alias tolga-mount="sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/MOUNT-ALL.sh"
alias tolga-mse="sudo ~/scripts/MYTOOLS/mse.sh"
alias tolga-stoh="sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh"
alias tolga-umount="sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/UMOUNT-ALL.sh"

###---------- fun stuff ----------###
alias tolga-pics="sxiv -t $HOME/Pictures/CUSTOM-WALLPAPERS/"
alias tolga-wp="sxiv -t $HOME/Pictures/Wallpaper/"

###---------- navigate files and directories ----------###
alias ..="cd .."
alias cl="clear"
alias copy="rsync -P"
alias la="lsd -a"
alias ll="lsd -l"
alias Ls="lsd"
alias ls="ls --color=auto"
alias dir="dir --color=auto"
alias lsla="lsd -la"

# alias chmod commands
alias tolga-000='sudo chmod -R 000'
alias tolga-644='sudo chmod -R 644'
alias tolga-666='sudo chmod -R 666'
alias tolga-755='sudo chmod -R 755'
alias tolga-777='sudo chmod -R 777'
alias tolga-mx='sudo chmod a+x'

# Search command line history
alias tolga-h="history | grep "

# Search running processes
alias tolga-p="ps aux | grep "
alias tolga-topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias tolga-f="find . | grep "

# Alias's for safe and forced reboots
alias tolga-rebootforce='sudo shutdown -r -n now'
alias tolga-rebootsafe='sudo shutdown -r now'

###---------- Tools ----------###
alias rc="source ~/.bashrc && clear && echo "" && fortune | lolcat  && echo """
alias tolga-bashrc='kwrite  ~/.bashrc'
alias tolga-cong="sysctl net.ipv4.tcp_congestion_control"
alias tolga-fmem="echo && echo 'Current mem:' && free -h && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' && echo && echo 'After: ' && free -h"
alias tolga-fmem2="echo && echo 'Current mem:' && free -h && sudo /bin/sh -c '/bin/sync && /sbin/sysctl -w vm.drop_caches=3' && echo && echo 'After: ' && free -h"
alias tolga-fstab="sudo mount -a && sudo systemctl daemon-reload && echo && echo \"Reloading of fstab done\" && echo"
alias tolga-grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg"
alias tolga-io="cat /sys/block/sda/queue/scheduler"
alias tolga-line="echo '## ------------------------------ ##'"
# alias tolga-nvidia="sudo systemctl enable --now akmods --force && sudo dracut --force && echo && echo \"Force akmods and Dracut on nvidia done\" && echo"
alias tolga-nvidia='sudo systemctl enable --now akmods --force && sudo dracut --force && echo && echo "Force akmods and Dracut on NVIDIA done" && echo'

alias tolga-pdfcompress='bash /home/tolga/scripts/pdf1.sh'
alias tolga-samba='echo "Restarting Samba" -- sleep 2 && sudo systemctl enable smb.service nmb.service && sudo systemctl restart smb.service nmb.service'
alias tolga-swapreload="cl && echo && echo 'Turning swap off:' && echo 'Turning swap on:' && tolga-line && sudo swapon --all && sudo swapon --show && echo && echo 'Reload Swap(s):' && tolga-line && sudo mount -a && sudo systemctl daemon-reload && sudo swapon --show && echo && echo 'Free memory:' && tolga-line && free -h && echo && duf && tolga-sys && tolga-fmem"
alias tolga-sys="echo && tolga-io && echo && tolga-cong && echo && echo 'ZSWAP status: ( Y = ON )' && cat /sys/module/zswap/parameters/enabled && systemctl restart earlyoom && systemctl status earlyoom --no-pager"
alias tolga-trim="sudo fstrim -av"
alias tolga-update="sudo dnf5 update && sudo dnf update && flatpak update -y && flatpak uninstall --unused && flatpak uninstall --delete-data && [ -f /usr/bin/flatpak ] && flatpak uninstall --unused --delete-data --assumeyes"
alias tolga-sysctl-reload="sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system && sudo sysctl -p && sudo mount -a && sudo systemctl daemon-reload"

###---------- file access ----------###
alias tolga-bconf="vim ~/.config/bash/.bashrc"
alias tolga-cp="cp -riv"
alias tolga-htos='sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh'
alias tolga-mkdir="mkdir -vp"
alias tolga-mount='sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/MOUNT-ALL.sh'
alias tolga-mse='sudo ~/scripts/MYTOOLS/MAKE-SCRIPTS-EXECUTABLE.sh'
alias tolga-mv="mv -iv"
alias tolga-mynix='sudo ~/.config/MY-TOOLS/assets/scripts/COMMAN-NIX-COMMAND-SCRIPT/MyNixOS-commands.sh'
alias tolga-stoh='sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh'
alias tolga-trimgen='sudo ~/.config/MY-TOOLS/assets/scripts/GENERATION-TRIMMER/TrimmGenerations.sh'
alias tolga-umount='sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/UMOUNT-ALL.sh'
alias tolga-zconf="vim ~/.config/zsh/.zshrc"

alias cj="sudo journalctl --rotate; sudo journalctl --vacuum-time=1s"

alias tolga-batt='clear && echo "Battery: $(acpi -b | awk '\''{print $3}'\'')" && echo '' && echo "Battery Percentage: $(acpi -b | awk '\''{print $4}'\'')" && echo '' && echo "Remaining Time: $(acpi -b | awk '\''{print $5,$6,$7 == "until" ? "until fully charged" : $7}'\'')"'

###---------- session ----------###
alias tolga-sess='session=$XDG_SESSION_TYPE && echo "" && gum spin --spinner dot --title "Current XDG session is: [ $session ] """ -- sleep 2'

###---------- Nvidia session ----------###

export LIBVA_DRIVER_NAME=nvidia              # Specifies the VA-API driver to use for hardware acceleration
export WLR_NO_HARDWARE_CURSORS=1             # Disables hardware cursors for Wayland to avoid issues with some Nvidia drivers
export __GLX_VENDOR_LIBRARY_NAME=nvidia      # Specifies the GLX vendor library to use, ensuring Nvidia's library is used
export __GL_SHADER_CACHE=1                   # Enables the GL shader cache, which can improve performance by caching compiled shaders
export __GL_THREADED_OPTIMIZATION=1          # Enables threaded optimization in Nvidia's OpenGL driver for better performance
export CLUTTER_BACKEND=wayland               # Specifies Wayland as the backend for Clutter
export MOZ_ENABLE_WAYLAND=1                  # Enables Wayland support in Mozilla applications (e.g., Firefox)
export NIXOS_OZONE_WL=1                      # Enables the Ozone Wayland backend for Chromium-based browsers
export NIXPKGS_ALLOW_UNFREE=1                # Allows the installation of packages with unfree licenses in Nixpkgs
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1 # Disables window decorations in Qt applications when using Wayland
export SDL_VIDEODRIVER=wayland               # Sets the video driver for SDL applications to Wayland
export MOZ_DBUS_REMOTE=1
export MOZ_ALLOW_DOWNGRADE=1                 # Don't throw "old profile" dialog box.

###---------- BTRFS TOOLS ----------######
alias tolga-balance-home="sudo btrfs balance start /home && sudo btrfs balance status /home"
alias tolga-balance-root="sudo btrfs balance start / && sudo btrfs balance status /"
alias tolga-scrub-home="sudo btrfs scrub start /home && sudo btrfs scrub status /home"
alias tolga-scrub-root="sudo btrfs scrub start / && sudo btrfs scrub status /"

###---------- Konsole effects ----------###
PS1="\[\e[1;m\]┌(\[\e[1;32m\]\u\[\e[1;34m\]@\h\[\e[1;m\]) \[\e[1;m\]➤\[\e[1;36m\] \W \[\e[1;m\] \n\[\e[1;m\]└\[\e[1;33m\]➤\[\e[0;m\]  "

###---------- Nix package manager ----------###
# export PATH="/home/tolga/.nix-profile/bin:$PATH"
# . /home/tolga/.nix-profile/etc/profile.d/nix.sh

###---------- Vscoding ----------###
# eval "$(direnv hook bash)"

###---------- Solus related ----------###
alias tolga-solus='sudo mount -a && sudo systemctl daemon-reload && sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system'

# Function to generate a random color code
random_color() {
  echo $((16 + RANDOM % 216))
}

# Function to generate a random color code
random_color() {
  echo $((16 + RANDOM % 216))
}

# Define colors
YELLOW=226
WHITE=231
BRIGHT_BLUE=81

# Function to display fortune with random colors
fortune_with_random_colors() {
  local color
  color=$(random_color)
  printf "\033[38;5;%dm%s\033[0m\n" "$color" "$1"
}

# Check if the system is Solus
if [ -f "/usr/bin/eopkg" ]; then
  # Solus system
  #nix-env -iA nixpkgs.lolcat
  #nix-env -iA nixpkgs.fortune
  export PATH="/home/tolga/.nix-profile/bin:$PATH"
  . /home/tolga/.nix-profile/etc/profile.d/nix.sh
  export PATH="/home/tolga/.nix-profile/bin:$PATH"
  export PATH=$PATH:/usr/local/bin/direnv
  export PATH="$HOME/.nix-profile/bin:$PATH"
  export PATH="$HOME/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

  FORTUNE_COMMAND="/home/tolga/.nix-profile/bin/fortune"
else
  # Other distro
  FORTUNE_COMMAND="fortune"
fi

# Fetch the fortune message
fortune_message="$($FORTUNE_COMMAND)"

# Display the fortune message with random colors
#echo "" && fortune_with_random_colors "$fortune_message" && echo ""

# nix-env -iA nixpkgs.fortune
# export NIXPKGS_ALLOW_UNFREE=1 && nix-env -iA nixpkgs.megasync

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

XDG_DESKTOP_DIR="$HOME/"
XDG_DOWNLOAD_DIR="$HOME/"
XDG_DOCUMENTS_DIR="$HOME/"
XDG_MUSIC_DIR="$HOME/"
XDG_PICTURES_DIR="$HOME/"
XDG_VIDEOS_DIR="$HOME/"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"

cl && echo "" && fortune | lolcat && echo ""
#export PATH="/home/tolga/.nix-profile/bin:$PATH"
#. /home/tolga/.nix-profile/etc/profile.d/nix.sh

alias gitup="$HOME/Documents/gitup.sh"

EOF
)

display_message "[${GREEN}✔${NC}]Copying bashrc to user home"
# Append to current user's .bashrc
append_if_not_exists "$HOME/.bashrc" "$bashrc_content"
sleep 1.5

display_message "[${GREEN}✔${NC}]Copying basrc to root"
# Append to root's .bashrc
append_if_not_exists "/root/.bashrc" "$bashrc_content"

display_message "[${GREEN}✔${NC}]Time to apply tweaks"
sleep 1.7

apply_solus_tweaks
apply_samba
apply_templates

# Colors for output
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
NC="\033[0m" # No Color

display_message "[${GREEN}✔${NC}]Time to apply CAKE tweak"
sleep 1.5

# Get a list of all network interfaces (excluding irrelevant ones)
interfaces=$(ip link show | awk -F: '$0 !~ "lo|virbr|docker|^[^0-9]"{print $2;getline}')

# Define bandwidth (adjust as needed or set dynamically)
default_bandwidth="1Gbit"

# Apply CAKE qdisc to each interface
for interface in $interfaces; do
    apply_cake_qdisc "$interface" "$default_bandwidth"
done

# Display the configured qdiscs
for interface in $interfaces; do
    echo -e "${BLUE}Qdisc configuration for ${interface}:${NC}"
    sudo tc qdisc show dev "$interface"
done

# Add net.core.default_qdisc = cake to /etc/sysctl.conf if it doesn't exist
sysctl_conf="/etc/sysctl.conf"
if grep -qxF 'net.core.default_qdisc = cake' "$sysctl_conf"; then
    echo -e "${YELLOW}net.core.default_qdisc is already set to cake in ${sysctl_conf}.${NC}"
else
    echo 'net.core.default_qdisc = cake' | sudo tee -a "$sysctl_conf"
    echo -e "${YELLOW}Added net.core.default_qdisc = cake to ${sysctl_conf}.${NC}"
fi

# Apply the sysctl settings
if sudo sysctl -p; then
    echo -e "${YELLOW}sysctl settings applied successfully.${NC}"
else
    echo -e "${RED}Failed to apply sysctl settings.${NC}"
fi

echo -e "${YELLOW}Traffic control settings applied successfully.${NC}"
echo -e "${YELLOW}net.core.default_qdisc set to cake in /etc/sysctl.conf.${NC}"

# Verification Step
for interface in $interfaces; do
    echo -e "${BLUE}Verifying qdisc configuration for ${interface}:${NC}"
    qdisc_output=$(sudo tc qdisc show dev "$interface")
    if echo "$qdisc_output" | grep -q 'cake'; then
        echo -e "${YELLOW}CAKE qdisc is active on ${interface}.${NC}"
    else
        echo -e "${RED}CAKE qdisc is NOT active on ${interface}.${NC}"
    fi
    echo "$qdisc_output"
done

echo "Script executed successfully.
Thankyou for using my script"
sleep 3
