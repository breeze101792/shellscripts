########################################################
########################################################
#####                                              #####
#####    For HS Tools Functions                    #####
#####                                              #####
########################################################
########################################################

########################################################
#####    Alias                                     #####
########################################################
alias clips="clip -s "
alias clipx="clip -x "

########################################################
#####    File Function                             #####
########################################################
function waitsync()
{
    # waitsync [target_file]
    # wait for target file exist
    local target=$1
    local interval=1
    while [ ! -e ${target} ];
    do
        echo "Wait for ${target}"
        sleep ${interval}
        renter
    done
    echo "Found ${target}"
}
function clip()
{
    local flag_fake_run=false
    if [ "$#" = 0 ]
    then
        eval "clip -g"
        return 0
    fi
    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -s|--set-clip)
                shift 1
                if [[ $# = 0 ]] && [ ! -t 0 ]
                then
                    local var_from_pipe="$(xargs echo)"
                    # echo "FD 0 has opened."
                    hs_config -s "${HS_VAR_CLIPBOARD}" "${var_from_pipe}"
                elif [[ ${#} = 0 ]]
                then
                    hs_config -s "${HS_VAR_CLIPBOARD}" "$(realpath .)"
                elif [[ ${#} = 1 ]] && [ -e ${1} ]
                then
                    hs_config -s "${HS_VAR_CLIPBOARD}" "$(realpath ${1})"
                else
                    hs_config -s "${HS_VAR_CLIPBOARD}" "${@}"
                fi
                break
                ;;
            -p|--set-from-pipe)
                local var_from_pipe="$(xargs echo)"
                # echo "FD 0 has opened."
                hs_config -s "${HS_VAR_CLIPBOARD}" "${var_from_pipe}"
                ;;
            -g|--get-clip)
                hs_config -g "${HS_VAR_CLIPBOARD}"
                ;;
            -d|--get-current-dir)
                # get current dir
                hs_config -g "${HS_VAR_CURRENT_DIR}"
                ;;
            -c|--copy-file)
                clip -x cp %p .
                ;;
            -cd|--copy-directory)
                clip -x cp %p .
                ;;
            -ca|--copy-directory)
                clip -x cp %p/* .
                ;;
            -f|--fake-run)
                flag_fake_run=true
                ;;
            -x|--excute)
                shift 1
                local excute_cmd=$(printf "$(echo $@ | sed 's/%p/%s/g' )" "$(clip -g)")
                echo ${excute_cmd} |mark -s yellow ${excute_cmd}
                if ! ${flag_fake_run}
                then
                    printf "Excute Commands?(Y/n)"
                    read tmp_ans
                    test "${tmp_ans}" != "n" && eval ${excute_cmd}
                fi

                break
                ;;
            -h|--help)
                echo "Clibboard Usage"
                printlc -cp false -d "->" "-s|--set-clip" "Set Clipbboard, default use pwd for setting var"
                printlc -cp false -d "->" "-p|--set-from-pipe" "Set Clipbboard, default use pwd for setting var"
                printlc -cp false -d "->" "-g|--get-clip" "Get Clipbboard, default use getting action"
                printlc -cp false -d "->" "-d|--get-current-dir" "Get current dir vars, get current stored dir"
                printlc -cp false -d "->" "-c|--copy-file" "cp file to current folder"
                printlc -cp false -d "->" "-cd|--copy-directory" "cp all file to current folder"
                printlc -cp false -d "->" "-f|--fake-run" "Do fake run on -x"
                printlc -cp false -d "->" "-x|--excute" "Excute command, replace %p with clip buffer"

                return 0
                ;;
            *)
                hs_config -s "${HS_VAR_CLIPBOARD}" "${@}"
                break
                ;;
        esac
        shift 1
    done
}
bkfile()
{
    local flag_auto_idx="y"
    local var_bk_file=""
    local var_bk_name=""
    local var_description=""
    local var_idx="00"
    local var_date="$(tstamp)"
    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -n|--name)
                var_description="$(echo $2 | sed 's/\ /_/g')"
                shift 1
                ;;
            -f|--backup-file)
                var_bk_file="$(echo $2 | sed 's/\ /_/g')"
                shift 1
                ;;
            -h|--help)
                echo "bkfile [Options] [file name]"
                printlc -cp false -d "->" "-n|--name" "append description on the file name"
                printlc -cp false -d "->" "-f|--backup-file" "specify file name"
                printlc -cp false -d "->" "-h|--help" "Print help function "
                return 0
                ;;
            *)
                if [ "${var_bk_file}" != "" ]
                then
                    echo "Backup file already definied"
                    return 1
                fi
                var_bk_file="$(echo $1 | sed 's/\ /_/g')"
                ;;
        esac
        shift 1
    done
    var_bk_file="$(echo ${var_bk_file} | sed 's/\/$//g')"
    if [ ! -f "${var_bk_file}" ] && [ ! -d "${var_bk_file}" ]
    then
        echo "File(${var_bk_file}) not found!"
        return 1
    fi

    var_idx=$(find . -name "${var_bk_file}*" | sed "s/_/\n/g" | grep "I[0-9]\{2\}" | sed "s/I//g" | sort | tail -n 1)
    var_idx=$(printf 'I%02d' "$(( ${var_idx} + 1 ))")

    var_bk_name="${var_bk_file}_${var_idx}_${var_date}"
    if [ "${var_description}" != "" ]
    then
        var_bk_name="${var_bk_name}_${var_description}"
    fi

    echo -e "Backup ${var_bk_file} to ${var_bk_name}\n"
    mv "${var_bk_file}" "${var_bk_name}"
}
function rln()
{
    ln -sf $(realpath $1) $2
}
function retitle()
{
    # print -Pn "\e]0;$@\a"
    echo -en "\033]0;$@\a"
}
function bisync()
{
    local local_path=$1
    local remote_path=$2
    rsync -rtuvh --no-compress --progress $local_path/* $remote_path
    rsync -rtuvh --no-compress --progress $remote_path/* $local_path
}
function fsync()
{
    local local_path=$1
    local remote_path=$2
    # rsync -avhW --no-compress --progress ${*}
    rsync -avhW --no-compress --progress ${1}/* ${2}
}
function renter()
{
    local cpath=$(realpath "${PWD}")
    local idx=$((1))
    while true
    do
        local tmp_path="$(pwd | rev | cut -d '/' -f ${idx}- |rev)"
        if [ -d "${tmp_path}" ]
        then
            echo "Goto ${tmp_path}"
            cd "$(realpath ${tmp_path})"
            break
        elif [ "${tmp_path}" = "/" ]
        then
            break
        fi
        idx=$((idx + 1))
    done
    # cd ${HOME}
    # cd ${cpath}
}
function extract()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2|*.tbz2)
                tar xvjf $1
                ;;
            *.tar.xz)
                tar xvJf $1
                ;;
            *.tar.gz|*.tgz)
                tar xvzf $1
                ;;
            *.bz2)
                bunzip2 $1
                ;;
            *.rar)
                unrar x $1
                ;;
            *.gz)
                gunzip $1
                ;;
            *.tar)
                tar xvf $1
                ;;
            *.zip)
                unzip $1
                ;;
            *.Z)
                uncompress $1
                ;;
            *.7z)
                7z x $1
                ;;
            *)
                echo "Unknown file type, use 7z to extract it"
                7z x $1
                ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
function tstamp()
{
    date +%Y%m%d_%H%M%S
}
function fakeshell()
{
    local precmd=$1
    local postcmd=""
    local cmd=""
    echo "Fake shell"

    while printf "FShell>" && read cmd
    do
        eval "${precmd} ${cmd} ${postcmd}"
    done
}
function read_key()
{
    # /usr/include/linux/input-event-codes.h
    read -n 1 var_input
    # printf ${var_input} | xxd | cut -d " " -f 2-7
    printf "\nvar: \$\'\\\x%s\'\n" $(printf ${var_input} | xxd | cut -d " " -f 2-7) 
}
function xkey()
{
    local var_skey_prefix="sudo ydotool key "
    local var_skey_postfix=" > /dev/null"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -h|--help)
                cli_helper -c "xkey" -cd "remote keyboard emulation"
                cli_helper -d "Please Launch ydotoold & launch in bash."
                cli_helper -t "SYNOPSIS"
                cli_helper -d "xkey [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    # only bash work & please do ydotoold first
    if [ "${HS_ENV_SHELL}" != "bash" ]
    then
        echo "Only Support in Bash. Currently use ${HS_ENV_SHELL}"
        return 1
    fi
    local var_input=""
    local var_previous=""

    local var_start=0
    local var_end=0
    local var_time=0

    while IFS= read -s -r -n 1 var_input
    do
        var_end=$(date +%s%N)
        case ${var_input} in
            '')
                echo "Enter dected"
                ${var_skey_prefix} "ENTER"
                continue
                ;;
            ${uparrow})
                echo "up dected"
                continue
                ;;
            # $'\x2c')
                #     echo "Ctrl + < dected"
                #     ${var_skey_prefix} "ctrl+PATGEUP"
                # continue
                #     ;;
            # $'\x2e')
                #     echo "Ctrl + > dected"
                #     ${var_skey_prefix} "ctrl+PATGEDOWN"
                # continue
                #     ;;
            # $'\x1b')
            #     echo "esc dected"
            #     ${var_skey_prefix} "esc"
            #     continue
            #     ;;
            $'\x16')
                echo "Ctrl + v dected"
                ${var_skey_prefix} "ctrl+v"
                continue
                ;;
            $'\x18')
                echo "Ctrl + x dected"
                ${var_skey_prefix} "ctrl+x"
                continue
                ;;
            $'\x01')
                echo "Ctrl + a dected"
                ${var_skey_prefix} "ctrl+a"
                continue
                ;;
            $'\x14')
                echo "Ctrl + t dected"
                ${var_skey_prefix} "ctrl+t"
                continue
                ;;
            $'\x17')
                echo "Ctrl + w dected"
                ${var_skey_prefix} "ctrl+w"
                continue
                ;;
            $'\x0c')
                echo "Ctrl + l dected"
                ${var_skey_prefix} "ctrl+l"
                continue
                ;;
            $'\x7f')
                echo "backspace dected"
                ${var_skey_prefix} "backspace"
                continue
                ;;
            ' ')
                echo "Space dected"
                # ${var_skey_prefix} "SPACE"
                ${var_skey_prefix} " "
                continue
                ;;
        esac

        # local var_time=$(expr ${var_end} - ${var_start})
        # echo "Time Space:${var_end} - ${var_start} = ${var_time}"
        # echo $(test ${var_time} -le 20000000 )
        if [ ${var_time} -le 20000000 ]
        then
            # echo "Enter double key press"
            case ${var_previous}${var_input} in
                '[A')
                    echo "Enter Arror Up"
                    ${var_skey_prefix} "KEY_UP"
                    continue
                    ;;
                '[B')
                    echo "Enter Arror Down"
                    ${var_skey_prefix} "KEY_DOWN"
                    continue
                    ;;
                '[C')
                    echo "Enter Arror Right"
                    ${var_skey_prefix} "KEY_RIGHT"
                    continue
                    ;;
                '[D')
                    echo "Enter Arror Left"
                    ${var_skey_prefix} "KEY_LEFT"
                    continue
                    ;;
                $'\x1b'$'\x1b')
                    echo "esc dected"
                    ${var_skey_prefix} "esc"
                    continue
                    ;;
            esac
        fi

        # printf "\r%s" ${var_read_buf}
        if [ "${var_input}" != "[" ] && [ "${var_previous}"  != $'\x1b' ]
        then
            echo "${var_input}"
            ${var_skey_prefix} "${var_input}" 2> /dev/null
        fi

        # Update time
        var_previous=${var_input}
        var_start=${var_end}

    done
}

function silence()
{
    local precmd=""
    local postcmd="> /dev/null"
    local cmd="$@"

    eval "${precmd} ${cmd} ${postcmd}"
}
