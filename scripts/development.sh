########################################################
########################################################
#####                                              #####
#####    Development Function                      #####
#####                                              #####
########################################################
########################################################

########################################################
#####    Alias                                     #####
########################################################
# git alias ##
# alias glog2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"

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
    local file_exclude=()
    local find_cmd=""
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--append)
                file_ext+="-o -name \"*.${2}\""
                shift 1
                ;;
            -x|--exclude)
                file_exclude+="-o -name \"*.${2}\""
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
            find_cmd="find ${tmp_path} \( -type f -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' ${file_ext[@]} \) -a \( -not -path '*/auto_gen*' -o -not -path '*/build' ${file_exclude[@]} \) | xargs realpath >> proj.files"
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
#####    Debug                                     #####
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
#####    Others Function                           #####
########################################################
logfile()
{

    if [ "$1" = "-p" ]
    then
        if [ ! -d "${2}" ]
        then
            echo "Create Log Folder: $2"
            mkdir ${2}
        fi

        local logname="$(realpath $2)/logfile_`tstamp`.log"
        shift 2
    else
        local logname="logfile_`tstamp`.log"
    fi
    local start_date=$(date)

    echo "Command:\"$@\"" > $logname
    echo "Start Date: ${start_date}" >> $logname
    echo "================================================" >> $logname
    eval "$@" 2>&1 | tee -a $logname
    echo "================================================" >> $logname
    echo "Command Finished:\"$@\"" >> $logname
    echo "Start Date: ${start_date}" >> $logname
    echo "End   Date: $(date)" >> $logname

    echo "Log file has been stored in ${logname}" | mark -s green ${logname}
}
function slink()
{
    local target_path=""
    if [ "$#" = "1" ]
    then
        target_path=$(realpath ${1})
    else
        target_path=$(realpath ${PWD})
    fi

    rm ${HS_PATH_SLINK}
    ln -sf  ${target_path} ${HS_PATH_SLINK}
    ls -al ${HS_PATH_SLINK}
}
########################################################
#####    Build                                     #####
########################################################
function mark_build()
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
########################################################
#####    Exc Enhance                               #####
########################################################
function session
{
    local session_name=""
    if [ "$#" = "1" ]
    then
        local tmp_name=$(tmux ls |grep ${1}| cut -d ':' -f 1)
        if [ "${tmp_name}" != "" ] &&  tmux ls
        then
            session_name=${tmp_name}
        else
            session_name=${1}
        fi
    else
        # session_name="Tmp Session"
        tmux ls
        return
    fi

    if tmux ls | grep ${session_name}
    then
        echo "Start session: ${session_name}"
        retitle ${session_name}
        tmux a -dt ${session_name}
    else
        echo "Create session: ${session_name}"
        retitle ${session_name}
        pureshell "export TERM='xterm-256color' && tmux -2 new -s ${session_name}"
    fi
    # tmux a -t ${session_name} || tmux new -s ${session_name}
}
function erun()
{
    # enhanced run
    local excute_cmd=""
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--Source-HS)
                local excute_cmd="source $HOME/tools/shellscripts/source.sh -p=$HOME/tools/shellscripts -s="${HS_ENV_SHELL}" --change-shell-path=n --silence=y && "
                ;;
            -h|--help)
                echo "erun"
                printlc -cp false -d "->" "-s|--Source-HS" "Source HS config"
                return 0
                ;;

            *)
                local excute_cmd="${excute_cmd}$@"
                break
                ;;
        esac
        shift 1
    done

    local start_time=$(date "+%Y-%m-%d_%H:%M:%S")
    echo "Start cmd: $(printc -c yellow ${excute_cmd})"
    printt "$(printlc -lw 32 -cw 0 -d " " "Start Jobs at ${start_time}" "")" | mark -s green "#"
    # mark_build "${excute_cmd}"
    if [ -n "${HS_PATH_LOG}" ]
    then
        if [ ! -d "${HS_PATH_LOG}" ]
        then
            mkdir ${HS_PATH_LOG}
        fi
        logfile -p "${HS_PATH_LOG}" eval "${excute_cmd}"
    else
        echo "Log file path not define.HS_PATH_LOG=${HS_PATH_LOG}"
        eval "${excute_cmd}"
    fi
    local end_time=$(date "+%Y-%m-%d_%H:%M:%S")
    printt "$(printlc -lw 32 -cw 0 -d " " "Job Finished" "")\n$(printlc -lw 8 -cw 24 "Start" ${start_time})\n$(printlc -lw 8 -cw 24  "End" ${end_time})" | mark -s green "#"
    echo "Finished cmd: $(printc -c yellow ${excute_cmd})"
}
########################################################
#####    Git Function                              #####
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
                printlc -cp false -d "->" "-d|--draft" "Set draft"
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
    echo "---- Clone ----"
    echo "Fetch cmd: git clone ${fetch_url} -b ${branch_name}"
    echo "Fetch cmd: git clone ${fetch_url} -b ${rel_branch_name}"
    echo "Fetch cmd: git clone ${fetch_url} -b ${current_branch}"
    echo "---- Reset Online ----"
    echo "Fetch cmd: git reset --hard $(git remote)/${branch_name}"
    echo "Fetch cmd: git reset --hard $(git remote)/${rel_branch_name}"
    echo "Fetch cmd: git reset --hard $(git remote)/${current_branch}"

}
function rforall()
{
    repo forall -vc "git $@"
}
########################################################
#####    Binary                                    #####
########################################################
wdiff()
{
    diff -rq $1 $2 | cut -f2 -d' '| uniq | sort
}
hex2bin()
{
    cat $1 | sed s/,//g | sed s/0x//g | xxd -r -p - $2
}
########################################################
#####    Pythen                                    #####
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
