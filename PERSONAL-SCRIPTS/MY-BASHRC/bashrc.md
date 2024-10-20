```bash
source /usr/share/defaults/etc/profile

eval "$(direnv hook bash)"
###---------- ALIASES ----------###
# source ~/.bashrc

# echo "" && fortune && echo ""

alias tolga-alert='notify-send --urgency=low "$(history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//")"'
alias tolga-tolga='sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/tolgaerok/tolga-scripts/main/Fedora39/TolgaFedora39.sh)"'

alias tolga-systcl="sudo /home/tolga/scripts/systcl.sh"

###---------- my tools ----------###
alias tolga-htos="sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh"
alias tolga-mount="sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/MOUNT-ALL.sh"
alias tolga-mse="sudo ~/scripts/MYTOOLS/mse.sh"
alias tolga-stoh="sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh"
alias tolga-umount="sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/UMOUNT-ALL.sh"

###---------- fun stuff ----------###
alias tolga-pics="sxiv -t $HOME/Pictures/CUSTOM-WALLPAPERS/"
alias tolga-wp="sxiv -t $HOME/Pictures/Wallpaper/"

###---------- navigate files and directories ----------###
alias ..="cd .."
alias cl="clear"
alias copy="rsync -P"
alias la="lsd -a"
alias ll="lsd -l"
alias Ls="lsd"
alias ls="ls --color=auto"
alias dir="dir --color=auto"
alias lsla="lsd -la"

# alias chmod commands
alias tolga-000='sudo chmod -R 000'
alias tolga-644='sudo chmod -R 644'
alias tolga-666='sudo chmod -R 666'
alias tolga-755='sudo chmod -R 755'
alias tolga-777='sudo chmod -R 777'
alias tolga-mx='sudo chmod a+x'

# Search command line history
alias tolga-h="history | grep "

# Search running processes
alias tolga-p="ps aux | grep "
alias tolga-topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias tolga-f="find . | grep "

# Alias's for safe and forced reboots
alias tolga-rebootforce='sudo shutdown -r -n now'
alias tolga-rebootsafe='sudo shutdown -r now'

###---------- Tools ----------###
alias rc="source ~/.bashrc && clear && echo "" && fortune | lolcat  && echo """
alias tolga-bashrc='kwrite  ~/.bashrc'
alias tolga-cong="sysctl net.ipv4.tcp_congestion_control"
alias tolga-fmem="echo && echo 'Current mem:' && free -h && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' && echo && echo 'After: ' && free -h"
alias tolga-fmem2="echo && echo 'Current mem:' && free -h && sudo /bin/sh -c '/bin/sync && /sbin/sysctl -w vm.drop_caches=3' && echo && echo 'After: ' && free -h"
alias tolga-fstab="sudo mount -a && sudo systemctl daemon-reload && echo && echo \"Reloading of fstab done\" && echo"
alias tolga-grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg && sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg"
alias tolga-io="cat /sys/block/sda/queue/scheduler"
alias tolga-line="echo '## ------------------------------ ##'"
# alias tolga-nvidia="sudo systemctl enable --now akmods --force && sudo dracut --force && echo && echo \"Force akmods and Dracut on nvidia done\" && echo"
alias tolga-nvidia='sudo systemctl enable --now akmods --force && sudo dracut --force && echo && echo "Force akmods and Dracut on NVIDIA done" && echo'

alias tolga-pdfcompress='bash /home/tolga/scripts/pdf1.sh'
alias tolga-samba='echo "Restarting Samba" -- sleep 2 && sudo systemctl enable smb.service nmb.service && sudo systemctl restart smb.service nmb.service'
alias tolga-swapreload="cl && echo && echo 'Turning swap off:' && echo 'Turning swap on:' && tolga-line && sudo swapon --all && sudo swapon --show && echo && echo 'Reload Swap(s):' && tolga-line && sudo mount -a && sudo systemctl daemon-reload && sudo swapon --show && echo && echo 'Free memory:' && tolga-line && free -h && echo && duf && tolga-sys && tolga-fmem"
alias tolga-sys="echo && tolga-io && echo && tolga-cong && echo && echo 'ZSWAP status: ( Y = ON )' && cat /sys/module/zswap/parameters/enabled && systemctl restart earlyoom && systemctl status earlyoom --no-pager"
alias tolga-trim="sudo fstrim -av"
alias tolga-update="sudo dnf5 update && sudo dnf update && flatpak update -y && flatpak uninstall --unused && flatpak uninstall --delete-data && [ -f /usr/bin/flatpak ] && flatpak uninstall --unused --delete-data --assumeyes"
alias tolga-sysctl-reload="sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system && sudo sysctl -p && sudo mount -a && sudo systemctl daemon-reload"

###---------- file access ----------###
alias tolga-bconf="vim ~/.config/bash/.bashrc"
alias tolga-cp="cp -riv"
alias tolga-htos='sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-HOME-TO-SERVER.sh'
alias tolga-mkdir="mkdir -vp"
alias tolga-mount='sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/MOUNT-ALL.sh'
alias tolga-mse='sudo ~/scripts/MYTOOLS/MAKE-SCRIPTS-EXECUTABLE.sh'
alias tolga-mv="mv -iv"
alias tolga-mynix='sudo ~/.config/MY-TOOLS/assets/scripts/COMMAN-NIX-COMMAND-SCRIPT/MyNixOS-commands.sh'
alias tolga-stoh='sudo ~/.config/MY-TOOLS/assets/scripts/Zysnc-Options/ZYSNC-SERVER-TO-HOME.sh'
alias tolga-trimgen='sudo ~/.config/MY-TOOLS/assets/scripts/GENERATION-TRIMMER/TrimmGenerations.sh'
alias tolga-umount='sudo ~/.config/MY-TOOLS/assets/scripts/Mounting-Options/UMOUNT-ALL.sh'
alias tolga-zconf="vim ~/.config/zsh/.zshrc"

alias cj="sudo journalctl --rotate; sudo journalctl --vacuum-time=1s"

alias tolga-batt='clear && echo "Battery: $(acpi -b | awk '\''{print $3}'\'')" && echo '' && echo "Battery Percentage: $(acpi -b | awk '\''{print $4}'\'')" && echo '' && echo "Remaining Time: $(acpi -b | awk '\''{print $5,$6,$7 == "until" ? "until fully charged" : $7}'\'')"'

###---------- session ----------###
alias tolga-sess='session=$XDG_SESSION_TYPE && echo "" && gum spin --spinner dot --title "Current XDG session is: [ $session ] """ -- sleep 2'

###---------- Nvidia session ----------###
export LIBVA_DRIVER_NAME=nvidia                  # Specifies the VA-API driver to use for hardware acceleration
export WLR_NO_HARDWARE_CURSORS=1             # Disables hardware cursors for Wayland to avoid issues with some Nvidia drivers
export __GLX_VENDOR_LIBRARY_NAME=nvidia      # Specifies the GLX vendor library to use, ensuring Nvidia's library is used
export __GL_SHADER_CACHE=1                   # Enables the GL shader cache, which can improve performance by caching compiled shaders
export __GL_THREADED_OPTIMIZATION=1          # Enables threaded optimization in Nvidia's OpenGL driver for better performance


###---------- Misc envir setings ------###
# export GTK_MODULES=canberra-gtk-module           # Module for playing event sounds in GTK applications
# export QT_QPA_PLATFORM=xcb                      # Specifies XCB as the Qt platform plugin
# export QT_SESSION_MANAGER=0                     # Disables the session manager for Qt applications
export CLUTTER_BACKEND=wayland                   # Specifies Wayland as the backend for Clutter
export MOZ_ALLOW_DOWNGRADE=1                     # Allows downgrading profiles in Mozilla applications
export MOZ_DBUS_REMOTE=1                         # Enables remote D-Bus communication in Mozilla applications
export MOZ_ENABLE_WAYLAND=1                      # Enables Wayland support in Mozilla applications (e.g., Firefox)
export NIXOS_OZONE_WL=1                          # Enables the Ozone Wayland backend for Chromium-based browsers
export NIXPKGS_ALLOW_UNFREE=1                    # Allows the installation of packages with unfree licenses in Nixpkgs
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1     # Disables window decorations in Qt applications when using Wayland
export SDL_VIDEODRIVER=wayland                   # Sets the video driver for SDL applications to Wayland



###---------- Temporarily disable --######
# unset QT_QPA_PLATFORM
# unset QT_SESSION_MANAGER
# unset GTK_MODULES


###---------- BTRFS TOOLS ----------######
alias tolga-balance-home="sudo btrfs balance start /home && sudo btrfs balance status /home"
alias tolga-balance-root="sudo btrfs balance start / && sudo btrfs balance status /"
alias tolga-scrub-home="sudo btrfs scrub start /home && sudo btrfs scrub status /home"
alias tolga-scrub-root="sudo btrfs scrub start / && sudo btrfs scrub status /"

###---------- Konsole effects ----------###
PS1="\[\e[1;m\]┌(\[\e[1;32m\]\u\[\e[1;34m\]@\h\[\e[1;m\]) \[\e[1;m\]➤\[\e[1;36m\] \W \[\e[1;m\] \n\[\e[1;m\]└\[\e[1;33m\]➤\[\e[0;m\]  "

###---------- Nix package manager ----------###
# export PATH="/home/tolga/.nix-profile/bin:$PATH"
# . /home/tolga/.nix-profile/etc/profile.d/nix.sh

###---------- Vscoding ----------###
# eval "$(direnv hook bash)"

###---------- Solus related ----------###
alias tolga-solus='sudo mount -a && sudo systemctl daemon-reload && sudo udevadm control --reload-rules && sudo udevadm trigger && sudo sysctl --system'

# Function to generate a random color code
random_color() {
  echo $((16 + RANDOM % 216))
}

# Function to generate a random color code
random_color() {
  echo $((16 + RANDOM % 216))
}

# Define colors
YELLOW=226
WHITE=231
BRIGHT_BLUE=81

# Function to display fortune with random colors
fortune_with_random_colors() {
  local color
  color=$(random_color)
  printf "\033[38;5;%dm%s\033[0m\n" "$color" "$1"
}

# Check if the system is Solus
if [ -f "/usr/bin/eopkg" ]; then
  # Solus system
  #nix-env -iA nixpkgs.lolcat
  #nix-env -iA nixpkgs.fortune
  export PATH="/home/tolga/.nix-profile/bin:$PATH"
  . /home/tolga/.nix-profile/etc/profile.d/nix.sh
  export PATH="/home/tolga/.nix-profile/bin:$PATH"
  export PATH=$PATH:/usr/local/bin/direnv
  export PATH="$HOME/.nix-profile/bin:$PATH"
  export PATH="$HOME/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

  FORTUNE_COMMAND="/home/tolga/.nix-profile/bin/fortune"
else
  # Other distro
  FORTUNE_COMMAND="fortune"
fi

# Fetch the fortune message
fortune_message="$($FORTUNE_COMMAND)"

# Display the fortune message with random colors
#echo "" && fortune_with_random_colors "$fortune_message" && echo ""

# nix-env -iA nixpkgs.fortune
# export NIXPKGS_ALLOW_UNFREE=1 && nix-env -iA nixpkgs.megasync

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

XDG_DESKTOP_DIR="$HOME/"
XDG_DOWNLOAD_DIR="$HOME/"
XDG_DOCUMENTS_DIR="$HOME/"
XDG_MUSIC_DIR="$HOME/"
XDG_PICTURES_DIR="$HOME/"
XDG_VIDEOS_DIR="$HOME/"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"

cl && echo "" && fortune | lolcat && echo ""
#export PATH="/home/tolga/.nix-profile/bin:$PATH"
#. /home/tolga/.nix-profile/etc/profile.d/nix.sh

alias gitup="$HOME/Documents/gitup.sh"
cl && echo "" && fortune | lolcat && echo ""

alias fastfetch='BLUEFIN_FETCH_LOGO=$(find $HOME/.config/fastfetch/logo/* | /usr/bin/shuf -n 1) && rm -rf $HOME/.cache/fastfetch && /usr/bin/fastfetch --logo $BLUEFIN_FETCH_LOGO -c $HOME/.config/fastfetch/config.jsonc'
alias cake="sudo tc -s qdisc show dev wlp3s0 && sudo systemctl status apply-cake-qdisc.service"
```
