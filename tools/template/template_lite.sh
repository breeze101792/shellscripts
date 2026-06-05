#!/bin/bash
###########################################################
## Vars
###########################################################
export VAR_SCRIPT_NAME="$(basename ${BASH_SOURCE[0]%=.})"
export SCRIPT_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export PATH_ROOT="$(pwd)"

###########################################################
## Functions
###########################################################
fHelp()
{
    echo "${VAR_SCRIPT_NAME}"
    echo "[Example]"
    printf "    %s\n" "run help: ${VAR_SCRIPT_NAME} -h"
    echo "[Options]"
    printf "    %- 16s\t%s\n" "-v|--verbose" "Print in verbose mode"
    printf "    %- 16s\t%s\n" "-h|--help" "Print helping"
}
function fexample()
{
    echo "This is example function."
}
## Main Functions
###########################################################
function fMain()
{
    while [[ $# != 0 ]]
    do
        case $1 in
            -h|--help)
                fHelp
                exit 0
                ;;
            *)
                echo "Unknown Options: ${1}"
                fHelp
                exit 1
                ;;
        esac
        shift 1
    done

    fexample
}

fMain "$@"
