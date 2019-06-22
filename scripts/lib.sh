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
########################################################
#####    Functions                                 #####
########################################################
function doloop()
{
    for each_input in $($1)
    do
        # echo $2 $each_input
        bash -c "$2 $each_input"
    done
}
function ffind()
{
    pattern=$1
    echo Looking for $pattern
    find . -iname "*$pattern*"

}
function epath()
{
    #echo "Export Path $1";
    # if grep -q $1 <<<$PATH;
    if echo ${PATH} | grep -q $1
    then
        echo "$1 has alread in your PATH";
        return;
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
function groot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=""
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    local path_array=(`echo $cpath | sed 's/\//\n/g'`)
    for each_folder in $path_array
    do
        if [ $each_folder = $target ]
        then
            cd `echo $cpath | sed "s/$each_folder.*/$each_folder/g"`
            echo goto $each_folder
            return
        fi
    done
    # wallk through files
    while ! ls -a $tmp_path | grep $target;
    do
        pushd $tmp_path > /dev/null
        tmp_path=`pwd`
        if [ $(pwd) = '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            return
        fi
        popd > /dev/null
        tmp_path=$tmp_path"/.."
        target_path=$tmp_path
    done
    echo "goto $target_path"
    cd $target_path
}
function droot()
{
    # fileroot path target
    local cpath=`pwd`
    local target_path=""
    local tmp_path=$cpath
    local target=${1}
    local path_array=(`echo $cpath | sed 's/\//\n/g'`)

    for each_folder in $path_array
    do
        echo $each_folder
        # Upper case: ${var1^^}
        # Lower case: ${var2^^}
        # [ ${each_folder,,} = ${target,,} ]
        if [ -d ${each_folder} ] && [ $(grep -ix "${target}" <<< "${each_folder}")]
        then
            cd `echo $cpath | sed "s/$each_folder.*/$each_folder/g"`
            echo goto $each_folder
            return
        fi
    done
}
function lab_groot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=""
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    local path_array=(`echo $cpath | sed 's/\//\n/g'`)
    for each_folder in $path_array
    do
        echo $each_folder
        # Upper case: ${var1^^}
        # Lower case: ${var2^^}
        # [ ${each_folder,,} = ${target,,} ]
        if [ -d ${each_folder} ] && [ $(grep -ix "${target}" <<< "${each_folder}")]
        then
            cd `echo $cpath | sed "s/$each_folder.*/$each_folder/g"`
            echo goto $each_folder
            return
        fi
    done
    return
    # wallk through files
    while ! ls -a $tmp_path | grep $target;
    do
        pushd $tmp_path > /dev/null
        tmp_path=`pwd`
        if [ $(pwd) = '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            return
        fi
        popd > /dev/null
        tmp_path=$tmp_path"/.."
        target_path=$tmp_path
    done
    echo "goto $target_path"
    cd $target_path
}
