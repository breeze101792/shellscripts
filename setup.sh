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
    local var_config_path=${HOME}/.config/git
    local var_def_cfg=${HOME}/.gitconfig
    # local backup_path=${HS_SCRIPT_PATH}/backup/git_bak_`tstamp`

    if [ ! -f "${HOME}/.gitconfig" ] || ! cat "${HOME}/.gitconfig" | grep 'config/git/config.cfg' > /dev/null
    then
        # echo "${HOME}/.gitconfig exist."
        # echo "Please remove before using this script"
        # return
        touch ${var_def_cfg}
        if ! cat "${HOME}/.gitconfig" | grep '\[include\]' > /dev/null
        then
            echo [include] >> ${var_def_cfg}
        fi
        sed -i "/\[include\]/a \ \ \ \ path = ${HOME}/.config/git/config.cfg" ${var_def_cfg}
    else
        echo "${var_def_cfg} exist"
    fi

    if [ ! -d "${var_config_path}" ]
    then
        mkdir -p ${var_config_path}
    fi
    ln -sf ${HS_SCRIPT_PATH}/configs/git/*   ${var_config_path}/
    touch ${var_config_path}/work.cfg

    if [ ! -f "${var_config_path}/user.cfg" ]
    then
        echo "Enter User Name:"
        read var_user_name
        echo "Enter User Mail:"
        read var_user_mail
        echo "[user]" >> ${var_config_path}/user.cfg
        echo "    email = ${var_user_mail}" >> ${var_config_path}/user.cfg
        echo "    name = ${var_user_name}" >> ${var_config_path}/user.cfg
    fi
    cat ${var_def_cfg}

    ## Others
    ##################################################################
    # git config --global http.sslVerify false

}
function setup_usr()
{
    echo "Setup Local usr"
    local local_usr_path=${HOME}/.usr
    mkdir ${local_usr_path}
    mkdir ${local_usr_path}/bin
    mkdir ${local_usr_path}/lib

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
            -u|--usr)
                setup_usr
                ;;
            -x|--excute)
                shift 1
                excute $@
                return 0
                ;;
            -h|--help)
                echo "Setup Usage"
                printf "    %s%s%s\n" "-t|--tmux" "->" "Setup tmux"
                printf "    %s%s%s\n" "-g|--git" "->" "Setup git"
                printf "    %s%s%s\n" "-s|--shell" "->" "Setup shell"
                printf "    %s%s%s\n" "-u|--usr" "->" "setup local usr"
                printf "    %s%s%s\n" "-x|--excute" "->" "Excute with hs env"
                printf "    %s%s%s\n" "-h|--help" "->" "Help me"
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
