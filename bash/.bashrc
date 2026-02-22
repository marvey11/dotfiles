# ~/dotfiles/bash/.bashrc

HISTSIZE=65536
HISTFILESIZE=${HISTSIZE}

# 1. If not running interactively, don't do anything
[[ $- != *i* ]] && return

# 2. Set the Base Directory for our modules
BASH_DOT_DIR="${HOME}/.bash.d"

# 3. Source all modular files in order
if [ -d "$BASH_DOT_DIR" ]; then
    # Loop through all .sh files in the directory
    for file in "$BASH_DOT_DIR"/*.sh; do
        # Ensure the file exists (handles empty directory case) and is readable
        if [[ -f "$file" && "$file" == *.sh ]]; then
            source "$file"
        fi
    done
fi

unset BASH_DOT_DIR
