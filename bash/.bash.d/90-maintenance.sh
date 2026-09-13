# Update dotfiles, restow, and reload shell
dot-sync() {
    # Store current directory to safely return upon completion or failure
    local current_dir
    current_dir="$(pwd)"

    # Dynamically resolve dotfiles repository directory
    local dotfiles_dir=""
    if [ -d "${HOME}/projects/github.com/dotfiles" ]; then
        dotfiles_dir="${HOME}/projects/github.com/dotfiles"
    elif [ -d "${HOME}/dotfiles" ]; then
        dotfiles_dir="${HOME}/dotfiles"
    else
        echo "❌ Error: Could not locate dotfiles repository directory." >&2
        return 1
    fi

    echo "Checking for dotfile updates in ${dotfiles_dir}..."
    cd "${dotfiles_dir}" || return 1

    # Pull latest changes from GitHub
    if ! git pull origin main; then
        echo "❌ Error: Failed to pull latest changes from git." >&2
        cd "${current_dir}" || return 1
        return 1
    fi

    # Restow using deploy.sh if present, or fallback to explicit stow command
    if [ -x "./deploy.sh" ]; then
        ./deploy.sh
    else
        stow --dir="${dotfiles_dir}" --target="${HOME}" -R bash scripts git
    fi

    # Return to original working directory
    cd "${current_dir}" || return 0

    # Ensure local scripts are executable if any exist
    if [ -d "${HOME}/.local/bin" ] && compgen -G "${HOME}/.local/bin/*" > /dev/null; then
        chmod +x "${HOME}/.local/bin/"*
    fi

    # Reload active shell configuration
    # Shellcheck disable=SC1090
    source "${HOME}/.bashrc"

    echo "✅ Dotfiles updated and shell reloaded!"
}
