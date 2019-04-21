# project releated commands
## env
epath ${HOME}/.bin
## alias
alias mdebug="screen -S debug -L -Logfile debug_`tstamp`.log /dev/ttyUSB1 115200 "
alias sdebug="screen -S debug_s -L -Logfile debug_`tstamp`.log"
alias proot="groot .project"
# git alias ##
#export lg1="log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"

## functions ##
# project commands
function pjinit()
{
    if [ $# = 0 ]
    then
        local pj_name=$(echo `pwd` |rev| cut -d'/' -f 1| rev)
    else
        local pj_name=$1
    fi
    local pj_postfix="proj"
    echo "export PJ_ROOT=`pwd`" > ${pj_name}.${pj_postfix}
    echo "export PJ_NAME=$pj_name" > ${pj_name}.${pj_postfix}
    echo "export PJ_DATE=`date`" >> ${pj_name}.${pj_postfix}

}
function pjroot()
{
    if [[ -z $PJ_ROOT ]]
    then
        groot proj
    else
        cd $PJ_ROOT
    fi
}
# vim funcions
function gcc_setup()
{
    if [ "$1" != "clang"]
    then
        local gcc_ver=7
        alias gcc='gcc-$gcc_ver'
        alias cc='gcc-$gcc_ver'
        alias g++='g++-$gcc_ver'
        alias c++='c++-$gcc_ver'
    fi
}
function pvinit_en()
{
    local proj_path=$HS_ENV_IDE_PATH/$1
    shift 1
    local src_path=($@)
    local count=0
    echo ${src_path[@]}
    mkdir $proj_path
    while true
    do
        current_path=${src_path[$count]}
        echo -e "Searching folder: $current_path"
        if [ "$current_path" = "" ]
        then
            echo "Finished"
            break
        else
            ln -sf `pwd`/$current_path $proj_path/$current_path
            # find ${current_path} -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" >> cscope.files
        fi
        let count++
    done
    pushd $proj_path
        find ${current_path} -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" >> cscope.files
        ctags -R
        cscope -b
        mv cscope.out cscope.db
    popd

}
function pvinit_bak()
{
    local src_path=($@)
    echo ${src_path[@]}
    ctags -R
    local count=0
    while true
    do
        current_path=${src_path[$count]}
        if [ "$current_path" = "" ]
        then
            echo "Finished"
            break
        else
            echo -e "Searching folder: $current_path"
            find ${current_path} -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" >> cscope.files
        fi
        let count++
    done
    cscope -b
    mv cscope.out cscope.db
}
function pvinit()
{
    local src_path=($@)
    echo ${src_path[@]}
    local count=0
    rm cscope.db proj.files tags
    while true
    do
        current_path=${src_path[$count]}
        if [ "$current_path" = "" ]
        then
            echo "Finished"
            break
        else
            echo -e "Searching folder: $current_path"
            find ${current_path} -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" >> proj.files
        fi
        let count++
    done
    cscope -b -i proj.files
    ctags -L proj.files
    mv cscope.out cscope.db
}

function pvim()
{
    local cpath=`pwd`
    groot "cscope.db"
    export CSCOPE_DB=`pwd`/cscope.db
    echo $CSCOPE_DB
    cd $cpath
    vim $@
}
function make()
{
    pathpat="(/[^/]*)+:[0-9]+"
    ccred=$(echo -e "\033[0;31m")
    ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    /usr/bin/make "$@" 2>&1 | sed -E -e "/[Uu]ndefined[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ff]atl[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ee]rror[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ww]arning[: ]/ s%$pathpat%$ccyellow&$ccend%g"
    return ${PIPESTATUS[0]}
}
function gcheckoutByDate()
{
    # local checkout_date="2019-04-10 00:00"
    local checkout_date=$1
    local cBranch=`git rev-parse --abbrev-ref HEAD`
    local target_commit=`git rev-list -n 1 --first-parent --before=$checkout_date $cBranch`
    git checkout $target_commit
}
gpush()
{
    echo "Push commit to Branch $1"
        local cbranch=""
        local remote=""
        local branch=""
    if [ $# = 0 ]
    then
        local cbranch=$(git branch| sed -e '/^[^*]/d' -e 's/* //g')
        local remote=$(git branch -r | grep $cbranch | grep -ve "HEAD" |rev |cut -d'/' -f2 | rev)
        local branch=$(git branch -r | grep $cbranch | grep -ve "HEAD" |rev |cut -d'/' -f1 | rev)
        echo "[1] Auto push to $remote $branch";
        # git push $remote HEAD:refs/for/$branch
    elif [ $# = 1 ]
    then
        local cbranch=$1
        local remote=$(git branch -r | grep $cbranch | grep -ve "HEAD" |rev |cut -d'/' -f2 | rev)
        local branch=$(git branch -r | grep $cbranch | grep -ve "HEAD" |rev |cut -d'/' -f1 | rev)
        echo "[2] Auto push to $remote $branch";
        # git push $remote HEAD:refs/for/$branch
    elif [ $# = 2 ]
    then
        local remote=$1
        local branch=$2
        echo "[3] Auto push to $remote $branch";
        # git push $remote HEAD:refs/for/$branch
    fi
    git push $remote HEAD:refs/for/$branch
}
rgit()
{
    repo forall -vc "git $@"
}
mark()
{
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
    local hi_word=$1
    shift 1
    ccred=$(echo -e "\033[0;31m")
    ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    echo $ccred$hi_word$ccend
    $@ 2>&1 | sed -E -e "s%${hi_word}%${ccred}&${ccend}%ig"
}
mark_build()
{
    local ccred=$(echo -e "\033[0;31m")
    local ccyellow=$(echo -e "\033[0;33m")
    local ccend=$(echo -e "\033[0m")
    $@ 2>&1 | sed -E -e "s%undefined%$ccred&$ccend%ig" -e "s%fatl%$ccred&$ccend%ig" -e "s%error%$ccred&$ccend%ig" -e "s%fail%$ccred&$ccend%ig" -e "s%warning%$ccyellow&$ccend%ig"
}
wdiff()
{
    diff -rq $1 $2 | cut -f2 -d' '| uniq | sort
}
hex2bin()
{
    cat $1 | sed s/,//g | sed s/0x//g | xxd -r -p - $2
}
# repo enhance
function fGitCheckoutByDate()
{
    local checkout_date=$1
    local cBranch=$2
    local target_commit=`git rev-list -n 1 --first-parent --before=$checkout_date $cBranch`
    echo branch: $cBranch/$target_commit
    # echo git checkout $target_commit
    git checkout $target_commit
}
