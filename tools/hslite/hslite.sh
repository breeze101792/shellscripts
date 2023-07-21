#!/bin/sh
################################################################
####    Env
################################################################
[ -z ${HOME} ] && export HOME=/

################################################################
####    Settings
################################################################
# Use GNU ls colors when tab-completing files
set colored-stats on

# Disable history function
set +o history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

################################################################
####    Alias
################################################################
alias ll="ls -al"
alias grep="grep --line-buffered"

################################################################
####    Function
################################################################
epath()
{
    local flag_verbose=n
    if [[ $# == 0 ]]
    then
        echo "PATH=${PATH}"
        return 0
    fi
    #echo "Export Path $1";
    # if grep -q $1 <<<$PATH;
    local target_path=$(realpath $1)
    if echo ${PATH} | grep -q ${target_path}
    then
        [ "${flag_verbose}" = "y" ] && echo "${target_path} has alread in your PATH";
        return 1
    else
        [ "${flag_verbose}" = "y" ] && echo -E "export PATH=${target_path}:"'$PATH;'
        export PATH=${target_path}:$PATH;
        return 0
    fi;

}
balias()
{
    local var_toolbox="busybox"
     var_white_list=("ls")
    for each_cmd in $(${var_toolbox} | grep 'Currently defined functions' -A 1000 | sed 's/,//g' | sed '1d')
    do
        if [ "${each_cmd}" = '[' ] || [ "${each_cmd}" = '[[' ] || command -v ${each_cmd} > /dev/null
        then
            for each_whited_listed_cmd in ${var_white_list}
            do
                if [ "${each_whited_listed_cmd}" = "${each_cmd}" ]
                then
                    echo "alias |${each_cmd}|"
                    alias ${each_cmd}="${var_toolbox} ${each_cmd}"
                fi
            done
            continue
        fi
        echo "alias |${each_cmd}|"
        alias ${each_cmd}="${var_toolbox} ${each_cmd}"
    done
}
################################################################
####    Post Setting
################################################################
if test -f work.sh
then
    source work.sh
fi
