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
    local rc_script=''
    if [ "${HS_ENV_SHELL}" = "bash" ]
    then
        rc_script=~/.bashrc
    elif [ "${HS_ENV_SHELL}" = "zsh" ]
    then
        rc_script=~/.zshrc
    else
        echo 'Shell not supported.'
        return -1
    fi
    touch ${rc_script}
    if ! cat ${rc_script} | grep 'source\.sh'
    then
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${HS_ENV_SHELL}
        echo source ${HS_SCRIPT_PATH}/source.sh -s=${HS_ENV_SHELL} >> ${rc_script}
    else
        echo 'HS Already install'
    fi
}
function setup_shell_lite()
{
    local rc_script=''
    if [ "${HS_ENV_SHELL}" = "bash" ]
    then
        rc_script=~/.bashrc
    else
        echo 'Shell not supported.'
        return -1
    fi
    cp -f ${HS_SCRIPT_PATH}/tools/hslite/hslite.sh ${HOME}/hslite.sh
    touch ${rc_script}
    if ! $(cat ${rc_script} | grep 'source\.sh')
    then
        echo source ${HOME}/hslite.sh
        echo source ${HOME}/hslite.sh >> ${rc_script}
    else
        echo 'HS Already install'
    fi
}
function setup_tmux()
{
    if ! command -v bc > /dev/null
    then
        echo "bc not found on your shell"
        exit -1
    fi
    ln -sf ${HS_SCRIPT_PATH}/configs/tmux/tmux.conf ${HOME}/.tmux.conf
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
function setup_config()
{
    echo "Setup Local config"
    local local_config_path=${HOME}/.hsconfig.sh

    echo "########################################################" >> ${local_config_path}
    echo "#####                                              #####" >> ${local_config_path}
    echo "#####    Template Setting                          #####" >> ${local_config_path}
    echo "#####                                              #####" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}

    echo "########################################################" >> ${local_config_path}
    echo "#####    Config Setting Zone                       #####" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    cat ${HS_SCRIPT_PATH}/shell/enviroment/config.sh | grep test |grep HS_CONFIG | sed "s/^.*&/#/g" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    echo "#####    Path Setting Zone                         #####" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    cat ${HS_SCRIPT_PATH}/shell/enviroment/config.sh | grep test |grep HS_PATH | grep -v "ECD" | sed "s/^.*&/#/g" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    echo "#####    Platform Setting Zone                     #####" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    cat ${HS_SCRIPT_PATH}/shell/enviroment/config.sh | grep test |grep HS_PLATFORM | sed "s/^.*&/#/g" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    echo "#####    VARs Zone                                 #####" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    cat ${HS_SCRIPT_PATH}/shell/enviroment/config.sh | grep test |grep HS_VAR | grep -v "ECD" | sed "s/^.*&/#/g" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    echo "#####    Shortcut Path                             #####" >> ${local_config_path}
    echo "########################################################" >> ${local_config_path}
    cat ${HS_SCRIPT_PATH}/shell/enviroment/config.sh | grep test | grep "ECD" | sed "s/^.*&/#/g" >> ${local_config_path}

    cat ${local_config_path}
}
function setup_hsexc()
{
    local var_hs_target_path="$(realpath ~/.usr/bin)/hsexc"
    echo "${SHELL} ${HS_SCRIPT_PATH}/source.sh --silence=n -p ${HS_SCRIPT_PATH} -x "'$@' > ${var_hs_target_path}
    chmod u+x ${var_hs_target_path}
}
function excute()
{
    echo "Script Path:${HS_SCRIPT_PATH}"
    echo ${SHELL} ${HS_SCRIPT_PATH}/source.sh --silence=n -p ${HS_SCRIPT_PATH} -x $@
    ${SHELL} ${HS_SCRIPT_PATH}/source.sh --silence=n -p ${HS_SCRIPT_PATH} -x $@
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
            -h|--shell-setup)
                setup_shell
                ;;
            -s|--setup)
                setup_shell
                setup_config
                setup_usr
                setup_tmux
                setup_git
                ;;
            -l|--lite)
                setup_shell_lite
                ;;
            -u|--usr)
                setup_usr
                ;;
            -c|--config)
                setup_config
                ;;
            -hx|--hs-excute)
                setup_hsexc
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
                printf "    %s%s%s\n" "-s|--setup" "->" "Setup all"
                printf "    %s%s%s\n" "-hs|--shell-setup" "->" "Setup shell"
                printf "    %s%s%s\n" "-l|--lite" "->" "Setup lite shell"
                printf "    %s%s%s\n" "-c|--config" "->" "Setup config"
                printf "    %s%s%s\n" "-u|--usr" "->" "setup local usr"
                printf "    %s%s%s\n" "-hs|--hs-excute" "->" "Create hs excutable on .usr/bin"
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
