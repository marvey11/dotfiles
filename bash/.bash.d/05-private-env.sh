# Load user-specific environment variables from outside the dotfiles repo.
PRIVATE_ENV_FILE="${XDG_CONFIG_HOME:-${HOME}/.config}/dotfiles/env.sh"

if [[ -r "${PRIVATE_ENV_FILE}" ]]; then
    source "${PRIVATE_ENV_FILE}"
fi

unset PRIVATE_ENV_FILE
