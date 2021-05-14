#/bin/env shell
SCRIPT_PATH="$(realpath $(dirname ${0}))"

function setup_shell()
{
    echo $SHELL
    local shell_name=$(echo $SHELL | rev | cut -d '/' -f 1 | rev)
    if [ "$shell_name" = "bash" ]
    then
        echo source $SCRIPT_PATH/source.sh -s=$shell_name
        echo source $SCRIPT_PATH/source.sh -s=$shell_name >> ~/.bashrc
    elif [ "$shell_name" = "zsh" ]
    then
        echo source $SCRIPT_PATH/source.sh -s=$shell_name
        echo source $SCRIPT_PATH/source.sh -s=$shell_name >> ~/.zshrc
    fi
}
function setup_tmux()
{
    ln -sf $SCRIPT_PATH/configs/others/tmux.conf ${HOME}/.tmux.conf
}
function excute()
{
    echo "Script Path:${SCRIPT_PATH}"
    echo ${SCRIPT_PATH}/source.sh --silence=n -x $@
    ${SCRIPT_PATH}/source.sh --silence=n -x $@
}
function setup()
{
    while [ "$#" != "0" ]
    do
        case $1 in
            -t|--tmux)
                setup_tmux
                ;;
            -s|--shell)
                setup_shell
                ;;
            -x|--excute)
                shift 1
                excute $@
                return 0
                ;;
            -h|--help)
                echo "Setup Usage"
                printf "%s%s%s\n" "-t|--tmux" "->" "Set tmux"
                printf "%s%s%s\n" "-s|--shell" "->" "Set shell"
                return 0
                ;;
            *)
                setup_shell
                ;;
        esac
        shift 1
    done
}
setup $@
