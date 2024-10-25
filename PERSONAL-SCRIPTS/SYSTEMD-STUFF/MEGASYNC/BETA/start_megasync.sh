#!/bin/bash
# Tolga Erok
# 15 oct 2024

# Detect and export the correct display session for KDE (X11/Wayland)
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    export WAYLAND_DISPLAY="wayland-0"
else
    export DISPLAY=":0"
fi

# Launch MEGAsync inside distrobox f40
distrobox-enter --name f40 -- megasync &

