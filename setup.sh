SCRIPT_PATH=$(realpath .)

function setup_shell()
{
    echo $SHELL
    local shell_name=$(echo $SHELL | rev | cut -d '/' -f 1 | rev)
    if [ "$shell_name" = "bash" ]
    then
        echo source $SCRIPT_PATH/source.sh -s=$shell_name -p=${SCRIPT_PATH}
    elif [ "$shell_name" = "zsh" ]
    then
        echo source $SCRIPT_PATH/source.sh -s=$shell_name -p=${SCRIPT_PATH}
    fi
}
function setup_tmux()
{
    ln -sf $SCRIPT_PATH/configs/others/tmux.conf ${HOME}/.tmux.conf
}
function setup()
{
    while true
    do
        case $1 in
            --tmux)
                setup_tmux
                shift 1
                break
                ;;
            --shell)
                setup_shell
                shift 1
                break
                ;;
            *)
                echo "Unknown Options"
                shift 1
                break
                ;;
        esac
    done
}
setup $@
