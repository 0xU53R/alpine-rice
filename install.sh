#!/bin/sh

set -e

echo "== Alpine i3 Setup Starting =="

# ------------------------------
# Update system
# ------------------------------
doas apk update
doas apk upgrade

# ------------------------------
# Core X + i3
# ------------------------------
doas apk add \
    i3wm i3status i3lock i3blocks dmenu \
    xorg-server xinit dbus

# ------------------------------
# Drivers (safe defaults)
# ------------------------------
doas apk add \
    xf86-input-libinput mesa-dri-gallium

# ------------------------------
# Network + audio
# ------------------------------
doas apk add \
    networkmanager network-manager-applet \
    pipewire pipewire-pulse wireplumber

# ------------------------------
# Desktop tools
# ------------------------------
doas apk add \
    alacritty rofi feh picom \
    thunar gvfs \
    firefox

# ------------------------------
# Utilities
# ------------------------------
doas apk add \
    git zsh starship fastfetch htop

# ------------------------------
# Fonts + themes
# ------------------------------
doas apk add \
    font-dejavu font-noto papirus-icon-theme arc-theme

# ------------------------------
# Enable services
# ------------------------------
doas rc-update add dbus
doas rc-update add networkmanager

# ------------------------------
# Xinit setup (auto-start i3)
# ------------------------------
echo "exec i3" > ~/.xinitrc

# ------------------------------
# Basic i3 config setup
# ------------------------------
mkdir -p ~/.config/i3

cat > ~/.config/i3/config << 'EOF'
set $mod Mod4

bindsym $mod+Return exec alacritty
bindsym $mod+d exec rofi -show drun
bindsym $mod+Shift+r reload
bindsym $mod+Shift+e exit

font pango:monospace 10

exec --no-startup-id dbus-launch nm-applet
exec --no-startup-id pipewire
exec --no-startup-id wireplumber
exec --no-startup-id picom --experimental-backends

bar {
    status_command i3status
}
EOF


# ------------------------------
# Zsh + starship (optional nice CLI)
# ------------------------------
if [ ! -f ~/.zshrc ]; then
    echo 'eval "$(starship init zsh)"' > ~/.zshrc
fi

echo "== DONE =="
echo "Reboot, then run: startx"doas sh -c '
# revert shell to default (ash)
usermod -s /bin/ash $(whoami) 2>/dev/null || true

# remove installed packages
apk del zsh tmux git curl nano vim htop openssh bash fastfetch shadow 2>/dev/null || true

# remove configs
rm -rf ~/.zsh ~/.oh-my-zsh ~/.zshrc ~/.tmux.conf

# disable ssh
rc-update del sshd 2>/dev/null || true

echo "System reverted. Reboot recommended."
'
