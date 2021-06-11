########################################################
########################################################
#####                                              #####
#####    For sHellScript Source Script             #####
#####                                              #####
########################################################
########################################################

#####    Private Function
########################################################
# In this area please unset it after use
function hs_source()
{
    local source_file=$1
    local flag_debug="n"

    if [ ${flag_debug} = "y" ]
    then
        local start_time=$(date +%s%N)
        source $(realpath ${source_file})
        local end_time=$(date +%s%N)

        # echo "$start_time, $end_time"
        local diff_time=$(( (${end_time} - ${start_time})/1000000 ))
        printf "[${diff_time}] source ${source_file}\n"
    else
        source $(realpath ${source_file})
    fi
}
function hs_motd()
{
    # ps -Aeo pid,cmd | grep "^${PPID}"
    local var_msg=()
    local var_distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f 2 )
    local var_logo

    local var_ubuntu=()
    local var_raspberry=()
    local var_arch=()
    local var_other=()
    # var_arch+='              +                '
    # var_arch+='              #                '
    # var_arch+='             ###               '
    # var_arch+='            #####              '
    # var_arch+='            ######             '
    # var_arch+='           ; #####;            '
    # var_arch+='          +##.#####            '
    # var_arch+='         +##########           '
    # var_arch+='        #############;         '
    # var_arch+='       ###############+        '
    # var_arch+='      #######   #######        '
    # var_arch+='    .######;     ;###;`".      '
    # var_arch+='   .#######;     ;#####.       '
    # var_arch+='   #########.   .########`     '
    # var_arch+='  ######             ######    '
    # var_arch+=' ;####                 ####;   '
    # var_arch+=' ##                       ##   '
    # var_arch+='#                          `#  '

    local var_color="\033[38;2;23;147;209m"
    local var_clr_reset="\e[0m"
    var_arch+=${var_color}'                   ▄                    '${var_clr_reset}
    var_arch+=${var_color}'                  ▟█▙                   '${var_clr_reset}
    var_arch+=${var_color}'                 ▟███▙                  '${var_clr_reset}
    var_arch+=${var_color}'                ▟█████▙                 '${var_clr_reset}
    var_arch+=${var_color}'               ▟███████▙                '${var_clr_reset}
    var_arch+=${var_color}'              ▂▔▀▜██████▙               '${var_clr_reset}
    var_arch+=${var_color}'             ▟██▅▂▝▜█████▙              '${var_clr_reset}
    var_arch+=${var_color}'            ▟█████████████▙             '${var_clr_reset}
    var_arch+=${var_color}'           ▟███████████████▙            '${var_clr_reset}
    var_arch+=${var_color}'          ▟█████████████████▙           '${var_clr_reset}
    var_arch+=${var_color}'         ▟███████████████████▙          '${var_clr_reset}
    var_arch+=${var_color}'        ▟█████████▛▀▀▜████████▙         '${var_clr_reset}
    var_arch+=${var_color}'       ▟████████▛      ▜███████▙        '${var_clr_reset}
    var_arch+=${var_color}'      ▟█████████        ████████▙       '${var_clr_reset}
    var_arch+=${var_color}'     ▟██████████        █████▆▅▄▃▂      '${var_clr_reset}
    var_arch+=${var_color}'    ▟██████████▛        ▜█████████▙     '${var_clr_reset}
    var_arch+=${var_color}'   ▟██████▀▀▀              ▀▀██████▙    '${var_clr_reset}
    var_arch+=${var_color}'  ▟███▀▘                       ▝▀███▙   '${var_clr_reset}
    var_arch+=${var_color}' ▟▛▀                               ▀▜▙  '${var_clr_reset}

    var_raspberry+="    .~~.   .~~.    "
    var_raspberry+="   '. \ ' ' / .'   "
    var_raspberry+="    .~ .~~~..~.    "
    var_raspberry+="   : .~.'~'.~. :   "
    var_raspberry+="  ~ (   ) (   ) ~  "
    var_raspberry+=" ( : '~'.~.'~' : ) "
    var_raspberry+="  ~ .~ (   ) ~. ~  "
    var_raspberry+="   (  : '~' :  )   "
    var_raspberry+="    '~ .~~~. ~'    "
    var_raspberry+="        '~'        "
    var_raspberry+="                   "

    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''
    var_ubuntu+=''

    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''
    var_other+=''

    var_msg+=$(printf "%- 16s: %s" "OS" "$(cat /etc/os-release | grep "^NAME=" | cut -d "\"" -f 2 )")
    var_msg+=$(printf "%- 16s: %s" "Hostname" "$(hostname)")
    var_msg+=$(printf "%- 16s: %s" "Kernel Version" "$(uname -r)")
    var_msg+=$(printf "%- 16s: %s" "Processor Type" "$(cat /proc/cpuinfo | grep 'model name' | head -n 1 | cut -d ':' -f 2 | sed 's/^\s//g')")
    var_msg+=$(printf "%- 16s: %s" "RAM Free" "$(free -h | grep Mem | sed 's/\s\+/ /g' | cut -d ' ' -f 4) / $(free -h | grep Mem | sed 's/\s\+/ /g' | cut -d ' ' -f 2)")
    var_msg+=$(printf "%- 16s: %s" "Uptime" "$(uptime | sed 's/\s\+/ /g' |cut -d " " -f 4 | sed 's/,//g')")
    var_msg+=$(printf "%- 16s: %s" "Root" "$(df -h / |tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 3) / $(df -h / | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 2) ($(df -h / | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 5))")
    var_msg+=$(printf "%- 16s: %s" "EDITOR" "${EDITOR}")
    # var_msg+=$(printf "%- 16s: %s" "WM" "None")
    # var_msg+=$(printf "%- 16s: %s" "DE" "GNOME")
    command -v pacman > /dev/null && var_msg+=$(printf "%- 16s: %s" "Packages" "$(pacman -Q | wc -l)")

    if [ "${var_distro}" = "arch" ]
    then
        var_logo=(${var_arch[@]})
    elif [ "${var_distro}" = "arch" ]
    then
        var_logo=(${var_ubuntu[@]})
    elif [ "${var_distro}" = "raspbian" ]
    then
        var_logo=(${var_raspberry[@]})
    else
        var_logo=(${var_other[@]})
    fi

    for each_idx in $(seq 1 ${#var_logo})
    do
        printf "%s %s\n" "${var_logo[${each_idx}]}" "${var_msg[${each_idx}]}"
    done
}
function hs_autostart()
{
    local var_target=${1}
    local var_autostart_name="AUTOSTART_$(hostname)"
    local var_stored_uptime="$(hs_config -g ${var_autostart_name})"
    local var_current_uptime=$(($(date +%s -d "$(uptime -s)") / 10))

    if [ "${var_stored_uptime}" = "" ] || [ "${var_stored_uptime}" != "${var_current_uptime}" ]
    then
        ##########################################
        # Auto Start
        ##########################################
        hs_source ${var_target}

        hs_config -s "${var_autostart_name}" "${var_current_uptime}"
    fi
}

#####    Globa Function
########################################################
function pass()
{
    if false
    then
        echo -e -n ""
    fi
}
function hs_print()
{
    # FIXME remove this function due to motd added.
    pass
    # # echo ${HS_ENV_SILENCE}
    # if [ "${HS_ENV_SILENCE}" = "n" ]
    # then
    #     echo -E "hs> $@"
    # fi
}
function refresh
{
    local cpath=$(realpath .)
    source $HS_PATH_LIB/source.sh -p=${HS_PATH_LIB} -s=${HS_ENV_SHELL} -S=${HS_ENV_SILENCE} --refresh
    cd ${cpath}
}

function hs_main
{
    if [ "${HS_ENV_ENABLE}" = "false" ]
    then
        echo "Skip HS Env"
        return
    fi
    ##########################################
    # Vars
    ##########################################
    local flag_var_refresh="n"
    local var_user_config="${HOME}/.hsconfig.sh"
    local var_user_autostart="${HOME}/.hsautostart.sh"

    ##########################################
    # configs
    ##########################################
    local flag_env_silence=""
    local flag_env_change_shell_path=""
    local flag_env_shell=""
    local flag_env_lib_path=""

    ##########################################
    # Others
    ##########################################
    local excute_command=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p=*|--lib-path=*)
                flag_env_lib_path=${1#*=}
                ;;
            -s=*|--shell-type=*)
                flag_env_shell=${1#*=}
                ;;
            -S=*|--silence=*)
                flag_env_silence=${1#*=}
                ;;
            --change-shell-path=*)
                flag_env_change_shell_path=${1#*=}
                ;;
            -p|--lib-path)
                flag_env_lib_path=${2}
                shift 1
                ;;
            -s|--shell-type)
                flag_env_shell=${2}
                shift 1
                ;;
            -S|--silence)
                flag_env_silence=${2}
                shift 1
                ;;
            --change-shell-path)
                flag_env_change_shell_path=${2}
                shift 1
                ;;
            --refresh)
                flag_var_refresh="y"
                ;;
            -x|--excute)
                shift 1
                excute_command=$*
                break
                ;;
            *)
                # echo "Options not found. ${arg}"
                break
                ;;
        esac
        shift 1
    done
    ##########################################
    # Auto detect configs
    ##########################################
    if [ -z "${flag_env_shell}" ]
    then
        flag_env_shell="$(echo ${SHELL} | rev |  cut -d '/' -f 1 | rev)"
    fi
    if [ -z "${flag_env_lib_path}" ]
    then
        if [ "${flag_env_shell}" = "bash" ]
        then
            # don't use \", dirname has bug
            flag_env_lib_path="$(dirname ${BASH_SOURCE[0]})"
        else
            flag_env_lib_path="$(realpath .)"
        fi
    fi

    # source shell scripts
    ##########################################
    # setup configs
    ##########################################
    if [ "${flag_env_lib_path}" = "" ]
    then
        export HS_PATH_LIB=$(pwd)
    else
        export HS_PATH_LIB=${flag_env_lib_path}
    fi
    source $HS_PATH_LIB/shell/env_config.sh
    if [ -f ${var_user_config} ]
    then
        source ${var_user_config}
    fi
    # TODO to be delete
    if [ -f $HOME/.hsconfig ]
    then
        echo "[Warning] need to use .hsconfig"
        source $HOME/.hsconfig
    fi

    # silence mode in subshell
    if [[ "${SHLVL}" > "1" ]]
    then
        HS_ENV_SILENCE="y"
    fi
    ##########################################
    # setup custom configs
    ##########################################
    hs_source ${HS_PATH_LIB}/shell/shell_common.sh
    if [ "${flag_env_shell}" = "" ]
    then
        export HS_ENV_SHELL=bash
    else
        export HS_ENV_SHELL=${flag_env_shell}
    fi

    if [ "${flag_env_silence}" = "y" ]
    then
        HS_ENV_SILENCE="y"
    elif [ "${flag_env_silence}" = "n" ]
    then
        HS_ENV_SILENCE="n"
    fi
    if [ "${flag_env_change_shell_path}" = "y" ]
    then
        HS_CONFIG_CHANGE_DIR="y"
    elif [ "${flag_env_change_shell_path}" = "n" ]
    then
        HS_CONFIG_CHANGE_DIR="n"
    fi
    ##########################################
    # shell preset
    ##########################################

    ##########################################
    # shell init
    ##########################################
    if [ "$HS_ENV_SHELL" = "bash" ]
    then
        export HS_ENV_SHELL="bash"
        hs_source $HS_PATH_LIB/shell/base_bash.sh
    else
        export HS_ENV_SHELL="zsh"
        hs_source $HS_PATH_LIB/shell/base_zsh.sh
    fi
    hs_print "Version: $HS_ENV_VER"
    hs_source $HS_PATH_LIB/shell/env_platform.sh
    hs_source $HS_PATH_LIB/shell/lib.sh
    hs_source $HS_PATH_LIB/shell/cli.sh
    hs_source $HS_PATH_LIB/shell/tools.sh
    hs_source $HS_PATH_LIB/shell/development.sh
    hs_source $HS_PATH_LIB/shell/others.sh
    hs_source $HS_PATH_LIB/projects/project.sh
    ##########################################
    # shell post init
    ##########################################
    if [ "${HS_ENV_SHELL}" = "bash" ] && [ "${HS_CONFIG_FUNCTION_EXPORT}" = "y" ]
    then
        export_sh_func ${HS_PATH_LIB}/shell/shell_common.sh
        export_sh_func ${HS_PATH_LIB}/shell/lib.sh
        export_sh_func ${HS_PATH_LIB}/shell/tools.sh
        export_sh_func ${HS_PATH_LIB}/shell/development.sh
    fi
    # if [ "${flag_var_refresh}" = "n" ] && [ ${HS_ENV_SILENCE} = "n" ]
    # then
    #     retitle "${HS_ENV_TITLE}"
    # fi

    ##########################################
    # Source Other settings
    ##########################################

    if [ -f $HS_PATH_LIB/shell/lab.sh ]
    then
        hs_source $HS_PATH_LIB/shell/lab.sh
    fi
    # End of shell
    if [ -f ${HS_PATH_WORK}/work.sh ]
    then
        hs_source ${HS_PATH_WORK}/work.sh
    fi

    ##########################################
    # Post Settings
    ##########################################
    if [ -f "${var_user_autostart}" ]
    then
        hs_autostart ${var_user_autostart}
    fi

    if [ "${flag_var_refresh}" = "n" ] && [ ${HS_ENV_SILENCE} = "n" ] && [[ "${SHLVL}" = "1" ]]
    then
        hs_motd
    fi

    ##########################################
    # Excute Command
    ##########################################
    if [ ! -z "${excute_command}" ]
    then
        eval "${excute_command}"
    fi
}

hs_main $@
unset -f hs_main
unset -f hs_source
unset -f hs_autostart
unset -f hs_motd
##########################################
# Post Setting
##########################################
# retitle "HS Shell"
