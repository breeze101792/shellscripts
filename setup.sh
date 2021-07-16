#!/bin/bash
HS_SCRIPT_PATH=""
if [ -d "$(dirname ${0})" ]
then
    # zsh
    HS_SCRIPT_PATH="$(realpath $(dirname ${0}))"
elif [ -n "${BASH_SOURCE}" ]
then
    # bash
    HS_SCRIPT_PATH="$(realpath $(dirname ${BASH_SOURCE[0]}))"
fi
echo ${HS_SCRIPT_PATH}

function setup_shell()
{
    echo ${SHELL}
    local shell_name=$(echo ${SHELL} | rev | cut -d '/' -f 1 | rev)
    if [ "${shell_name}" = "bash" ]
    then
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${shell_name}
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${shell_name} >> ~/.bashrc
    elif [ "${shell_name}" = "zsh" ]
    then
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${shell_name}
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${shell_name} >> ~/.zshrc
    fi
}
function setup_tmux()
{
    ln -sf ${HS_SCRIPT_PATH}/configs/others/tmux.conf ${HOME}/.tmux.conf
}
function setup_git()
{
    cp -sf ${HS_SCRIPT_PATH}/configs/git/gitconfig   ${HOME}/.gitconfig
    ln -sf ${HS_SCRIPT_PATH}/configs/git/gitignore   ${HOME}/.gitignore
    ln -sf ${HS_SCRIPT_PATH}/configs/git/gitmessage  ${HOME}/.gitmessage
}
function excute()
{
    echo "Script Path:${HS_SCRIPT_PATH}"
    echo ${HS_SCRIPT_PATH}/source.sh --silence=n -x -p ${HS_SCRIPT_PATH} $@
    ${HS_SCRIPT_PATH}/source.sh --silence=n -x -p ${HS_SCRIPT_PATH} $@
}
function setup()
{
    while [ "$#" != "0" ]
    do
        case $1 in
            -t|--tmux)
                setup_tmux
                ;;
            -g|--git)
                setup_git
                ;;
            -s|--shell)
                setup_shell
                ;;
            -x|--excute)
                shift 1
                excute $@
                return 0
                ;;
            -h|--help)
                echo "Setup Usage"
                printf "%s%s%s\n" "-t|--tmux" "->" "Set tmux"
                printf "%s%s%s\n" "-g|--git" "->" "Set git"
                printf "%s%s%s\n" "-s|--shell" "->" "Set shell"
                return 0
                ;;
            *)
                setup_shell
                ;;
        esac
        shift 1
    done
}
setup $@
