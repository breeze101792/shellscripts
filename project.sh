# project releated commands

## alias
alias mdebug="screen -S debug -L -Logfile debug_`tstamp`.log /dev/ttyUSB1 115200 "
alias sdebug="screen -S debug_s -L -Logfile debug_`tstamp`.log"

# git alias ##
#export lg1="log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"

## functions ##
groot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    echo $target
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
    done
    cd $tmp_path
}
alias proot="groot project"
make()
{
    pathpat="(/[^/]*)+:[0-9]+"
    ccred=$(echo -e "\033[0;31m")
    ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    /usr/bin/make "$@" 2>&1 | sed -E -e "/[Uu]ndefined[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ff]atl[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ee]rror[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ww]arning[: ]/ s%$pathpat%$ccyellow&$ccend%g"
    return ${PIPESTATUS[0]}
}
gpush()
{
    echo "Push commit to Branch $1"
    if [ $# != 1 ]
    then
        echo "Missing Branch argment";
        return
    else
        git push origin HEAD:refs/for/$1
    fi
}
rgit()
{
    repo forall -vc "git $@"
}
