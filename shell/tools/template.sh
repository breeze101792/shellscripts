#!/bin/bash
########################################################
########################################################
#####                                              #####
#####    Template Function                         #####
#####                                              #####
########################################################
########################################################
function tmp1()
{
    local file_ext=()
    local cmd_args="echo 'Template Function'"
    local flag_verbose="n"
    local flag_echo="y"

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -o|--options)
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        # not start with -
                        cmd_args+=("${2}")
                        shift 1
                    fi
                fi
                ;;
            -a|--append)
                cmd_args+=("${2}")
                shift 1
                ;;
            -v|--verbose)
                flag_verbose="y"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--append" -d "append file extension on search"
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done
    if [ "${flag_echo}" = "y" ]
    then
        eval "${cmd_args[@]}"
    fi
}
