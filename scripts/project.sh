# project releated commands
########################################################
########################################################
#####                                              #####
#####    For HS Project Functions                  #####
#####                                              #####
########################################################
########################################################
epath ${HOME}/.bin > /dev/null
########################################################
#####    Alias                                     #####
########################################################
alias proot=proj_root
# git alias ##
# alias glog2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"
########################################################
########################################################
#####                                              #####
#####    Debug                                     #####
#####                                              #####
########################################################
########################################################
# Serial debug
function sdebug()
{
    local target_dev=/dev/ttyUSB0
    local baud_rate=115200
    local session_name="Debug"
    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -d|--device)
                target_dev=$2
                shift 1
                ;;
            -b|--baud-rate)
                baud_rate=$2
                shift 1
                ;;
            -s|--session-name)
                session_name=$2
                shift 1
                ;;
            -h|--help)
                echo "sdebug Usage"
                printlc -cp false -d "->" "-d|--device" "Set device"
                printlc -cp false -d "->" "-b|--baud-rate" "Set Baud Rate"
                printlc -cp false -d "->" "-s|--session-name" "Set Session Name"
                return 0
                ;;
            *)
                echo "Unknown Options"
                return 1
                ;;
        esac
        shift 1
    done
    retitle ${session_name}
    screen -S ${session_name} -L -Logfile debug_$(tstamp).log ${target_dev} ${baud_rate}
}
alias mdebug="sdebug --device /dev/ttyUSB1"

########################################################
########################################################
#####                                              #####
#####    Functions                                 #####
#####                                              #####
########################################################
########################################################
# project commands
function proj_root()
{
    if [[ -z $PROJ_ROOT ]]
    then
        if groot ".hs_*proj"
        then
            return 0
        else
            return 1
        fi
    else
        cd $PROJ_ROOT
        return 0
    fi
}
function proj_man()
{
    echo "Test"
    for arg in $@
    do
        echo loop ${arg}
        case $arg in
            -l|--list-project)
                ls ${HS_PATH_PROJ}
                ;;
            -i=*|--init=*)
                echo "init"
                export PROJ_FILE=${arg#*=}
                echo "Select Project: ${PROJ_FILE}"
                source ${HS_PATH_PROJ}/${PROJ_FILE}
                proj_envsetup

                local proj_postfix="proj"
                local proj_prefix=".hs_"
                local proj_local_file=${proj_prefix}${PROJ_NAME}.${proj_postfix}
                touch ${proj_local_file}
                echo "# $PROJ_NAME" >> ${proj_local_file}
                printf "export PROJ_FILE=%s\n" ${PROJ_FILE} >> ${proj_local_file}
                echo "export PROJ_ROOT=$(realpath ${PWD})" >> ${proj_local_file}
                echo -e "export PROJ_DATE=\"`date`\"" >> ${proj_local_file}
                source ${proj_local_file}
                ;;
            # --xxxxxxx=*)
            #     REPO_CHECKOUT_DEPTH=${arg#*=}
            #     DO_SET_CHECKOUT_DEPTH=y
            #     ;;
            *)
                echo Unknown
                break
                ;;
        esac
    done
    echo "End"
}
function proj_refresh()
{
    local cpath=$(pwd)
    if proj_root
    then
        source .hs_*.proj
    fi

    if [ -f "${PROJ_FILE}" ]
    then
        echo "Select Project: $1"
        source ${PROJ_FILE}
    fi
}
########################################################
#####    VIM                                      #####
########################################################
function pvupdate()
{
    local cpath=${PWD}
    froot proj.files

    cscope -b -i proj.files
    ctags -L proj.files
    mv cscope.out cscope.db
    echo "Update linking files"
    cd ${cpath}
}
function pvinit()
{
    local file_ext=()
    local find_cmd=""
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--append)
                file_ext+="-o -name \"*.${2}\""
                shift 1
                ;;
            -h|--help)
                echo "pvinit"
                printlc -cp false -d "->" "-a|--append" "append file extension on search"
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    if [ "$#" = "0" ]
    then
        echo "Please enter folder name"
        return -1
    fi
    local src_path=($@)
    echo Searching Path:${src_path[@]}
    echo file_ext: $file_ext
    [ -f cscope.db ] && rm cscope.db 2> /dev/null
    [ -f proj.files ] && rm proj.files 2> /dev/null
    [ -f tags ] && rm tags 2> /dev/null

    for each_path in ${src_path[@]}
    do
        local tmp_path=$(realpath ${each_path})
        echo "Searching path: ${tmp_path}"
        if [ "$tmp_path" = "" ]
        then
            continue
        else
            echo -e "Searching folder: $tmp_path"
            find_cmd="find ${tmp_path} \( -type f -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' ${file_ext[@]} \) -a \( -not -path '*/auto_gen*' -a -not -path '*/build' \) | xargs realpath >> proj.files"
            eval ${find_cmd}
        fi
    done
    cscope -b -i proj.files
    ctags -L proj.files
    mv cscope.out cscope.db
}

function pvim()
{
    # if [ -d $1 ]
    # then
    #     echo "Please enter a file name"
    # fi
    local target_file=$(realpath ${1})
    local cpath=`pwd`
    groot "cscope.db"
    # export CSCOPE_DB=`pwd`/cscope.db
    export CSCOPE_DB=`pwd`/cscope.db
    echo $CSCOPE_DB
    cd $cpath
    vim ${target_file}
    # unset var
    unset CSCOPE_DB
}
########################################################
#####    GIT                                      #####
########################################################
function gforall()
{
    find . -name ".git" | while read dir;
    do
        cd `dirname ${dir}`
        echo "Project Dir: ${dir}"
        # bash -c "$@" || { echo "checkout optee os file"; popd; exit 1; }
        eval "$@" || { echo "checkout optee os file"; popd; exit 1; }
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
    # gerrit push
    local cbranch=""
    local remote=""
    local branch=""
    local commit="HEAD"
    local push_word="for"
    local excute_flag="y"
    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -r|--remote)
                remote=$2
                shift 1
                ;;
            -b|--branch)
                branch=$2
                shift 1
                ;;
            -c|--commit)
                commit=$2
                shift 1
                ;;
            -d|--draft)
                push_word="drafts"
                ;;
            -f|--fake)
                excute_flag="n"
                ;;
            -h|--help)
                echo "gpush Usage"
                printlc -cp false -d "->" "-r|--remote" "Set remote"
                printlc -cp false -d "->" "-b|--branch" "Set branch"
                printlc -cp false -d "->" "-c|--commit" "Set commit"
                printlc -cp false -d "->" "-d|--draft" "Set dfaft"
                printlc -cp false -d "->" "-f|--fake" "Set fake"
                return 0
                ;;
            *)
                echo "Unknown Options"
                return 1
                ;;
        esac
        shift 1
    done

    if [ "${cbranch}" = "" ]
    then
        local cbranch=$(git branch| sed -e '/^[^*]/d' -e 's/* //g' | tr -d "[:blank:]")
        echo "Auto set current branch to |${cbranch}|"
    fi
    if [ "${remote}" = "" ]
    then
        local remote=$(git branch -r | grep "/$cbranch$" | grep -ve "HEAD" |rev |cut -d'/' -f2 | rev | tr -d "[:blank:]")
        # git show remote
        echo "Auto set remote to |${remote}|"
    fi
    if [ "${branch}" = "" ]
    then
        local branch=$(git branch -r | grep "/$cbranch$" | grep -ve "HEAD" |rev |cut -d'/' -f1 | rev | tr -d "[:blank:]")
        echo "Auto set branch to |${branch}|"
    fi


    printt "Auto Push ${commit} to ${remote}/${branch}" | mark -s green "#"
    local cmd="git push ${remote} ${commit}:refs/${push_word}/${branch}"
    # echo "Push ${commit} to ${remote}/${branch}"
    echo "Eval Command: ${cmd}"
    if [ "${excute_flag}" = "y" ]
    then
        eval ${cmd}
    fi
}
function ginfo()
{
    local fetch_url="$(git remote show $(git remote show) | grep Fetch |cut -d':' -f 2- | tr -d '[:blank:]')"
    local branch_name="$(git remote show $(git remote show) | grep 'HEAD branch' |cut -d':' -f 2- | tr -d '[:blank:]')"
    local rel_branch_name="$(git branch -a | grep '\->' | cut -d'/' -f 4)"
    local current_branch=$(git branch| sed -e '/^[^*]/d' -e 's/* //g' | tr -d "[:blank:]")
    git remote show $(git remote show) | head -n 4
    echo "Fetch cmd: git clone ${fetch_url} -b ${branch_name}"
    echo "Fetch cmd: git clone ${fetch_url} -b ${rel_branch_name}"
    echo "Fetch cmd: git clone ${fetch_url} -b ${current_branch}"

}
function rforall()
{
    repo forall -vc "git $@"
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

########################################################
#####    Build                                     #####
########################################################
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

# Color       #define       Value       RGB
# black     COLOR_BLACK       0     0, 0, 0
# red       COLOR_RED         1     max,0,0
# green     COLOR_GREEN       2     0,max,0
# yellow    COLOR_YELLOW      3     max,max,0
# blue      COLOR_BLUE        4     0,0,max
# magenta   COLOR_MAGENTA     5     max,0,max
# cyan      COLOR_CYAN        6     0,max,max
# white     COLOR_WHITE       7     max,max,max
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

    local clr_idx=1
    local hi_word=""
    local clr_code=""
    local ccstart=${color_array[1]}
    local ccend=$(echo -e "\033[0m")

    if [ "$1" = "-c" ] || [ "$1" = "-C" ] || [ "$1" = "--color" ]
    then
        clr_idx=$2
        shift 2
        hi_word=$*
        local ccstart=${color_array[$clr_idx]}
    elif [ "$1" = "-s" ] || [ "$1" = "-S" ] || [ "$1" = "--color-name" ]
    then
        local color_name=$2
        shift 2
        hi_word=$*
        case ${color_name} in
            red)
                ccstart=$(tput setaf 1)
                ;;
            green)
                ccstart=$(tput setaf 2)
                ;;
            yellow)
                ccstart=$(tput setaf 3)
                ;;
            blue)
                ccstart=$(tput setaf 4)
                ;;
        esac
    else
        hi_word=$*
    fi
    # echo $ccred$hi_word$ccend
    # $@ 2>&1 | sed -E -e "s%${hi_word}%${color_array[$clr_idx]}&${ccend}%ig"
    sed -u -E -e "s%${hi_word}%${ccstart}&${ccend}%ig"
}
mark_build()
{
    # local ccred=$(echo -e "\033[0;31m")
    # local ccyellow=$(echo -e "\033[0;33m")
    # local ccend=$(echo -e "\033[0m")
    # $@ 2>&1 | sed -E -e "s%undefined%$ccred&$ccend%ig" -e "s%fatal%$ccred&$ccend%ig" -e "s%error%$ccred&$ccend%ig" -e "s%fail%$ccred&$ccend%ig" -e "s%warning%$ccyellow&$ccend%ig"
    if [[ $# == 0 ]]
    then
        mark -s yellow "undefined" |  mark -s red "fatal" | mark -s red "error" | mark -s red "fail" | mark -s yellow "warning"
    else
        $@ 2>&1 | mark -s yellow "undefined" |  mark -s red "fatal" | mark -s red "error" | mark -s red "fail" | mark -s yellow "warning"
    fi
}
# function make()
# {
#     pathpat="(/[^/]*)+:[0-9]+"
#     ccred=$(echo -e "\033[0;31m")
#     ccyellow=$(echo -e "\033[0;33m")
#     ccend=$(echo -e "\033[0m")
#     # /usr/bin/make "$@" 2>&1 | sed -E -e "/[Uu]ndefined[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ff]atl[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ee]rror[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ww]arning[: ]/ s%$pathpat%$ccyellow&$ccend%g"
#     mark_build /usr/bin/make "$@"
#     return ${PIPESTATUS[0]}
# }
########################################################
#####    Dev                                       #####
########################################################
function pyenv_create()
{
    if [[ $# == 0 ]]
    then
        return 1
    fi
    local target_path=$(realpath ${1})
    virtualenv --system-site-packages -p python3 ${target_path}
}
function pyenv()
{
    source ${HS_PATH_PYTHEN_ENV}/bin/activate
    $@
    # deactivate
}
########################################################
#####    Others                                    #####
########################################################
wdiff()
{
    diff -rq $1 $2 | cut -f2 -d' '| uniq | sort
}
hex2bin()
{
    cat $1 | sed s/,//g | sed s/0x//g | xxd -r -p - $2
}
