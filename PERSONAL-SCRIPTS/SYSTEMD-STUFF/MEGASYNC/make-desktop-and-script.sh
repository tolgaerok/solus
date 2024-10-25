#!/bin/bash
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
