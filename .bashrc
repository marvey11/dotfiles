export HISTSIZE=-1
export HISTFILESIZE=-1

if [[ -f ${HOME}/.bash_aliases ]]; then
    source ${HOME}/.bash_aliases
fi

#
# load all script files found in ~/.bash_util.d/
#
BASH_UTIL_DIR="${HOME}/.bash-util.d/"
[[ -d ${BASH_UTIL_DIR} ]] &&
{
    for script in $(find ${BASH_UTIL_DIR} -name "*.sh"); do
        source ${script}
    done
}
