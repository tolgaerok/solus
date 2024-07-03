# solus
Personal Solus repo

### About
- Contained in this repo are a collection of my personal scripts to setup and tweak the current solus installation

Run setup-solus.sh located in: 

```bash
PERSONAL-SCRIPTS/USER-HOME-RELATED/setup-solus.sh
```

- To install Flatpak, run the following command in the terminal
```bash
sudo eopkg install flatpak xdg-desktop-portal-gtk
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```
- Install Chrome for solus
```bash
sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/web/browser/google-chrome-stable/pspec.xml
sudo eopkg it google-chrome-*.eopkg
```
