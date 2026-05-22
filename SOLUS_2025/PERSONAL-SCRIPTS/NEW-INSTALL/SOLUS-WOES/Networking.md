
# Solus Networking Woes


Edit: `/etc/samba/smb.conf`
```bash
[global]
client min protocol = SMB2
client max protocol = SMB3
```

Edit: `/etc/nsswitch.conf` 

```bash
hosts: mymachines mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
```

Do the following:

```bash
# Install Avahi if not already installed
sudo eopkg install avahi

# Enable and start Avahi
sudo systemctl enable --now avahi-daemon

# Restart Avahi and NetworkManager 
sudo systemctl restart avahi-daemon
sudo systemctl restart NetworkManager

# Check Avahi status
systemctl status avahi-daemon

# Allow Avahi (mDNS) and Samba through the firewall
sudo firewall-cmd --permanent --add-service=mdns
sudo firewall-cmd --permanent --add-service=samba
sudo firewall-cmd --reload

# Restart Samba
sudo systemctl restart smb

# Test Avahi discovery
avahi-browse -art
```