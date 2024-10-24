#!/bin/bash
# Tolga Erok
# 24 oct 2024

# variables
SERVICE_NAME="megasync.service"
SERVICE_PATH="$HOME/.config/systemd/user/$SERVICE_NAME"

# Create the systemd configuration
cat <<EOF >"$SERVICE_PATH"
[Unit]
Description=MEGAsync with my f40 container
After=graphical.target

[Service]
ExecStart=/bin/bash -c 'if [ "\$XDG_SESSION_TYPE" = "wayland" ]; then export XDG_RUNTIME_DIR="/run/user/\$(id -u)"; export WAYLAND_DISPLAY="wayland-0"; else export DISPLAY=":0"; fi; distrobox-enter --name f40 -- megasync'
Restart=on-failure
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
EOF

# Enable the service's
systemctl --user enable "$SERVICE_NAME"
systemctl --user start "$SERVICE_NAME"
systemctl --user status "$SERVICE_NAME"
