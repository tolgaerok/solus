#!/bin/bash
# Tolga Erok
# 24 oct 2024
# Make systemD megasync starter

SERVICE_FILE="$HOME/.config/systemd/user/megasync.service"

# Create configuration
cat <<EOF >"$SERVICE_FILE"
[Unit]
Description=MEGAsync with my container f40
After=graphical.target

[Service]
ExecStart=/bin/bash -c 'if [ "\$XDG_SESSION_TYPE" = "wayland" ]; then \
    export XDG_RUNTIME_DIR="/run/user/\$(id -u)"; \
    export WAYLAND_DISPLAY="wayland-0"; \
else \
    export DISPLAY=":0"; \
fi; \
distrobox-enter --name f40 -- megasync'
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# Enable the service's
systemctl --user enable megasync.service
systemctl --user start megasync.service
systemctl --user status megasync.service

echo "MEGAsync service created and started successfully!"
