SCRIPT_PATH=`pwd`
function setup()
{
    echo $SHELL
    local shell_name=$(echo $SHELL | rev | cut -d '/' -f 1 | rev)
    if [ "$shell_name" = "bash" ]
    then
        echo source $SCRIPT_PATH/source.sh -s=$shell_name -p=`pwd`
    elif [ "$shell_name" = "zsh" ]
    then
        echo source $SCRIPT_PATH/source.sh -s=$shell_name -p=`pwd`
    fi
}
function setup_config()
{
    ln -sf  $SCRIPT_PATH/configs/others/tmux.conf ${HOME}/.tmux.conf
}
setup $@
