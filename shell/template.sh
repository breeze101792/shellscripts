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
    local flag_echo="y"

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--append)
                cmd_args+="${2}"
                shift 1
                ;;
            -h|--help)
                cli_helper -t "tmplate"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "tmplate [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--append" -d "append file extension on search"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    if [ "${flag_echo}" = "y" ]
    then
        eval "${cmd_args}"
    fi
}
