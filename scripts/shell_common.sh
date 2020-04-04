########################################################
########################################################
#####                                              #####
#####    Shell Setup Functions                     #####
#####                                              #####
########################################################
########################################################
function epath()
{
    #echo "Export Path $1";
    # if grep -q $1 <<<$PATH;
    local target_path=$(realpath $1)
    if echo ${PATH} | grep -q ${target_path}
    then
        echo "${target_path} has alread in your PATH";
        # exit 1
        return 1
    else
        echo -E "export PATH=${target_path}:"'$PATH;'
        export PATH=${target_path}:$PATH;
    fi;

}
function shell_setup()
{
    epath ${HOME}/.bin > /dev/null
    if [ "${HS_CONFIG_CHANGE_DIR}" = "y" ]
    then
        set_working_path -g
    fi
}
function item_promote()
{
    if [[ $# == 1 ]]
    then
        local content=$1
        if [ "${HS_ENV_SHELL}" = "bash" ] || [ "${HS_ENV_SHELL}" = "sh" ]
        then
            local color="cyan"
            local start_str='\033[00m-['
            local end_str='\033[00m]-'
        elif [ "${HS_ENV_SHELL}" = "zsh" ]
        then
            local color="cyan"
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
    # get and set hs_config
    # if [ "$#" = "3" ] && [ "$1" = "-s" ]
    if [ "$1" = "-s" ]
    then
        # echo "$*"
        local target_var=$2
        local content=$3
        if [ -f "${HS_FILE_CONFIG}" ] && hs_config -e "${target_var}" > /dev/null
        then
            # echo ${target_var}
            # sed -i "s|${target_var}=.*|${target_var}=${content}|g" ${HS_FILE_CONFIG}
            sed -i "/${target_var}=.*/d" ${HS_FILE_CONFIG}
            # printf "%s=%s\n" "${target_var}" "${content}" >> ${HS_FILE_CONFIG}
        # else
            # printf "%s=%s\n" "${target_var}" "${content}" >> ${HS_FILE_CONFIG}
        fi
        printf "%s=%s\n" "${target_var}" "${content}" >> ${HS_FILE_CONFIG}
    elif [ "$#" = "2" ] && [ "$1" = "-g" ]
    then
        local target_var=$2
        if [ -f "${HS_FILE_CONFIG}" ]
        then
            # echo ${target_var}
            echo $(cat ${HS_FILE_CONFIG} | grep "${target_var}=" | cut -d "=" -f 2-)
        fi
    elif [ "$#" = "2" ] && [ "$1" = "-e" ]
    then
        local target_var=$2
        if [ -f "${HS_FILE_CONFIG}" ]
        then
            # echo ${target_var}
            if cat ${HS_FILE_CONFIG} | grep "${target_var}="
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
    case $1 in
        -s|--set-current-path)
            # hs_config -s "${HS_VAR_CURRENT_DIR}" $(realpath ${PWD})
            # hs_config -s "${HS_VAR_CURRENT_DIR}" "${PWD}"
            hs_config -s "${HS_VAR_CURRENT_DIR}" "$(pwd)"
            # if [ -n "${HS_FILE_CONFIG}" ]
            # then
            #     echo `pwd` > ${HS_FILE_CONFIG}
            # else
            #     echo "[Set Current path fail]"
            #     return 1
            # fi
            ;;
        -g|--go-to-setting-path)
            cd "$(hs_config -g "${HS_VAR_CURRENT_DIR}")"
            # if [ -n "${HS_FILE_CONFIG}" ] && [ -f "${HS_FILE_CONFIG}" ] && [ -d "$(cat ${HS_FILE_CONFIG})" ]
            # then
            #     cd "$(cat $HS_FILE_CONFIG)"
            # else
            #     echo "Goto Current path fail $(cat ${HS_FILE_CONFIG})"
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
                echo -e "-[\033[33;5;11mError\033[38;5;15m\033[00m]"
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
