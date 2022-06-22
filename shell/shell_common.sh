########################################################
########################################################
#####                                              #####
#####    Shell Setup Functions                     #####
#####                                              #####
########################################################
########################################################
function epath()
{
    local flag_verbose=n
    if [[ $# == 0 ]]
    then
        echo ${PATH}
        return 0
    fi
    #echo "Export Path $1";
    # if grep -q $1 <<<$PATH;
    local target_path=$(realpath $1)
    if echo ${PATH} | grep -q ${target_path}
    then
        [ "${flag_verbose}" = "y" ] && echo "${target_path} has alread in your PATH";
        return 1
    else
        [ "${flag_verbose}" = "y" ] && echo -E "export PATH=${target_path}:"'$PATH;'
        export PATH=${target_path}:$PATH;
        return 0
    fi;

}
function shell_setup()
{
    if [ "${HS_CONFIG_CHANGE_DIR}" = "y" ]
    then
        set_working_path -g
    fi
}
function shell_status()
{
    # 1st ret value is 0
    # 2nd ret value is 1
    # echo "${pipestatus[1]} ${pipestatus[2]}"
     zsh_status=${pipestatus[@]} bash_status=(${PIPESTATUS[@]})
    # local shell_status=()
    local var_idx=0
    local flag_echo='n'

    # if [[ "$#" = "0" ]]
    # then
    #     echo "Default action"
    # fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -e|--echo)
                flag_echo='y'
                ;;
            -i|--index)
                var_idx=$2
                shift 1
                ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "shell_status" -cd "shell_status function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "shell_status [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-e|--echo" -d "echo out status"
                cli_helper -o "-i|--index" -d "select idx, 0 base index"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_idx=$1
                return -1
                ;;
        esac
        shift 1
    done
    # if [ $# = 1 ]
    # then
    #     var_idx=$1
    # fi

    # echo "${bash_status[@]}, ${zsh_status[@]}"
    # echo "idx ${var_idx}: ${bash_status[${var_idx}]}, ${zsh_status[$((${var_idx} + 1))]}"

    if [ "${HS_ENV_SHELL}" = "bash" ] || [ "${HS_ENV_SHELL}" = "sh" ]
    then
        if [ "${flag_echo}" = "y" ]
        then
            echo ${bash_status[${var_idx}]}
        fi
        return ${bash_status[${var_idx}]}
        # return ${bash_status[${var_idx}]}
        # echo "${PIPESTATUS[0]} ${PIPESTATUS[1]}"
        # shell_status=(${bash_status[@]})
    elif [ "${HS_ENV_SHELL}" = "zsh" ]
    then
        # return ${zsh_status[$((${var_idx} + 1))]}
        if [ "${flag_echo}" = "y" ]
        then
            echo ${zsh_status[$((${var_idx} + 1))]}
        fi
        return ${zsh_status[$((${var_idx} + 1))]}
        # echo "${pipestatus[1]} ${pipestatus[2]}"
        # shell_status=(${zsh_status[@]})
        # shell_status=${zsh_status}
    else
        echo "shell_status: Fail to get return value"
        return 1
    fi
    # if [ ${#shell_status[@]} = 1 ]
    # then
    #     echo "${shell_status[0]}"
    # elif [ ${#shell_status[@]} = 2 ]
    # then
    #     echo "${shell_status[0]},${shell_status[1]}"
    # elif [ ${#shell_status[@]} = 3 ]
    # then
    #     echo "${shell_status[0]},${shell_status[1]},${shell_status[2]},${shell_status[3]}"
    # elif [ ${#shell_status[@]} = 4 ]
    # then
    #     echo "${shell_status[0]},${shell_status[1]},${shell_status[2]},${shell_status[3]}"
    # fi
    # return ${shell_status[@]}
}
function item_promote()
{
    if [[ $# == 1 ]]
    then
        local content=$1
        if [ "${HS_ENV_SHELL}" = "bash" ] || [ "${HS_ENV_SHELL}" = "sh" ]
        then
            local color="cyan"
            local start_str='\033[00m['
            local end_str='\033[00m]'
        elif [ "${HS_ENV_SHELL}" = "zsh" ]
        then
            local color="white"
            local start_str='%F{'${color}'}[%f'
            local end_str='%F{'${color}'}]%f'
        fi
        # printf "%s%s%s" ${start_str} ${content} ${end_str}
        echo -e ${start_str}${content}${end_str}
        # echo -e "-[\033[33;5;11mError\033[38;5;15m\033[00m]"
    fi
}
function hs_config()
{
    if [ ! -d $(dirname "${HS_TMP_FILE_CONFIG}") ]
    then
        mkdir -p $(dirname "${HS_TMP_FILE_CONFIG}")
    fi
    # get and set hs_config
    # if [ "$#" = "3" ] && [ "$1" = "-s" ]
    if [ "$1" = "-s" ]
    then
        # echo "$*"
        local target_var=$2
        local content=$3
        if hs_config -e "${target_var}" > /dev/null
        then
            # echo ${target_var}
            sed -i "/${target_var}=.*/d" ${HS_TMP_FILE_CONFIG}
        fi
        printf "%s=%s\n" "${target_var}" "${content}" >> ${HS_TMP_FILE_CONFIG}

        # echo sed -i -e "/^\(${target_var//\//\\/}=\).*/{s//\1${content}/;:a;n;ba;q}" -e "$a ${target_var//\//\\/}=${content}" ${HS_TMP_FILE_CONFIG}

    elif [ "$#" = "2" ] && [ "$1" = "-g" ]
    then
        local target_var=$2
        if [ -f "${HS_TMP_FILE_CONFIG}" ]
        then
            # echo ${target_var}
            echo $(cat ${HS_TMP_FILE_CONFIG} | grep "${target_var}=" | cut -d "=" -f 2-)
        fi
    elif [ "$#" = "2" ] && [ "$1" = "-e" ]
    then
        local target_var=$2
        if [ -f "${HS_TMP_FILE_CONFIG}" ]
        then
            # echo ${target_var}
            if cat ${HS_TMP_FILE_CONFIG} | grep "${target_var}="
            then
                return 0
            else
                return 1
            fi
        else
            return 1
        fi
    else
        echo "Unknown Options"
        return 1
    fi
    return 0
}
function set_working_path()
{
    # writing file to fs will slow down the shell respond time
    # case $1 in
    #     -s|--set-current-path)
    #         # hs_config -s "${HS_VAR_CURRENT_DIR}" "$(pwd)"
    #         # if test -f ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR} &&  [ "${PWD}" != "$(cat ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR} | head -n 1)" ]
    #         # then
    #         #     rm ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR}
    #         #     echo ${PWD} > ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR}
    #         # else
    #         #     echo ${PWD} > ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR}
    #         # fi
    #         test -f ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR} && rm ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR}
    #         echo ${PWD} > ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR}
    #         ;;
    #     -g|--go-to-setting-path)
    #         # cd "$(hs_config -g "${HS_VAR_CURRENT_DIR}")"
    #         if test -f ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR}
    #         then
    #             cd $(cat ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR} | head -n 1)
    #         fi
    #         ;;
    #     -e|*)
    #         # echo $(hs_config -g "${HS_VAR_CURRENT_DIR}")
    #         if test -f ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR}
    #         then
    #             cat ${HS_PATH_TMP}/${HS_VAR_CURRENT_DIR} | head -n 1
    #         else
    #             echo ${PWD}
    #         fi
    #         ;;
    # esac
    # return 0

    case $1 in
        -s|--set-current-path)
            # hs_config -s "${HS_VAR_CURRENT_DIR}" $(realpath ${PWD})
            # hs_config -s "${HS_VAR_CURRENT_DIR}" "${PWD}"
            # time (hs_config -s "${HS_VAR_CURRENT_DIR}" "$(pwd)")
            hs_config -s "${HS_VAR_CURRENT_DIR}" "$(pwd)"
            # if [ -n "${HS_TMP_FILE_CONFIG}" ]
            # then
            #     echo `pwd` > ${HS_TMP_FILE_CONFIG}
            # else
            #     echo "[Set Current path fail]"
            #     return 1
            # fi
            ;;
        -g|--go-to-setting-path)
            cd "$(hs_config -g "${HS_VAR_CURRENT_DIR}")"
            # if [ -n "${HS_TMP_FILE_CONFIG}" ] && [ -f "${HS_TMP_FILE_CONFIG}" ] && [ -d "$(cat ${HS_TMP_FILE_CONFIG})" ]
            # then
            #     cd "$(cat $HS_TMP_FILE_CONFIG)"
            # else
            #     echo "Goto Current path fail $(cat ${HS_TMP_FILE_CONFIG})"
            #     return 1
            # fi
            ;;
        -e|*)
            echo $(hs_config -g "${HS_VAR_CURRENT_DIR}")
            ;;
    esac
}

function check_cmd_status()
{
    RETVAL=$1
    case $RETVAL in
        1)
            if [ "${HS_ENV_SHELL}" = "bash" ] || [ "${HS_ENV_SHELL}" = "sh" ]
            then
                echo -e "\033[33;5;11mError\033[38;5;15m"
            elif [ "${HS_ENV_SHELL}" = "zsh" ]
            then
                # echo "%B%F{yellow}Error%b%F{cyan}][%f"
                echo "%B%F{yellow}Error%b%f"
            fi
            return $RETVAL
            ;;
        0)
            return 0
            ;;
        *)
            return $RETVAL
            ;;
    esac
}
function parse_git_branch()
{
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
    # bash
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    # zsh
    # git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1%F{cyan}][%f/'
}
function export_sh_func()
{
    local target_shell=$1
    if [ "${HS_ENV_SHELL}" = "bash" ]
    then
        if [ -f "${target_shell}" ]
        then
            for each_cmd in $(cat ${target_shell} | grep "^function.*()$" | sed "s/^function//g" | sed "s/()$//g" )
            do
                # echo eval "export -f ${each_cmd}"
                eval "export -f ${each_cmd}"
            done
        else
            echo "${target_shell} not found"
            return 1
        fi
    else
        echo "Only work in bash"
    fi
}
