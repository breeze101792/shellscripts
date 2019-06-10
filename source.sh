#!/bin/bash
function hs_init()
{
    export HS_VER=0.1.4
}
function refresh
{
    source $HS_LIB_PATH/source.sh -p $HS_LIB_PATH -s $HS_SHELL
}

function hs_main
{
    if [ "${HS_ENV_ENABLE}" = "false" ]
    then
        echo "Skip HS Env"
        return
    fi

    hs_init
    echo "Version: $HS_VER"
    while true;
    do
        case $1 in
            -t)
                echo "$1"
                shift 1
                ;;
            -p)
                export HS_LIB_PATH=$2
                shift 2
                ;;
            -s)
                export HS_SHELL=$2
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
    # source shell scripts
    source $HS_LIB_PATH/scripts/env_config.sh
    if [ -f $HOME/.hsconfig.sh ]
    then
        source $HOME/.hsconfig.sh
    fi
    if [ "$HS_SHELL" = "bash" ]
    then
        export HS_SHELL="bash"
        source $HS_LIB_PATH/scripts/base_bash.sh
    else
        export HS_SHELL="zsh"
        source $HS_LIB_PATH/scripts/base_zsh.sh
    fi
    source $HS_LIB_PATH/scripts/lib.sh
    source $HS_LIB_PATH/scripts/tools.sh
    source $HS_LIB_PATH/scripts/project.sh
    source $HS_LIB_PATH/scripts/lab.sh
    if [ -f $HS_LIB_PATH/scripts/work.sh ]
    then
        source $HS_LIB_PATH/scripts/work.sh
    fi
}

hs_main $@
unset -f hs_main
unset -f hs_init
