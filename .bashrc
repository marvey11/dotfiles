export HISTSIZE=-1
export HISTFILESIZE=-1

if [[ -f ${HOME}/.bash_aliases ]]; then
    source ${HOME}/.bash_aliases
fi

BASH_UTIL_DIR="${HOME}/.bash-util.d/"
[[ -d ${BASH_UTIL_DIR} ]] &&
{
    for bu_file in $(find ${BASH_UTIL_DIR} -name "*.sh"); do
        source ${bu_file}
    done
}
