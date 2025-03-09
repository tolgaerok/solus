# MegaSync Woes

```bash
[Desktop Entry]
Type=Application
Exec=/home/tolga/start_megasync.sh
Hidden=false
NoDisplay=false
X-KDE-Autostart-enabled=true
Name=Start MEGAsync in Distrobox
```

```bash
#!/bin/bash
# Start MEGAsync inside Distrobox
# Tolga Erok - 2024

export DISPLAY=:0    # Change to :1 if necessary
export XAUTHORITY="$HOME/.Xauthority"

# Launch MEGAsync inside Distrobox
distrobox-enter --name f40 -- bash -c 'export DISPLAY=:0; export QT_QPA_PLATFORM=xcb; megasync' &
```