#!/bin/bash
function hs_init()
{
    export HS_VER=0.1.2
    export HS_SHELL="zsh"
}
function refresh
{
    source $HS_LIB_PATH/source.sh -p $HS_LIB_PATH -s $HS_SHELL
}

function hs_main
{
    if [[ -z $HS_VER ]]; then
        hs_init
    fi

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
    source $HS_LIB_PATH/scripts/env.sh
    source $HS_LIB_PATH/scripts/config.sh
    if [ "$HS_SHELL" = "bash" ]
    then
        source $HS_LIB_PATH/scripts/base_bash.sh
    else
        source $HS_LIB_PATH/scripts/base_zsh.sh
    fi
    source $HS_LIB_PATH/scripts/lib.sh
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
