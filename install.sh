#!/bin/sh

export RUNZSH=no
export CHSH=yes
export KEEP_ZSHRC=yes

# ==============================
# FAST SYSTEM UPDATE
# ==============================
apk update >/dev/null && apk upgrade >/dev/null

# ==============================
# PACKAGES
# ==============================
apk add zsh tmux git curl nano vim htop openssh bash fastfetch nvim >/dev/null

# ==============================
# SSH
# ==============================
rc-update add sshd >/dev/null
service sshd start

# ==============================
# OH-MY-ZSH (AUTO)
# ==============================
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# ==============================
# ZSH PLUGINS
# ==============================
mkdir -p ~/.zsh

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions >/dev/null

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting >/dev/null

# ==============================
# ZSH CONFIG
# ==============================
cat << 'EOF' > ~/.zshrc

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [ "$EUID" -eq 0 ]; then
  PROMPT='%F{red}┌─[ROOT@%m]%f %F{yellow}[%~]%f
%F{red}└──╼ %f# '
else
  PROMPT='%F{cyan}┌─[%n@%m]%f %F{yellow}[%~]%f
%F{green}└──╼ %f$ '
fi

if [ -t 1 ]; then
  fastfetch
fi

alias t="tmux new -A -s main"

EOF

# ==============================
# DEFAULT SHELL
# ==============================
chsh -s /bin/zsh $(whoami)

# ==============================
# TMUX CONFIG
# ==============================
cat << 'EOF' > ~/.tmux.conf

set -g mouse on
set -g history-limit 10000

unbind C-b
set -g prefix C-a
bind C-a send-prefix

bind | split-window -h
bind - split-window -v

set -g default-terminal "screen-256color"

set -g status-style bg=black,fg=cyan
setw -g window-status-current-style bg=cyan,fg=black
setw -g window-status-style fg=cyan,bg=black

set -g status-left "#[fg=green]#H #[fg=yellow]| "
set -g status-right "#[fg=yellow]%Y-%m-%d #[fg=green]%H:%M"

EOF

echo "Done. Reboot now."
