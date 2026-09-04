# shellcheck shell=bash

alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Basic replacement for ls using eza
alias ls='eza --group-directories-first'

# Replacement for la / ll with long formatting, git status, and icons
alias la='eza -la --group-directories-first --icons'
alias ll='eza -l --group-directories-first --icons'

# dotfiles command
alias sys-check='system-check.sh'
alias sys-update='sudo ~/.local/bin/system-update.sh'
