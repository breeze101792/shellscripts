#!/bin/bash
# Get Script Path
HS_SCRIPT_PATH=""
HS_ENV_SHELL=""
if [ "$(echo $0 | sed 's/^-//g')" = "zsh" ]
then
    HS_ENV_SHELL="zsh"
    if [ -f "$(dirname ${0})/source.sh" ]
    then
        # zsh
        HS_SCRIPT_PATH="$(dirname ${0})"
    fi
elif [ "$(echo $0 | sed 's/^-//g')" = "bash" ]
then
    HS_ENV_SHELL="bash"
    if [ -n "${BASH_SOURCE}" ] && [ -f "$(dirname ${BASH_SOURCE[0]})/source.sh" ] 
    then
        # bash
        HS_SCRIPT_PATH="$(dirname ${BASH_SOURCE[0]})"
    fi
elif [ "$(echo $0 | sed 's/^-//g')" = "sh" ]
then
    HS_ENV_SHELL="sh"
else
    # fall back settings
    if [ "$(echo $SHELL | sed 's|/.*/||g')" = "zsh" ]
    then
        HS_ENV_SHELL="zsh"
        if [ -f "$(dirname ${0})/source.sh" ]
        then
            # zsh
            HS_SCRIPT_PATH="$(dirname ${0})"
        fi
    elif [ "$(echo $SHELL | sed 's|/.*/||g')" = "bash" ]
    then
        HS_ENV_SHELL="bash"
        if [ -n "${BASH_SOURCE}" ] && [ -f "$(dirname ${BASH_SOURCE[0]})/source.sh" ]
        then
            # bash
            HS_SCRIPT_PATH="$(dirname ${BASH_SOURCE[0]})"
        fi
    elif [ "$(echo $SHELL | sed 's|/.*/||g')" = "sh" ]
    then
        HS_ENV_SHELL="sh"
    else
        # defaut use bash
        HS_ENV_SHELL="bash"
        if [ -n "${BASH_SOURCE}" ] && [ -f "$(dirname ${BASH_SOURCE[0]})/source.sh" ]
        then
            # bash
            HS_SCRIPT_PATH="$(dirname ${BASH_SOURCE[0]})"
        fi
    fi
fi
HS_SCRIPT_PATH=$(realpath ${HS_SCRIPT_PATH})

function setup_shell()
{
    if [ "${HS_ENV_SHELL}" = "bash" ]
    then
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${HS_ENV_SHELL}
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${HS_ENV_SHELL} >> ~/.bashrc
    elif [ "${HS_ENV_SHELL}" = "zsh" ]
    then
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${HS_ENV_SHELL}
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${HS_ENV_SHELL} >> ~/.zshrc
    fi
}
function setup_tmux()
{
    if ! command -v bc > /dev/null
    then
        echo "bc not found on your shell"
        exit -1
    fi
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
        echo sed -i "/\[include\]/a \ \ \ \ path = ${HOME}/.config/git/config.cfg" ${var_def_cfg}
        sed -i "/\[include\]/a \ \ \ \ path = ${HOME}/.config/git/config.cfg" ${var_def_cfg}
    else
        echo "${var_def_cfg} exist"
    fi

    if [ ! -d "${var_config_path}" ]
    then
        mkdir -p ${var_config_path}
    fi
    ln -sf ${HS_SCRIPT_PATH}/configs/git/*   ${var_config_path}/
    if [ ! -f "${var_config_path}/credential.cfg" ]
    then
        cp ${HS_SCRIPT_PATH}/configs/git/template/credential_template.cfg ${var_config_path}/credential.cfg
    else
        echo "${var_config_path}/credential.cfg exist"

    fi
    if [ ! -f "${var_config_path}/feature.cfg" ]
    then
        cp ${HS_SCRIPT_PATH}/configs/git/template/feature_template.cfg ${var_config_path}/feature.cfg
    else
        echo "${var_config_path}/feature.cfg exist"
    fi

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
