#!/bin/bash
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
    source $HS_LIB_PATH/source.sh -p=${HS_LIB_PATH} -s=${HS_SHELL}
}

function hs_main
{
    if [ "${HS_ENV_ENABLE}" = "false" ]
    then
        echo "Skip HS Env"
        return
    fi
    local flag_env_silence=""
    local flag_env_change_shell_path=""

    for arg in $@
    do
        case $arg in
            -p=*|--lib-path=*)
                export HS_LIB_PATH=${arg#*=}
                ;;
            -s=*|--shell-type=*)
                export HS_SHELL=${arg#*=}
                ;;
            -S|--silence)
                flag_env_silence="y"
                ;;
            --change-shell-path=*)
                flag_env_change_shell_path="n"
                ;;
            # --xxxxxxx=*)
            #     REPO_CHECKOUT_DEPTH=${arg#*=}
            #     DO_SET_CHECKOUT_DEPTH=y
            #     ;;
            *)
                break
                ;;
        esac
    done

    # while true;
    # do
    #     case $1 in
    #         -t|--test)
    #             echo "$1"
    #             shift 1
    #             ;;
    #         -p|--lib_path)
    #             export HS_LIB_PATH=$2
    #             shift 2
    #             ;;
    #         -s|--shell-type)
    #             export HS_SHELL=$2
    #             shift 2
    #             ;;
    #         -S|--silence)
    #             flag_env_silence="y"
    #             shift 1
    #             ;;
    #         --change-shell-path)
    #             flag_env_change_shell_path="y"
    #             shift 1
    #             ;;
    #         *)
    #             break
    #             ;;
    #     esac
    # done
    # source shell scripts
    set -a
    ##########################################
    # setup configs
    ##########################################
    source $HS_LIB_PATH/scripts/env_config.sh
    if [ -f $HOME/.hsconfig.sh ]
    then
        source $HOME/.hsconfig.sh
    fi
    if [ "${flag_env_silence}" = "y" ]
    then
        HS_ENV_SILENCE="y"
    fi
    if [ "${flag_env_change_shell_path}" = "y" ]
    then
        HS_CONFIG_I3_PATCH="y"
    elif [ "${flag_env_change_shell_path}" = "n" ]
    then
        HS_CONFIG_I3_PATCH="n"
    fi
    ##########################################
    # shell init
    ##########################################
    if [ "$HS_SHELL" = "bash" ]
    then
        export HS_SHELL="bash"
        source $HS_LIB_PATH/scripts/base_bash.sh
    else
        export HS_SHELL="zsh"
        source $HS_LIB_PATH/scripts/base_zsh.sh
    fi
    source $HS_LIB_PATH/scripts/lib.sh
    hs_print "Version: $HS_VER"
    ##########################################
    # Post init
    ##########################################

    source $HS_LIB_PATH/scripts/tools.sh
    source $HS_LIB_PATH/scripts/project.sh
    source $HS_LIB_PATH/scripts/others.sh
    source $HS_LIB_PATH/scripts/lab.sh
    # End of shell
    if [ -f $HS_LIB_PATH/scripts/work.sh ]
    then
        source $HS_LIB_PATH/scripts/work.sh
    fi
    set +a
}

hs_main $@
unset -f hs_main
