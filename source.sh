#!/bin/bash
function hs_init()
{
    export HS_VER=0.1.1
    export HS_SHELL="zsh"
}
function refresh
{
    source $LIB_PATH/source.sh -p $LIB_PATH
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
                export LIB_PATH=$2
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
    source $LIB_PATH/env.sh
    source $LIB_PATH/config.sh
    if [ "$HS_SHELL" = "bash" ]
    then
        source $LIB_PATH/base_bash.sh
    else
        source $LIB_PATH/base_zsh.sh
    fi
    source $LIB_PATH/lib.sh 
    source $LIB_PATH/project.sh 
    if [ -f $LIB_PATH/lab.sh ]
    then
        source $LIB_PATH/lab.sh 
    fi
}

hs_main $@
unset -f hs_main
unset -f hs_init
