########################################################
########################################################
#####                                              #####
#####    For HS Lib Functions                      #####
#####                                              #####
########################################################
########################################################
#####    Shell Env                                 #####
########################################################
function pureshell()
{
    local env_term=xterm-256color
    local env_home="${HOME}"
    local env_vars="export TERM=${env_term} && export HOME=${env_home}"
    local pureshell_rc=~/.purebashrc
    if [ "${#}" = "0" ]
    then
        echo "Pure bash"
        if [ -f ~/.purebashrc ]
        then
            # the purebashrc shour contain execu
            env -i bash -c "${env_vars} && source ${pureshell_rc} && bash --norc"
            # env -i bash -c "${env_vars} && bash --rcfile  ${pureshell_rc}"
        else
            env -i bash -c "${env_vars} && bash --norc"
        fi
    else
        echo "Pure bash"
        local excute_cmd=$@
        if [ -f ${pureshell_rc} ]
        then
            # the purebashrc shour contain execu
            env -i bash -c "${env_vars} && source ${pureshell_rc} && bash --norc -c \"${excute_cmd}\""
            # env -i bash -c "${env_vars} && bash --rcfile  ${pureshell_rc}"
        else
            env -i bash -c "export TERM=${env_term} && export HOME=${env_home} && bash --norc -c \"${excute_cmd}\""
        fi
    fi

}
########################################################
#####    Folder Manipulation                       #####
########################################################
function ffind()
{
    local flag_color="n"
    local pattern=""
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--color)
                flag_color="y"
                ;;
            -n|--no-color)
                flag_color="n"
                ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-c|--color" -d "Hilight keywords"
                cli_helper -o "-n|--no-color" -d "Don't hilight keywords"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                pattern="$@"
                break
                ;;
        esac
        shift 1
    done
    if [ "$flag_color" = "y" ]
    then
        find . -iname "*${pattern}*" | mark ${pattern}
    else
        find . -iname "*${pattern}*"
    fi

}
function droot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=${cpath}
    local target=".git"
    local flag_ignore_case="y"
    local flag_full_match="n"
    local flag_verbose="n"
    local flag_fake="n"
    local grep_args=("")

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--case)
                flag_ignore_case="n"
                ;;
            -m|--full-match)
                flag_full_match="y"
                ;;
            -v|--verbose)
                flag_verbose="y"
                ;;
            -f|--fake)
                flag_fake="y"
                ;;
            -h|--help)
                echo "froot"
                printlc -cp false -d "->" "-c|--case" "Ignore case"
                printlc -cp false -d "->" "-m|--full-match" "full pattern match"
                printlc -cp false -d "->" "-f|--fake" "return target path"
                printlc -cp false -d "->" "-v|--verbose" "Echo Verbose"
                return 0
                ;;

            *)
                target=$@
                break
                ;;
        esac
        shift 1
    done

    if [ "${flag_ignore_case}" = "y" ]
    then
        grep_args+="-i"
    fi

    local path_array=(`echo ${cpath} | sed 's/\//\n/g'`)
    # wallk through files
    while ! echo ${tmp_path} | rev |  cut -d'/' -f 1 | rev   |  grep -q ${grep_args} ${target};
    do

        tmp_path=${tmp_path}"/.."
        pushd "${tmp_path}" > /dev/null
        tmp_path=`pwd`
        [ "${flag_verbose}" = "y" ] && echo "Searching in ${tmp_path}"
        if [ "$(pwd)" = "/" ];
        then
            [ "${flag_verbose}" = "y" ] && echo 'Hit the root'
            popd > /dev/null
            return 1
        fi
        popd > /dev/null
        target_path=${tmp_path}
    done

    if [ "${flag_full_match}" = "y" ] && [ "${target}" != "$(echo ${tmp_path} | rev |  cut -d'/' -f 1 | rev)" ]
    then
        return 1
    fi

    [ "${flag_verbose}" = "y" ] && echo "goto ${target_path}"
    if [ "${flag_fake}" = "y" ] 
    then
        echo "${target_path}"
    else
        cd "${target_path}"
    fi
    return 0
}
function froot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=${cpath}
    local target=".git"
    local flag_ignore_case="y"
    local flag_full_match="n"
    local flag_verbose="n"
    local flag_fake="n"
    local grep_args=("")

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--case)
                flag_ignore_case="n"
                ;;
            -m|--full-match)
                flag_full_match="y"
                ;;
            -v|--verbose)
                flag_verbose="y"
                ;;
            -f|--fake)
                flag_fake="y"
                ;;
            -h|--help)
                echo "froot"
                printlc -cp false -d "->" "-c|--case" "Ignore case"
                printlc -cp false -d "->" "-m|--full-match" "full pattern match"
                printlc -cp false -d "->" "-f|--fake" "return target path"
                printlc -cp false -d "->" "-v|--verbose" "Echo Verbose"
                return 0
                ;;

            *)
                target=$@
                break
                ;;
        esac
        shift 1
    done

    if [ "${flag_ignore_case}" = "y" ]
    then
        grep_args+="-i"
    fi

    # wallk through files
    while ! ls -a "${tmp_path}" | grep -q ${grep_args} $target;
    do
        tmp_path="${tmp_path}/.."
        pushd "${tmp_path}" > /dev/null
        tmp_path="$(pwd)"
        [ "${flag_verbose}" = "y" ] && echo "Searching in ${tmp_path}"
        if [ "$(pwd)" = "/" ];
        then
            [ "${flag_verbose}" = "y" ] && echo 'Hit the root'
            popd > /dev/null
            return 1
        fi
        popd > /dev/null
        target_path=${tmp_path}
    done

    if [ "${flag_full_match}" = "y" ] && [ ! -e ${target_path}/${target} ]
    then
        return 1
    fi

    [ "${flag_verbose}" = "y" ] && echo "goto $target_path"
    if [ "${flag_fake}" = "y" ] 
    then
        echo "${target_path}"
    else
        cd "${target_path}"
    fi
    return 0
}
function groot()
{
    local pattern=$@
    droot ${pattern} || froot ${pattern}
}
########################################################
#####    Output                                    #####
########################################################
function andrun()
{
    local var_cmd_1=()
    local var_cmd_2=()
    local var_delimiter=";"

    # if [[ "$#" = 2 ]]
    # then
    #     var_cmd_1="${1}"
    #     var_cmd_2="${2}"
    # fi

    while [[ "$#" != 0 ]]
    do
        # echo "Args:$@"
        case $1 in
            # -a)
            #     shift 1
            #     while [[ "$#" != 0 ]] && [ "${1}" != "-b" ]
            #     do
            #         var_cmd_1+=("$1")
            #         shift 1
            #     done
            #     ;;
            # -b)
            #     shift 1
            #     while [[ "$#" != 0 ]] && [ "${1}" != "-a" ]
            #     do
            #         var_cmd_2+=("$1")
            #         shift 1
            #     done
            #     ;;
            -d)
                var_delimiter=${2}
                shift 2
                ;;
            -h|--help)
                echo "froot"
                printlc -cp false -d "->" "-a" "command a"
                printlc -cp false -d "->" "-b" "command b"
                printlc -cp false -d "->" "-h|--help" "Echo help"
                return 0
                ;;

            *)
                tmp_hit_flag=n
                while [[ "$#" != 0 ]]
                do
                    echo "Args:$@"
                    if [ "${tmp_hit_flag}" = "n" ] && [ "${1}" = "${var_delimiter}" ]
                    then
                        tmp_hit_flag="y"
                        # shift 1
                        # continue
                    elif [ "${tmp_hit_flag}" = "n" ]
                    then
                        var_cmd_1+=("$1")
                    elif [ "${tmp_hit_flag}" = "y" ]
                    then
                        var_cmd_2+=("$1")
                    fi
                    shift 1
                done
                ;;
        esac
    done


    echo "andrun: \"${var_cmd_1[@]}\" and \"${var_cmd_2[@]}\""
    # $(${var_cmd_1}) && $(${var_cmd_2})
    eval "${var_cmd_1[@]}" && eval "${var_cmd_2[@]}"
}
function echoerr()
{
    >&2 echo $@
}
function escape()
{
    printf "%q\n" "${*}"
}
function mark()
{
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

# Color       #define       Value       RGB
# black     COLOR_BLACK       0     0, 0, 0
# red       COLOR_RED         1     max,0,0
# green     COLOR_GREEN       2     0,max,0
# yellow    COLOR_YELLOW      3     max,max,0
# blue      COLOR_BLUE        4     0,0,max
# magenta   COLOR_MAGENTA     5     max,0,max
# cyan      COLOR_CYAN        6     0,max,max
# white     COLOR_WHITE       7     max,max,max
    local color_array=(
        # $(echo -e "\033[0;30m")
        $(echo -e "\033[0;31m")
        $(echo -e "\033[0;32m")
        $(echo -e "\033[0;33m")
        $(echo -e "\033[0;34m")
        $(echo -e "\033[0;35m")
        $(echo -e "\033[0;36m")
        $(echo -e "\033[0;37m")
        $(echo -e "\033[1;30m")
        $(echo -e "\033[1;31m")
        $(echo -e "\033[1;32m")
        $(echo -e "\033[1;33m")
        $(echo -e "\033[1;34m")
        $(echo -e "\033[1;35m")
        $(echo -e "\033[1;36m")
        $(echo -e "\033[1;37m")
    )

    local clr_idx=1
    local hi_word=""
    local clr_code=""
    local ccstart=${color_array[1]}
    local ccend=$(echo -e "\033[0m")

    if [ "$1" = "-c" ] || [ "$1" = "-C" ] || [ "$1" = "--color" ]
    then
        clr_idx=$2
        shift 2
        hi_word=$*
        local ccstart=${color_array[$clr_idx]}
    elif [ "$1" = "-s" ] || [ "$1" = "-S" ] || [ "$1" = "--color-name" ]
    then
        local color_name=$2
        shift 2
        hi_word=$*
        case ${color_name} in
            red)
                ccstart=$(tput setaf 1)
                ;;
            green)
                ccstart=$(tput setaf 2)
                ;;
            yellow)
                ccstart=$(tput setaf 3)
                ;;
            blue)
                ccstart=$(tput setaf 4)
                ;;
            magenta)
                ccstart=$(tput setaf 5)
                ;;
            cyan)
                ccstart=$(tput setaf 6)
                ;;
            gray)
                ccstart=$(tput setaf 7)
                ;;
        esac
    else
        hi_word=$*
    fi
    # echo $ccred$hi_word$ccend
    # $@ 2>&1 | sed -E -e "s%${hi_word}%${color_array[$clr_idx]}&${ccend}%ig"
    sed -u -E -e "s%${hi_word}%${ccstart}&${ccend}%ig"
}
########################################################
#####    Error Functions                           #####
########################################################
function error_check()
{
    local result=$?
    # echo $#,$*,$result
    if [[ $# == 2 ]]
    then
        local function_name=$1
        local line_info=$2
        # echo "Trace: ${function_name} +${line_info}"
    fi
    if [ $result != 0 ]
    then
        local cmd=""
        echo "An Error Occur, error code <$result>"
        echo -en "continue(y/n)? "
        read cmd
        if [ "${cmd}" = "y" ]
        then
            printc -c red "Open Emergency Shell"
            # read cmd
            cmd=bash
            eval "${cmd}"
            error_check ${funcstack[@]:1:1}${FUNCNAME[0]} ${LINENO}
        fi
    fi
    return ${result}
}
function shell_debug()
{
    # set -f	set -o noglob	Disable file name generation using metacharacters (globbing).
    # set -v	set -o verbose	Prints shell input lines as they are read.
    # set -x	set -o xtrace	Print command traces before executing command.
    local cmd=$*

    set -x
    eval "${cmd}"
    set +x
    # if [[ ${level} == 0 ]]
    # then
    #     # set +f
    #     set +v
    #     set +x
    # elif [[ ${level} == 1 ]]
    # then
    #     # set +f
    #     set -v
    #     set +x
    # elif [[ ${level} == 2 ]]
    # then
    #     # set +f
    #     set +v
    #     set -x
    # fi
}
function elapse()
{
    # usage elapse [Start Date] [End Date]
    if (( $# != 2 ))
    then
        echo "usage elapse [Start Date] [End Date]"
        return 1
    fi
    local start_date=$1
    local end_date=$2

    local start_time=$(date -d"${start_date}" +%s)
    local end_time=$(date -d"${end_date}" +%s)

    local diff_time=$((${end_time} - ${start_time}))
    local dd=$((${diff_time} / 60 / 60 / 24))
    local hh=$((${diff_time} / 60 / 60 % 24))
    local mm=$((${diff_time} / 60 % 60))
    local ss=$((${diff_time} % 60 + 0))
    echo "${dd}d:${hh}h:${mm}m:${ss}s"
}
