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
alias glog2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gstatus='git status -uno '
alias gdiff='git diff --check --no-ext-diff'
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
#alias lg="git $lg1"
alias proot="froot -m .repo || froot -m .git"
alias nlfsgit="GIT_LFS_SKIP_SMUDGE=1 git "

########################################################
#####    VIM                                      #####
########################################################
function pvupdate()
{
    local cpath=${PWD}
    local target_file="proj.files"
    if froot ${target_file}
    then
        echo "Found ${target_file} in $(pwd)"
    else
        echo "${target_file} not found."
        return 1
    fi

    [ -f cscope.db ] && rm cscope.db 2> /dev/null
    [ -f cctree.db ] && rm cctree.db 2> /dev/null
    [ -f tags ] && rm tags 2> /dev/null

    ########################################
    # Add c(uncompress) for fast read
    # ctags -L proj.files
    ctags -R --c++-kinds=+p --C-kinds=+p --fields=+iaS --extra=+q -L proj.files &
    # ctags -R  --C-kinds=+p --fields=+aS --extra=+q
    # ctags -R -f ~/.vim/tags/c  --C-kinds=+p --fields=+aS --extra=+q
    cscope -c -b -i proj.files -f cscope.db&
    wait
    # command -V ccglue && ccglue -S cscope.out -o cctree.db
    command -V ccglue && ccglue -S cscope.db -o cctree.db
    # mv cscope.out cscope.db
    echo "Tag generate successfully."
    ########################################

    cd ${cpath}
}
function pvinit()
{
    local var_cpath=$(pwd)
    local file_ext=()
    local file_exclude=()
    local find_cmd=""
    local target_list_name="proj.files"
    local target_proj_name="proj.vim"
    local flag_append=n
    local flag_header=n

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--append)
                flag_append="y"
                ;;
            -e|--extension)
                file_ext+="-o -name \"*.${2}\""
                shift 1
                ;;
            -x|--exclude)
                file_exclude+="-o -name \"*.${2}\""
                shift 1
                ;;
            -c|--clean)
                local tmp_file_array=("${target_list_name}" "pvinit.err" "cscope.db" "cctree.db" "tags")
                for each_file in "${tmp_file_array[@]}"
                do
                    if [ -f "${each_file}" ]
                    then
                        echo "remove ${each_file}"
                        rm ${each_file}
                    fi
                done
                return 0
                ;;
            --header)
                flag_header=y
                ;;
            -h|--help)
                cli_helper -c "pvinit"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "pvinit [Options] [Dirs]"
                cli_helper -t "Options"
                cli_helper -o "-a|--append" -d "append more fire in file list"
                cli_helper -o "-e|--extension" -d "add file extension on search"
                cli_helper -o "-x|--exclude" -d "exclude file on search"
                cli_helper -o "-c|--clean" -d "Clean related files"
                cli_helper -o "--header" -d "Add header vim code"
                cli_helper -o "-h|--help" -d "Print help function "
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

    if [ "${flag_append}" = "n" ] && [ -f "${target_list_name}" ]
    then
        rm "${target_list_name}" 2> /dev/null
    elif [ "${flag_append}" = "y" ] && froot ${target_list_name}
    then
        target_list_name="$(realpath ${target_list_name})"
        cd ${var_cpath}
    fi
    echo "Searching Path:${#src_path[@]}${src_path[@]}"
    echo "file_ext: $file_ext"
    echo "Project List File: ${target_list_name}"

    for each_path in ${src_path[@]}
    do
        # echo "Searching path: ${each_path}"
        if [ ! -e ${each_path} ]
        then
            printc -c red "folder not found: "
            echo -e "${each_path}"
            continue
        else
            local tmp_path=$(realpath ${each_path})
            printc -c green "Searching folder: "
            echo -e "$tmp_path"
            find_cmd="find ${tmp_path} \( -type f -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' ${file_ext[@]} \) -a \( -not -path '*/auto_gen*' -o -not -path '*/build*' ${file_exclude[@]} \) | xargs realpath >> \"${target_list_name}\""
            # echo ${find_cmd}
            eval "${find_cmd}"
        fi
    done

    if [ "${flag_header}" = "y" ] && froot ${target_list_name}
    then
        cat ${target_list_name} | grep "h$\|hpp$\|hxx$" | xargs dirname | sort |uniq |sed "s/^/set path+=/g" > ${target_proj_name}
    fi

    local tmp_file="tmp.files"
    cat "${target_list_name}" | sort | uniq > "${tmp_file}"
    mv "${tmp_file}" "${target_list_name}"
    pvupdate
}

function pvim()
{
    # if [ -d $1 ]
    # then
    #     echo "Please enter a file name"
    # fi
    local vim_args=""
    local cpath=`pwd`
    local cmd_args=()
    local flag_cctree=n
    local flag_proj_vim=y
    local flag_time=n
    local var_timestamp="$(tstamp)"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -m|--map)
                flag_cctree=y
                ;;
            -p|--pure-mode)
                cmd_args+=("-u NONE")
                ;;
            -t|--time)
                flag_time=y
                cmd_args+=("-X --startuptime startup_${var_timestamp}.log")
                ;;
            -c|--clip)
                shift 1
                local buf_tmp="$@"
                [ -f "${buf_tmp}" ] && buf_tmp=$(realpath ${buf_tmp})
                [ -f "${HOME}/.vim/clip" ] && rm -f ${HOME}/.vim/clip

                printf "%s" "${buf_tmp}" | sed '$ s/$.*//g' > ${HOME}/.vim/clip
                return 0
                ;;
            -h|--help)
                cli_helper -c "pvim"
                cli_helper -d "pvim [Options] [File]"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "pvim [Options] [File]"
                cli_helper -t "Options"
                cli_helper -o "-m|--map" -d "Load cctree in vim"
                cli_helper -o "-p|--pure-mode" -d "Load withouth ide file"
                cli_helper -o "-t|--time" -d "Enable startup debug mode"
                cli_helper -o "-c|--clip" -d "Save file in vim buffer file"
                cli_helper -o "-h|--help" -d "Print help function "
                cli_helper -t "vim-Options"
                cli_helper -o "-R" -d "vim read only mode"
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    vim_args=$@

    # unset var
    unset CSCOPE_DB
    unset CCTREE_DB

    if froot "cscope.db"
    then
        export CSCOPE_DB=`pwd`/cscope.db
        echo "CSCOPE: ${CSCOPE_DB}"
    else
        echo "Project ccscop tag not found."
    fi
    if [ "${flag_proj_vim}" = "y" ] && test -f "proj.vim"
    then
        export PROJ_VIM=`pwd`/proj.vim
        echo "Proj VIM: ${PROJ_VIM}"
    fi

    if [ "${flag_cctree}" = "y" ] && test -f "cctree.db"
    then
        export CCTREE_DB=`pwd`/cctree.db
        echo "CCTREE: ${CCTREE_DB}"
    fi

    cd $cpath
    eval ${HS_VAR_VIM} ${cmd_args[@]} ${vim_args[@]}
    echo "Launching: ${HS_VAR_VIM} ${cmd_args[@]} ${vim_args[@]}"
    # unset var
    unset CSCOPE_DB
    unset CCTREE_DB

    if [ "${flag_time}" = "y" ]
    then
        tail -n 1 startup_${var_timestamp}.log
    fi
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
    local serial_log_path="${HS_PATH_LOG}/serial"
    local var_prefix=""

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
            -p|--prefix)
                var_prefix=$2
                shift 1
                ;;
            -h|--help)
                cli_helper -c "sdebug"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "sdebug [Options] [Device]"
                cli_helper -t "Options"
                cli_helper -o "-d|--device" -d "Set device"
                cli_helper -o "-b|--baud-rate" -d "Set Baud Rate"
                cli_helper -o "-s|--session-name" -d "Set Session Name"
                cli_helper -o "-p|--prefix" -d "Add prefix before program, usually use sudo"
                cli_helper -o "-h|--help" -d "Print help function "
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
    [ ! -d ${serial_log_path} ] && mkdir -p ${serial_log_path} && echo "Create ${serial_log_path}"
    var_cmd="${var_prefix} screen -S ${session_name} -L -Logfile ${serial_log_path}/debug_$(tstamp).log ${target_dev} ${baud_rate}"
    echo "${var_cmd}"
    eval "${var_cmd}"
}
alias mdebug="sdebug --device /dev/ttyUSB1"

########################################################
#####    Others Function                           #####
########################################################
function scheduler()
{
    echo "Enter taskwarrior"
    local var_promot="task> "
    local var_hist_list=()
    task
    # push current history to new stack , and switch to new list
    # fc -p -a /tmp/.zfhistory 10 10
    while true
    do
        local task_cmd=""
        if command -v vared > /dev/null
        then
            vared -p ${var_promot} task_cmd
        else
            read -p ${var_promot} -e task_cmd
        fi
        # echo ${task_cmd}
        case ${task_cmd} in
            task)
                ;;
            hist|history)
                for each_idx in $(seq 1 ${#var_hist_list[@]})
                do
                    printf "[%d] %s\n" "${each_idx}" "${var_hist_list[${each_idx}]}"
                done
                continue
                ;;
            projs)
                # task projects rc.list.all.projects=1
                task rc.list.all.projects=1 _projects
                continue
                ;;
            weekly)
                task end.after:sunday-2weeks completed
                continue
                ;;
            clear)
                clear
                continue
                ;;
        esac

        echo "-------------------------------------------------"
        eval task ${task_cmd}
        echo ""
        var_hist_list+=${task_cmd}
        if [[ ${#var_hist_list} = 21 ]]
        then
            var_hist_list=${var_hist_list:2:20}
        fi
    done
}
function logfile()
{
    local logdir=""
    local var_ret=0
    local var_tstamp=`tstamp`
    local var_logname="logfile_${var_tstamp}.log"
    local var_error_logname="logfile_${var_tstamp}_error.log"
    local flag_error_file="n"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p|--path)
                if [ ! -d "${2}" ]
                then
                    echo "Create Log Folder: $2"
                    mkdir ${2}
                fi

                local logdir="$(realpath $2)"
                shift 1
                ;;
            -e|--error)
                flag_error_file="y"
                ;;
            -f|--file-name)
                local var_logname="${2}"
                local var_error_logname=$(echo ${2} | sed 's/\.log/_error\.log/g')
                shift 1
                ;;
            -h|--help)
                echo "logfile"
                printlc -cp false -d "->" "-p|--path" "path name"
                printlc -cp false -d "->" "-f|--file-name" "file name"
                printlc -cp false -d "->" "-e|--error" "enable error file"
                return 0
                ;;

            *)
                break
                ;;
        esac
        shift 1
    done
    if [ -z "${logdir}" ]
    then
        local fulllogname=${var_logname}
        local full_error_logname=${var_error_logname}
    else
        local fulllogname=${logdir}/${var_logname}
        local full_error_logname=${logdir}/${var_error_logname}
    fi
    local start_date=$(date)
    local var_cmd="$(echo -e $@)"

    echo "Logfile Command:\"${var_cmd}\""
    echo "Command:\"${var_cmd}\"" > $fulllogname
    echo "Start Date: ${start_date}" >> $fulllogname
    echo "===================================================================" >> $fulllogname
    echo "==================================================================="
    if [ "${flag_error_file}" = "y" ]
    then
        # eval "${var_cmd}" 2> >(tee ${var_error_logname}) > >(tee ${var_error_logname}) | tee -a ${fulllogname}
        eval "${var_cmd}" 2> >(tee ${var_error_logname}) | tee -a ${fulllogname}
    else
        eval "${var_cmd}" 2>&1 | tee -a ${fulllogname}
    fi
    var_ret=$?

    echo "===================================================================" >> $fulllogname
    echo "Command Finished:\"${var_cmd}\"" >> $fulllogname
    echo "Start Date: ${start_date}" >> $fulllogname
    echo "End   Date: $(date)" >> $fulllogname
    echo "==================================================================="
    echo "Log file has been stored in the following path." | mark -s green "${fulllogname}"
    echo "Full Log: ${fulllogname}" | mark -s green "${fulllogname}"

    if [ "${flag_error_file}" = "y" ] && [ -n "${full_error_logname}" ]
    then
        if [ -s "${full_error_logname}" ]
        then
            echo "Err Log: ${full_error_logname}" | mark -s red "${full_error_logname}"
        else
            rm "${full_error_logname}"
        fi
    fi
    return ${var_ret}
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

    if [ -d "${target_path}" ]
    then
        rm ${HS_PATH_SLINK}
        ln -sf  ${target_path} ${HS_PATH_SLINK}
        ls -al ${HS_PATH_SLINK}
    else
        echo "Forder not found.(${target_path})"
    fi

}
########################################################
#####    Build                                     #####
########################################################
alias mark_build="mbuild "
function mbuild()
{
    local var_cmd=""
    local var_mark_cmd=""
    local tmp_color=""
    # red
    tmp_color="red"
    var_mark_cmd="mark -s ${tmp_color} 'fatal' | mark -s ${tmp_color} 'error' | mark -s ${tmp_color} 'fail'"
    var_mark_cmd="${var_mark_cmd} | mark -s ${tmp_color} '^make.* \*\*\*'"
    # yellow
    tmp_color="yellow"
    var_mark_cmd="${var_mark_cmd} | mark -s ${tmp_color} 'undefined' | mark -s ${tmp_color} 'redefined' | mark -s ${tmp_color} 'warning'"
    # green
    tmp_color="green"
    var_mark_cmd="${var_mark_cmd} | mark -s ${tmp_color} 'compile ' | mark -s ${tmp_color} '^make'"
    # cyan
    tmp_color="cyan"
    var_mark_cmd="${var_mark_cmd} | mark -s ${tmp_color} ' note'"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            # -a|--append)
            #     cmd_args+="${2}"
            #     shift 1
            #     ;;
            -c|--cat)
                var_cmd="cat ${var_cmd}"
                ;;
            -h|--help)
                cli_helper -c "mbuild" -cd "mark build function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "mbuild [Options] [command]"
                cli_helper -t "Options"
                cli_helper -o "-c|--cat" -d "cat file with mark"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_cmd="${var_cmd} $@"
                break
                ;;
        esac
        shift 1
    done
    if [[ $# == 0 ]]
    then
        # mark -s green 'compile' | mark -s yellow 'undefined' | mark -s yellow 'redefined' |    mark -s red 'fatal' | mark -s red 'error' | mark -s red 'fail' | mark -s yellow 'warning'
        eval "${var_mark_cmd}"
    else
        # eval ${var_cmd} 2>&1 | mark -s green "compile" | mark -s yellow "undefined" | mark -s yellow "redefined" |    mark -s red "fatal" | mark -s red "error" | mark -s red "fail" | mark -s yellow "warning"
        eval "${var_cmd}" 2>&1 | eval "${var_mark_cmd}"
    fi
}
function lanalyser
{
    local var_logfile=""
    local flag_android="n"
    local flag_make="n"
    local flag_syntax="n"
    local flag_command_missing="n"
    local flag_file_missing="n"
    local flag_others="n"
    local flag_python="n"

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--all)
                flag_android="y"
                flag_make="y"
                flag_syntax="y"
                flag_command_missing="y"
                flag_file_missing="y"
                flag_others="y"
                flag_python="y"
                ;;
            -v|--vim)
                shift 1
                eval vim $@
                return 0
                ;;
            -f|--log-file)
                var_logfile="${2}"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "lanalyser" -cd "lanalyser function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "lanalyser [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--all" -d "enable all debug flag"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-v|--vim" -d "dirrect vim log file "
                cli_helper -o "-f|--log-file" -d "Specify log file"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_logfile="$@"
                break
                ;;
        esac
        shift 1
    done

    if [ "${flag_android}" = "y" ]
    then
        echo "flag_android: ${flag_android}"
        echo "---- Android log analysis"
        # local total_line=$(wc -l ${var_logfile} | cut -d " " -f1 )
        # cat ${var_logfile} | grep -B ${total_line} "error.*generated" | tac | grep -B ${total_line} "generated.$" | tac | mark_build
        cat -n ${var_logfile} | grep "error.*generated\|^FAILED:" | mark_build
    fi
    if [ "${flag_make}" = "y" ]
    then
        echo "---- Make log analysis"
        cat -n ${var_logfile} | grep "make.*Error\|Makefile.*\*\*\*" | mark_build
    fi
    if [ "${flag_syntax}" = "y" ]
    then
        echo "---- Syntax log analysis"
        tmp_pattern="undefined reference"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"

        tmp_pattern="unknown type name"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"
    fi

    if [ "${flag_command_missing}" = "y" ]
    then
        echo "---- command missing "
        cat -n ${var_logfile} | grep "command not found" | mark "command not found"
    fi

    if [ "${flag_file_missing}" = "y" ]
    then
        echo "---- file/dir/permission missing "
        tmp_pattern="Can not find directory"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"

        tmp_pattern="No such file or directory"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"

        tmp_pattern="No space left on device"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"
    fi

    if [ "${flag_python}" = "y" ]
    then
        echo "---- python error"
        tmp_pattern="Traceback (most recent call last):"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"

    fi

    if [ "${flag_others}" = "y" ]
    then
        echo "---- Others error"
        tmp_pattern="syntax error"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"

        tmp_pattern="\-\-help"
        cat -n ${var_logfile} | grep "${tmp_pattern}" | mark "${tmp_pattern}"

    fi
}
########################################################
#####    Exc Enhance                               #####
########################################################
function session
{
    local var_taget_session=""
    local var_action=""
    local var_remove_list=()

    if [[ "$#" = "0" ]]
    then
        # var_taget_session="Tmp Session"
        tmux ls
        return
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -rm|--remove|rm)
                var_action="remove"
                shift 1
                var_remove_list+=${@}
                break
                ;;
            -a|--attach|a)
                var_taget_session=${2}
                var_action="attach"
                break
                ;;
            -ao|--attach-only|ao)
                var_taget_session=${2}
                var_action="attach-only"
                break
                ;;
            -c|--create|c)
                var_taget_session=${2}
                var_action="create"
                break
                ;;
            -da|--deattach-all|da)
                var_action="deatach-all"
                break
                ;;
            --host|host|hostname|h)
                local var_hostname="$(cat /etc/hostname)"
                local tmp_name=$(tmux ls |grep ${var_hostname}| cut -d ':' -f 1)
                if [ "${tmp_name}" != "" ] &&  tmux ls
                then
                    var_action="attach"
                    var_taget_session=${tmp_name}
                else
                    var_action="create"
                    var_taget_session=${var_hostname}
                fi
                break
                ;;
            -h|--help)
                cli_helper -c "session" -cd "session function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "session [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-r|--remove" -d "remove session with session list"
                cli_helper -o "-a|--attach" -d "attach session with session name"
                cli_helper -o "-ao|--attach-only|ao" -d "attach session with session name"
                cli_helper -o "-c|--create" -d "create session with session name"
                cli_helper -o "-da|--deatach-all" -d "deatach all session"
                cli_helper -o "-d|--deatach" -d "deatach session"
                cli_helper -o "--host|host|hostname|h" -d "deatach all session"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                local tmp_name=$(tmux ls |grep ${1}| cut -d ':' -f 1)
                if [ "${tmp_name}" != "" ] &&  tmux ls
                then
                    var_action="attach-only"
                    var_taget_session=${tmp_name}
                else
                    var_action="create"
                    var_taget_session=${1}
                fi
                break
                ;;
        esac
        shift 1
    done

    if [ "${var_action}" = "attach" ]
    then
        echo "Start session: ${var_taget_session}"
        retitle ${var_taget_session}
        tmux a -dt ${var_taget_session}
    elif [ "${var_action}" = "attach-only" ]
    then
        echo "Start session: ${var_taget_session}"
        retitle ${var_taget_session}
        tmux a -t ${var_taget_session}
    elif [ "${var_action}" = "create" ]
    then
        echo "Create session: ${var_taget_session}"
        retitle ${var_taget_session}
        pureshell "export TERM='xterm-256color' && tmux -u -2 new -s ${var_taget_session}"
    elif [ "${var_action}" = "remove" ]
    then
        echo "Remove session: ${var_remove_list}"
        for each_session in $(echo "${var_remove_list}")
        do
            if [ "${each_session}" != "" ]
            then
                echo "Remove ${each_session}"
                tmux kill-session -t "${each_session}"
            fi
        done
    elif [ "${var_action}" = "deatach-all" ]
    then
        echo "Deatach all session"

        for each_session in $(tmux ls | cut -d ":" -f 1)
        do
            if [ "${each_session}" != "" ]
            then
                echo "Detach ${each_session}"
                tmux detach-client -s "${each_session}"
            fi
        done
    fi

    # tmux a -t ${var_taget_session} || tmux new -s ${var_taget_session}
}
function erun()
{
    # enhanced run
    local var_ret=0
    local excute_cmd=""
    local log_path=${HS_PATH_LOG}/$(date +%Y%m)/$(date +%d)

    local history_file="${log_path}/erun_history.log"
    local log_file="${log_path}/logfile_$(tstamp).log"

    local flag_log_enable="y"
    local flag_color_enable="n"
    local flag_send_mail="n"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--Source-HS)
                local excute_cmd="source $HOME/tools/shellscripts/source.sh -p=$HOME/tools/shellscripts -s=${HS_ENV_SHELL} --change-shell-path=n --silence=y && "
                ;;
            -L|--no-log)
                flag_log_enable="n"
                ;;
            -c|--color)
                flag_color_enable="y"
                ;;
            -m|--mail)
                flag_send_mail="y"
                ;;
            -h|--help)
                cli_helper -c "erun"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "erun [Options] [Command]"
                cli_helper -t "Options"
                cli_helper -o "-s|--Source-HS" -d "Source HS config"
                cli_helper -o "-L|--no-log" -d "Run with record log"
                cli_helper -o "-c|--color" -d "Enable Color"
                cli_helper -o "-m|--mail" -d "Send mail after command is finished"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                return 0
                ;;

            *)
                local excute_cmd="${excute_cmd} $*"
                break
                ;;
        esac
        shift 1
    done

    # local start_time=$(date "+%Y-%m-%d_%H:%M:%S")
    local start_time=$(date)
    echo "Start cmd: $(printc -c yellow ${excute_cmd})"
    # print "$(printlc -lw 32 -cw 0 -d " " "Start Jobs at ${start_time}" "")" | mark -s green "#"
    echo "$(printlc -lw 32 -cw 0 -d " " "Start Jobs at ${start_time}" "")" | mark -s green "#"
    # mark_build "${excute_cmd}"
    if [ -n "${HS_PATH_LOG}" ] && [ "${flag_log_enable}" = "y" ]
    then
        if [ ! -d "${log_path}" ]
        then
            mkdir -p ${log_path}
        fi
        printf "Cmd: %s\nLogfile: %s\n----------------------------\n" "${excute_cmd}" "${log_file}" >> ${history_file}

        logfile -e -f "${log_file}" "${excute_cmd}"
    else
        # echo "Log file path not define.HS_PATH_LOG=${HS_PATH_LOG}"
        eval "${excute_cmd}"
    fi
    var_ret=$?
    # local end_time=$(date "+%Y-%m-%d_%H:%M:%S")
    local end_time=$(date)
    # echo $(elapse "${start_time}" "${end_time}")
    printt "$(printlc -lw 50 -cw 0 -d " " "Job Finished" "")\n$(printlc -lw 14 -cw 36 "Start" "${start_time}")\n$(printlc -lw 14 -cw 36  "End" "${end_time}")\n$(printlc -lw 14 -cw 36  "Elapse" "$(elapse "${start_time}" "${end_time}")")" | mark -s green "#"
    echo "Finished cmd: $(printc -c yellow ${excute_cmd})"

    if [ "${flag_send_mail}" = "y" ]
    then
        printf 'Command finished: %s\nCommand Log: %s\n' "${excute_cmd}" "${log_file}" | mail -s "[Notify][ERUN] Command finished" ${HS_ENV_MAIL}
    fi
    return ${var_ret}
}
alias ecd="ecd"
function xcd()
{
    echo "Enhanced cd"

    local cpath=$(pwd)
    local target_path=""
    local sub_folder=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--hs-script|hs)
                target_path=${HS_PATH_LIB}
                ;;
            -w|--work-script|work)
                target_path=${HS_PATH_WORK}
                ;;
            -i|--vim-ide|ide)
                target_path=${HS_PATH_IDE}
                ;;
            --slink|slink)
                target_path=${HS_PATH_SLINK}
                ;;
            -c|--document|doc|document)
                target_path=${HS_PATH_DOCUMENT}
                ;;
            -d|--download|dl|download|down)
                target_path=${HS_PATH_DOWNLOAD}
                ;;
            --log|log)
                target_path=${HS_PATH_LOG}
                ;;
            -l|--lab|lab)
                target_path=${HS_PATH_LAB}
                if [ ! -d "${target_path}" ]
                then
                    mkdir ${target_path}
                fi
                ;;
            -b|--build|build)
                target_path=${HS_PATH_BUILD}
                ;;
            ${HS_VAR_ECD_NAME_0})
                target_path=${HS_PATH_ECD_0}
                ;;
            ${HS_VAR_ECD_NAME_1})
                target_path=${HS_PATH_ECD_1}
                ;;
            ${HS_VAR_ECD_NAME_2})
                target_path=${HS_PATH_ECD_2}
                ;;
            ${HS_VAR_ECD_NAME_3})
                target_path=${HS_PATH_ECD_3}
                ;;
            ${HS_VAR_ECD_NAME_4})
                target_path=${HS_PATH_ECD_4}
                ;;
            ${HS_VAR_ECD_NAME_5})
                target_path=${HS_PATH_ECD_5}
                ;;
            ${HS_VAR_ECD_NAME_6})
                target_path=${HS_PATH_ECD_6}
                ;;
            ${HS_VAR_ECD_NAME_7})
                target_path=${HS_PATH_ECD_7}
                ;;
            ${HS_VAR_ECD_NAME_8})
                target_path=${HS_PATH_ECD_8}
                ;;
            ${HS_VAR_ECD_NAME_9})
                target_path=${HS_PATH_ECD_9}
                ;;
            -p|--proj|proj|project|projects)
                local tmp_path=$(echo ${HS_PATH_PROJ})
                if [ -n "${2}" ]
                then
                    target_path=${tmp_path}/*${2}*
                    echo "HAL to ${2}"
                else
                    target_path=${tmp_path}
                fi
                ;;
            -h|--help)
                cli_helper -c "xcd" -cd "Enchanced cd function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "xcd [Options] [Value]"
                cli_helper -d "Note. if you have any issue with case, please do shopt -s extglob"

                cli_helper -t "Options"
                cli_helper -o "-s|--hs-script|hs" -d "cd to ${HS_PATH_LIB}"
                cli_helper -o "-w|--work-script|work" -d "cd to ${HS_PATH_WORK}"
                cli_helper -o "-i|--vim-ide|ide" -d "cd to ${HS_PATH_IDE}"
                cli_helper -o "--slink|slink" -d "cd to ${HS_PATH_SLINK}"
                cli_helper -o "-l|--lab|lab" -d "cd to ${HS_PATH_LAB}"
                cli_helper -o "-b|--build|build" -d "cd to ${HS_PATH_BUILD}"
                cli_helper -o "-p|--proj|proj|" -d "cd to ${HS_PATH_PROJ}"
                cli_helper -o "-d|--download|dl|download|down)" -d "cd to ${HS_PATH_DOWNLOAD}"
                cli_helper -o "-c|--document|doc|document)" -d "cd to ${HS_PATH_DOCUMENT}"
                cli_helper -o "-h|--help" -d "Print help function "

                cli_helper -t "Customization Options"
                [ ! -z ${HS_VAR_ECD_NAME_0} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_0} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_0}"
                [ ! -z ${HS_VAR_ECD_NAME_1} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_1} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_1}"
                [ ! -z ${HS_VAR_ECD_NAME_2} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_2} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_2}"
                [ ! -z ${HS_VAR_ECD_NAME_3} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_3} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_3}"
                [ ! -z ${HS_VAR_ECD_NAME_4} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_4} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_4}"
                [ ! -z ${HS_VAR_ECD_NAME_5} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_5} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_5}"
                [ ! -z ${HS_VAR_ECD_NAME_6} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_6} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_6}"
                [ ! -z ${HS_VAR_ECD_NAME_7} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_7} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_7}"
                [ ! -z ${HS_VAR_ECD_NAME_8} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_8} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_8}"
                [ ! -z ${HS_VAR_ECD_NAME_9} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_9} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_9}"

                return 0
                ;;

            *)
                tmp_args=$@
                if [ -z "${target_path}" ]
                then
                    if [ -d "${tmp_args}" ]
                    then
                        target_path=${tmp_args}
                    else
                        target_path="$(realpath *${tmp_args}*)"
                    fi
                else
                    sub_folder=${tmp_args}
                fi
                break
                ;;
            # *)
            #     echo "Target not found"
            #     cd ${cpath}
            #     return 1
            #     ;;
        esac
        shift 1
    done
    if [ -z "${target_path}" ]
    then
        target_path="$(clip -d)"
    fi

    if [ -d "${target_path}" ]
    then
        echo goto ${target_path} | mark -s green ${target_path}
        eval "cd ${target_path}"
        if [ -d "${sub_folder}" ]
        then
            echo goto ${sub_folder} | mark -s green ${sub_folder}
            eval "cd ${sub_folder}"
        fi
        ls
        return 0
    else
        echo "Can't find ${target_path}"
        cd ${cpath}
        return 1
    fi

}
function fcd()
{

    local cpath=$(pwd)
    local depth=99
    local target_folder=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--depth)
                depth=$2
                shift 1
                ;;
            -m|--max|m)
                depth=99
                ;;
            -h|--help)
                echo "fast cd|fcd"
                printlc -cp false -d "->" "-d|--depth" "Depth: default is 3"
                printlc -cp false -d "->" "-m|--max|m" "Depth: Do max search, depth is 6"
                return 0
                ;;

            *)
                target_folder=${@}
                ;;
        esac
        shift 1
    done
    # echo "Fast cd to ${target_folder}"

    if [[ ${depth} > 0 ]]
    then
        # echo "Finding in Layer 0"
        test -d ${target_folder} && cd ${target_folder} && return 0
    fi

    if [[ ${depth} > 1 ]]
    then
        # echo "Finding in Layer 1"
        if ls * | grep "^${target_folder}$"
        then
            test -d */${target_folder} && cd */${target_folder} && return 0
            return 1
        fi
    fi

    if [[ ${depth} > 2 ]]
    then
        # echo "Finding in Layer 2"
        if ls */* | grep "^${target_folder}$"
        then
            test -d */*/${target_folder} && cd */*/${target_folder} && return 0
            return 1
        fi
    fi

    if [[ ${depth} > 3 ]]
    then
        # echo "Finding in Layer 3"
        if ls */*/* | grep "^${target_folder}$"
        then
            test -d */*/*/${target_folder} && cd */*/*/${target_folder} && return 0
            return 1
        fi
    fi

    if [[ ${depth} > 4 ]]
    then
        # echo "Finding in Layer 4"
        if ls */*/*/* | grep "^${target_folder}$"
        then
            test -d */*/*/*/${target_folder} && cd */*/*/*/${target_folder} && return 0
            return 1
        fi
    fi
    ####

    if [[ ${depth} > 5 ]]
    then
        # echo "Finding in Layer 5"
        if ls */*/*/*/* | grep "^${target_folder}$"
        then
            test -d */*/*/*/*/${target_folder} && cd */*/*/*/*/${target_folder} && return 0
            return 1
        fi
    fi
    if [[ ${depth} > 6 ]]
    then
        # echo "Finding in Layer 6"
        if ls */*/*/*/*/* | grep "^${target_folder}$"
        then
            test -d */*/*/*/*/*/${target_folder} && cd */*/*/*/*/*/${target_folder} && return 0
            return 1
        fi
    fi
    return 1
}
########################################################
#####    Git Function                              #####
########################################################
function gconfig()
{
    local var_config_mode=""
    local var_config_cmd=""
    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -g|--global)
                var_config_mode="--global"
                ;;
            --ssl-verify)
                tmp_enable=${2}
                if [ "${tmp_enable}" = "y" ]
                then
                    var_config_cmd="http.sslVerify true"
                else
                    var_config_cmd="http.sslVerify false"
                fi

                shift 1
                ;;
            --file-mode)
                tmp_enable=${2}
                if [ "${tmp_enable}" = "y" ]
                then
                    var_config_cmd="core.fileMode true"
                else
                    var_config_cmd="core.fileMode false"
                fi

                shift 1
                ;;
            -h|--help)
                cli_helper -c "gconfig" -cd "gconfig function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "gconfig [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-g|--global" -d "global mode mode"
                cli_helper -o "--file-mode" -d "Swtich file mode"
                cli_helper -o "--ssl-verify" -d "Switch ssl verify"
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    echo git config ${var_config_mode} ${var_config_cmd}
    eval git config ${var_config_mode} ${var_config_cmd}
}
function gforall()
{
    local var_target_cmd=""
    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -l|--log)
                var_target_cmd="git log --pretty='format:%cd %p->%h %cn(%an) %s' -n 1"
                break
                ;;
            -h|--help)
                cli_helper -c "gforall" -cd "gforall function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "gforall [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-l|--log" -d "Print first commit"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_target_cmd="$@"
                break
                ;;
        esac
        shift 1
    done

    find . -name ".git" | while read dir;
    do
        cd `dirname ${dir}`
        echo "Project Dir: ${dir}" | mark "${dir}"
        eval "${var_target_cmd}"
        cd - > /dev/null
        echo ""
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
    echo "git clone https://${git_host}/${git_project} -b ${git_branch} $@"
    git clone https://${git_host}/${git_project} -b ${git_branch} $@
}
function gcheckoutByDate()
{
    pwd
    local checkout_date=$1
    local cBranch=$(git rev-parse --abbrev-ref HEAD)
    local target_commit=`git rev-list -n 1 --first-parent --before="$checkout_date" $cBranch`
    echo branch: $cBranch
    echo commit: $target_commit
    echo git checkout $target_commit
    git checkout $target_commit
}
function gpush()
{

    local var_cpath="$(pwd)"
    # gerrit push
    local var_commit="HEAD"
    local var_push_word="for"
    local var_excute_flag="y"

    local var_topic=""
    local flag_user_check="n"

    local var_remote="$(git remote show)"
    local var_branch="$(git branch | grep '^\*' | sed 's/^\*//g')"

    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -r|--remote)
                var_remote=$2
                shift 1
                ;;
            -b|--branch)
                var_branch=$2
                shift 1
                ;;
            -c|--commit)
                var_commit=$2
                shift 1
                ;;
            -t|--topic)
                var_topic="${2}"
                shift
                ;;
            -d|--draft)
                var_push_word="drafts"
                ;;
            -f|--fake)
                var_excute_flag="n"
                ;;
            -h|--help)
                echo "gpush Usage"
                printlc -cp false -d "->" "-r|--remote" "Set remote"
                printlc -cp false -d "->" "-b|--branch" "Set branch"
                printlc -cp false -d "->" "-c|--commit" "Set commit"
                printlc -cp false -d "->" "-t|--topic" "Set topic"
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
    tracking_branch_name="$(git branch -a | grep '\->' | cut -d'/' -f 4)"
    current_branch=$(git branch| sed -e '/^[^*]/d' -e 's/* //g' | tr -d "[:blank:]")

    if [ "${var_branch}" = "" ] && $(echo ${tracking_branch_name} | grep detached)
    then
        var_branch=${tracking_branch_name}
    elif [ "${var_branch}" = "" ] && $(echo ${current_branch} | grep detached)
    then
        var_branch=${current_branch}
    fi
    if [ "${var_branch}" = "" ] || $(echo ${var_branch} | grep detached)
    then
        echo "Branch Not found."
        var_branch="master"
        flag_user_check="y"
    fi

    var_branch="$(echo ${var_branch} | sed 's/\ +//g')"

    local cmd="git push ${var_remote} ${var_commit}:refs/${var_push_word}/${var_branch}"

    if [ "${var_topic}" != "" ]
    then
        cmd="${cmd} -o topic=${var_topic}"
    fi

    printt "Auto Push ${var_commit} to ${var_remote}/${var_branch}" | mark -s green "#"
    echo "Eval Command: ${cmd}"
    if [ "${var_excute_flag}" = "y" ] && [ "${flag_user_check}" = "y" ]
    then
        printf "Would you like to excute command?(Y/n)"
        read var_ans
        if [ "${var_ans}" != "n" ] || [ "${var_ans}" != "N" ]
        then
            eval ${cmd}
        fi
    elif [ "${var_excute_flag}" = "y" ]
    then
        eval ${cmd}
    fi
}
function ginfo()
{
    local var_cpath=$(pwd)
    local var_remote=""
    local var_branch=""
    local var_url=""
    local flag_isgit='n'

    local tracking_branch_name=""
    local current_branch=""
    local flag_info='n'
    local flag_auto='n'

    if froot -f -m '.git'
    then
        flag_isgit='y'
    fi

    if [ "${flag_isgit}" = 'y' ]
    then
        var_remote="$(git remote show)"
        var_branch="$(git branch | grep '^\*' | sed 's/^\*//g')"
        var_url="$(git remote get-url ${var_remote})"
    fi

    if [[ "$#" = "0" ]]
    then
        flag_info='y'
    fi

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--auto-detect)
                cli_helper -o "-a|--auto-detect" -d "Auto detect branch/remote"
                ;;
            -h|--help)
                cli_helper -c "ginfo" -cd "git information"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "ginfo [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                flag_info='y'
                flag_auto='y'
                break
                ;;
        esac
        shift 1
    done


    if [ "${flag_auto}" = "y" ]
    then
        tracking_branch_name="$(git branch -a | grep '\->' | cut -d'/' -f 4)"
        current_branch=$(git branch| sed -e '/^[^*]/d' -e 's/* //g' | tr -d "[:blank:]")

        if [ "${var_branch}" = "" ] && $(echo ${tracking_branch_name} | grep detached)
        then
            var_branch=${tracking_branch_name}
        elif [ "${var_branch}" = "" ] && $(echo ${current_branch} | grep detached)
        then
            var_branch=${current_branch}
        fi
        if [ "${var_branch}" = "" ] || $(echo ${var_branch} | grep detached)
        then
            echo "Branch Not found."
            var_branch="master"
            flag_user_check="y"
        fi
    fi


    var_branch="$(echo ${var_branch} | sed 's/\ +//g')"

    if [ "${flag_info}" = "y" ]
    then
        echo "Remote: \"${var_remote}\""
        echo "Branch: \"${var_branch}\""
        echo "URL   : \"${var_url}\""
        echo "---- Clone ----"
        echo "> git clone ${var_url} -b ${var_branch}"
        echo "---- Reset Online ----"
        echo "> git reset --hard ${var_remote}/${var_branch}"
        echo "---- Pull Online Branch----"
        echo "> git pull ${var_remote} ${var_branch}"
        echo "---- track Online Branch ----"
        echo "> git branch --set-upstream-to=${var_remote}/${var_branch} ${current_branch} "
        echo "---- Patches ----"
        echo "Generate Patch: git format-patch -n <num_of_patchs> <commit>"
        echo "Apply Patch   : git am --directory=<path_to_your_patch_root> <path_to_your_patch>"
        echo "---- Others ----"
        echo "Fetch online commit: git fetch --all"
        echo "Get Info for First 1 Commit: git log --pretty='format:%p->%h %cn(%an) %s' -n 1"
        echo "Get Info for First 1 Commit: git log --pretty='format:%cd %p->%h %cn(%an) %s' -n 1"
        echo "Show all file status: git status --ignored all"
        echo "Add all file with ignored file: git add -Avf"
        echo "Clean out commit: git gc --prune=now --aggressive"
        echo "Parse current path: git rev-parse --show-prefix"
    fi


}
function gfiles()
{
    local var_cpath=$(pwd)
    local var_path=""
    # Use xargs tar cvf <your_tar_file.tar> could save the patch with tar
    local var_commit=""
    local var_commit_start=""
    local var_commit_end=""
    local var_num="1"
    local var_commit_name=""
    local var_extra_cmd=""
    local flag_compress="n"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--commit)
                var_commit=$2
                shift 1
                ;;
            -n|--number)
                var_num="$2"
                shift 1
                ;;
            -p|--path)
                var_path="$(realpath ${2})"
                shift 1
                ;;
            -t|--tar)
                flag_compress="y"
                ;;
            -h|--help)
                cli_helper -c "gfiles" -cd "gfiles function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "gfiles [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-c|--commit" -d "Specify commit hash"
                cli_helper -o "-n|--number" -d "get commit before n commit"
                cli_helper -o "-t|--tar" -d "compress file with tar command"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_commit="$1"
                break
                ;;
        esac
        shift 1
    done
    froot .git

    if [ -n "${var_commit}" ]
    then
        var_commit_start=$(git log --pretty='format:%h' -1 ${var_commit})
        var_commit_end=$(git log --pretty='format:%h' -1 ${var_commit}~${var_num})

        var_commit_name=${var_commit_start}_${var_commit_end}_$(git log --pretty='format:%s' -n 1 ${var_commit_start}| sed "s/://g" | sed "s/\]\[//g" | sed "s/\]//g" | sed "s/\[//g" | sed "s/\ /_/g")
    else
        var_commit_start=""
        var_commit_end=""

        var_commit_name=$(tstamp)
    fi

    if [ "${flag_compress}" = "y" ]
    then
        tmp_file="${var_commit_name}.tbz2"
        git diff ${var_commit_start} ${var_commit_end} --name-only ${var_path}| xargs tar -cvjf "${tmp_file}"
        echo "Get Compressed file in :$(realpath ${tmp_file})"
    else
        git diff ${var_commit_start} ${var_commit_end} --name-only ${var_path}
    fi
    cd ${var_cpath}
}
function gsize()
{
    local cpath=$(pwd)
    local var_commit="HEAD"
    local var_verbose="n"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--commit)
                var_commit=$2
                shift 1
                ;;
            -v|--verbose)
                var_verbose="y"
                ;;
            -h|--help)
                cli_helper -c "gsize" -cd "gsize function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "gsize [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-c|--commit" -d "Specify commit hash"
                cli_helper -o "-v|--verbose" -d "Specify commit hash"
                # cli_helper -o "-n|--number" -d "get commit before n commit"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_commit="$1"
                break
                ;;
        esac
        shift 1
    done

    froot .git

    ITEM_LIST_NAME=(`git diff-tree -r -c -M -C --no-commit-id $var_commit | sed "s/\s\+/ /g" | cut -d ' ' -f 6`)
    # echo ${ITEM_LIST_NAME}
    ITEM_LIST="`git diff-tree -r -c -M -C --no-commit-id $var_commit`"
    BLOB_HASH_LIST=(`echo "$ITEM_LIST" | awk '{ print $4 }'`)
    local COMMIT_SIZE=0

    if [ "${var_verbose}" = "y" ]
    then
        for each_idx in $(seq 0 ${#BLOB_HASH_LIST[@]})
        do
            if [ ! -f "${ITEM_LIST_NAME[$each_idx]}" ]
            then
                continue
            fi
            local tmp_size=$(echo ${BLOB_HASH_LIST[$each_idx]} | git cat-file --batch-check | grep "blob" | awk '{ print $3}')
            echo -E ${ITEM_LIST_NAME[$each_idx]}: $(numfmt --to=iec-i --suffix=B --padding=7 $tmp_size)
            # COMMIT_SIZE=$((${tmp_size} + ${COMMIT_SIZE}))

        done
    fi
    BLOB_HASH_LIST="`echo "$ITEM_LIST" | awk '{ print $4 }'`"

    SIZE_LIST="`echo "$BLOB_HASH_LIST" | git cat-file --batch-check | grep "blob" | awk '{ print $3}'`"
    COMMIT_SIZE="`echo "$SIZE_LIST" | awk '{ sum += $1 } END { print sum }'`"
    echo "${var_commit}: $(numfmt --to=iec-i --suffix=B --padding=7 $COMMIT_SIZE)(${COMMIT_SIZE})"

    cd ${cpath}
}
function gpatch()
{
    local var_patch_url=""
    local var_patch_file=""
    local var_manifest_file=""
    local var_patch_root="$(pwd)"
    local var_action="apply"
    local status_file_mismatch="n"
    local status_apply_error="n"
    local flag_add_patch_file="n"
    local flag_git_tool='n'

    local tmp_patch_file="test_$(tstamp).patch"
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -u|--url)
                var_patch_url=$2
                shift 1
                ;;
            -f|--file)
                var_patch_file=$2
                shift 1
                ;;
            -p|--apply-path)
                var_patch_root="2"
                shift 1
                ;;
            -r|--revert-patch)
                var_action='revert'
                ;;
            -g|--git)
                flag_git_tool="y"
                ;;
            -a|--add)
                flag_add_patch_file='y'
                ;;
            # -m|--manifest)
            #     var_manifest_file="2"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "gpatch" -cd "gpatch function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "gpatch [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-u|--url" -d "Specify formate patch url"
                cli_helper -o "-f|--file" -d "Specify formate patch file"
                cli_helper -o "-p|--apply-path" -d "Specify formate patch apply path"
                cli_helper -o "-r|--revert-patch" -d "Action: Revert patch with formate patch"
                cli_helper -o "-g|--git" -d "use get apply to apply patch, default use patch"
                cli_helper -o "-a|--add" -d "Add patched file to git"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_patch_url=$2
                break
                ;;
        esac
        shift 1
    done

    eval "${var_patch_url}" > "${tmp_patch_file}"
    local var_patch_subject=$(cat ${tmp_patch_file} | grep "Subject" | cut -d ":" -f 2  | sed "s/\]//g" | sed "s/\[//g" | sed "s/\ /_/g" | sed "s/\///g" | sed "s/_PATCH_//g")
    local var_patch_file="${var_patch_subject}_$(tstamp).patch"


    for each_cl_file in $(cat ${tmp_patch_file} | grep "\-\-\- b" | cut -d "/" -f 2- )
    do
        if [ ! -f ${each_cl_file} ]
        then
            echo "${each_cl_file} not found in your code tree."
            status_file_mismatch=y
        fi
    done
    if [ ${status_file_mismatch} = "y" ]
    then
        echo "File misssing found. Do you want to proceed git am?(y/N)"
        read tmp_ans
        # echo Ans:${tmp_ans}
        if [ "${tmp_ans}" != "y" ] || [ "${tmp_ans}" != "Y" ]
        then
            return 0
        fi
    fi

    # echo "git am --directory ${var_patch_root} ${tmp_patch_file}"
    # git am --directory ${var_patch_root} ${tmp_patch_file}
    if [ "${var_action}" = "apply" ]
    then
        if [ "${flag_git_tool}" = "y" ]
        then
            echo "flag_git_tool: ${flag_git_tool}"
            ## apply with git
            echo git apply -v -p 1 --directory $(git rev-parse --show-prefix) ${tmp_patch_file}
            git apply -v -p 1 --directory $(git rev-parse --show-prefix) ${tmp_patch_file}
        else
            echo "evaluate: patch -p1 -b -i ${tmp_patch_file}"
            patch -p1 -b -i ${tmp_patch_file} | mark -s red "reject" | mark -s red "FAILED" | mark -s red 'git binary diffs are not supported'
            if [[ $? = 0 ]]
            then
                status_apply_error=y
            fi
        fi

    elif [ "${var_action}" = "revert" ]
    then
        echo "patch -R -p1 -b -i ${tmp_patch_file}"
        patch -R -p1 -b -i ${tmp_patch_file} | mark -s red "FAILED"
    fi

    if [ ${status_apply_error} = "y" ]
    then
        echo "File apply failed. Do you want to proceed?(y/N)"
        read tmp_ans
        # echo Ans:${tmp_ans}
        if [ "${tmp_ans}" != "y" ] || [ "${tmp_ans}" != "Y" ]
        then
            return 0
        fi
    fi

    if [ "${flag_add_patch_file}" = "y" ]
    then
        for each_cl_file in $(cat ${tmp_patch_file} | grep "\-\-\- b" | cut -d "/" -f 2- )
        do
            if [ -f "${each_cl_file}.rej" ]
            then
                printc -c red "Found reject file: ${each_cl_file}.rej\n"
            elif [ -f ${each_cl_file} ]
            then
                git add ${each_cl_file}
            fi
        done
    fi

    echo "mv ${tmp_patch_file} ${var_patch_file}"
    mv "${tmp_patch_file}" "${var_patch_file}"
}
function greset()
{
    git reset --hard HEAD
    git clean -fxd
}
function rpath()
{
    # get git project path in manifest
    var_url_patch="$(pwd)"
    var_manifest_path=""

    var_git_proj_name=""

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -u|--url)
                var_url_patch="${2}"
                shift 1
                ;;
            -m|--manifest)
                var_manifest_path="${2}"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "rpath" -cd "get git project path in manifest"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "rpath [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-u|--url" -d "Add git url for getting project path"
                cli_helper -o "-m|--manifest" -d "Specify manifest path, suport both file and folder"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    # echo "[shaun] Modify"

    for each_line in $(tokenizer ${var_url_patch})
    do
        # echo each_line: ${each_line}", " $(${each_line} | grep http)
        # echo "echo ${each_line} | grep http"
        if echo ${each_line} | grep http > /dev/null
        then
            var_git_proj_name="$(echo ${each_line} | cut -d '/' -f 4-)"
            # echo "Hit var_git_proj_name: ${var_git_proj_name}"
        fi
    done

    # echo " Find ${var_git_proj_name} in ${var_manifest_path}"

    if [ -d "${var_manifest_path}" ]
    then
        echo $(cat ${var_manifest_path}/* |grep "${var_git_proj_name}\"" | tokenizer | grep path | cut -d '=' -f 2)
    elif [ -f "${var_manifest_path}" ]
    then
        echo $(cat ${var_manifest_path} | grep "${var_git_proj_name}\"" | tokenizer | grep path | cut -d '=' -f 2)
    else
        echo "Please specify mainfest file path"
    fi
}
function rreset()
{
    local var_jobs="64"
    repo forall -j ${var_jobs} -vc "git reset --hard HEAD"
    repo forall -j ${var_jobs} -vc "git clean -fd"
    repo sync  -j ${var_jobs}
}
function rdate()
{
    local checkout_date=$1
    local var_action=""
    if [[ "$#" = "0" ]]
    then
        echo "Date not found."
        echo "ex. rdate \"2020-07-22 02:00\""
        return 0
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--date|date)
                checkout_date=$1
                shift 1
                ;;
            -h|--help)
                cli_helper -c "rdate" -cd "rdate function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "rdate [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-d|--date|date" -d "Specify date for commit"
                cli_helper -t "Example"
                cli_helper -d "rdate -d 2020-07-22 02:00"
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    repo forall -j ${HS_ENV_CPU_NUMBER}  -c "pwd && git reset --hard \$(git rev-list -n 1 --first-parent --before=\"${checkout_date}\" \$(git rev-parse --abbrev-ref HEAD))"
}
########################################################
#####    Binary                                    #####
########################################################
function wdiff()
{
    diff -rq $1 $2 | cut -f2 -d' '| uniq | sort
}

function endian()
{
    cd ${COV_ROOT_PATH}
    # echo "fcssn_to_rmaid"

    for each_line in $(cat ${COV_INPUT_FILE} | head -n 10)
    do
        # echo "${each_line}"
        local tmp_string=""
        local tmp_idx=0

        tmp_string="${each_line:$((${tmp_idx} + 2)):2}${each_line:$((${tmp_idx} + 0)):2}"
        tmp_idx="$((${tmp_idx} + 4))"
        tmp_string="${tmp_string}${each_line:$((${tmp_idx} + 2)):2}${each_line:$((${tmp_idx} + 0)):2}"

        # echo "After ${#tmp_string} -> ${tmp_string}"
        echo "${tmp_string}00000000" >> ${COV_OUTPUT_IDLIST}
    done
    echo "Generate list at file ${COV_OUTPUT_IDLIST}"
}
function hex2bin()
{
    local tmp_input_file="hex2bin.${tstamp}.in"

    local var_output_file=""
    local tmp_output_file="hex2bin.${tstamp}.out"
    local var_fmt=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -i|--input-str)
                if [ -f "${tmp_input_file}" ]
                then
                    echo "Input file exist!!"
                    return 1
                fi
                if [ -f "${2}" ]
                then
                    cp ${2} ${tmp_input_file}
                elif [ -n "${2}" ]
                then
                    tmp_input_file=$(echo "${2}" > "${tmp_input_file}")
                else
                    echo "Input file/str not exist!!"
                    return 1
                fi
                shift 1
                ;;
            -o|--output)
                var_output_file="${2}"
                shift 1
                ;;
            -c|--c-header)
                var_fmt="c-header"
                ;;
            -s|--std-out)
                var_fmt="stdout"
                ;;
            -h|--help)
                cli_helper -c "hex2bin" -cd "hex2bin function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "hex2bin [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-i|--input" -d "Input, could be file/str"
                cli_helper -o "-o|--output" -d "Output File name"
                cli_helper -o "-h|--help" -d "Print help function "
                cli_helper -t "Output Formate"
                cli_helper -o "-c|--c-header" -d "Output to c header fmt"
                cli_helper -o "-s|--std-out" -d "Output to std out"
                return 0
                ;;
            *)
                ;;
        esac
        shift 1
    done

    # if [ "${var_output_file}" = "" ]
    # then
    #     var_output_file="$(echo ${tmp_input_file} | sed 's/\..*//g')"
    # fi
    # echo "Converting ${var_output_file}"

    cat ${tmp_input_file} | sed s/,//g | sed s/0x//g | xxd -r -p - ${tmp_output_file}

    if [ "${var_fmt}" = "c-header" ]
    then
        xxd -i ${tmp_output_file} > ${tmp_output_file}
        rm ${tmp_output_file}
    fi

    if [ "${var_output_file}" = "" ]
    then
        cat ${tmp_output_file}
    else
        mv ${tmp_output_file} ${var_output_file}
    fi
    rm ${tmp_input_file}
    [ -f "${tmp_output_file}" ] && rm ${tmp_output_file}

}
########################################################
#####    Pythen                                    #####
########################################################
function pyenv()
{
    local var_target_path="${HS_PATH_PYTHEN_ENV}"
    local var_action=""
    local var_pip_cmd=""
    if [[ "$#" = "0" ]]
    then
        var_action="active"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--create|c)
                var_action="create"
                ;;
            -a|--active|a)
                var_action="active"
                ;;
            -d|--deactivate|d)
                var_action="deactivate"
                deactivate
                ;;
            -u|--update|u)
                var_action="update"
                ;;
            -p|--path)
                var_target_path="$(realpath ${2})"
                shift 1
                ;;
            --pip|pip)
                var_action="pip"
                var_pip_cmd="${@}"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "pyenv" -cd "pyenv function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "pyenv [Options] [Value]"
                cli_helper -d "default path will set to HS_PATH_PYTHEN_ENV"
                cli_helper -t "Options"
                cli_helper -o "-c|--create|c" -d "create Pyenv"
                cli_helper -o "-a|--active|a" -d "active Pyenv"
                cli_helper -o "-d|--deactivate|d" -d "deactivate Pyenv"
                cli_helper -o "-u|--update|u" -d "update pip"
                cli_helper -o "-p|--path" -d "setting pyen path"
                cli_helper -o "--pip|pip" -d "Do pip install with trust host"
                cli_helper -o "-h|--help" -d "Print help function "

                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    if [ "${var_action}" = "active" ]
    then
        source ${var_target_path}/bin/activate
        # $@
    elif [ "${var_action}" = "update" ]
    then
        python -m pip install --upgrade pip
    elif [ "${var_action}" = "create" ]
    then
        if [ -d ${var_target_path} ]
        then
            echo ${var_target_path} exist.
            return 1
        else
            # local target_path=$(realpath ${1})
            # virtualenv --system-site-packages -p python3 ${target_path}
            # echo virtualenv --system-site-packages -p python ${var_target_path}
            virtualenv --system-site-packages -p python ${var_target_path}
        fi
    elif [ "${var_action}" = "pip" ]
    then
        pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org $@
    fi
    # deactivate
}
########################################################
#####    GTK                                       #####
########################################################
function gtkbw()
{
    local var_def_port=5
    local var_run_cmd=""

    local flag_action=""

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--daemon)
                flag_action="daemon"
                ;;
            -r|--run)
                flag_action="run"
                shift 1
                var_run_cmd=${@}
                break
                ;;
            -h|--help)
                cli_helper -c "bwgtk" -cd "Run GTK Application by using broadway"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "bwgtk [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-d|--daemon" -d "Start broadway daemon"
                cli_helper -o "-r|--run" -d "Run GTK Application, will take the reset of args as cmd"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                flag_action="run"
                var_run_cmd=${@}
                break
                ;;
        esac
        shift 1
    done
    if [ "${flag_action}" = "run" ]
    then
        echo GDK_BACKEND=broadway BROADWAY_DISPLAY=:${var_def_port} ${var_run_cmd}
        GDK_BACKEND=broadway BROADWAY_DISPLAY=:${var_def_port} ${var_run_cmd}
    elif [ "${flag_action}" = "daemon" ]
    then
        echo Enter Broadway with: http://localhost:808${var_def_port}/
        broadwayd :${var_def_port}

    fi

}
