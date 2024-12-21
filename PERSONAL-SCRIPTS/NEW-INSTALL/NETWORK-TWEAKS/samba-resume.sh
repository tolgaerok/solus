# sudo nano /etc/systemd/system/samba-resume.service
# sudo systemctl enable samba-resume.service

[Unit]
Description=Restart Samba services after suspend
After=suspend.target

[Service]
ExecStart=/usr/bin/systemctl restart smb nmb wsdd.service

[Install]
WantedBy=suspend.target
