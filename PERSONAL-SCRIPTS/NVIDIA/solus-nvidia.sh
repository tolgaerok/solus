#!/bin/bash
# tolga erok
# 10/3/25

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Update system
pacman -Syu --noconfirm

# Detect NVIDIA GPU
GPU_VENDOR=$(lspci | grep -i nvidia)
if [[ -z "$GPU_VENDOR" ]]; then
    echo "No NVIDIA GPU detected. Exiting..." >&2
    exit 1
fi

echo "NVIDIA GPU detected. Proceeding with installation..."

# Install necessary packages
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings nvidia-dkms linux-headers

# Enable persistence mode for NVIDIA drivers
echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_EnableMSI=1" > /etc/modprobe.d/nvidia.conf

# Generate initramfs
mkinitcpio -P

# Blacklist Nouveau driver
echo "blacklist nouveau" > /etc/modprobe.d/blacklist-nouveau.conf

# Enable NVIDIA services
systemctl enable nvidia-persistenced.service

# Configure Xorg (if using X11)
if [[ -d /etc/X11/xorg.conf.d ]]; then
    cat << EOF > /etc/X11/xorg.conf.d/20-nvidia.conf
Section "Device"
    Identifier "NVIDIA GPU"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration" "True"
EndSection
EOF
fi

echo "NVIDIA driver installation completed! Reboot for changes to take effect."
