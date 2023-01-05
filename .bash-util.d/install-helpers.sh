#
# Installs an addon script into the .bash-too.d directory in ${HOME}.
#
# Ties in directly with the infrastructure established in dotfiles' install script.
#
function install-addon {
    local target_dir=${HOME}/.bash-too.d

    local source=${1}
    local target=${target_dir}/$(basename {source})

    if [[ ! -e ${target} ]]; then
        ln -s ${source} ${target}
    elif [[ -L ${target} ]]; then
        rm ${target} && ln -s ${source} ${target}
    else
        echo "ERROR: ${target} exists but is not a symlink. Skipping..." >&2
    fi
}
