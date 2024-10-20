#!/bin/bash

# Prompt for CIFS server location
read -p "Enter the CIFS server location (e.g., //192.168.0.14/documents): " CIFS_SERVER

# Prompt for mount point name
read -p "Enter the name for the mount point (e.g., MINT): " MOUNT_POINT_NAME
MOUNT_POINT="/mnt/$MOUNT_POINT_NAME"

# Prompt for fstab file location
read -p "Enter the /etc/fstab file location (default: /etc/fstab): " FSTAB_FILE
FSTAB_FILE=${FSTAB_FILE:-/etc/fstab}

# Variables
CREDENTIALS_FILE="/etc/samba/credentials"
BOOKMARKS_FILE="$HOME/.config/gtk-3.0/bookmarks"
USER_UID=$(id -u tolga)
GROUP_GID=$(getent group samba | cut -d: -f3)

# Check if the samba group exists
if [ -z "$GROUP_GID" ]; then
  echo "The 'samba' group does not exist. Please create it or use an existing group."
  exit 1
fi

FILE_MODE="0777"
DIR_MODE="0777"
VERS="3.0"

# Create mount point directory in /mnt
sudo mkdir -p $MOUNT_POINT

# Ensure the credentials file exists, or create it
if [ ! -f $CREDENTIALS_FILE ]; then
  echo "Credentials file does not exist at $CREDENTIALS_FILE."
  read -p "Enter SMB username: " SMB_USERNAME
  read -s -p "Enter SMB password: " SMB_PASSWORD
  echo
  sudo bash -c "echo 'username=$SMB_USERNAME' > $CREDENTIALS_FILE"
  sudo bash -c "echo 'password=$SMB_PASSWORD' >> $CREDENTIALS_FILE"
  sudo chmod 600 $CREDENTIALS_FILE
  echo "Credentials file created at $CREDENTIALS_FILE with permissions set to 600."
fi

# Add CIFS mount to /etc/fstab
sudo bash -c "echo '$CIFS_SERVER $MOUNT_POINT cifs credentials=$CREDENTIALS_FILE,uid=$USER_UID,gid=$GROUP_GID,file_mode=$FILE_MODE,dir_mode=$DIR_MODE,vers=$VERS,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s 0 0' >> $FSTAB_FILE"

# Mount the CIFS share
echo "Mounting $CIFS_SERVER to $MOUNT_POINT..."
sudo mount -t cifs $CIFS_SERVER $MOUNT_POINT -o credentials=$CREDENTIALS_FILE,uid=$USER_UID,gid=$GROUP_GID,file_mode=$FILE_MODE,dir_mode=$DIR_MODE,vers=$VERS -v

# Check if the mount was successful
if mount | grep $MOUNT_POINT >/dev/null; then
  echo "Successfully mounted $CIFS_SERVER to $MOUNT_POINT."
else
  echo "Failed to mount $CIFS_SERVER to $MOUNT_POINT."
  exit 1
fi

# Add to Nautilus bookmarks
if ! grep -q "file://$MOUNT_POINT" $BOOKMARKS_FILE; then
  echo "file://$MOUNT_POINT $MOUNT_POINT_NAME" >>$BOOKMARKS_FILE
  echo "Added $MOUNT_POINT to Nautilus bookmarks."
fi

# Restart Nautilus
nautilus -q

# Ensure the proper permissions
sudo chown -R tolga:samba $MOUNT_POINT
echo "Set ownership for $MOUNT_POINT to tolga:samba."

echo "Setup complete."
