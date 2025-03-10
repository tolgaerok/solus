# MegaSync Woes


* Location: `/home/tolga/.config/autostart/`

```bash
[Desktop Entry]
Type=Application
Version=1.0
Name=MEGAsync
Comment=Sync with MEGA cloud
# Exec=bash -c "sleep 5 && /home/tolga/start_megasync.sh"
# Exec=env -i HOME=$HOME DISPLAY=:1 XAUTHORITY=$HOME/.Xauthority bash -c "/home/tolga/start_megasync.sh"
Exec=bash -c "sleep 1 && xhost +SI:localuser:tolga && /home/tolga/start_megasync.sh"
Icon=mega
Terminal=false
StartupNotify=false
X-GNOME-Autostart-Delay=1
```

* Location: `/home/tolga/`

```bash
#!/bin/bash
# Start MEGAsync inside Distrobox
# Tolga Erok - 2024

LOGFILE="$HOME/megasync.log"
echo "Starting MEGAsync at $(date)" >> "$LOGFILE"

# set display
if [ -z "$DISPLAY" ]; then
    export DISPLAY=":1"
fi

export XAUTHORITY="$HOME/.Xauthority"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"  # Fix XDG_RUNTIME_DIR issue, thanks solus

echo "DISPLAY=$DISPLAY" >> "$LOGFILE"
echo "XAUTHORITY=$XAUTHORITY" >> "$LOGFILE"
echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >> "$LOGFILE"
echo "--------------------------------------------------------------------- " >> "$LOGFILE"

# access to fucking X11
xhost +SI:localuser:tolga >> "$LOGFILE" 2>&1
distrobox-enter --name f40 -- bash -c "export DISPLAY=$DISPLAY; export QT_QPA_PLATFORM=xcb; megasync" >> "$LOGFILE" 2>&1 &

```

* Must Do the following:
```bash
touch ~/megasync.log
chmod 644 ~/megasync.log
chmod +x /home/tolga/start_megasync.sh
chmod +x ~/.config/autostart/megasync.desktop
```

#

* Log File Output:

```bash
Starting MEGAsync at Mon Mar 10 10:23:04 AWST 2025
DISPLAY=:1
XAUTHORITY=/home/tolga/.Xauthority
glx: failed to create dri3 screen
failed to load driver: nouveau
error: XDG_RUNTIME_DIR is invalid or not set in the environment.
glx: failed to create dri3 screen
failed to load driver: nouveau
---------------------------------------------------------------------
Starting MEGAsync at Mon 10 Mar 2025 10:32:13 AWST
DISPLAY=:1
XAUTHORITY=/home/tolga/.Xauthority
XDG_RUNTIME_DIR=/run/user/1000
localuser:tolga being added to access control list
Starting container...                   	[32m [ OK ]
[0mInstalling basic packages...            	[32m [ OK ]
[0mSetting up devpts mounts...             	[32m [ OK ]
[0mSetting up read-only mounts...          	[32m [ OK ]
[0mSetting up read-write mounts...         	[32m [ OK ]
[0mSetting up host's sockets integration...	[32m [ OK ]
[0mIntegrating host's themes, icons, fonts...	[32m [ OK ]
[0mSetting up distrobox profile...         	[32m [ OK ]
[0mSetting up sudo...                      	[32m [ OK ]
[0mSetting up user's group list...         	[32m [ OK ]
[0m
Container Setup Complete!
Avoiding wayland
```