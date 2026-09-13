# bash/.bash.d/21-uv.sh

# Ensure local bin is in PATH for uv/uvx binaries
if [ -d "${HOME}/.local/bin" ] && [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi

# Enable uv shell completion if uv is present
if command -v uv &>/dev/null; then
  eval "$(uv generate-shell-completion bash)"
fi
