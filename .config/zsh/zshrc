#!/bin/sh
export ZDOTDIR=$HOME/.config/zsh
HISTFILE=$HOME/.zsh_history
setopt appendhistory

unsetopt BEEP

source "$ZDOTDIR/zsh-functions"
zsh_add_file "zsh-exports"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

# Colors
autoload -U promptinit && promptinit
autoload -Uz colors && colors


