doas sh -c '
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
