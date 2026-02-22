# Update dotfiles, restow, and reload shell
dot-sync() {
    # Store current directory to return later
    local current_dir=$(pwd)
    
    echo "Checking for dotfile updates..."
    cd "$HOME/dotfiles" || return
    
    # Pull latest changes from GitHub
    git pull origin main
    
    # Restow all packages (bash, scripts, etc.)
    # The '*' expands to all top-level folders in your dotfiles repo
    stow -R */
    
    # Return to original directory
    cd "$current_dir"

    # Ensure our local scripts are executable
    if [ -d "$HOME/.local/bin" ]; then
        chmod +x "$HOME/.local/bin/"*
    fi
   
    # Reload the shell configuration
    source "$HOME/.bashrc"
    
    echo "✅ Dotfiles updated and shell reloaded!"
}
