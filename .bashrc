#
# Sources all *.sh files found in the directory specified as this function's parameter.
#
# Does nothing if the specified directory doesn't exist.
#
function source_all {
    local directory=$1

    [[ -d ${directory} ]] &&
    {
        for script in $(find ${directory} -name "*.sh"); do
            source ${script}
        done
    }
}

for dotfile in ${HOME}/.{bash_aliases,exports,functions}; do
    [[ -f ${dotfile} && -r ${dotfile} ]] && source ${dotfile}
done

#
# load all function script files found in ~/.bash_util.d/ and ~/.bash-too.d/
#
# the difference to .functions is that these scripts bundle functionality for a specific topic while .functions is
# simply a collection of unrelated functions
#
# ~/.bash_util.d/ is usually sym-linked from this repository, while ~/.bash-too.d/ bundles scripts from other sources
#
for src_dir in ${HOME}/.bash-{util,too}.d/; do
    source_all ${src_dir}
done

unset -f source_all
unset dotfile src_dir
