#!/bin/bash
########################################################
########################################################
#####                                              #####
#####    For sHellScript Source Script             #####
#####                                              #####
########################################################
########################################################
function hs_print()
{
    # echo ${HS_ENV_SILENCE}
    if [ "${HS_ENV_SILENCE}" = "n" ]
    then
        echo -E "hs> $@"
    fi
}
function refresh
{
    local cpath=$(realpath .)
    source $HS_PATH_LIB/source.sh -p=${HS_PATH_LIB} -s=${HS_ENV_SHELL} -S=${HS_ENV_SILENCE} --refresh
    cd ${cpath}
}
function hs_source()
{
    local source_file=$1

    if false
    then
        local start_time=$(date +%s%N)
        source $(realpath ${source_file})
        local end_time=$(date +%s%N)

        # echo "$start_time, $end_time"
        local diff_time=$(( (${end_time} - ${start_time})/1000000 ))
        hs_print "[${diff_time}] source ${source_file}\n"
    else
        source $(realpath ${source_file})
    fi
}

function hs_main
{
    if [ "${HS_ENV_ENABLE}" = "false" ]
    then
        echo "Skip HS Env"
        return
    fi
    ##########################################
    # Vars
    ##########################################
    local flag_var_refresh="n"

    ##########################################
    # configs
    ##########################################
    local flag_env_silence=""
    local flag_env_change_shell_path=""
    local flag_env_shell=""
    local flag_env_lib_path=""

    ##########################################
    # Others
    ##########################################
    local excute_command=""


    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p=*|--lib-path=*)
                flag_env_lib_path=${1#*=}
                ;;
            -s=*|--shell-type=*)
                flag_env_shell=${1#*=}
                ;;
            -S=*|--silence=*)
                flag_env_silence=${1#*=}
                ;;
            --change-shell-path=*)
                flag_env_change_shell_path=${1#*=}
                ;;
            -p|--lib-path)
                flag_env_lib_path=${2}
                shift 1
                ;;
            -s|--shell-type)
                flag_env_shell=${2}
                shift 1
                ;;
            -S|--silence)
                flag_env_silence=${2}
                shift 1
                ;;
            --change-shell-path)
                flag_env_change_shell_path=${2}
                shift 1
                ;;
            --refresh)
                flag_var_refresh="y"
                ;;
            -x|--excute)
                shift 1
                excute_command=$*
                break
                ;;
            *)
                # echo "Options not found. ${arg}"
                break
                ;;
        esac
        shift 1
    done
    ##########################################
    # Auto detect configs
    ##########################################
    if [ -z "${flag_env_shell}" ]
    then
        flag_env_shell="$(echo ${SHELL} | rev |  cut -d '/' -f 1 | rev)"
    fi
    if [ -z "${flag_env_lib_path}" ]
    then
        if [ "${flag_env_shell}" = "bash" ]
        then
            flag_env_lib_path="$(dirname \"${BASH_SOURCE[0]}\")"
        else
            flag_env_lib_path="$(realpath .)"
        fi
    fi

    # source shell scripts
    ##########################################
    # setup configs
    ##########################################
    if [ "${flag_env_lib_path}" = "" ]
    then
        export HS_PATH_LIB=$(pwd)
    else
        export HS_PATH_LIB=${flag_env_lib_path}
    fi
    source $HS_PATH_LIB/shell/env_config.sh
    if [ -f $HOME/.hsconfig.sh ]
    then
        source $HOME/.hsconfig.sh
    fi
    if [ -f $HOME/.hsconfig ]
    then
        source $HOME/.hsconfig
    fi
    ##########################################
    # setup custom configs
    ##########################################
    hs_source ${HS_PATH_LIB}/shell/shell_common.sh
    if [ "${flag_env_shell}" = "" ]
    then
        export HS_ENV_SHELL=bash
    else
        export HS_ENV_SHELL=${flag_env_shell}
    fi

    if [ "${flag_env_silence}" = "y" ]
    then
        HS_ENV_SILENCE="y"
    elif [ "${flag_env_silence}" = "n" ]
    then
        HS_ENV_SILENCE="n"
    fi
    if [ "${flag_env_change_shell_path}" = "y" ]
    then
        HS_CONFIG_CHANGE_DIR="y"
    elif [ "${flag_env_change_shell_path}" = "n" ]
    then
        HS_CONFIG_CHANGE_DIR="n"
    fi
    ##########################################
    # shell preset
    ##########################################

    ##########################################
    # shell init
    ##########################################
    if [ "$HS_ENV_SHELL" = "bash" ]
    then
        export HS_ENV_SHELL="bash"
        hs_source $HS_PATH_LIB/shell/base_bash.sh
    else
        export HS_ENV_SHELL="zsh"
        hs_source $HS_PATH_LIB/shell/base_zsh.sh
    fi
    hs_print "Version: $HS_ENV_VER"
    hs_source $HS_PATH_LIB/shell/env_platform.sh
    hs_source $HS_PATH_LIB/shell/lib.sh
    hs_source $HS_PATH_LIB/shell/cli.sh
    hs_source $HS_PATH_LIB/shell/tools.sh
    hs_source $HS_PATH_LIB/shell/development.sh
    hs_source $HS_PATH_LIB/shell/others.sh
    hs_source $HS_PATH_LIB/projects/project.sh
    ##########################################
    # shell post init
    ##########################################
    if [ "${HS_ENV_SHELL}" = "bash" ] && [ "${HS_CONFIG_FUNCTION_EXPORT}" = "y" ]
    then
        export_sh_func ${HS_PATH_LIB}/shell/shell_common.sh
        export_sh_func ${HS_PATH_LIB}/shell/lib.sh
        export_sh_func ${HS_PATH_LIB}/shell/tools.sh
        export_sh_func ${HS_PATH_LIB}/shell/development.sh
    fi
    # if [ "${flag_var_refresh}" = "n" ] && [ ${HS_ENV_SILENCE} = "n" ]
    if [ "${flag_var_refresh}" = "n" ]
    then
        retitle "${HS_ENV_TITLE}"
    fi

    ##########################################
    # Source Other settings
    ##########################################

    if [ -f $HS_PATH_LIB/shell/lab.sh ]
    then
        hs_source $HS_PATH_LIB/shell/lab.sh
    fi
    # End of shell
    if [ -f ${HS_PATH_WORK}/work.sh ]
    then
        hs_source ${HS_PATH_WORK}/work.sh
    fi

    ##########################################
    # Excute Command
    ##########################################
    if [ ! -z "${excute_command}" ]
    then
        eval "${excute_command}"
    fi
}

hs_main $@
unset -f hs_main
##########################################
# Post Setting
##########################################
# retitle "HS Shell"
