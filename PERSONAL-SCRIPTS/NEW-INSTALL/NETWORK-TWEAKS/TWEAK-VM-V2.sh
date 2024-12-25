#!/bin/bash

# check the sysctl.d directory exists
SYSCTL_DIR="/etc/sysctl.d"
if [ ! -d "$SYSCTL_DIR" ]; then
    echo "Creating sysctl.d directory..."
    sudo mkdir -p "$SYSCTL_DIR"
    sudo chmod 755 "$SYSCTL_DIR"
fi

# Check if the sysctl configuration file exists, create it if not
SYSCTL_CONF="$SYSCTL_DIR/99-sysctl.conf"
if [ ! -f "$SYSCTL_CONF" ]; then
    sudo touch "$SYSCTL_CONF"
    sudo chmod 644 "$SYSCTL_CONF"
    echo "$SYSCTL_CONF has been created."
fi

# sysctl parameters and their desired values
declare -A sysctl_params=(
    ["net.ipv4.conf.all.accept_redirects"]=0
    ["vm.swappiness"]=1
    ["net.ipv4.ip_forward"]=1
    ["kernel.randomize_va_space"]=2
    ["net.ipv4.tcp_keepalive_time"]=60
    ["net.ipv4.udp_rmem_min"]=8192
    ["kernel.unprivileged_bpf_disabled"]=1
    ["net.ipv4.tcp_window_scaling"]=1
    ["net.core.wmem_max"]=1073741824
    ["net.core.rmem_max"]=1073741824
    ["net.ipv4.tcp_mtu_probing"]=1
    ["net.core.netdev_max_backlog"]=16384
    ["net.ipv4.tcp_keepalive_intvl"]=10
    ["fs.inotify.max_user_watches"]=1048576
    ["net.ipv4.conf.all.send_redirects"]=0
    ["fs.inotify.max_queued_events"]=1048576
    ["vm.dirty_bytes"]=742653184
    ["fs.inotify.max_user_instances"]=1048576
    ["net.core.somaxconn"]=8192
    ["net.ipv4.tcp_keepalive_probes"]=6
    ["net.core.wmem_default"]=8388608
    ["net.ipv4.tcp_rmem"]="4096 87380 1073741824"
    ["kernel.core_uses_pid"]=1
    ["net.ipv4.tcp_low_latency"]=1
    ["net.core.default_qdisc"]="cake"
    ["net.ipv4.conf.default.send_redirects"]=0
    ["vm.dirty_writeback_centisecs"]=300
    ["net.ipv4.udp_wmem_min"]=8192
    ["net.core.optmem_max"]=25165824
    ["vm.dirty_expire_centisecs"]=500
    ["net.ipv4.conf.default.accept_redirects"]=0
    ["net.ipv4.tcp_congestion_control"]="bbr"
    ["vm.dirty_background_bytes"]=474217728
    ["kernel.kptr_restrict"]=1
    ["kernel.sysrq"]=0
    ["net.ipv4.tcp_fastopen"]=3
    ["net.ipv4.tcp_ecn"]=1
    ["net.core.rmem_default"]=8388608
    ["net.ipv4.tcp_wmem"]="4096 87380 1073741824"
)

# Apply the sysctl settings
for param in "${!sysctl_params[@]}"; do
    echo "$param = ${sysctl_params[$param]}" | sudo tee -a "$SYSCTL_CONF"
    sudo sysctl -w "$param=${sysctl_params[$param]}"
    echo "Set $param to ${sysctl_params[$param]}."
done

# Reload sysctl configurations
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo sysctl --system

echo "All sysctl parameters have been set and applied."
