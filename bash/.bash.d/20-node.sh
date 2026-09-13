# Node environment auto-loader (fnm or nvm)

# 1. Add local fnm path if present and not already in PATH
if [ -d "${HOME}/.local/share/fnm" ] && [[ ":${PATH}:" != *":${HOME}/.local/share/fnm:"* ]]; then
  export PATH="${HOME}/.local/share/fnm:${PATH}"
fi

# 2. Prefer fnm if binary is available
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell bash)"

# 3. Fall back to nvm if present on legacy hosts
elif [ -d "${HOME}/.nvm" ]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
  [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
fi
