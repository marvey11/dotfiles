# Function to safely add to PATH only if the directory exists and isn't already there
add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# 1. Add your personal scripts folder
add_to_path "$HOME/.local/bin"

# 2. Add other common user-level binary folders (optional but helpful)
add_to_path "$HOME/bin"

# Clean up the function so it doesn't stay in the environment
unset -f add_to_path
