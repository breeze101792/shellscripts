# project releated commands
########################################################
#####    Settings                                     #####
########################################################
epath ${HOME}/.bin
########################################################
#####    Alias                                     #####
########################################################
alias mdebug="screen -S debug -L -Logfile debug_`tstamp`.log /dev/ttyUSB1 115200 "
alias sdebug="screen -S debug_s -L -Logfile debug_`tstamp`.log"
alias proot="groot .project"
# git alias ##
#export lg1="log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"

########################################################
#####    Functions                                 #####
########################################################
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
function pvinit()
{
    local src_path=($@)
    echo ${src_path[@]}
    [ -f cscope.db ] && rm cscope.db 2> /dev/null
    [ -f proj.files ] && rm proj.files 2> /dev/null
    [ -f tags ] && rm tags 2> /dev/null

    for each_path in ${src_path[@]}
    do
        echo "Searching path: ${each_path}"
        if [ "$each_path" = "" ]
        then
            echo "Finished"
            break
        else
            echo -e "Searching folder: $each_path"
            # find ${each_path} -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" >> proj.files
            # find ${each_path} \( -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" \) -a \( -not -path "*/build/*" -a -not -path "*/auto_gen*" \) >> proj.files
            find ${each_path} \( -type f -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" \) -a \( -not -path "*/auto_gen*" -a  -not -path "*/build" \) >> proj.files
        fi
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
function gforall()
{
    find . -name ".git" | while read dir;
    do
        cd `dirname ${dir}`
        echo "Project Dir: ${dir}"
        bash -c "$@" || { echo "checkout optee os file"; popd; exit 1; }
        cd -
    done
}
function gclone()
{
    echo "new"
    if (( $# < 3 ))
    then
        echo "gitclone shoulde have 3 args."
        echo "gitclone [Server] [project] [branch]"
        echo "$@"
        return -1
    fi
    local git_host=$1
    local git_project=$2
    local git_branch=$3
    shift 3

    echo "Clone ${git_project}:${git_branch} from ${git_host}"
    git clone http://${git_host}/${git_project} -b ${git_branch} $@
}
function gcheckoutByDate()
{
    pwd
    local checkout_date=$1
    local cBranch=$2
    local target_commit=`git rev-list -n 1 --first-parent --before="$checkout_date" $cBranch`
    echo branch: $cBranch
    echo commit: $target_commit
    echo git checkout $target_commit
    git checkout $target_commit
}
function gpush()
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
rforall()
{
    repo forall -vc "git $@"
}
function mark()
{
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
    if [[ $# = 1 ]]
    then
        local clr_idx=1
        local hi_word=$1
        shift 1
    else
        local clr_idx=$1
        local hi_word=$2
        shift 2
    fi
    local color_array=(
        # $(echo -e "\033[0;30m")
        $(echo -e "\033[0;31m")
        $(echo -e "\033[0;32m")
        $(echo -e "\033[0;33m")
        $(echo -e "\033[0;34m")
        $(echo -e "\033[0;35m")
        $(echo -e "\033[0;36m")
        $(echo -e "\033[0;37m")
        $(echo -e "\033[1;30m")
        $(echo -e "\033[1;31m")
        $(echo -e "\033[1;32m")
        $(echo -e "\033[1;33m")
        $(echo -e "\033[1;34m")
        $(echo -e "\033[1;35m")
        $(echo -e "\033[1;36m")
        $(echo -e "\033[1;37m")
    )
    # ccred=$(echo -e "\033[0;31m")
    # ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    # echo $ccred$hi_word$ccend
    # $@ 2>&1 | sed -E -e "s%${hi_word}%${color_array[$clr_idx]}&${ccend}%ig"
    sed -E -e "s%${hi_word}%${color_array[$clr_idx]}&${ccend}%ig"
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
