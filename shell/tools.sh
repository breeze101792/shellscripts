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
            -l|--link)
                clip -x 'ln -s $(realpath %p) ./'
                ;;
            -c|--copy-file)
                clip -x cp -r %p .
                ;;
            -cd|--copy-directory)
                clip -x cp -r %p .
                ;;
            -ca|--copy-directory)
                clip -x cp -r %p/* .
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
                cli_helper -c "clip" -cd "clip function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "clip [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-s|--set-clip" -d "Set Clipbboard, default use pwd for setting var"
                cli_helper -o "-p|--set-from-pipe" -d "Set Clipbboard, default use pwd for setting var"
                cli_helper -o "-g|--get-clip" -d "Get Clipbboard, default use getting action"
                cli_helper -o "-d|--get-current-dir" -d "Get current dir vars, get current stored dir"
                cli_helper -o "-c|--copy-file" -d "cp file to current folder"
                cli_helper -o "-cd|--copy-directory" -d "cp dir to current folder"
                cli_helper -o "-ca|--copy-all" -d "cp all file too current folder"
                cli_helper -o "-f|--fake-run" -d "Do fake run on -x"
                cli_helper -o "-x|--excute" -d "Excute command, replace %p with clip buffer"
                cli_helper -o "-h|--help" -d "Print help function "

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

    var_idx=$(find . -name "${var_bk_file}*" | sed "s/_/\n/g" | grep "I[0-9]\{2\}" | sed "s/I//g" | sort | tail -n 1 | sed "s/^0\+//g")
    var_idx=$(printf 'I%02d' "$(( ${var_idx} + 1 ))")

    var_bk_name="${var_bk_file}_${var_idx}_${var_date}"
    if [ "${var_description}" != "" ]
    then
        var_bk_name="${var_bk_name}_${var_description}"
    fi

    echo -e "Backup ${var_bk_file} to ${var_bk_name}"
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
function compressor()
{
    local cmd_prog="tar"
    local cmd_args=""
    cmd_args+=()

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -f|--file)
                cmd_args+=(-f $2)
                shift 1
                ;;
            -j|--bzip)
                if command -v pbzip2
                then
                    cmd_args+=(--use-compress-program=pbzip2)
                else
                    cmd_args+=(-j)
                fi
                ;;
            -z|--xzip)
                if command -v pigz
                then
                    cmd_args+=(--use-compress-program=pigz)
                else
                    cmd_args+=(-z)
                fi
                ;;
            -x|--extract)
                cmd_args+=(-x)
                ;;
            -c|--compress)
                cmd_args+=(-c)
                ;;
            -a|--auto|a)
                shift 1
                # local tmp_folder_name="$(dirname $(realpath ${1}) | sed 's|/.*/||g')"
                local tmp_arch_name="$(echo ${1} |sed 's/\..*//g' |sed 's|/||g')_$(tstamp).tbz2"
                compressor -j -c -f ${tmp_arch_name} $@
                echo "Compressed file: ${tmp_arch_name}"
                return 0
                ;;

            # -a|--append)
            #     cmd_args+="${2}"
            #     shift 1
            #     ;;
            -v|--verbose)
                cmd_args+=(-v)
                ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-f|--file" -d "file name for process"
                cli_helper -o "-j|--bzip2" -d "use bzip2 alg"
                cli_helper -o "-z|--xz" -d "use xz alg"
                cli_helper -o "-x|--extract" -d "extract file"
                cli_helper -o "-c|--compress" -d "compress file"
                cli_helper -o "-a|--auto" -d "auto compress file"
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                cmd_args+=($@)
                break
                ;;
        esac
        shift 1
    done
    echo ${cmd_prog} ${cmd_args[@]}
    eval ${cmd_prog} ${cmd_args[@]}
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
    local var_skey_prefix="sudo ydotool "
    local var_skey_args=""
    local var_cmd=""

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
    local var_promote="Key>"
    local var_input=""
    local var_previous=""
    local var_target_key=""

    local var_start=0
    local var_end=0
    local var_time=0

    printf "Please Type Any Key.\n"
    while IFS= read -s -r -n 1 var_input
    do
        # echo "->\"${var_input}\""
        var_end=$(date +%s%N)
        var_target_key=""
        case ${var_input} in
            '')
                # echo "Enter dected"
                var_target_key="ENTER"
                ;;
            ${uparrow})
                # echo "up dected"
                ;;
            $'\x16')
                # echo "Ctrl + v dected"
                var_target_key="ctrl+v"
                ;;
            $'\x18')
                # echo "Ctrl + x dected"
                var_target_key="ctrl+x"
                ;;
            $'\x01')
                # echo "Ctrl + a dected"
                var_target_key="ctrl+a"
                ;;
            $'\x14')
                # echo "Ctrl + t dected"
                var_target_key="ctrl+t"
                ;;
            $'\x17')
                # echo "Ctrl + w dected"
                var_target_key="ctrl+w"
                ;;
            $'\x0c')
                # echo "Ctrl + l dected"
                var_target_key="ctrl+l"
                ;;
            $'\x7f')
                # echo "backspace dected"
                var_target_key="backspace"
                ;;
            ' ')
                # echo "Space dected"
                var_target_key=" "
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
                    # echo "Enter Arror Up"
                    var_target_key="KEY_UP"
                    ;;
                '[B')
                    # echo "Enter Arror Down"
                    var_target_key="KEY_DOWN"
                    ;;
                '[C')
                    # echo "Enter Arror Right"
                    var_target_key="KEY_RIGHT"
                    ;;
                '[D')
                    # echo "Enter Arror Left"
                    var_target_key="KEY_LEFT"
                    ;;
                $'\x1b'$'\x1b')
                    # echo "esc dected"
                    var_target_key="esc"
                    ;;
            esac
        fi
        var_previous=${var_input}

        # printf "\r%s" ${var_input}
        if [ "${var_target_key}" = "" ] && ([ "${var_input}" = "[" ] || [ "${var_input}"  = $'\x1b' ])
        then
            var_start=${var_end}
            continue
        fi

        # printf "%s %s\n" ${var_promote} ${var_target_key}
        if [ "${var_target_key}" = "" ]
        then
            printf "%s %s\n" "${var_promote}" "${var_input}"
            var_skey_args="type"
            var_cmd="${var_skey_prefix} ${var_skey_args} \"${var_input}\""
        else
            printf "%s %s\n" "${var_promote}" "${var_target_key}"
            var_skey_args="key"
            var_cmd="${var_skey_prefix} ${var_skey_args} \"${var_target_key}\""
        fi
        # echo ${var_cmd}
        eval "${var_cmd}" 2> /dev/null
    done
    printf "\n"
}

function silence()
{
    local precmd=""
    local postcmd="> /dev/null"
    local cmd="$@"

    eval "${precmd} ${cmd} ${postcmd}"
}
