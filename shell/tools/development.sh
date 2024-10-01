#!/bin/bash
########################################################
########################################################
#####                                              #####
#####    Development Function                      #####
#####                                              #####
########################################################
########################################################

########################################################
#####    Debug                                     #####
########################################################
# Serial debug
function sdebug()
{
    local target_dev=''
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
                cli_helper -o "-b|--baud-rate" -d "Set Baud Rate, Other: 115200, 1500000"
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
    if ! $(test -c "${target_dev}")
    then
        if ls /dev/ttyACM*
        then
            target_dev=$(ls /dev/ttyACM*|head -n 1)
        elif ls /dev/ttyUSB*
        then
            target_dev=$(ls /dev/ttyUSB*|head -n 1)
        else
            echo 'Please specify serial device'
        fi
    fi
    retitle ${session_name}-${target_dev}
    [ ! -d ${serial_log_path} ] && mkdir -p ${serial_log_path} && echo "Create ${serial_log_path}"
    var_cmd="${var_prefix} screen -S ${session_name} -L -Logfile ${serial_log_path}/debug_$(tstamp).log ${target_dev} ${baud_rate}"
    echo "${var_cmd}"
    eval "${var_cmd}"
    echo "${var_cmd}"
}

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
        var_hist_list+=(${task_cmd})
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
                # disable this, cause it can't return error status
                # flag_error_file="y"
                ;;
            -f|--file-name)
                local var_logname="${2}"
                local var_error_logname=$(echo ${2} | sed 's/\.log/_error\.log/g')
                shift 1
                ;;
            -h|--help)
                echo "logfile"
                # printlc -cp false -d "->" "-e|--error" "enable error file"

                cli_helper -c "logfile" -cd "logfile function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "logfile [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-p|--path" -d "path name"
                cli_helper -o "-f|--file-name" -d "file name"
                cli_helper -o "-h|--help" -d "Print help function "
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
        var_ret=$(shell_status -e )
    else
        eval "${var_cmd}" 2>&1 | tee -a ${fulllogname}
        var_ret=$(shell_status -e )
    fi
    # echo "Return: ${var_ret}"

    echo "===================================================================" >> $fulllogname
    echo "Command Finished:\"${var_cmd}\"" >> $fulllogname
    echo "Return code: ${var_ret}" >> $fulllogname
    echo "Start Date: ${start_date}" >> $fulllogname
    echo "End   Date: $(date)" >> $fulllogname
    echo "==================================================================="
    echo "Log file has been stored in the following path." | mark -s green "${fulllogname}"
    echo "Full Log: ${fulllogname}" | mark -s green "${fulllogname}"
    hs_varconfig -s "${HS_VAR_LOGFILE}" "${fulllogname}"

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
    local var_slink_path="${HS_PATH_SLINK}"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p|--path)
                if [ -d "${2}" ]
                then
                    target_path=$(realpath ${2})
                fi
                shift 1
                ;;
            -2)
                var_slink_path="${var_slink_path}_2"
                ;;
            -3)
                var_slink_path="${var_slink_path}_3"
                ;;
            -l|--list|ls)
                echo "List ${var_slink_path}"
                ls ${var_slink_path}
                return 0
                ;;
            -c|--clean)
                return 0
                ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "slink" -cd "slink function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "slink [Options] [Value]"
                cli_helper -t "Options"
                # cli_helper -o "-a|--append" -d "append file extension on search"
                cli_helper -o "-p|--path" -d "Target path "
                cli_helper -o "-c|--clean" -d "Clean slink path "
                cli_helper -o "-2" -d "Using 2nd slink path"
                cli_helper -o "-3" -d "Using 3rd slink path"
                cli_helper -o "-l|--list|ls" -d "List slink path"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                # echo "Wrong args, $@"
                # return -1
                if [ -d "${@}" ]
                then
                    target_path=$(realpath ${@})
                    break;
                fi
                ;;
        esac
        shift 1
    done

    if [ -z "${target_path}" ]
    then
        target_path=$(realpath ${PWD})
    fi


    if [ -d "${target_path}" ]
    then
        test -L ${var_slink_path} && rm ${var_slink_path}
        ln -sf  ${target_path} ${var_slink_path}
        ls -al ${var_slink_path}
    else
        echo "Forder not found.(${target_path})"
    fi

}
########################################################
#####    Build                                     #####
########################################################
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
            #     cmd_args+=("${2}")
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
function banlys
{
    local var_logfile=""
    local var_next_line='\n'
    local flag_android="y"
    local flag_make="y"
    local flag_syntax="y"
    local flag_others="y"
    local flag_clike="y"
    local flag_python="y"
    local flag_shell="y"

    local flag_edit="n"
    local flag_found_error="n"

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--all|a|all)
                flag_android="y"
                flag_make="y"
                flag_syntax="y"
                flag_shell="y"
                flag_others="y"
                flag_python="y"
                flag_clike="y"
                ;;
            android|an)
                flag_android="y"
                ;;
            make)
                flag_make="y"
                ;;
            c|cpp)
                flag_clike="y"
                ;;
            python|py)
                flag_python="y"
                ;;
            sh)
                flag_shell="y"
                ;;
            --buffer-file|buffer|buf)
                var_logfile="$(hs_varconfig -g ${HS_VAR_LOGFILE})"
                ;;
            -v|--vim)
                flag_edit=y
                # shift 1
                # eval vim $@
                # return 0
                ;;
            -f|--log-file)
                var_logfile="${2}"
                shift 1
                ;;
            -d|-debug)
                flag_android="y"
                flag_make="y"
                flag_syntax="y"
                flag_shell="y"
                flag_others="y"
                flag_python="y"
                flag_clike="y"
                var_logfile="${2}"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "banlys" -cd "build/compil error analyzer "
                cli_helper -t "SYNOPSIS"
                cli_helper -d "banlys [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--all" -d "enable all debug flag"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-v|--vim" -d "dirrect vim log file "
                cli_helper -o "-d|--debug" -d "Specify log file, and enable all debug filter, indicate -a,-f"
                cli_helper -o "-f|--log-file" -d "Specify log file"
                cli_helper -o "--buffer-file|buffer|buf" -d "Read file from hs buffer"
                cli_helper -o "sh|c|python|make|android" -d "Enable log function"
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

    if [ "${var_logfile}" = "" ] && test -f "build.log"
    then
        var_logfile="build.log"
    fi

    if [ "${flag_edit}" = "y" ]
    then
        vim ${var_logfile}
        return 0
    fi

    if [ "${flag_android}" = "y" ]
    then
        tmp_buf=''
        # echo "flag_android: ${flag_android}"
        # echo "---- Android log analysis"
        section_title="Android log analysis"
        # local total_line=$(wc -l ${var_logfile} | cut -d " " -f1 )
        # cat ${var_logfile} | purify | grep -B ${total_line} "error.*generated" | tac | grep -B ${total_line} "generated.$" | tac | mbuild
        line_buf=$(cat -n ${var_logfile} | purify | grep "error.*generated\|^FAILED:" | mbuild)
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        if test -n "${tmp_buf}"
        then
            echo "## ${section_title}"
            echo '################################################################'
            printf "%s\n" "${tmp_buf}"
            flag_found_error='y'
        fi
    fi
    if [ "${flag_make}" = "y" ]
    then
        tmp_buf=''
        # echo "---- Make log analysis"
        section_title="Make log analysis"
        line_buf=$(cat -n ${var_logfile} | purify | grep "make.*Error\|Makefile.*\*\*\*" | mbuild)
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        if test -n "${tmp_buf}"
        then
            echo "## ${section_title}"
            echo '################################################################'
            printf "%s\n" "${tmp_buf}"
            flag_found_error='y'
        fi
    fi
    if [ "${flag_syntax}" = "y" ]
    then
        tmp_buf=''
        # echo "---- Syntax log analysis"
        section_title="Syntax log analysis"
        tmp_pattern="undefined reference"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark -s red "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        tmp_pattern="unknown type name"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        if test -n "${tmp_buf}"
        then
            echo "## ${section_title}"
            echo '################################################################'
            printf "%s\n" "${tmp_buf}"
            flag_found_error='y'
        fi
    fi

    if [ "${flag_shell}" = "y" ]
    then
        tmp_buf=''
        # echo "---- command missing "
        section_title="Shell Error"
        line_buf=$(cat -n ${var_logfile} | purify | grep "command not found" | mark -s red "command not found")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        # echo "---- file/dir/permission missing "
        tmp_pattern="Can not find directory"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        tmp_pattern="No such file or directory"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        tmp_pattern="No space left on device"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        tmp_pattern="Permission denied"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        # echo "---- shell error "
        tmp_pattern="Argument list too long"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        if test -n "${tmp_buf}"
        then
            echo "## ${section_title}"
            echo '################################################################'
            printf "%s\n" "${tmp_buf}"
            flag_found_error='y'
        fi
    fi
    if [ "${flag_clike}" = "y" ]
    then
        tmp_buf=''

        # echo "---- C/Cpp error"
        section_title="C/Cpp error"
        tmp_pattern="error:"
        line_buf=$(cat -n ${var_logfile} | purify | grep -B 1 "${tmp_pattern}" | mark -s red "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        if test -n "${tmp_buf}"
        then
            echo "## ${section_title}"
            echo '################################################################'
            printf "%s\n" "${tmp_buf}"
            flag_found_error='y'
        fi
    fi

    if [ "${flag_python}" = "y" ]
    then
        tmp_buf=''
        # echo "---- python error"
        section_title="python error"
        tmp_pattern="Traceback (most recent call last):"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark -s red "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        if test -n "${tmp_buf}"
        then
            echo "## ${section_title}"
            echo '################################################################'
            printf "%s\n" "${tmp_buf}"
            flag_found_error='y'
        fi
    fi

    if [ "${flag_others}" = "y" ]
    then
        tmp_buf=''
        # echo "---- Others error"
        section_title="Others error"
        tmp_pattern="syntax error"
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        # tmp_pattern='\-\-help'
        tmp_pattern='[-]\{2\}help'
        line_buf=$(cat -n ${var_logfile} | purify | grep "${tmp_pattern}" | mark "${tmp_pattern}")
        test -n "${line_buf}" && tmp_buf+=${line_buf}${var_next_line}

        if test -n "${tmp_buf}"
        then
            echo "## ${section_title}"
            echo '################################################################'
            printf "%s\n" "${tmp_buf}"
            flag_found_error='y'
        fi
    fi

    if [ "${flag_found_error}" = 'y' ]
    then
        echo '################################################################'
    else
        echo 'Error not found.'
    fi
}
########################################################
#####    Exc Enhance                               #####
########################################################
function session()
{
    local var_taget_socket=""
    local var_action=""
    local var_remove_list=()
    local var_cmd=('tmux')
    local var_config_file=""
    local flag_multiple_instance=y
    local var_session_tmp_path=${HS_TMP_SESSION_PATH}/$(hostname)

    local var_target_name=""

    if [ ! -d ${var_session_tmp_path} ]
    then
        mkdir -p ${var_session_tmp_path}
    fi

    if [[ "$#" = "0" ]]
    then
        session ls
        return
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -D|--default)
                flag_multiple_instance="n"
                ;;
            -l|--list|ls)
                var_action="list"
                ;;
            -L|--real-list)
                var_action="real-list"
                ;;
            -p|--purge)
                var_action="purge"
                ;;
            -rm|--remove|rm)
                var_action="remove"
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        var_target_name=${2}
                        shift 1
                    fi
                fi
                ;;
            -rl|--remove-list|rl)
                var_action="remove-list"
                shift 1
                var_remove_list+=(${@})
                break
                ;;
            -a|--attach|a|attach)
                var_action="attach"
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        var_target_name=${2}
                        shift 1
                    fi
                fi
                ;;
            -ao|--attach-only|ao)
                var_action="attach-only"
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        var_target_name=${2}
                        shift 1
                    fi
                fi
                ;;
            -c|--create|c|create)
                var_action="create"
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        var_target_name=${2}
                        shift 1
                    fi
                fi
                ;;
            -da|--detach-all|da)
                var_action="detach-all"
                ;;
            -d|--detach|d|detach)
                var_action="detach"
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        var_target_name=${2}
                        shift 1
                    fi
                fi
                ;;
            -s|--socket)
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        var_taget_socket=${2}
                        shift 1
                    fi
                fi
                ;;
            -t|---target-name)
                var_target_name=${2}
                # echo "target: var_target_name:$var_target_name"
                shift 1
                ;;
            -f|--file)
                if test -f ${2}
                then
                    var_cmd+=("-f ${2}")
                else
                    echo "Config file not found. $2"
                    return 1
                fi
                shift 1
                ;;
            --host|host|hostname|h)
                local var_hostname=""
                if command -v hostname 2>&1 > /dev/null
                then
                    var_hostname="$(hostname)"
                elif test -f "/etc/hostname"
                then
                    var_hostname="$(cat /etc/hostname)"
                fi

                # modify name for remove special chars.
                if test -n "${var_hostname}"
                then
                    var_hostname=$(echo ${var_hostname}| sed 's/\./_/g')
                fi

                local tmp_name=$(session ls | grep "${var_hostname}" | cut -d ':' -f 1| cut -d "@" -f 2 | tr -d  ' ')
                if [ "${tmp_name}" != "" ]
                then
                    var_action="attach"
                    var_target_name=${tmp_name}
                else
                    var_action="create"
                    var_target_name=${var_hostname}
                fi
                ;;
            -h|--help)
                cli_helper -c "session" -cd "session is an independ instance of tmux"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "session [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-D|--default" -d "use default socket"
                cli_helper -o "-L|--real-list" -d "use command info to list session"
                cli_helper -o "-ao|--attach-only|ao" -d "attach session with session name"
                cli_helper -o "-a|--attach" -d "attach session with session name"
                cli_helper -o "-c|--create" -d "create session with session name"
                cli_helper -o "-da|--detach-all" -d "detach all session"
                cli_helper -o "-d|--detach" -d "detach session"
                cli_helper -o "-s|--socket" -d "specify session socket file, please specify it at last"
                cli_helper -o "-t|--target-name" -d "specify session name"
                cli_helper -o "-h|--help" -d "Print help function "
                cli_helper -o "-l|--list" -d "list session"
                cli_helper -o "-p|--purge" -d "purge socket"
                cli_helper -o "-rm|--remove" -d "remove session with session list"
                cli_helper -o "-f|--file" -d "Specify config file"
                cli_helper -o "--host|host|hostname|h" -d "detach all session"
                return 0
                ;;
            *)
                echo "Auto detect."
                local tmp_name=$(session ls |grep "${1}" | cut -d ':' -f 1| cut -d "@" -f 2 | tr -d ' ')
                if [ "${tmp_name}" != "" ]
                then
                    var_action="attach-only"
                    var_target_name=${tmp_name}
                else
                    var_action="create"
                    var_target_name=${1}
                fi
                break
                ;;
        esac
        shift 1
    done
    if [ "$var_action" = "create" ] || [ "$var_action" = "attach" ] || [ "$var_action" = "attach-only" ]
    then
        if test -n "${TMUX}"
        then
            echo "Don't do tmux inside tmux."
            return 1
        fi
    fi
    ## Run with independ instance
    # -S socket path
    # -L socket name(default socket path)
    # ${var_cmd[@]} -S test new -s sharedsession
    if test -z "${var_target_name}"
    then
        # echo "Assign var_target_name"
        var_target_name="${var_taget_socket}"
    fi
    if test -z "${var_taget_socket}"
    then
        # echo "Assign var_taget_socket"
        var_taget_socket="${var_target_name}"
    fi

    # echo "${var_action} session: ${var_target_name}@${var_taget_socket}"

    if [ "${var_action}" = "attach" ]
    then
        echo "${var_action} session: ${var_target_name}@${var_taget_socket}"
        retitle ${var_taget_socket}
        if [ "${flag_multiple_instance}" = "y" ] && [ -n "${var_taget_socket}" ]
        then
            var_cmd+=("-S ${var_session_tmp_path}/${var_taget_socket}")
        fi
        eval ${var_cmd[@]} a -dt ${var_target_name}
    elif [ "${var_action}" = "attach-only" ]
    then
        echo "${var_action} session: ${var_target_name}@${var_taget_socket}"
        retitle ${var_taget_socket}
        echo ${var_cmd[@]} a -t ${var_target_name}
        if [ "${flag_multiple_instance}" = "y" ] && [ -n "${var_taget_socket}" ]
        then
            var_cmd+=("-S ${var_session_tmp_path}/${var_taget_socket}")
        fi
        eval ${var_cmd[@]} a -t ${var_target_name}
    elif [ "${var_action}" = "create" ]
    then
        echo "${var_action} session: ${var_taget_socket}"
        retitle ${var_taget_socket}
        # echo pureshell "export TERM='xterm-256color' && ${var_cmd[@]} -u -2 new -s ${var_taget_socket}"
        if [ "${flag_multiple_instance}" = "y" ] && [ -n "${var_taget_socket}" ]
        then
            var_cmd+=("-S ${var_session_tmp_path}/${var_taget_socket}")
        fi
        # NOTE, don't carete session with names
        var_target_name="${var_taget_socket}"
        pureshell "export TERM='xterm-256color' && ${var_cmd[@]} -u -2 new -s ${var_target_name}"
    elif [ "${var_action}" = "list" ]
    then
        echo "${var_action} session:"

        if [ "${flag_multiple_instance}" = "y" ]
        then
            for each_session in $(ls ${var_session_tmp_path})
            do
                # ps -ef |grep 'tmux\|session' |grep "\/$each_session "
                if ps -ef |grep 'tmux\|session' | grep "/$each_session " > /dev/null
                then
                    printf "%s@%s:%s\n" "$(eval ${var_cmd[@]} -S ${var_session_tmp_path}/${each_session} ls|cut -d ':' -f 1)" "${each_session}" "$(eval ${var_cmd[@]} -S ${var_session_tmp_path}/${each_session} ls|cut -d ':' -f 2-)"
                fi
            done
        else
            tmux ls
            # for each_session in $(tmux ls | cut -d ':' -f 1)
            # do
            #     printf "${each_session}: Off\n"
            # done
        fi

    elif [ "${var_action}" = "real-list" ]
    then
        echo "${var_action} session by ps:"
        for each_session in $(ls ${var_session_tmp_path})
        do
            # ps -ef |grep 'tmux\|session' |grep "\/$each_session "
            if ps -ef |grep 'tmux\|session' | grep "/$each_session " > /dev/null
            then
                # printf "${each_session}: On\n"
                eval ${var_cmd[@]} -S ${var_session_tmp_path}/${each_session} ls
            else
                printf "${each_session}: Off\n" | mark -s yellow ${each_session}
            fi
        done
    elif [ "${var_action}" = "purge" ]
    then
        echo "${var_action} session by ps:"
        for each_session in $(ls ${var_session_tmp_path})
        do
            # ps -ef |grep 'tmux\|session' |grep "\/$each_session "
            if ps -ef |grep 'tmux\|session' | grep "/$each_session " > /dev/null
            then
                printf "Session on : ${each_session}\n"
            else
                printf "Remove : ${each_session}\n" | mark -s yellow ${each_session}
                rm ${var_session_tmp_path}/${each_session}
            fi
        done

        echo "Kill Orphan process:"
        for each_socket in $(ps -eo pid,command | grep tmux | tr -s " "  | sed "s/^ //g"  |cut -d " " -f 4 | sort |uniq)
        do
            if ! test -S ${each_socket}
            then

                for each_process in $(ps -eo pid,command | grep "/home/shaun/.cache/hs_temp/session/test"| grep tmux | tr -s " " | sed -s "s/^ //g" | cut -d " " -f 1)
                do
                    echo kill -9 ${each_process}
                    kill -9 ${each_process}
                done
            fi
        done

    elif [ "${var_action}" = "remove" ]
    then
        echo "Try: ${var_action} ${var_target_name}@${var_taget_socket}"

        for each_session in $(session ls | cut -d ":" -f 1| cut -d '@' -f 2)
        do
            if [ "${each_session}" = "${var_target_name}" ]
            then
                echo "Remove ${each_session}@${var_taget_socket}"
                eval ${var_cmd[@]} -S ${var_session_tmp_path}/${var_taget_socket} kill-session -t "${var_target_name}"
                if [[ ${?} = 0 ]]
                then
                    rm ${var_session_tmp_path}/${each_session}
                else
                    echo "Remove session fail: ${each_session}"
                fi
            fi
        done
    elif [ "${var_action}" = "remove-list" ]
    then
        echo "${var_action} session: ${var_remove_list[@]}"
        for each_session in $(echo "${var_remove_list}")
        do
            if [ "${each_session}" != "" ]
            then
                echo "Remove ${each_session}"
                eval ${var_cmd[@]} -S ${var_session_tmp_path}/${each_session} kill-session -t "${each_session}"
                if [[ ${?} = 0 ]]
                then
                    rm ${var_session_tmp_path}/${each_session}
                else
                    echo "Remove session fail: ${each_session}"
                fi
            fi
        done
    elif [ "${var_action}" = "detach-all" ]
    then
        echo "${var_action} all session"

        for each_session in $(session ls | cut -d ":" -f 1| cut -d '@' -f 2)
        do
            if [ "${each_session}" != "" ]
            then
                echo "Detach ${each_session}"
                eval ${var_cmd[@]} -S ${var_session_tmp_path}/${each_session} detach-client -s "${each_session}"
            fi
        done
    elif [ "${var_action}" = "detach" ]
    then
        echo "${var_action} ${var_target_name}@${var_taget_socket}"

        for each_session in $(session ls | cut -d ":" -f 1| cut -d '@' -f 2)
        do
            if [ "${each_session}" = "${var_taget_socket}" ]
            then
                echo "Detach ${var_target_name}"
                eval ${var_cmd[@]} -S ${var_session_tmp_path}/${var_taget_socket} detach-client -s "${var_target_name}"
            fi
        done
    fi

    # Remove session socket if it exit
    if [ "${var_action}" = "create" ] || [ "${var_action}" = "attach" ] || [ "${var_action}" = "attach-only" ]
    then
        if [ "${var_taget_socket}" != "" ] && ! session ls |grep ${var_taget_socket} && test -S ${var_session_tmp_path}/${var_taget_socket}
        then
            # FIXME, It will remvoe change session, And cause memory leak.
            echo "Remove session ${var_taget_socket}"
            rm ${var_session_tmp_path}/${var_taget_socket}
        fi
    fi

    # ${var_cmd[@]} a -t ${var_taget_socket} || ${var_cmd[@]} new -s ${var_taget_socket}
}
function sanity_check()
{
    local threshold=95
    local var_disk=$(pwd)
    tmp_percent=$(df -h ${var_disk} | tr -s ' '  | tail -n 1 | cut -d ' ' -f 5 | sed 's/%//g')
    tmp_size=$(df -h ${var_disk} | tr -s ' '  | tail -n 1 | cut -d ' ' -f 4 | sed 's/%//g')
    if ((${tmp_percent} > ${threshold} ))
    then
        printc -c red "${var_disk}(${tmp_size}/${tmp_percent}) is bigger then ${threshold}%\n"
    fi

    local var_disk=/tmp
    tmp_percent=$(df -h ${var_disk} | tr -s ' '  | tail -n 1 | cut -d ' ' -f 5 | sed 's/%//g')
    tmp_size=$(df -h ${var_disk} | tr -s ' '  | tail -n 1 | cut -d ' ' -f 4 | sed 's/%//g')
    if ((${tmp_percent} > ${threshold} ))
    then
        printc -c red "${var_disk}(${tmp_size}/${tmp_percent}) is bigger then ${threshold}%\n"
    fi
}
function erun()
{
    # enhanced run
    local var_ret=0
    local excute_cmd=""
    local log_path=${HS_PATH_LOG}/$(date +%Y%m)/$(date +%d)

    local history_file="${log_path}/erun_history.log"
    local log_file="${log_path}/logfile_$(tstamp).log"

    local flag_sudo="n"
    local flag_lite="n"
    local flag_log_enable="y"
    local flag_color_enable="n"
    local flag_send_mail="n"
    local flag_analize_fail="n"
    local var_cmd_ret='0'

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -sh|--Source-HS)
                local excute_cmd="source ${HS_PATH_LIB}/source.sh -p=${HS_PATH_LIB} -s=${HS_ENV_SHELL} --change-shell-path=n --silence=y && "
                ;;
            -s|--sudo)
                flag_sudo="y"
                ;;
            -e|--eval)
                flag_lite="y"
                flag_log_enable="n"
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
            -d|--debug)
                flag_analize_fail="y"
                ;;
            -l|--list-log)
                cat ${log_path}/erun_history.log
                return 0
                ;;
            -h|--help)
                cli_helper -c "erun"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "erun [Options] [Command]"
                cli_helper -t "Options"
                cli_helper -o "-sh|--Source-HS" -d "Source HS config"
                cli_helper -o "-s|--sudo" -d "sudo excute"
                cli_helper -o "-e|--eval" -d "an alternative eval"
                cli_helper -o "-L|--no-log" -d "Run without record log"
                cli_helper -o "-c|--color" -d "Enable Color"
                cli_helper -o "-m|--mail" -d "Send mail after command is finished"
                cli_helper -o "-d|--debug" -d "use banlys to debug"
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
    # preproccess
    if [ "${flag_sudo}" = "y" ]
    then
        excute_cmd="sudo ${excute_cmd}"
    fi

    # local start_time=$(date "+%Y-%m-%d_%H:%M:%S")
    local start_time=$(date)
    echo "Evaluating: $(printc -c yellow ${excute_cmd})"
    # print "$(printlc -lw 32 -cw 0 -d " " "Start Jobs at ${start_time}" "")" | mark -s green "#"
    if [ "${flag_lite}" = "n" ]
    then
        echo "$(printlc -lw 32 -cw 0 -d " " "Start Jobs at ${start_time}" "")" | mark -s green "#"
    fi
    # mbuild "${excute_cmd}"
    if [ -n "${HS_PATH_LOG}" ] && [ "${flag_log_enable}" = "y" ] && [ "${flag_lite}" = "n" ]
    then
        if [ ! -d "${log_path}" ]
        then
            mkdir -p ${log_path}
        fi
        # should keep this in one line to prevent insertion of other task
        printf "Command: %s\nLogfile: %s\n================================================================\n" "${excute_cmd}" "${log_file}" >> ${history_file}

        hs_varconfig -s "${HS_VAR_LOGFILE}" "${log_file}"
        logfile -e -f "${log_file}" "${excute_cmd}"
    else
        # echo "Log file path not define.HS_PATH_LOG=${HS_PATH_LOG}"
        eval "${excute_cmd}"
    fi
    var_ret=$?
    # if [ ${var_ret} != 0 ]
    # then
    #     echo "An Error occur, return:${var_ret}" | mark -s red Error
    # fi
    # local end_time=$(date "+%Y-%m-%d_%H:%M:%S")
    #
    if [ "${flag_lite}" = "n" ]
    then
        local end_time=$(date)
        # echo $(elapse "${start_time}" "${end_time}")
        printt "$(printlc -lw 50 -cw 0 -d " " "Job Finished" "")\n$(printlc -lw 14 -cw 36 "Start" "${start_time}")\n$(printlc -lw 14 -cw 36  "End" "${end_time}")\n$(printlc -lw 14 -cw 36  "Elapse" "$(elapse "${start_time}" "${end_time}")")" | mark -s green "#"
        if [ ${var_ret} != 0 ]
        then
            # echo "An Error occur, return:${var_ret}" | mark -s red Error
            echo "Fail to finished cmd, Return (${var_ret}): $(printc -c yellow ${excute_cmd})"| mark -s red 'Fail'
            if [ "${flag_analize_fail}" = 'y' ]
            then
                banlys -a -d ${log_file}
            else
                echo "Note. You could use 'banlys buf' to analyze error."
            fi
        else
            echo "Finished cmd: $(printc -c yellow ${excute_cmd})"
        fi

        if [ "${flag_send_mail}" = "y" ]
        then
            printf 'Command finished: %s\nCommand Log: %s\n Return: %d\n' "${excute_cmd}" "${log_file}" | mail -s "[Notify][ERUN] Command finished" ${HS_ENV_MAIL} ${var_ret}
        fi

        if [ "${fun_ret}" != '0' ]
        then
            sanity_check
        fi
    fi
    return ${var_ret}
}
function xcd()
{
    # echo "Enhanced cd"
    local cpath=$(pwd)
    local target_path=""
    local sub_folder=""
    local var_action="cd"
    local var_arg=""
    local var_path=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -a|--add)
                var_action="add"
                var_arg=${2}
                if test -e "${3}"
                then
                    # var_path=$(realpath ${3})
                    var_path=${3}
                else
                    # echo "Not folder found"
                    return 0
                fi
                # shift 2
                break
                ;;
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
            ${HS_VAR_ECD_NAME_0}) target_path=${HS_PATH_ECD_0} ;;
            ${HS_VAR_ECD_NAME_1}) target_path=${HS_PATH_ECD_1} ;;
            ${HS_VAR_ECD_NAME_2}) target_path=${HS_PATH_ECD_2} ;;
            ${HS_VAR_ECD_NAME_3}) target_path=${HS_PATH_ECD_3} ;;
            ${HS_VAR_ECD_NAME_4}) target_path=${HS_PATH_ECD_4} ;;
            ${HS_VAR_ECD_NAME_5}) target_path=${HS_PATH_ECD_5} ;;
            ${HS_VAR_ECD_NAME_6}) target_path=${HS_PATH_ECD_6} ;;
            ${HS_VAR_ECD_NAME_7}) target_path=${HS_PATH_ECD_7} ;;
            ${HS_VAR_ECD_NAME_8}) target_path=${HS_PATH_ECD_8} ;;
            ${HS_VAR_ECD_NAME_9}) target_path=${HS_PATH_ECD_9} ;;

            ${HS_VAR_ECD_NAME_10}) target_path=${HS_PATH_ECD_10} ;;
            ${HS_VAR_ECD_NAME_11}) target_path=${HS_PATH_ECD_11} ;;
            ${HS_VAR_ECD_NAME_12}) target_path=${HS_PATH_ECD_12} ;;
            ${HS_VAR_ECD_NAME_13}) target_path=${HS_PATH_ECD_13} ;;
            ${HS_VAR_ECD_NAME_14}) target_path=${HS_PATH_ECD_14} ;;
            ${HS_VAR_ECD_NAME_15}) target_path=${HS_PATH_ECD_15} ;;
            ${HS_VAR_ECD_NAME_16}) target_path=${HS_PATH_ECD_16} ;;
            ${HS_VAR_ECD_NAME_17}) target_path=${HS_PATH_ECD_17} ;;
            ${HS_VAR_ECD_NAME_18}) target_path=${HS_PATH_ECD_18} ;;
            ${HS_VAR_ECD_NAME_19}) target_path=${HS_PATH_ECD_19} ;;

            ${HS_VAR_ECD_NAME_20}) target_path=${HS_PATH_ECD_20} ;;
            ${HS_VAR_ECD_NAME_21}) target_path=${HS_PATH_ECD_21} ;;
            ${HS_VAR_ECD_NAME_22}) target_path=${HS_PATH_ECD_22} ;;
            ${HS_VAR_ECD_NAME_23}) target_path=${HS_PATH_ECD_23} ;;
            ${HS_VAR_ECD_NAME_24}) target_path=${HS_PATH_ECD_24} ;;
            ${HS_VAR_ECD_NAME_25}) target_path=${HS_PATH_ECD_25} ;;
            ${HS_VAR_ECD_NAME_26}) target_path=${HS_PATH_ECD_26} ;;
            ${HS_VAR_ECD_NAME_27}) target_path=${HS_PATH_ECD_27} ;;
            ${HS_VAR_ECD_NAME_28}) target_path=${HS_PATH_ECD_28} ;;
            ${HS_VAR_ECD_NAME_29}) target_path=${HS_PATH_ECD_29} ;;
            -p|--proj|proj|project|projects)
                local tmp_path=$(echo ${HS_PATH_PROJ})
                if [ -n "${2}" ] && test -d $(realpath ${tmp_path}/*${2}*)
                then
                    # target_path=${tmp_path}/*${2}*
                    target_path=$(realpath ${tmp_path}/*${2}*)
                    # echo "HAL to ${2}"
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

                [ ! -z ${HS_VAR_ECD_NAME_10} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_10} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_10}"
                [ ! -z ${HS_VAR_ECD_NAME_11} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_11} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_11}"
                [ ! -z ${HS_VAR_ECD_NAME_12} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_12} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_12}"
                [ ! -z ${HS_VAR_ECD_NAME_13} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_13} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_13}"
                [ ! -z ${HS_VAR_ECD_NAME_14} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_14} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_14}"
                [ ! -z ${HS_VAR_ECD_NAME_15} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_15} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_15}"
                [ ! -z ${HS_VAR_ECD_NAME_16} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_16} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_16}"
                [ ! -z ${HS_VAR_ECD_NAME_17} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_17} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_17}"
                [ ! -z ${HS_VAR_ECD_NAME_18} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_18} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_18}"
                [ ! -z ${HS_VAR_ECD_NAME_19} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_19} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_19}"

                [ ! -z ${HS_VAR_ECD_NAME_20} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_20} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_20}"
                [ ! -z ${HS_VAR_ECD_NAME_21} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_21} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_21}"
                [ ! -z ${HS_VAR_ECD_NAME_22} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_22} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_22}"
                [ ! -z ${HS_VAR_ECD_NAME_23} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_23} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_23}"
                [ ! -z ${HS_VAR_ECD_NAME_24} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_24} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_24}"
                [ ! -z ${HS_VAR_ECD_NAME_25} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_25} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_25}"
                [ ! -z ${HS_VAR_ECD_NAME_26} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_26} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_26}"
                [ ! -z ${HS_VAR_ECD_NAME_27} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_27} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_27}"
                [ ! -z ${HS_VAR_ECD_NAME_28} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_28} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_28}"
                [ ! -z ${HS_VAR_ECD_NAME_29} ] && cli_helper -o  "$(echo ${HS_VAR_ECD_NAME_29} | sed 's/[()@]//g')" -d "cd to ${HS_PATH_ECD_29}"
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

    # if [ -z "${target_path}" ]
    # then
    #     tmp_clip="$(clip --silence -d)"
    #     test -z tmp_clip && target_path="${tmp_clip}"
    # fi

    if [ "${var_action}" = "add" ]
    then
        local var_cnt=0

        while [ ${var_cnt} -lt 20 ]
        do
            local tmp_name=$(echo "HS_VAR_ECD_NAME_$var_cnt")
            local tmp_path=$(echo HS_PATH_ECD_${var_cnt})

            local tmp_cmd='test "${var_arg}" = "$'${tmp_name}'" '
            if eval "${tmp_cmd}"
            then
                # echo "Same pattern"
                break
            fi

            local tmp_cmd='test -z $'${tmp_name}
            if eval "${tmp_cmd}"
            then
                export ${tmp_name}="${var_arg}"
                export ${tmp_path}="${var_path}"
                export var_cnt=$((${var_cnt} + 1))
                break
            fi
            export var_cnt=$((${var_cnt} + 1))
        done
    else
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
        elif [ ! -z "${target_path}" ]
        then
            echo "Can't find ${target_path}"
            cd ${cpath}
            return 1
        else
            echo "target path is empty"
        fi

    fi


}
function fcd()
{

    local cpath=$(pwd)
    local depth=5
    local target_folder=""
    local var_action="search"
    local flag_verbose=false
    local flag_fast_hit=false

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--depth)
                depth=$2
                shift 1
                ;;
            -f|--fast-hit)
                flag_fast_hit=true
                ;;
            -l|--latest)
                var_action="latest"
                ;;
            -v|--verbose)
                flag_verbose=true
                ;;
            -h|--help)
                cli_helper -c "fcd" -cd "fcd function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "fcd [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-f|--fast-hit" -d "Fast hit"
                cli_helper -o "-d|--depth" -d "Depth: default is 5"
                cli_helper -o "-l|--latest" -d "Get in to latest modify folder"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;

            *)
                target_folder=${@}
                ;;
        esac
        shift 1
    done

    if [ "${var_action}" = "latest" ]
    then
        # echo "var_action: ${var_action}"
        local tmp_latest_dir=$(ls --sort="time" -d */| head -n 1)
        test -d ${tmp_latest_dir} && cd ${tmp_latest_dir} && return 0
    elif [ "${var_action}" = "search" ]
    then
        local tmp_real_pattern="*/*"
        local canditate_path=""
        local tmp_canditate_folder=""

        # echo "var_action: ${var_action}"
        if [[ ${depth} > 0 ]]
        then
            [ ${flag_verbose} = true ] && echo "Finding in Layer 0"
            # test -d ${target_folder} && cd ${target_folder} && return 0
            test -d ${target_folder} && tmp_canditate_folder=("$(realpath ${target_folder})")
        fi

        for each_depth in $(seq 1 ${depth})
        do
            [ ${flag_verbose} = true ] && echo "Finding in Layer ${each_depth}"
            # eval "realpath ${tmp_real_pattern}"
            [ ${flag_verbose} = true ] && echo Finding: $(eval "realpath ${tmp_real_pattern}" | grep "/${target_folder}$")
            for each_path in $(eval "realpath ${tmp_real_pattern}"  2> /dev/null | grep "/${target_folder}$")
            do
                # echo "each path:${each_path}"
                if test -d "${each_path}"
                then
                    if test -z "${tmp_canditate_folder}"
                    then
                        tmp_canditate_folder=("${each_path}")
                    else
                        tmp_canditate_folder+=("${each_path}")
                    fi
                fi
            done
            if [ ${flag_fast_hit} = true ] && [ "${#tmp_canditate_folder[@]}" -gt "1" ]
            then
                [ ${flag_verbose} = true ] && echo "Fast hit ${each_depth}"
                break
            fi
            tmp_real_pattern=${tmp_real_pattern}"/*"
        done

        if [[ "${#tmp_canditate_folder[@]}" = "1" ]]
        then
            # cd ${tmp_canditate_folder[0]}
            if test -d "${tmp_canditate_folder[0]}"
            then
                canditate_path=${tmp_canditate_folder[0]}
            elif test -d "${tmp_canditate_folder[1]}"
            then
                canditate_path=${tmp_canditate_folder[1]}
            fi
        elif [[ "${#tmp_canditate_folder[@]}" > "1" ]]
        then
            # echo for each_idx in seq 0 ${#tmp_canditate_folder[@]}
            for each_idx in $(seq 0 ${#tmp_canditate_folder[@]})
            do
                if test -d "${tmp_canditate_folder[${each_idx}]}"
                then
                    echo "[${each_idx}]:${tmp_canditate_folder[${each_idx}]}"
                fi
            done

            printf "Please select path(default 1):"
            read tmp_ans

            if test -n "${tmp_ans}"
            then
                # echo ${tmp_canditate_folder[${tmp_ans}]}
                # cd ${tmp_canditate_folder[${tmp_ans}]}
                canditate_path=${tmp_canditate_folder[${tmp_ans}]}
            else
                canditate_path=${tmp_canditate_folder[1]}
            fi
        fi

        [ ${flag_verbose} = true ] && echo "Canditate_path: ${canditate_path}->${tmp_canditate_folder[@]}"
        # echo "${canditate_path}"
        if test -d "${canditate_path}"
        then
            cd "${canditate_path}" && return 0
            return 1
        fi
        return 1
    else
        # echo "var_action: ${var_action}"
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
                var_target_cmd="git log --pretty='format:%cd(%cr) %p->%h %cn(%an) %s' -n 1"
                break
                ;;
            --disable-filemode)
                var_target_cmd="git config core.fileMode false"
                break
                ;;
            status)
                var_target_cmd="git status"
                break
                ;;
            -h|--help)
                cli_helper -c "gforall" -cd "gforall function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "gforall [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-l|--log" -d "Print first commit"
                cli_helper -o "--disable-filemode" -d "Disable file mode"
                cli_helper -o "status" -d "git status"
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
    local cpath="$(pwd)"
    local checkout_date=""
    local cBranch=""
    local target_commit=""
    local flag_fake="n"

    if [[ "$#" = "0" ]]
    then
        gcheckoutByDate -h
        return -1
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--date)
                checkout_date="${2}"
                shift 1
                ;;
            -f|--fake)
                flag_fake="y"
                ;;

            -h|--help)
                cli_helper -c "gcheckoutByDate" -cd "gcheckoutByDate function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "gcheckoutByDate [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-d|--date" -d "Checkout date, format: $(date '+%Y-%m-%d\\ %H:%M:%S'), may need \\ on space"
                cli_helper -o "-f|--fake" -d "Fake run"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                checkout_date="${2}"
                ;;
        esac
        shift 1
    done
    if [ -z "${checkout_date}" ]
    then
        echo 'No checkout date found'
        return -1
    fi
    cBranch=$(git rev-parse --abbrev-ref HEAD)
    target_commit=`git rev-list -n 1 --first-parent --before="$checkout_date" $cBranch`

    echo path   : ${cpath}
    echo branch : ${cBranch}
    echo commit : ${target_commit}
    echo git checkout ${target_commit}

    if [ "${flag_fake}" != "y" ]
    then
        git checkout ${target_commit}
    fi
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

    local var_remote="$(ginfo remote)"
    local var_branch="$(ginfo branch)"

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
    local var_action='info'
    local var_cpath=$(pwd)
    local var_remote=""
    local var_branch=""
    local var_url=""
    local flag_isgit='n'

    local tracking_branch_name=""
    local current_branch=""
    # local flag_info='n'

    if froot -f -m '.git' > /dev/null
    then
        flag_isgit='y'
    fi

    if [ "${flag_isgit}" = 'y' ]
    then
        var_remote="$(git remote show)"
        var_branch="$(git branch | grep '^\*' | sed 's/^\* //g')"
        var_url="$(git remote get-url ${var_remote})"
    fi

    if [[ "$#" = "0" ]]
    then
        var_action='info'
    fi

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -b|--branch|branch)
                var_action='branch'
                ;;
            -r|--remote|remote)
                var_action='remote'
                ;;
            -h|--help)
                cli_helper -c "ginfo" -cd "git information"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "ginfo [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-b|--branch|branch" -d "get branch info"
                cli_helper -o "-r|--remote|remote" -d "get remote info"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                # var_action='info'
                break
                ;;
        esac
        shift 1
    done

    tracking_branch_name="$(git branch -a | grep '\->' | cut -d'/' -f 4)"
    current_branch=$(git branch| sed -e '/^[^*]/d' -e 's/* //g' | tr -d "[:blank:]")
    if test -n "$(echo ${var_branch} | grep detached)"·
    then
        if [ $(echo ${tracking_branch_name} | grep -v detached) ]
        then
            var_branch=${tracking_branch_name}
        elif [ $(echo ${current_branch} | grep -v detached) ]
        then
            var_branch=${current_branch}
        fi
    fi
    if [ "${var_action}" = "branch" ]
    then
        echo "${var_branch}"
    elif [ "${var_action}" = "remote" ]
    then
        echo "${var_remote}"
    elif [ "${var_action}" = "info" ]
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
        echo "---- Config ----"
        echo "git config core.fileMode false"
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
function grun()
{
    local var_action='info'
    local var_cpath=$(pwd)
    local var_remote=""
    local var_branch=""
    local var_url=""
    local var_patch_file=""
    local flag_isgit='n'

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -b|--branch|branch)
                var_action='branch'
                ;;
            -c|--checkout|checkout)
                var_action='checkout'
                ;;
            -r|--reset|reset)
                var_action='reset'
                ;;
            -p|--pull|pull)
                var_action='pull'
                ;;
            -t|--track|track)
                var_action='track'
                ;;
            -f|--fetch|fetch)
                var_action='fetch'
                ;;
            -C|--clean|clean)
                var_action='clean'
                ;;
            -g|--generate-patch|generate-patch)
                var_action='patch'
                ;;
            -a|--apply-patch|apply-patch)
                var_action='apply'
                var_patch_file=$2
                shift 1
                ;;
            -h|--help)
                cli_helper -c "grun" -cd "git run"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "grun [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-b|--branch|branch" -d "Create Branch name with remote branch"
                cli_helper -o "-c|--checkout|checkout" -d "Checkout Branch name with remote branch"
                cli_helper -o "-r|--reset|reset" -d "Reset to remote tracking branch"
                cli_helper -o "-p|--pull|pull" -d "Pull remote tracking branch"
                cli_helper -o "-t|--track|track" -d "Tracking to remote branch"
                cli_helper -o "-f|--fetch|fetch" -d "Fetch remote tracking branch"
                cli_helper -o "-C|--clean|clean" -d "Clean garbage"
                # cli_helper -o "-g|--generate-patch|generate-patch" -d "Generate patch of HEAD commit"
                # cli_helper -o "-a|--apply-patch|apply-patch" -d "Apply patch"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_action="$1"
                break
                ;;
        esac
        shift 1
    done

    if froot -f -m '.git' > /dev/null
    then
        flag_isgit='y'
    fi

    if [ "${flag_isgit}" = 'y' ]
    then
        var_remote="$(ginfo --remote)"
        var_branch="$(ginfo --branch)"
        var_url="$(git remote get-url ${var_remote})"
    else
        echo "It's not an git project"
        return 1
    fi

    local tmp_cmd=""
    if [ "${var_action}" = "reset" ]
    then
        tmp_cmd="git reset --hard ${var_remote}/${var_branch}"
    elif [ "${var_action}" = "branch" ]
    then
        tmp_cmd="git checkout -b ${var_branch}"
    elif [ "${var_action}" = "branch" ]
    then
        tmp_cmd="git checkout ${var_branch}"
    elif [ "${var_action}" = "pull" ]
    then
        tmp_cmd="git pull ${var_remote} ${var_branch}"
    elif [ "${var_action}" = "track" ]
    then
        tmp_cmd="git branch --set-upstream-to=${var_remote}/${var_branch} ${current_branch}"
    elif [ "${var_action}" = "fetch" ]
    then
        tmp_cmd="git fetch  ${var_remote} ${var_branch}"
    elif [ "${var_action}" = "clean" ]
    then
        tmp_cmd="git gc --prune=now --aggressive"
    elif [ "${var_action}" = "patch" ]
    then
        tmp_cmd="git format-patch -n 1 HEAD"
    elif [ "${var_action}" = "apply" ]
    then
        tmp_cmd="git am --directory=./ ${var_patch_file}"
    elif [ "${var_action}" = "info" ]
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
    if test -n "${tmp_cmd}"
    then
        echo "${tmp_cmd}"
        eval "${tmp_cmd}"
    fi
}

function glog()
{
    local var_git_log_cmd=""
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -1)
                var_git_log_cmd="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
                # var_git_log_cmd="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%cD%C(reset) %C(bold green)(%cr)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
                ;;
            -2)
                var_git_log_cmd="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
                ;;
            -a|--append)
                cmd_args+=("${2}")
                shift 1
                ;;
            -v|--verbose)
                flag_verbose="y"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-1" -d "format 1"
                cli_helper -o "-2" -d "format 2"
                cli_helper -o "-a|--append" -d "append file extension on search"
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done
    if test -z "${var_git_log_cmd}"
    then
        var_git_log_cmd="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%cD%C(reset) %C(bold green)(%cr)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
    fi

    echo ${var_git_log_cmd}
    eval ${var_git_log_cmd}
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
    C    OMMIT_SIZE="`echo "$SIZE_LIST" | awk '{ sum += $1 } END { print sum }'`"
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
            if [[ $? != 0 ]]
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
function rprun()
{
    local var_cpath=$(pwd)
    local var_jobs="16"

    local var_remote=""
    local var_branch=""
    local var_url=""
    local var_patch_file=""

    local flag_isrepo='n'
    local flag_info=false
    local flag_sync=false
    local flag_reset=false
    local flag_status=false

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--sync|sync)
                flag_sync=true
                ;;
            -r|--reset|reset)
                flag_reset=true
                ;;
            --status|status)
                flag_status=true
                ;;
            -h|--help)
                cli_helper -c "grun" -cd "git run"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "grun [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-s|--sync|sync" -d "Sync one repo only"
                cli_helper -o "--status|status" -d "Show status info"
                cli_helper -o "-r|--reset|reset" -d "reset repo & clean out files"
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

    if froot -f -m '.repo' > /dev/null
    then
        flag_isrepo='y'
    else
        echo "Not a repo project."
        return 1
    fi

    local tmp_cmd=""

    if [ ${flag_reset} = true ]
    then
        tmp_cmd="repo forall -v -j ${var_jobs} -c 'git reset --hard HEAD; git clean -fd'"
        echo "${tmp_cmd}"
        eval "${tmp_cmd}"
        error_check
    fi

    if [ ${flag_sync} = true ]
    then
        tmp_cmd="repo sync -j${var_jobs} -c --no-tags --no-clone-bundle"
        echo "${tmp_cmd}"
        eval "${tmp_cmd}"
        error_check
    fi

    if [ ${flag_status} = true ]
    then
        tmp_cmd="repo forall -v  -c 'git log --pretty='format:%p->%h %cn(%an) %s' -n 1'"
        echo "${tmp_cmd}"
        eval "${tmp_cmd}"
        error_check
    fi

    if [ ${flag_info} = true ]
    then
        echo "Usefull repo commands"
    fi

    # if test -n "${tmp_cmd}"
    # then
    #     echo "${tmp_cmd}"
    #     eval "${tmp_cmd}"
    # fi
}
function rpcode()
{
    # local var_jobs=8
    local var_tag_url=""
    local flag_init=false
    local flag_sync=false
    local var_groups="default"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--download|down|download)
                flag_init=true
                flag_sync=true
                ;;
            -i|--init|init)
                flag_init=true
                ;;
            -s|--sync|sync)
                flag_sync=true
                ;;
            -u|--url)
                var_tag_url=${2}
                shift 1
                ;;
            -g|--group)
                var_groups="$2"
                shift 1
                ;;
            # -a|--append)
            #     cmd_args+=("${2}")
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-d|--download" -d "Init/Sync repo"
                cli_helper -o "-i|--init" -d "Init repo"
                cli_helper -o "-s|--sync" -d "Sync repo"
                cli_helper -o "-u|--url" -d "Input URL tag"
                cli_helper -o "-g|--group" -d "Download with group"
                # cli_helper -o "-a|--append" -d "append file extension on search"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done

    var_tag_project="$(echo ${var_tag_url} | sed 's/\/+.*//g' | sed 's|plugins/gitiles/||g')"
    var_tag_branch="$(echo ${var_tag_url} | sed 's/.*heads\///g' | cut -d '/' -f 1)"
    var_tag_manifest="$(echo ${var_tag_url} | sed 's/.*heads\///g' | cut -d '/' -f 2-)"

    # echo ${var_tag_project}
    # echo ${var_tag_branch}
    # echo ${var_tag_manifest}
    if test -z "${var_tag_project}" || test -z "${var_tag_branch}" || test -z "${var_tag_manifest}"
    then
        echo "Parsing fail.Project: ${var_tag_project}, Branch: ${var_tag_branch}, Manifest: ${var_tag_manifest}"
        return -1
    fi

    echo repo init -u ${var_tag_project} -b ${var_tag_branch} -m ${var_tag_manifest} -g ${var_groups}
    if [ ${flag_init} = true ]
    then
        repo init -u ${var_tag_project} -b ${var_tag_branch} -m ${var_tag_manifest} -g ${var_groups}
        echo "repo init -u ${var_tag_project} -b ${var_tag_branch} -m ${var_tag_manifest} -g ${var_groups}" >> .repo/repo_init.log
    fi

    if [ ${flag_sync} = true ]
    then
        rprun -s
    fi
}
# function rpreset()
# {
#     local var_jobs="64"
#     repo forall -j ${var_jobs} -vc "git reset --hard HEAD"
#     repo forall -j ${var_jobs} -vc "git clean -fd"
#     repo sync  -j ${var_jobs}
# }
function rpcheckoutByDate()
{
    local cpath="$(pwd)"
    local checkout_date=""
    local var_action=""
    local flag_fake="n"

    if [[ "$#" = "0" ]]
    then
        echo "Date not found."
        echo "ex. rpcheckoutByDate \"2020-07-22 02:00\""
        return 0
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--date|date)
                checkout_date=$1
                shift 1
                ;;
            -f|--fake|fake)
                flag_fake=y
                ;;
            -h|--help)
                cli_helper -c "rpcheckoutByDate" -cd "rpcheckoutByDate stand for repo checkout"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "rpcheckoutByDate [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-d|--date|date" -d "Specify date for commit"
                cli_helper -o "-f|--fake|fake" -d "Fake run"
                cli_helper -t "Example"
                cli_helper -d "rpcheckoutByDate -d 2020-07-22 02:00"
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    if [ -z "${checkout_date}" ]
    then
        echo 'No checkout date found'
        return -1
    fi

    if [ "${flag_fake}" = "y" ]
    then
        echo repo forall -j $(nproc --all)  -c "pwd && git reset --hard \$(git rev-list -n 1 --first-parent --before=\"${checkout_date}\" \$(git rev-parse --abbrev-ref HEAD))"
    else
        repo forall -j $(nproc --all)  -c "pwd && git reset --hard \$(git rev-list -n 1 --first-parent --before=\"${checkout_date}\" \$(git rev-parse --abbrev-ref HEAD))"
    fi
}
function proot()
{
    local var_action=''

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -r|--repo)
                var_action='repo'
                ;;
            -g|--git)
                var_action='git'
                ;;
            -o|--out)
                var_action='out'
                ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "proot" -cd "proot function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "proot [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-r|--repo" -d "Goto dir with .repo located"
                cli_helper -o "-g|--git" -d "Goto dir with .git located"
                cli_helper -o "-o|--out" -d "Goto dir outside project"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done
    # alias proot="froot -m .git || froot -m .repo"
    if [ "${var_action}" = "repo" ]
    then
        # echo "flag_repo: ${flag_repo}"
        froot -m .repo
    elif [ "${var_action}" = "git" ]
    then
        # echo "flag_git: ${flag_git}"
        froot -m .git
    elif [ "${var_action}" = "out" ]
    then

        cd $(froot -f -m .repo || froot -f -m .git)/..
    else
        froot -m .repo || froot -m .git
    fi
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
    local tmp_input_file="hex2bin.$(tstamp).in"

    local var_output_file=""
    local tmp_output_file="hex2bin.$(tstamp)"
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
        xxd -i ${tmp_output_file}  > ${tmp_output_file}.h
        mv -f ${tmp_output_file}.h ${tmp_output_file}
    fi

    if [ "${var_output_file}" = "" ]
    then
        cat ${tmp_output_file}
        [ -f "${tmp_output_file}" ] && rm ${tmp_output_file}
    else
        mv ${tmp_output_file} ${var_output_file}
    fi
    [ -f "${tmp_input_file}" ] && rm ${tmp_input_file}

}
########################################################
#####    Pythen                                    #####
########################################################
function pymodule()
{
    python -m $@
}
function pyvenv()
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
                cli_helper -c "pyvenv" -cd "pyvenv function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "pyvenv [Options] [Value]"
                cli_helper -d "default path will set to HS_PATH_PYTHEN_ENV"
                cli_helper -t "Options"
                cli_helper -o "-c|--create|c" -d "create Pyvenv"
                cli_helper -o "-a|--active|a" -d "active Pyvenv"
                cli_helper -o "-d|--deactivate|d" -d "deactivate Pyvenv"
                cli_helper -o "-u|--update|u" -d "update pip"
                cli_helper -o "-p|--path" -d "setting pyen path, default path:${HS_PATH_PYTHEN_ENV}"
                cli_helper -o "--pip|pip" -d "Do pip install with trust host"
                cli_helper -o "-h|--help" -d "Print help function "
                cli_helper -t "Note."
                cli_helper -d "pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org [Pkg]"
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
        # pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
        pip3 list --outdated | cut -d " " -f 1 | grep -v "Package\|-" | xargs pip install -U
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
