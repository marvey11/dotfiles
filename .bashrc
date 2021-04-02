for dotfile in ${HOME}/.{bash_aliases,exports,functions}; do
    [[ -f ${dotfile} && -r ${dotfile} ]] && source ${dotfile}
done
unset dotfile

#
# load all function script files found in ~/.bash_util.d/
#
# the difference to .functions is that these scripts bundle functionality for a specific topic while .functions is
# simply a collection of unrelated functions
#
BASH_UTIL_DIR="${HOME}/.bash-util.d/"
[[ -d ${BASH_UTIL_DIR} ]] &&
{
    for script in $(find ${BASH_UTIL_DIR} -name "*.sh"); do
        source ${script}
    done
}
unset script
