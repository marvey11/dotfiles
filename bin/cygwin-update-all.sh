#! /bin/bash

#
# Updates all Cygwin packages.
#

DOWNLOAD_DIR="/tmp/www.cygwin.com"
SETUP_EXE_PATH="${DOWNLOAD_DIR}/setup-x86_64.exe"

wget -N -P ${DOWNLOAD_DIR} http://www.cygwin.com/setup-x86_64.exe && {
    chmod u+x ${SETUP_EXE_PATH}
    ${SETUP_EXE_PATH} -n -N -d -g -q -a x86_64
}
