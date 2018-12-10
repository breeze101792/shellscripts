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
                LIB_PATH=$2
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
    # source shell scripts
    source $LIB_PATH/lib.sh
}

__main $@
unset -f __main
