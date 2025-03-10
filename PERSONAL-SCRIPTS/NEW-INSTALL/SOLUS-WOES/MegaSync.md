# MegaSync Woes

### Do the following
```bash
touch ~/megasync.log
chmod 644 ~/megasync.log
```

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

# access to fucking X11
xhost +SI:localuser:tolga >> "$LOGFILE" 2>&1
distrobox-enter --name f40 -- bash -c "export DISPLAY=$DISPLAY; export QT_QPA_PLATFORM=xcb; megasync" >> "$LOGFILE" 2>&1 &

```