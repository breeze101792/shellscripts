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
    if [[ "$#" = "0" ]]
    then
        echo "Default action"
        return 0
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--append)
                file_ext+="-o -name \"*.${2}\""
                shift 1
                ;;
            -h|--help)
                echo "pvinit"
                printlc -cp false -d "->" "-a|--append" "append file extension on search"
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
}
