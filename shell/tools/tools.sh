#!/bin/bash
########################################################
########################################################
#####                                              #####
#####    For HS Tools Functions                    #####
#####                                              #####
########################################################
########################################################

########################################################
#####    Text Function                             #####
########################################################
function purify()
{
    local var_action='stdin'
    local var_input_file=''
    local var_rename_target=''
    local flag_trim=false
    local flag_verbose=false
    local flag_rename_all=false
    local flag_replace=false
    local flag_purify=true

    local var_trim_method="middle"
    local var_replace_src=""
    local var_replace_dst=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--stdin)
                var_action='stdin'
                ;;
            -f|--file)
                var_action='file'
                var_input_file="${2}"
                shift 1
                ;;
            -t|--trim)
                flag_trim=true
                if (( "$#" >= "2" ))
                then
                    if [ ${2} = "middle" ] || [ ${2} = "m" ]
                    then
                        var_trim_method="middle"
                        shift 1
                    elif [ ${2} = "front" ] || [ ${2} = "f" ]
                    then
                        var_trim_method="front"
                        shift 1
                    elif [ ${2} = "rear" ] || [ ${2} = "r" ]
                    then
                        var_trim_method="rear"
                        shift 1
                    fi
                fi
                ;;
            -r|--replace)
                flag_replace=true
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        # not start with -
                        var_replace_src="${2}"
                        var_replace_dst=""
                        shift 1
                    fi
                elif (( "$#" >= "3" ))
                then
                    if ! [[ $2 =~ \-.* ]] && ! [[ $3 =~ \-.* ]]
                    then
                        # not start with -
                        var_replace_src="${2}"
                        var_replace_dst="${3}"
                        shift 2
                    elif ! [[ $2 =~ \-.* ]]
                    then
                        # not start with -
                        var_replace_src="${2}"
                        var_replace_dst=""
                        shift 1
                    fi
                fi
                ;;
            -a|--purify-all)
                var_action="rename"
                # var_action="rename-all"
                flag_rename_all=true
                ;;
            -n|--purify-name)
                var_rename_target="$2"
                var_action="rename"
                shift 1
                ;;
            -v|--verbose)
                flag_verbose=true
                ;;
            -h|--help)
                cli_helper -c "purify" -cd "purify function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "purify [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--purify-all" -d "rename all file found on current folder."
                cli_helper -o "-n|--purify-name" -d "rename file & remove special symbol"
                cli_helper -o "-t|--trim" -d "trim file name if too long"
                cli_helper -o "-r|--replace" -d "Replease src to dst, exp, -r src dst"
                cli_helper -o "-f|--file" -d "get stream from file"
                cli_helper -o "-s|--stdin" -d "get stream from stdin, default"
                cli_helper -o "-v|--verbose" -d "Print verbose info"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo 'Unknown options: $@'
                break
                ;;
        esac
        shift 1
    done

    # echo "Purify on ${var_action}"
    if [ ${var_action} = "stdin" ]
    then
        # get things from std stream
        sed -r "s/\x1B\[[0-9]{0,3}(;[0-9]{1,3}){0,2}[a-zA-Z]//g" | sed -r "s/\r//g"
    elif [ ${var_action} = "file" ]
    then
        local tmp_output_file="purify_$(basename ${var_input_file})"
        if test -f "${tmp_output_file}"
        then
            echo "File already exist. ${tmp_output_file}"
            return 0
        else
            cat ${var_input_file} | sed -r "s/\x1B\[[0-9]{0,3}(;[0-9]{1,3}){0,2}[a-zA-Z]//g" | sed -r "s/\r//g" > ${tmp_output_file}
        fi
    elif [ "${var_action}" = "rename" ]
    then

        # local tmp_cmd_list=""
        file_list=()
        if [ -e "${var_rename_target}" ]
        then
            file_list=($(printf "%s\n" ${var_rename_target}))
            # tmp_cmd_list="printf '%s\n' '${var_rename_target}'"
        fi

        if [ "${flag_rename_all}" = true ]
        then
            # file_list=($(printf "%s\n" *))
            # tmp_cmd_list="printf '%s\n' *"
            for tmp_file in "$PWD"/*; do
                # purify -n "${tmp_file}"
                file_list+=("${tmp_file##*/}")
            done
        fi

        IFS=$'\n' file_list=(${file_list[@]})

        # for each_file in $(eval ${tmp_cmd_list})
        for each_file in ${file_list[@]}
        do
            [ ${flag_verbose} = true ] && echo echo "Each File: '${each_file}'"
            if ! test -e "${each_file}"
            then
                continue
            fi

            local tmp_taget_name=$(echo "${each_file}"| rev | cut -d '/' -f 1| rev)

            # escap
            if [ ${flag_purify} = true ]
            then
                tmp_taget_name=$(echo "${tmp_taget_name}" | sed "s/ /_/g")
                tmp_taget_name=$(echo "${tmp_taget_name}" | sed -r "s/[^0-9a-zA-Z._-]/_/g")
                tmp_taget_name=$(echo "${tmp_taget_name}" | sed -r "s/\[_\]\+/_/g")
                tmp_taget_name=$(echo "${tmp_taget_name}" | sed -r "s/^_//g")
                tmp_taget_name=$(echo "${tmp_taget_name}" | sed -r "s/_$//g")
                tmp_taget_name=$(echo "${tmp_taget_name}" | tr -s '_')
            fi

            if [ ${flag_replace} = true ] && echo ${tmp_taget_name} |grep "${var_replace_src}" 2>&1 > /dev/null
            then
                [ ${flag_verbose} = true ] && echo "Replace '${var_replace_src}' => '${var_replace_dst}'"
                tmp_taget_name=$(echo  ${tmp_taget_name} | sed "s/${var_replace_src}/${var_replace_dst}/g")
            fi

            if [ ${flag_trim} = true ]
            then
                [ ${flag_verbose} = true ] && echo "Trim: ${flag_trim}"

                if [[ ${#tmp_taget_name} -gt 72 ]]
                then
                    if [ ${var_trim_method} = "middle" ]
                    then
                        tmp_taget_name=${tmp_taget_name:0:32}_xx_${tmp_taget_name:$((${#tmp_taget_name} - 32)):32}
                    elif [ ${var_trim_method} = "front" ]
                    then
                        tmp_taget_name=xx_${tmp_taget_name:$((${#tmp_taget_name} - 64)):64}
                    elif [ ${var_trim_method} = "rear" ]
                    then
                        tmp_taget_name=${tmp_taget_name:0:64}_xx$(echo ${tmp_taget_name:$((${#tmp_taget_name} - 5)):5} | sed 's/.*\./\./g')
                    else
                        tmp_taget_name=${tmp_taget_name:0:32}_xx_${tmp_taget_name:$((${#tmp_taget_name} - 32)):32}
                    fi
                fi
            fi
            if [ ${tmp_taget_name} = ${each_file} ]
            then
                [ ${flag_verbose} = true ] && echo "Ignore file: \"${each_file}\""
                continue
            fi

            if test -e "${tmp_taget_name}"
            then
                echo "File(${tmp_taget_name}) already exist, change name."
                tmp_taget_name=dup_${tmp_taget_name}
                if test -e "${tmp_taget_name}"
                then
                    echo "File already exist, change rename fail."
                    continue
                fi
            fi

            echo "mv ${each_file} ${tmp_taget_name}" >> rename.list
            mv "${each_file}" "${tmp_taget_name}"
            echo "Find new file: \"${each_file}\" -> \"${tmp_taget_name}\""
        done
    fi
}

########################################################
#####    File Function                             #####
########################################################
function crypt()
{
    local cmd_args=("openssl enc")
    local var_src_file=""
    local var_out_file=""

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -e|--encrypt)
                cmd_args+=("-aes-256-cbc")
                # cmd_args+=(" -iter 16")
                cmd_args+=(" -md md5")
                ;;
            -d|--decrypt)
                cmd_args+=("-d -aes-256-cbc")
                # cmd_args+=(" -iter 16")
                cmd_args+=(" -md md5")
                ;;
            -k|--key)
                cmd_args+=("-k ${2}")
                shift 1
                ;;
            -i|--input-file)
                cmd_args+=("-in")
                cmd_args+=("${2}")
                var_src_file=${2}
                shift 1
                ;;
            -o|--output-file)
                cmd_args+=("-out")
                cmd_args+=("${2}")
                var_out_file=${2}
                shift 1
                ;;
            -a|--args)
                cmd_args+=("${2}")
                shift 1
                ;;
            -h|--help)
                cli_helper -c "crypt" -cd "crypt function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "crypt [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-e|--encrypt" -d "DO encrypt "
                cli_helper -o "-d|--decrypt" -d "DO decrypt "
                cli_helper -o "-k|--key" -d "Specify password "
                cli_helper -o "-i|--input-file" -d "Specify input file "
                cli_helper -o "-o|--output-file" -d "Specify output file "
                cli_helper -o "-a|--args" -d "add other args"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    if [ -z "${var_out_file}" ]
    then
        cmd_args+=("-out")
        cmd_args+=("${var_src_file}.aes")
    fi

    echo "${cmd_args[@]}"
    eval "${cmd_args[@]}"
    # openssl enc -aes-256-cbc -in un_encrypted.data -out encrypted.data
    # openssl enc -d -aes-256-cbc -in encrypted.data -out un_encrypted.data
}
function waitsync()
{
    # waitsync [target_file]
    # wait for target file exist
    local target=$1
    local interval=1
    while [ ! -e "${target}" ];
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
    local var_clipidx="0"
    local var_clipboard="${HS_VAR_CLIPBOARD}_${var_clipidx}"
    local var_max_idx=5

    if [ "$#" = 0 ]
    then
        eval "clip -l"
        return 0
    fi
    while true
    do
        if [ "$#" = 0 ]
        then
            # echo no args
            break
        fi
        case $1 in
            -l|--list|ls)
                # echo "Clipboard buffer def : $(clip -g )"
                for each_idx in $(seq 0 ${var_max_idx})
                do
                    echo "Clipboard buffer ${each_idx}   : $(clip -b ${each_idx} -g )"
                done
                # echo "Clipboard buffer 0   : $(clip -b 0 -g )"
                # echo "Clipboard buffer 1   : $(clip -b 1 -g )"
                # echo "Clipboard buffer 2   : $(clip -b 2 -g )"
                # echo "Clipboard buffer 3   : $(clip -b 3 -g )"
                # echo "Clipboard buffer 4   : $(clip -b 4 -g )"
                # echo "Clipboard buffer 5   : $(clip -b 5 -g )"
                ;;
            -b|--clip-buffer)
                if (( $# > 1 )) && (( $2 < 6 )) && (( $2 > -1 ))
                then
                    var_clipidx=${2}
                    var_clipboard="${HS_VAR_CLIPBOARD}_${var_clipidx}"
                    shift 1
                # elif (( $# > 1 )) && (( $2 < 6 )) && (( $2 > -1 ))
                # then
                #     echo "Clip number should be in 0~5"
                #     return 1
                fi
                ;;
            -1)
                var_clipidx=1
                var_clipboard="${HS_VAR_CLIPBOARD}_${var_clipidx}"
                ;;
            -2)
                var_clipidx=2
                var_clipboard="${HS_VAR_CLIPBOARD}_${var_clipidx}"
                ;;
            -3)
                var_clipidx=3
                var_clipboard="${HS_VAR_CLIPBOARD}_${var_clipidx}"
                ;;
            -4)
                var_clipidx=4
                var_clipboard="${HS_VAR_CLIPBOARD}_${var_clipidx}"
                ;;
            -5)
                var_clipidx=5
                var_clipboard="${HS_VAR_CLIPBOARD}_${var_clipidx}"
                ;;
            -s|--set-clip)
                shift 1
                if [[ $# = 0 ]] && [ ! -t 0 ]
                then
                    echo "get args from pipe"
                    local var_from_pipe="$(xargs echo)"
                    # echo "FD 0 has opened."
                    hs_varconfig -s "${var_clipboard}" "${var_from_pipe}"
                elif [[ ${#} = 1 ]] && [ -e ${1} ]
                then
                    hs_varconfig -s "${var_clipboard}" "$(realpath ${1})"
                elif [[ ${#} = 1 ]]
                then
                    hs_varconfig -s "${var_clipboard}" "${@}"
                # elif [[ ${#} = 0 ]]
                # then
                #     hs_varconfig -s "${var_clipboard}" "$(realpath .)"
                else
                    echo "No args specify"
                    return -1
                    # hs_varconfig -s "${var_clipboard}" "${@}"
                fi
                break
                ;;
            -p|--set-from-pipe)
                local var_from_pipe="$(xargs echo)"
                # echo "FD 0 has opened."
                hs_varconfig -s "${var_clipboard}" "${var_from_pipe}"
                ;;
            -g|--get-clip)
                hs_varconfig -g "${var_clipboard}"
                ;;

            ## Addictional options
            # -d|--get-current-dir)
            #     # get current dir
            #     hs_varconfig -g "${HS_VAR_CURRENT_DIR}"
            #     ;;
            -f|--fake-run)
                flag_fake_run=true
                ;;
            -x|--excute)
                shift 1
                local excute_cmd=$(printf "$(echo $@ | sed 's/%p/%s/g' )" "$(clip -b ${var_clipidx} -g)")
                if echo $@ | grep "%p" > /dev/null
                then
                    excute_cmd=$(printf "$(echo $@ | sed 's/%p/%s/g' )" "$(clip -b ${var_clipidx} -g)")
                else
                    excute_cmd=$(printf "$(echo $@ | sed 's/$/ %s/g' )" "$(clip -b ${var_clipidx} -g)")
                fi
                echo ${excute_cmd} |mark -s yellow ${excute_cmd}
                if ! ${flag_fake_run}
                then
                    printf "Excute Commands?(Y/n)"
                    read tmp_ans
                    test "${tmp_ans}" != "n" && eval ${excute_cmd}
                fi

                break
                ;;
            -ex|--enhance-excute)
                shift 1
                # local excute_cmd=$(printf "$(echo $@ | sed 's/%p/%s/g' )" "$(clip -b ${var_clipidx} -g)")

                excute_cmd=$(echo ${@} | sed 's/%p/$(clip -b ${var_clipidx} -g )/g' )
                # echo ${excute_cmd}

                excute_cmd=$(echo ${excute_cmd} | sed 's/%0/$(clip -b 0 -g )/g' \
                | sed 's/%1/$(clip -b 1 -g )/g' \
                | sed 's/%2/$(clip -b 2 -g )/g' \
                | sed 's/%3/$(clip -b 3 -g )/g' \
                | sed 's/%4/$(clip -b 4 -g )/g' \
                | sed 's/%5/$(clip -b 5 -g )/g'
                )
                excute_cmd=$( eval echo ${excute_cmd})
                # echo ${excute_cmd}

                echo ${excute_cmd} |mark -s yellow ${excute_cmd}
                if ! ${flag_fake_run}
                then
                    printf "Excute Commands?(Y/n)"
                    read tmp_ans
                    test "${tmp_ans}" != "n" && eval ${excute_cmd}
                fi

                break
                ;;
            # commands
            -cd)
                local clip_buff="$(clip -b ${var_clipidx} -g )"
                if test -d ${clip_buff}
                then
                    excute_cmd="cd ${clip_buff}"
                elif test -f ${clip_buff}
                then
                    excute_cmd="cd $(dirname ${clip_buff})"
                else
                    echo "Path not found."
                    return 1
                fi
                ${excute_cmd}
                ;;
            -ln|--link)
                clip -b ${var_clipidx} -x 'ln -s $(realpath %p) ./'
                ;;
            -c|-cf|--copy-file)
                clip -b ${var_clipidx} -x cp -r "%p" .
                ;;
            -ca|--copy-all)
                clip -b ${var_clipidx} -x cp -r "%p/*" .
                ;;
            -h|--help)
                cli_helper -c "clip" -cd "clip function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "clip [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-b|--clip-buffer" -d "Set Clipbboard buffer from 0 to 5, default use 0"
                cli_helper -o "-l|--list" -d "List Clipbboard buffer from 0 to 5"
                cli_helper -o "-s|--set-clip" -d "Set Clipbboard, default use pwd for setting var"
                cli_helper -o "-p|--set-from-pipe" -d "Set Clipbboard, default use pwd for setting var"
                cli_helper -o "-g|--get-clip" -d "Get Clipbboard, default use getting action"
                # cli_helper -o "-d|--get-current-dir" -d "Get current dir vars, get current stored dir"
                cli_helper -o "-c|-cf|--copy-file" -d "cp file to current folder"
                cli_helper -o "-ca|--copy-all" -d "cp all file too current folder"
                cli_helper -o "-cd" -d "Change to dir"
                cli_helper -o "-ln|--link" -d "Link file to the current folder"
                cli_helper -o "-f|--fake-run" -d "Do fake run on -x"
                cli_helper -o "-x|--excute" -d "Excute command, replace %p with clip buffer."
                cli_helper -o "-ex|--enhance-excute" -d "Excute command, replace %0,%1...%5 with clip buffer."
                cli_helper -o "-h|--help" -d "Print help function "

                return 0
                ;;
            *)
                excute_cmd=$(echo "${@}" $(clip -b ${var_clipidx} -g ))
                # echo ${excute_cmd}

                echo ${excute_cmd} |mark -s yellow ${excute_cmd}
                if ! ${flag_fake_run}
                then
                    printf "Excute Commands?(Y/n)"
                    read tmp_ans
                    test "${tmp_ans}" != "n" && eval ${excute_cmd}
                fi

                break
                ;;
        esac
        shift 1
    done
}
function bkfile()
{
    local flag_auto_idx="y"
    local flag_copy_mode="n"
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
            -c|--copy)
                flag_copy_mode="y"
                ;;
            -h|--help)
                echo "bkfile [Options] [file name]"
                printlc -cp false -d "->" "-n|--name" "append description on the file name"
                printlc -cp false -d "->" "-f|--backup-file" "specify file name"
                printlc -cp false -d "->" "-c|--copy" "copy mode, leave original file"
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

    if [ "${flag_copy_mode}" = "y" ]
    then
        cp -r "${var_bk_file}" "${var_bk_name}"
    else
        mv "${var_bk_file}" "${var_bk_name}"
    fi
}
function xsh()
{
    local var_args=('')
    local var_host=""
    local flag_renew=false

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -R|--renew|renew)
                flag_renew=true
                var_host=$2
                shift 1
                ;;
            -h|--help)
                cli_helper -c "xsh" -cd "xsh(real link) function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "xsh [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-R|--renew|renew" -d "Renew known host, -R [host-name]"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_args+=($@)
                break
                # echo "Wrong args, %@"
                # return -1
                ;;
        esac
        shift 1
    done

    if [ ${flag_renew} = true ]
    then
        ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "${var_host}"
    fi
}
function rln()
{
    local var_args=('')
    local flag_mode="soft"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -H|--hard)
                flag_mode="hard"
                ;;
            -s|--soft)
                flag_mode="soft"
                ;;
            -h|--help)
                cli_helper -c "rln" -cd "rln(real link) function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "rln [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-H|--hard" -d "hard link, default behavior"
                cli_helper -o "-s|--soft" -d "soft link"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_args+=($1)
                break
                # echo "Wrong args, %@"
                # return -1
                ;;
        esac
        shift 1
    done
    if [ "${flag_mode}" = "soft" ]
    then
        var_args=('-s')
    # elif [ "${flag_mode}" = "hard" ]
    # then
    #     var_args=('-h')
    fi

    # echo "Do: ln ${var_args[@]} $(echo $1) $2"
    echo "ln ${var_args[@]} $(realpath $1) $2"
    ln ${var_args[@]} $(realpath $1) $2
}
function hstemp()
{
    local var_temp_file=""
    local var_target_file="./"
    local var_cmd=""

    # default file.
    var_temp_file="${HS_PATH_LIB}/tools/template/template_lite.sh"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -l|--lite)
                var_temp_file="${HS_PATH_LIB}/tools/template/template_lite.sh"
                ;;
            -w|--work)
                var_temp_file="${HS_PATH_LIB}/tools/template/template_work.sh"
                ;;
            -f|--full)
                var_temp_file="${HS_PATH_LIB}/tools/template/template.sh"
                ;;
            -t|--target)
                if (( "$#" >= "2" ))
                then
                    if ! [[ $2 =~ \-.* ]]
                    then
                        # not start with -
                        var_target_file="$2"
                        shift 1
                    fi
                fi
                ;;
            -h|--help)
                cli_helper -c "hstemp" -cd "hstemp function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "hstemp [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-l|--lite" -d "Copy template lite file"
                cli_helper -o "-f|--full" -d "Copy template full file, default copy this one."
                cli_helper -o "-t|--target" -d "Copy template file to target folder/name, default copy to the current folder."
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break;
                ;;
        esac
        shift 1
    done

    var_cmd=("cp" "${var_temp_file}" "${var_target_file}")
    erun --eval ${var_cmd[@]}
}

function xfm()
{
    ${HS_PATH_LIB}/tools/filemanager/filemanager.sh $@
    local tmp_path=$(${HS_PATH_LIB}/tools/filemanager/filemanager.sh -l flush)
    # if ${HS_PATH_LIB}/tools/filemanager/filemanager.sh -l 2> /dev/null
    # then
    if test -d "${tmp_path}"
    then
        echo goto path:${tmp_path}
        cd "${tmp_path}"
    fi
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
function filesync()
{
    local var_excute_cmd=("rsync")
    local var_exclude_list=("")

    local flag_fake="n"

    local flag_ssh="n"
    local var_src_host=""
    local var_dst_host=""

    local var_src_path=""
    local var_dst_path=""

    # Pre set
    var_exclude_list+=("--exclude='*.swp'")
    var_exclude_list+=("--exclude='.git*'")
    var_exclude_list+=("--exclude='.git'")
    var_exclude_list+=("--exclude='.repo'")

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--source)
                var_src_path="${2}"
                shift 1
                ;;
            -d|--destination)
                var_dst_path="${2}"
                shift 1
                ;;
            -sh|--source-host)
                flag_ssh="y"
                var_src_host="${2}"
                shift 1
                ;;
            -dh|--destination-host)
                flag_ssh="y"
                var_dst_host="${2}"
                shift 1
                ;;
            -e|--exclude)
                var_exclude_list+=("--exclude='${2}'")
                shift 1
                ;;
            -f|--fake)
                flag_fake="y"
                ;;
            -h|--help)
                cli_helper -c "filesync" -cd "filesync function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "filesync [Options] [Value]"

                cli_helper -t "Options"
                # cli_helper -o "-a|--append" -d "append file extension on search"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-s|--source" -d "Source path"
                cli_helper -o "-d|--destination" -d "Destination path"
                cli_helper -o "-sh|--source-host" -d "Source host, imply ssh connection"
                cli_helper -o "-dh|--destination-host" -d "Destination host, imply ssh connection"
                cli_helper -o "-e|--exclude" -d "Exclude file"
                cli_helper -o "-f|--fake" -d "Fake run, print command"
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

    ## Pre check
    if test -z ${var_src_path}
    then
        echo "Source path not found"
        return -1
    fi
    if test -z ${var_dst_path}
    then
        echo "Destination path not found"
        return -1
    fi

    # commands prepare
    ## Rsync args
    # -v : verbose
    # -r : copies data recursively (but don’t preserve timestamps and permission while transferring data.
    # -a : archive mode, which allows copying files recursively and it also preserves symbolic links, file permissions, user & group ownerships, and timestamps.
    # -z : compress file data.
    # -h : human-readable, output numbers in a human-readable format.
    # --whole-file, -W  copy files whole (w/o delta-xfer algorithm)

    # rsync -avhW --no-compress --exclude='*.git*' --exclude='*.repo*' --progress --omit-dir-times ${var_src_path}/* ${var_dst_path}
    var_excute_cmd+=("-avhW" "--progress" "--omit-dir-times" )
    # var_excute_cmd+=("--no-compress")
    var_excute_cmd+=("--compress")
    # NOTE. Not every version support compress choice
    # var_excute_cmd+=("--compress-choice=lz4")

    if [ "${flag_ssh}" = 'y' ]
    then
        var_excute_cmd+=("-e ssh")
    fi

    var_excute_cmd+=("${var_exclude_list[@]}")

    if test -n "${var_src_host}"
    then
        var_excute_cmd+=("${var_src_host}:${var_src_path}/*")
    else
        var_excute_cmd+=("${var_src_path}/*")
    fi

    if test -n "${var_dst_host}"
    then
        var_excute_cmd+=("${var_dst_host}:${var_dst_path}")
    else
        var_excute_cmd+=("${var_dst_path}")
    fi

    ## do sync
    # rsync -avhW --no-compress --progress ${*}
    # rsync -avhW --no-compress --progress ${var_src_path}/* ${var_dst_path}
    # rsync -av -e ssh --exclude='*.git*' --exclude='*.swp*' ${local_path}/shellscripts/* ${remote_host}:${tools_path}/shellscripts/ &

    # rsync -avhW --no-compress --exclude='*.git*' --exclude='*.repo*' --progress --omit-dir-times ${var_src_path}/* ${var_dst_path}
    if [ "${flag_fake}" = 'y' ]
    then
        echo ${var_excute_cmd[@]}
        return $?
    else
        echo ${var_excute_cmd[@]}
        eval ${var_excute_cmd[@]}
        return $?
    fi
}
function eftp()
{
    local ftp_server=""
    local ftp_user="$(whoami)"
    local ftp_pass=""
    local ftp_prefix="./"
    local ftp_action=""
    local ftp_cmd=""

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--server)
                ftp_server=${2}
                shift 1
                ;;
            -u|--user)
                ftp_user=${2}
                shift 1
                ;;
            -p|--pass)
                ftp_pass=${2}
                shift 1
                ;;
            -f|--folder)
                ftp_prefix=${2}
                shift 1
                ;;
            put)
                ftp_action="put"
                ;;
            pull)
                ftp_action="pull"
                ;;
            # -f|--file)
            #     cmd_args+=("${2}")
            #     shift 1
            #     ;;
            -v|--verbose)
                flag_verbose="y"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-a|--append" -d "append file extension on search"
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                ftp_cmd="$@"
                break
                ;;
        esac
        shift 1
    done
    # echo "Action ${ftp_action}"
    # echo "Cmd: ${ftp_cmd}"

    if [ "${ftp_action}" = "put" ]
    then
        echo "FTP put ${ftp_cmd}"
        ftp -n <<EOF
open ${ftp_server}
user ${ftp_user} ${ftp_pass}
cd ${ftp_prefix}
put ${ftp_cmd}
ls
EOF
    elif [ "${ftp_action}" = "pull" ]
    then
        echo "FTP pull ${ftp_cmd}"
        ftp -n <<EOF
open ${ftp_server}
user ${ftp_user} ${ftp_pass}
cd ${ftp_prefix}
pull ${ftp_cmd}
ls
EOF
    else
        echo "FTP ${ftp_cmd}"
        ftp -n <<EOF
open ${ftp_server}
user ${ftp_user} ${ftp_pass}
cd ${ftp_prefix}
${ftp_cmd}
ls
EOF
    fi

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
    local var_archive_name=""
    local var_ext_name="tar"

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            # -f|--file)
            #     cmd_args+=(-f $2)
            #     shift 1
            #     ;;
            -n|--name)
                # cmd_args+=(-f $2)
                var_archive_name=$2
                shift 1
                ;;
            -j|--bzip)
                var_ext_name="tbz2"
                if command -v pbzip2
                then
                    cmd_args+=(--use-compress-program=pbzip2)
                else
                    cmd_args+=(-j)
                fi
                ;;
            -z|--xzip)
                var_ext_name="tgz"
                if command -v pigz
                then
                    cmd_args+=("--use-compress-program='pigz --best'")
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
                local tmp_archive_name=""
                if [ -z ${var_archive_name} ]
                then
                    tmp_archive_name="$(echo ${1} |sed 's/\..*//g' |sed 's|/||g' |sed 's| |_|g')_$(tstamp)"
                else
                    tmp_archive_name="$(echo ${var_archive_name} |sed 's/\..*//g' |sed 's|/||g' |sed 's| |_|g')_$(tstamp)"
                fi
                compressor -j -c -n "${tmp_archive_name}" $@
                # echo "Compressed file: ${tmp_archive_name}"
                return 0
                ;;

            # -a|--append)
                #     cmd_args+=("${2}")
            #     shift 1
            #     ;;
            -v|--verbose)
                cmd_args+=(-v)
                ;;
            -h|--help)
                cli_helper -c "compressor" -cd "compressor function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "compressor [Options] [Value]"
                cli_helper -t "Options"
                # cli_helper -o "-f|--file" -d "output file name"
                cli_helper -o "-n|--name" -d "output file name"
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

    if [ "${var_archive_name}" ]
    then
        cmd_args+=(-f "${var_archive_name}.${var_ext_name}")
    else
        tmp_archive_name="compressed_$(tstamp).${var_ext_name}"
        cmd_args+=(-f ${tmp_archive_name})
    fi
    echo ${cmd_prog} ${cmd_args[@]}
    eval ${cmd_prog} ${cmd_args[@]}
    echo "Compressed file is ${var_archive_name}"

    # Backup run with progress bar
    # tar cf - /folder-with-big-files -P | pv -s $(du -sb /folder-with-big-files | awk '{print $1}') | gzip > big-files.tar.gz
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
    while [[ "$#" != 0 ]]
    do
        case $1 in
            # -a|--append)
            #     cmd_args+=("${2}")
            #     shift 1
            #     ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "tstamp" -cd "tstamp function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "tstamp [Options] [Value]"
                cli_helper -d "Default use 'date +%Y%m%d_%H%M%S'"
                cli_helper -t "Options"
                # cli_helper -o "-a|--append" -d "append file extension on search"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                ;;
        esac
        shift 1
    done
    date +%Y%m%d_%H%M%S
}
function synctime()
{
    local target_host=''
    local target_user=''
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -t|--taget-host)
                target_host="${2}"
                shift 1
                ;;
            -u|--user)
                target_host="${2}"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "synctime" -cd "synctime for remote host"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-t|--taget-host" -d "Specify host name"
                cli_helper -o "-u|--user" -d "Specify user name"
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

    if test -z ${target_host}
    then
        echo 'Please enter host name'
        synctime -h
        return 0
    fi

    if test -z ${target_user}
    then
        ssh ${target_host} "sudo date $(date +%m%d%H%M%G.%S)"
    else
        ssh ${target_user}@${target_host} "sudo date $(date +%m%d%H%M%G.%S)"
    fi

}
function fakeshell()
{
    local frontcmd=""
    local rearcmd=""
    local cmd=""
    echo "Fake shell"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -f|--front)
                frontcmd="${2}"
                shift 1
                ;;
            -r|--rear)
                rearcmd="${2}"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-f|--front" -d "Add comand before target cmd"
                cli_helper -o "-r|--rear" -d "Add comand after of target cmd"
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

    while printf "FShell:${PWD}>" && read cmd
    do
        eval "${frontcmd} ${cmd} ${rearcmd}"
    done
}
function doloop()
{
    local var_list_cmd=""
    local var_cmd=""
    local var_interval="1"
    local var_terminate_condiction='default'
    local flag_clean_on_start='y'

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--cmd)
                var_cmd="${2}"
                shift 1
                ;;
            -l|--list)
                var_list_cmd="${2}"
                shift 1
                ;;
            -n|--number)
                var_list_cmd="seq 0 ${2}"
                shift 1
                ;;
            -i|--interval)
                var_interval="${2}"
                shift 1
                ;;
            -t|--terminate)
                var_terminate_condiction="${2}"
                shift 1
                ;;
            -nc|--no-clear)
                flag_clean_on_start="n"
                ;;
            -e|--extension)
                var_list_cmd="ls *.${2}"
                ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "doloop" -cd "doloop function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "doloop [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-c|--cmd" -d "do command with %p do replace by list item"
                cli_helper -o "-l|--list" -d "generate list command"
                cli_helper -o "-n|--number" -d "generate number seq command(Start from 0), accept one number input"
                cli_helper -o "-i|--interval" -d "Specify running interval, default is 0.5 seconds"
                cli_helper -o "-t|--terminate" -d "Specify terminate condiction, default/fail/success"
                cli_helper -o "-nc|--no-clear" -d "No clear screen in each start"
                cli_helper -o "-h|--help" -d "Print help function "
                cli_helper -t "Buildin List"
                cli_helper -o "-e|--extension" -d "generate list with provided file exetension."
                return 0
                ;;
            *)
                if [ -z "${var_cmd}" ]
                then
                    var_cmd="${@}"
                fi
                break
                ;;
        esac
        shift 1
    done
    if [ -z "${var_list_cmd}" ]
    then
        var_list_cmd="seq 0 86400"
        flag_fail_on_terminate='y'
    fi

    if [ -z "${var_cmd}" ] && [ -z "${var_list_cmd}" ]
    then
        echo "Not command found. cmd:${var_cmd}, list:${var_list_cmd}"
        return 1
    fi

    local var_idx=0
    for each_input in $(eval ${var_list_cmd})
    do
        # local tmp_cmd=$(printf "$(echo ${var_cmd} | sed 's/%p/%s/g' )" "${each_input}")
        local tmp_cmd=$(echo ${var_cmd} | sed "s|%p|${each_input}|g" )
        # local tmp_cmd=$(printf $(echo ${var_cmd} | sed "s/%p/${each_input}/g" ))
        local tmp_buf=""

        tmp_buf+="[${var_idx}@$(tstamp)]:\"${each_input}\":\"${tmp_cmd}\"\n"
        tmp_buf+="===========================================\n"
        # bash -c "${var_cmd} ${each_input}"
        tmp_buf+=$(eval ${tmp_cmd} 2>&1)
        result=$?
        tmp_buf+="\n"
        tmp_buf+="Return Value: ${result}\n"
        tmp_buf+="===========================================\n"

        if [ "${flag_clean_on_start}" = "y" ]
        then
            clear
        fi
        echo -e "${tmp_buf[@]}"

        if [ "${var_terminate_condiction}" = "fail" ] && [ "${result}" != "0" ]
        then
            echo "Command fail at \"${each_input}\":\"${tmp_cmd}\""
            return ${result}
        elif [ "${var_terminate_condiction}" = "success" ] && [ "${result}" = "0" ]
        then
            echo "Command success at \"${each_input}\":\"${tmp_cmd}\""
            return ${result}
        fi
        sleep ${var_interval}
    done
}
function read_key()
{
    local var_count=1
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--cont)
                var_count=$2
                shift 1
                ;;
            -h|--help)
                cli_helper -c "read_key" -cd "read_key function, please use it on BASH"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "read_key [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-c|--count" -d "count for recieve char "
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
    # /usr/include/linux/input-event-codes.h
    read -n ${var_count} var_input
    # printf ${var_input} | xxd | cut -d " " -f 2-7
    printf "\nvar: \$\'\\\x%s\'\n" $(printf ${var_input} | xxd | cut -d " " -f 2-7)
}
function xtools()
{

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -ds|--disable-sleep)
                echo "Set xorg screen saver off"
                xset s off
                xset -dpms
                xset s noblank
                ;;
            -v|--verbose)
                flag_verbose="y"
                shift 1
                ;;
            -h|--help)
                cli_helper -c "xtools" -cd "xtools function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "xtools [Options] [Value]"
                cli_helper -t "Options"
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
