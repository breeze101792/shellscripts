#!/bin/bash
export LIB_PATH=$(pwd)

function refresh
{
    source $LIB_PATH/source.sh -p $LIB_PATH
}

function __main
{
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
            *)
                break
                ;;
        esac
    done
    # source shell scripts
    source $LIB_PATH/base.sh
    source $LIB_PATH/lib.sh 
    if [ -d pacman -Syu uboot-cubieboard2 ];then
        source $LIB_PATH/lab.sh 
    fi
}

__main $@
unset -f __main
