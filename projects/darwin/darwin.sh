# /bin/bash
hs_print "Source Darwin(dw) project"
alias dwlsport="sudo lsof -i -P | grep LISTEN | grep :$PORT"
alias dwlsport4="sudo lsof -nP -i4TCP:$PORT | grep LISTEN"

function dwinfo()
{
    sw_vers
    xcodebuild -showsdks

}
function dwkeyrate()
{
    local var_action=""
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--default)
                var_action="default"
                ;;
            -e|--efficent)
                var_action="efficent"
                ;;
            -v|--verbose)
                flag_verbose=true
                ;;
            -h|--help)
                cli_helper -c "dw_keyrate" -cd "dw_keyrate function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "dw_keyrate [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-d|--default" -d "Restore to defaul key rate settings"
                cli_helper -o "-e|--efficent" -d "Reduce key rate settings"
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


    if [ "${var_action}" = "efficent" ]
    then
        echo "Actions: ${var_action}"
        defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
        defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
    elif [ "${var_action}" = "default" ]
    then
        echo "Actions: ${var_action}"
        defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
        defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms)
    fi
    echo "After settings, please re-login."

}
