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
    local var_cmd="echo 'Template Function'"
    local flag_echo="y"

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--append)
                file_ext+="-o -name \"*.${2}\""
                shift 1
                ;;
            -h|--help)
                echo "tmplate"
                printlc -cp false -d "->" "-a|--append" "append file extension on search"
                printlc -cp false -d "->" "-h|--help" "Print help function "
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
        eval "${var_cmd}"
    fi
}
