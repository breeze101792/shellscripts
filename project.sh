# project releated commands

## git alias ##
#export lg1="log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"

## functions ##
groot()
{
    local tmp_path=$(pwd)
    local cpath=$(pwd)
    while ! ls $cpath | egrep $1;
    do 
        pushd $cpath > /dev/null
        cpath=`pwd`
        if [ $(pwd) == '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            return
        fi
        popd > /dev/null
        cpath=$cpath"/.."
    done
    cd $cpath
}
proot()
{
    local cpath=$(pwd)
    while ! ls $cpath | egrep '*.project';
    do 
        pushd $cpath > /dev/null
        cpath=`pwd`
        if [ $(pwd) == '/' ];
        then
            echo 'Hit the root'
            cd $cpath
            popd > /dev/null
            return
        fi
        popd > /dev/null
        cpath=$cpath"/.."
    done
    cd $cpath
}
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
    fi
    git push origin HEAD:refs/for/$1
}
rgit()
{
    repo forall -vc "git $@"
}
