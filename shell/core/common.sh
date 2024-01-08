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
        echo "PATH=${PATH}"
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
function teval()
{
    local exc_cmd="eval"
    local exc_args="$@"
    local max_timeout=500

    local start_time=$(date +%s%N)
    ${exc_cmd} "${exc_args}"
    local end_time=$(date +%s%N)

    # echo "$start_time, $end_time"
    local diff_time=$(( (${end_time} - ${start_time})/1000000 ))

    printf "[${diff_time}] ${exc_cmd} ${exc_args}\n"
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
    local content=""
    local color=""
    local start_str=""
    local end_str=""

    case $1 in
        -t)
            shift 1
            content="$(eval teval $@ | sed 's/\n//g')"
            ;;
        -c|--cmd)
            shift 1

            # this is the patch for control shell function
            if [ "${HS_CONFIG_CHANGE_DIR}" = "n" ] && [ "${1}" = "set_working_path" ]
            then
                return 0
            elif [ "${HS_CONFIG_SHELL_GIT_PARSE}" = "n" ] && [ "${1}" = "parse_git_branch" ]
            then
                return 0
            fi

            content="$(eval $@)"
            ;;
        *)
            content="$@"
            ;;
    esac

    if [ "${HS_ENV_SHELL}" = "bash" ] || [ "${HS_ENV_SHELL}" = "sh" ]
    then
        color="cyan"
        start_str='\033[00m['
        end_str='\033[00m]'
    elif [ "${HS_ENV_SHELL}" = "zsh" ]
    then
        color="white"
        start_str='%F{'${color}'}[%f'
        end_str='%F{'${color}'}]%f'
    fi
    # printf "%s%s%s" ${start_str} ${content} ${end_str}
    test -n "${content}" && echo -e ${start_str}${content}${end_str}
    # echo -e "-[\033[33;5;11mError\033[38;5;15m\033[00m]"
}
function hs_varconfig()
{
    if [ ! -f "${HS_TMP_FILE_CONFIG}" ]
    then
        if [ ! -d "${HS_PATH_TMP}" ]
        then
            mkdir -p "${HS_PATH_TMP}"
        fi
        touch "${HS_TMP_FILE_CONFIG}"
    fi
    # get and set hs_varconfig
    # if [ "$#" = "3" ] && [ "$1" = "-s" ]
    case $1 in
        -s)
            # echo "$*"
            local target_var=$2
            local content=$3
            # echo sed --quiet -i "s|${target_var}=.*|${target_var}=${content}|g" ${HS_TMP_FILE_CONFIG}
            # echo grep --no-messages -f ${HS_TMP_FILE_CONFIG} ${target_var}
            if cat ${HS_TMP_FILE_CONFIG} | grep --silent ${target_var}
            then
                # echo grep true
                # sed -i "/${target_var}=.*/d" ${HS_TMP_FILE_CONFIG}
                # sed -i "s/${target_var}=.*/${target_var}=${content}/g" ${HS_TMP_FILE_CONFIG}
                if [ $HS_ENV_OS = "bsd" ]
                then
                    sed -i "" "s|${target_var}=.*|${target_var}=${content}|g" ${HS_TMP_FILE_CONFIG}
                else
                    sed -i "s|${target_var}=.*|${target_var}=${content}|g" ${HS_TMP_FILE_CONFIG}
                fi
            else
                # echo grep false
                printf "%s=%s\n" "${target_var}" "${content}" >> ${HS_TMP_FILE_CONFIG}
            fi

            ;;
        -g)
            local target_var=$2
            if [ -f "${HS_TMP_FILE_CONFIG}" ]
            then
                # echo ${target_var}
                # echo $(cat ${HS_TMP_FILE_CONFIG} | grep "${target_var}=" | cut -d "=" -f 2-)
                cat ${HS_TMP_FILE_CONFIG} | grep "${target_var}=" | cut -d "=" -f 2-
            fi
            ;;
        -e)
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
            ;;
    esac
    return 0

}
function set_working_path()
{
    case $1 in
        -s|--set-current-path)
            local var_tmp_path="$(hs_varconfig -g ${HS_VAR_CURRENT_DIR})"
            if [ -d "${PWD}" ] && [ "${var_tmp_path}" != "${PWD}" ]
            then
                hs_varconfig -s "${HS_VAR_CURRENT_DIR}" "$(pwd)"
            fi

            ;;
        -g|--go-to-setting-path)
            local var_tmp_path="$(hs_varconfig -g ${HS_VAR_CURRENT_DIR})"
            if [ -d "${var_tmp_path}" ]
            then
                cd "${var_tmp_path}"
            fi

            ;;
        -e|*)
            echo $(hs_varconfig -g "${HS_VAR_CURRENT_DIR}")
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
    # only give 200 ms for git command
    # timeout 0.2 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
    timeout 0.2 git rev-parse --abbrev-ref HEAD 2> /dev/null | sed 's/HEAD/no branch/g'
    # only support on > git 2.22
    # git branch --show-current

    if ! check_cmd_status
    then
        echo 'git command tiemout'
    fi
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
function hsconfig()
{

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p|--advanced-promote)
                HS_CONFIG_ADVANCED_PROMOTE=${2}
                shift 1
                ;;
            -h|--help)
                cli_helper -c "hsconfig" -cd "hsconfig function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "hsconfig [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-p|--advanced-promote" -d "Enable/Disable(Y/n) advance promote"
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
