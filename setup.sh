function setup()
{
    echo $SHELL
    local shell_name=$(echo $SHELL | rev | cut -d '/' -f 1 | rev)
    if [ "$shell_name" = "bash" ]
    then
        echo `pwd`/source.sh -s $shell_name -p `pwd`
    elif [ "$shell_name" = "zsh" ]
    then
        echo `pwd`/source.sh -s $shell_name -p `pwd`
    fi
}
setup $@
