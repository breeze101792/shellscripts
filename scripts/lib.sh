########################################################
########################################################
#####                                              #####
#####    For HS Lib Functions                      #####
#####                                              #####
########################################################
########################################################
#####    Alias                                     #####
########################################################
alias ls='ls --color=auto --group-directories-first -X '
alias l='ls -a --color=auto'
alias ll='l -lh'
alias llt='ll -t'
alias cgrep='grep --color=always '
alias sgrep='grep -rnIi  '
alias scgrep='grep --color=always -rnIi  '
alias vim='TERM=xterm-256color && vim '
alias vi='TERM=xterm-256color && vim -m '
########################################################
#####    Functions                                 #####
########################################################
function tstamp()
{
    date +%Y%m%d_%H%M%S
}
function doloop()
{
    local gen_list_cmd=$1
    local do_cmd=$2
    for each_input in $(eval ${gen_list_cmd})
    do
        echo ${do_cmd} $each_input
        # bash -c "${do_cmd} ${each_input}"
        eval "${do_cmd} ${each_input}"
    done
}
function looptimes()
{
    local times=10
    for each_time in $(seq 0 ${times})
    do
        echo Times: ${each_time}
        echo "==========================================="
        eval $@
        echo "==========================================="
        echo Sleep 3 seconds
        sleep 3
    done
}
function ffind()
{
    local flag_color="n"
    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -c|--color)
                flag_color="y"
                ;;
            -n|--no-color)
                flag_color="n"
                ;;
            -h|--help)
                echo "sdebug Usage"
                printlc -cp false -d "->" "-d|--device" "Set device"
                printlc -cp false -d "->" "-b|--baud-rate" "Set Baud Rate"
                printlc -cp false -d "->" "-s|--session-name" "Set Session Name"
                return 0
                ;;
            *)
                # echo Looking for $pattern
                break
                ;;
        esac
        shift 1
    done
    local pattern=$1
    if [ "$flag_color" = "y" ]
    then
        find . -iname "*${pattern}*" | mark ${pattern}
    else
        find . -iname "*${pattern}*"
    fi

}
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
function pureshell()
{
    local term_type=xterm-256color
    local pureshell_rc=~/.purebashrc
    if [ "${#}" = "0" ]
    then
        echo "Pure bash"
        if [ -f ~/.purebashrc ]
        then
            # the purebashrc shour contain execu
            env -i bash -c "export TERM=${term_type} && source ${pureshell_rc} && bash --norc"
            # env -i bash -c "export TERM=${term_type} && bash --rcfile  ${pureshell_rc}"
        else
            env -i bash -c "export TERM=${term_type} && bash --norc"
        fi
    else
        echo "Pure bash"
        local excute_cmd=$@
        if [ -f ${pureshell_rc} ]
        then
            # the purebashrc shour contain execu
            env -i bash -c "export TERM=${term_type} && source ${pureshell_rc} && bash --norc -c \"${excute_cmd}\""
            # env -i bash -c "export TERM=${term_type} && bash --rcfile  ${pureshell_rc}"
        else
            env -i bash -c "export TERM=${term_type} && bash --norc -c \"${excute_cmd}\""
        fi
    fi

}
function droot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=${cpath}
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    local path_array=(`echo $cpath | sed 's/\//\n/g'`)
    # wallk through files
    while ! echo ${tmp_path} | rev |  cut -d'/' -f 1 | rev   |  grep -i $target;
    do
        tmp_path=$tmp_path"/.."
        pushd "$tmp_path" > /dev/null
        tmp_path=`pwd`
        # echo "Searching in $tmp_path"
        if [ $(pwd) = '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            return 1
            # exit 1
        fi
        popd > /dev/null
        target_path=$tmp_path
    done
    echo "goto $target_path"
    cd $target_path
}
function froot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    local target_path=${cpath}
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    # wallk through files
    while ! ls -a $tmp_path | grep -i $target;
    do
        tmp_path=$tmp_path"/.."
        pushd "$tmp_path" > /dev/null
        tmp_path=`pwd`
        echo "Searching in $tmp_path"
        if [ $(pwd) = '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            # exit 1
            return 1
        fi
        popd > /dev/null
        target_path=$tmp_path
    done
    echo "goto $target_path"
    cd $target_path
}
function groot()
{
    local pattern=$1
    droot ${pattern} || froot ${pattern}
}
function echoerr()
{
    >&2 echo $@
}
function printt
{
    local width=$((80))
    local frame_char='#'
    local frame_width=$((4))
    local frame_height=$((1))
    while true
    do
        case $1 in
            -w|--width)
                width=$2
                shift 2
                ;;
            -fw|--frame-width)
                frame_width=$2
                shift 2
                ;;
            -fh|--frame-height)
                frame_height=$2
                shift 2
                ;;
            -fc|--frame-char)
                frame_char=$2
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done

    local padding_char=' '
    local content="$*"
    local frame_padding=$(seq -s"${frame_char}" 0 ${frame_width} | tr -d '[:digit:]')

    for each_time in $(seq 1 ${frame_height})
    do
        seq -s"${frame_char}" 0 ${width} | tr -d '[:digit:]'
    done

    echo -e "\n${content}\n" | while IFS='' read -r line
    do
        # this is content + 1
        # local content_cnt=$(eval echo ${line} | wc -m)
        local content_cnt=$(echo -e "${line}" | wc -m)
        # echo "\"${line}\"->$content_cnt"
        content_cnt=$(($content_cnt-1))
        if ((${content_cnt} % 2 == 1))
        then
            line=${line}${padding_char}
        fi
        local content_pad_cnt=$(((${width} - ${frame_width}*2 - ${content_cnt}) / 2))
        # local pading=$(seq -s${padding_char} 0 ${content_pad_cnt} | tr -d '[:digit:]')
        local pading=$(seq -s'-' 0 ${content_pad_cnt} | tr -d '[:digit:]' | sed "s/-/${padding_char}/g")
        # echo -e $(seq -s${padding_char} 0 ${content_pad_cnt} )

        # printf "%s%s%s%s%s\n" "${frame_padding}" "${pading}" "${line}" "${pading}" "${frame_padding}"
        echo -e "${frame_padding}${pading}${line}${pading}${frame_padding}"
    done
    for each_time in $(seq 1 ${frame_height})
    do
        seq -s"${frame_char}" 0 ${width} | tr -d '[:digit:]'
    done

}
function printlc()
{
    local label_width=$((24))
    local content_width=$((32))
    local divide_char=":"
    local flag_content_padding=true
    while true
    do
        case $1 in
            -lw|--label-width)
                label_width=$((0 + $2))
                shift 2
                ;;
            -cw|--content-width)
                content_width=$((0 + $2))
                shift 2
                ;;
            -d|--divide)
                divide_char=$2
                shift 2
                ;;
            -cp|--content-padding)
                flag_content_padding=$2
                shift 2
                ;;
            *)
                break
                ;;
        esac

    done
    # print label : content
    # printf label and it's content
    local label=$1
    local content=$2
    local frame_width=$((${label_width} + ${content_width} + 1))

    local padding_char=' '
    local label_cnt=$((0 + $(echo "${label}" | sed "s/[\(\)]/#/g"| wc -m)))
    local content_cnt=$((0 + $(echo "${content}" |sed "s/[\(\)]/#/g"| wc -m)))

    local label_padding_cnt=$(( ${label_width} - ${label_cnt} ))
    local content_padding_cnt=$(( ${content_width} - ${content_cnt} ))
    local label_padding="$(seq -s'-' 0 ${label_padding_cnt} | tr -d '[:digit:]' | sed "s/-/${padding_char}/g")"
    local content_padding="$(seq -s'-' 0 ${content_padding_cnt} | tr -d '[:digit:]' | sed "s/-/${padding_char}/g")"
    # echo $1: $2
    # printf "%s%s:%s%s" ${label} ${label_padding} ${content} ${content_padding}
    if [ "${flag_content_padding}" = "true" ]
    then
        echo -e "${label}${label_padding}${divide_char}${content_padding}${content}"
    else
        echo -e "${label}${label_padding}${divide_char}${content}"
    fi
}
function printc()
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

    if [ "$1" = "-i" ] || [ "$1" = "-I" ] || [ "$1" = "--inedx-color" ]
    then
        clr_idx=$2
        shift 2
        hi_word=$*
        local ccstart=${color_array[$clr_idx]}
    elif [ "$1" = "-c" ] || [ "$1" = "-C" ] || [ "$1" = "--color-name" ]
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
        esac
    elif [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        echo "printc"
        printlc -cp false -d "->" "-c|--color-name" "print with color name"
        printlc -cp false -d "->" "-i|--index-color" "print with color index"
    else
        hi_word=$*
    fi
    # echo $hi_word
    # sed -u -E -e "s%${hi_word}%${ccstart}&${ccend}%ig"
    # printf "%s%s%s" ${ccstart} ${hi_word} ${ccend}
    echo -ne "${ccstart}${hi_word}${ccend}"
}
function join_by()
{
    local IFS="$1"; shift; echo "$*";
    # local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";
}
function clipboard()
{
    if [ "$#" = 0 ]
    then
        eval "clipboard -g"
        return 0
    fi
    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -s|--set-clipboard)
                hs_config -s "${HS_VAR_CLIPBOARD}" "${2}"
                shift 1
                ;;
            -g|--get-clipboard)
                hs_config -g "${HS_VAR_CLIPBOARD}"
                ;;
            -d|--get-current-dir)
                # get current dir
                hs_config -g "${HS_VAR_CURRENT_DIR}"
                ;;
            -h|--help)
                echo "sdebug Usage"
                printlc -cp false -d "->" "-s|--set-clipboard" "Set Clipbboard"
                printlc -cp false -d "->" "-g|--get-clipboard" "Get Clipbboard"
                printlc -cp false -d "->" "-d|--get-current-dir" "Get current dir vars"
                return 0
                ;;
            *)
                echo "Unknown Options"
                return 1
                ;;
        esac
        shift 1
    done
}
########################################################
#####    Error Functions                           #####
########################################################

function error_check()
{
    local result=$?
    echo $#,$*
    if [[ $# == 2 ]]
    then
        local function_name=$1
        local line_info=$2
        echo "Trace: ${function_name} +${line_info}"
    fi
    if [ $result != 0 ]
    then
        local cmd=""
        echo "An Error Occur, error code <$result>"
        echo -en "continue(y/n)? "
        read cmd
        if [ "${cmd}" = "y" ]
        then
            printc -c red "Emergency Command>"
            read cmd
            eval "${cmd}"
            error_check ${funcstack[@]:1:1}${FUNCNAME[0]} ${LINENO}
        fi
    fi
    return ${result}
}
function cmd_debug()
{
    # set -f	set -o noglob	Disable file name generation using metacharacters (globbing).
    # set -v	set -o verbose	Prints shell input lines as they are read.
    # set -x	set -o xtrace	Print command traces before executing command.
    local cmd=$*

    set -x
    eval "${cmd}"
    set +x
}
