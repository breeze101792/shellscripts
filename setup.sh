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
            -t|--tmux)
                setup_tmux
                ;;
            -s|--shell)
                setup_shell
                ;;
            -h|--help)
                echo "Setup Usage"
                printf "%s%s%s\n" "-t|--tmux" "->" "Set tmux"
                printf "%s%s%s\n" "-s|--shell" "->" "Set shell"
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
}
setup $@
