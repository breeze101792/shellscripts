#!/bin/bash
########################################################
########################################################
#####                                              #####
#####    For HS Lib Functions                      #####
#####                                              #####
########################################################
########################################################
#####    Alias                                     #####
########################################################
alias ls='ls --color=auto --group-directories-first -X '
# alias ls='ls --color=auto'
alias l='ls -a --color=auto'
alias ll='l -lh'
alias llt='ll -t'
alias xc="xclip"
alias xv="xclip -o"
alias tstamp='date +%Y%m%d_%H%M%S'
alias cgrep='grep --color=always '
alias sgrep='grep --color=always -rnIi  '
alias vim='TERM=xterm-256color && vim '
alias vi='TERM=xterm-256color && vim -m '
########################################################
#####    Functions                                 #####
########################################################
function doloop()
{
    local gen_list_cmd=$1
    local do_cmd=$2
    for each_input in $(bash -c ${gen_list_cmd})
    do
        echo ${do_cmd} $each_input
        # bash -c "${do_cmd} ${each_input}"
        eval "${do_cmd} ${each_input}"
    done
}
function ffind()
{
    pattern=$1
    # echo Looking for $pattern
    find . -iname "*$pattern*"

}
function epath()
{
    #echo "Export Path $1";
    # if grep -q $1 <<<$PATH;
    if echo ${PATH} | grep -q $1
    then
        echo "$1 has alread in your PATH";
        # exit 1
        return 1
    else
        export PATH=$1:$PATH;
    fi;

}
function pureshell()
{
    echo "Pure bash"
    if [ -f ~/.purebashrc ]
    then
        # the purebashrc shour contain execu
        env -i bash -c "export TERM=xterm && source ~/.purebashrc && bash --norc"
        # env -i bash -c "export TERM=xterm && bash --rcfile  ~/.purebashrc"
    else
        env -i bash -c "export TERM=xterm && bash --norc"
    fi

}
function droot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=${cpath}
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    local path_array=(`echo $cpath | sed 's/\//\n/g'`)
    # wallk through files
    while ! echo ${tmp_path} | rev |  cut -d'/' -f 1 | rev   |  grep -i $target;
    do
        tmp_path=$tmp_path"/.."
        pushd $tmp_path > /dev/null
        tmp_path=`pwd`
        # echo "Searching in $tmp_path"
        if [ $(pwd) = '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            return 1
            # exit 1
        fi
        popd > /dev/null
        target_path=$tmp_path
    done
    echo "goto $target_path"
    cd $target_path
}
function froot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=${cpath}
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    # wallk through files
    while ! ls -a $tmp_path | grep -i $target;
    do
        tmp_path=$tmp_path"/.."
        pushd $tmp_path > /dev/null
        tmp_path=`pwd`
        echo "Searching in $tmp_path"
        if [ $(pwd) = '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            # exit 1
            return 1
        fi
        popd > /dev/null
        target_path=$tmp_path
    done
    echo "goto $target_path"
    cd $target_path
}
function groot()
{
    local pattern=$1
    droot ${pattern} || froot ${pattern}
}
function echoerr()
{
    >&2 echo $@
}
