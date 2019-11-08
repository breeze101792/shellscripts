function item_promote()
{
    if [[ $# == 1 ]]
    then
        local content=$1
        if [ "${HS_SHELL}" = "bash" ] || [ "${HS_SHELL}" = "sh" ]
        then
            local color="cyan"
            local start_str='\033[00m-['
            local end_str='\033[00m]-'
        elif [ "${HS_SHELL}" = "zsh" ]
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
function set_working_path()
{
    case $1 in
        -s|--set-current-path)
            if [ -n "${HS_ENV_CONFIG}" ]
            then
                echo `pwd` > ${HS_ENV_CONFIG}
            else
                echo "[Set Current path fail]"
                return 1
            fi
            ;;
        -g|--go-to-setting-path|*)
            if [ -n "${HS_ENV_CONFIG}" ] && [ -f "${HS_ENV_CONFIG}" ] && [ -d "$(cat ${HS_ENV_CONFIG})" ]
            then
                cd "$(cat $HS_ENV_CONFIG)"
            else
                echo "Goto Current path fail $(cat ${HS_ENV_CONFIG})"
                return 1
            fi
            ;;
    esac
}

function check_cmd_status()
{
    RETVAL=$1
    case $RETVAL in
        1)
            if [ "${HS_SHELL}" = "bash" ] || [ "${HS_SHELL}" = "sh" ]
            then
                echo -e "-[\033[33;5;11mError\033[38;5;15m\033[00m]"
            elif [ "${HS_SHELL}" = "zsh" ]
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
