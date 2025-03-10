# Update ALIAS

![alt text](image.png)

```bash
alias tolga-update='
echo -e "\e[1;32m[✔]\e[0m Network is metered. Rotating and vacuuming journal logs...\n" && \
(sudo journalctl --rotate; sudo journalctl --vacuum-time=1s && sleep 1) && \
sleep 1 && \
cleanup_solus && \
display_message "[\e[1;32m✔\e[0m]  Checking flatpaks" && \
echo -e "\e[1;32m[✔]\e[0m Checking updates for installed flatpak programs...\n" && \
sudo flatpak update --appstream && flatpak update && \
sudo flatpak update -y && \
sleep 1 && \
echo -e "\e[1;32m[✔]\e[0m Removing Old Flatpak Cruft...\n" && \
flatpak uninstall --unused && \
flatpak uninstall --delete-data && \
sudo rm -rfv /var/tmp/flatpak-cache-* && \
[ -f /usr/bin/flatpak ] && flatpak uninstall --unused --delete-data --assumeyes && \
flatpak --user uninstall --unused -y --noninteractive && \
/usr/bin/flatpak --user update -y --noninteractive && \
/usr/bin/flatpak --user repair && \
echo -e "\e[1;32m[✔]\e[0m All updates and cleanups are complete."'
```