Original init script from /mnt/data/tools/shellscripts/../work/wifi/dalebook/dale.sh
############################################
#!/bin/zsh
## Info
################################################################
if test -z "${SUNRISE_USER_PATH}"
then
    printf "%s\n" ''
    printf "%s\n" '      _                     _         '
    printf "%s\n" '     | |                   (_)        '
    printf "%s\n" '   __| | __ _ _ ____      ___ _ __    '
    printf "%s\n" '  / _` |/ _` | '"'"'__\ \ /\ / / | '"'"'_ \   '
    printf "%s\n" ' | (_| | (_| | |   \ V  V /| | | | |  '
    printf "%s\n" '  \__,_|\__,_|_|    \_/\_/ |_|_| |_|  '
    printf "%s\n" ''

    echo "Connections: ${SSH_CONNECTION}"

    echo -en "\033]0;$(hostname)\a"
fi
## Dale setup
################################################################
# Add this to ~/.zshrc
if false
then
    # RC Setup
    alias shaun="source /Users/sunrise/Downloads/shaun/dale.sh"
    if test -n "${SUNRISE_USER_PATH}"
    then
        source /Users/sunrise/Downloads/shaun/dale.sh
    fi

    # ENV Setup with tmux or zellij
    # IT's only for zsh.
    export ZDOTDIR='/Users/sunrise/Downloads/shaun'
fi
################################################################

## predefine
################################################################
export SUNRISE_USERNAME=$(whoami)
test -z ${SUNRISE_PASSWORD} && export SUNRISE_PASSWORD="sunrise123"

## exports
################################################################
if test -d "${HOME}/Downloads/shaun"
then
    export SUNRISE_USER_PATH=$(realpath ${HOME}/Downloads/shaun)
elif test -f "./dale.sh"
then
    # this is only for compatiable test.
    export SUNRISE_USER_PATH=$(realpath ./)
fi

export HSL_SHELL=zsh
export HSL_ROOT_PATH="$(realpath ${SUNRISE_USER_PATH}/tools)"
export HSL_LOCAL_VAR="${SUNRISE_USER_PATH}/.var"

## Customize setup
################################################################
test -z ${HSLW_FF_DUT_NAME} && export HSLW_FF_DUT_NAME="localhost"
test -z ${HSLW_SUNRISE_PASSWORD} && export HSLW_SUNRISE_PASSWORD="sunrise123"

# it's use with ZDOTDIR
# export ZDOTDIR='/Users/sunrise/Downloads/shaun'
test -f ${SUNRISE_USER_PATH}/.zshrc || ln -s ${SUNRISE_USER_PATH}/dale.sh ${SUNRISE_USER_PATH}/.zshrc

## hslite setup
################################################################
source ${SUNRISE_USER_PATH}/tools/hslite.sh

## Other config setup
################################################################
if test -f "${SUNRISE_USER_PATH}/customize.sh"
then
    source ${SUNRISE_USER_PATH}/customize.sh
fi

if test -f "${SUNRISE_USER_PATH}/lab.sh"
then
    source ${SUNRISE_USER_PATH}/lab.sh
fi

# Init
dale_init

## alias
################################################################

# Functions alias
# alias reload="source ${SUNRISE_USER_PATH}/dale.sh"
alias reload="source ${SUNRISE_USER_PATH}/dale.sh"

## Brew setup
################################################################
# if test -f "/opt/homebrew/bin/brew"
# then
#     eval "$(/opt/homebrew/bin/brew shellenv)"
# fi
if test -f "/opt/homebrew/opt/coreutils/libexec/gnubin"
then
    PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi
