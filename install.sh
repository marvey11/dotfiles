#! /bin/bash

function print_error {
    local message=${1}
    echo "ERROR: ${message}" >&2
}

function install_file {
    local source=${1}
    local target=${2}

    if [[ ! -e ${target} ]]; then
        ln -s ${source} ${target}
    elif [[ -L ${target} ]]; then
        rm ${target} && ln -s ${source} ${target}
    else
        print_error "${target} exists but is not a symlink. Skipping..."
    fi
}

function install_directory {
    local source=${1}
    local target=${2}

    if [[ ! -e ${target} ]]; then
        ln -s ${source} ${target}
    elif [[ -L ${target} ]]; then
        rm ${target} && ln -s ${source} ${target}
    elif [[ -d ${target} ]]; then
        echo "Target is a directory; trying to install contained files separately..."
        for src_file in $(find ${source} -type f); do
            install_file ${src_file} ${target}/$(basename ${src_file})
        done
    else
        print_error "${target} exists but is neither a symlink nor a directory. Skipping..."
    fi
}

curdir=$(dirname $0)

for dotfile in .{bash_aliases,exports,functions}; do
    echo "--> Installing ${dotfile}"
    install_file ${curdir}/${dotfile} ${HOME}/${dotfile}
done

for src_dir in bin .bash-util.d; do
    echo "--> Installing ${src_dir}"
    install_directory ${curdir}/${src_dir} ${HOME}/${src_dir}
done

addon_dir="~/.bash-too.d"
[[ -e ${addon_dir} ]] || mkdir -p ${addon_dir}

unset -f install_directory install_file print_error
unset addon_dir curdir dotfile src_dir
