########################################################
########################################################
#####                                              #####
#####    For HS CLI Functions                      #####
#####                                              #####
########################################################
########################################################

########################################################
####    CLI Function
########################################################
function cli_helper()
{
    local var_cmd_name=""
    local var_cmd_description=""
    local var_title=""
    local var_option=""
    local var_description=""
    local var_prefix="      "

    while true
    do
        case $1 in
            -c|--command-name)
                var_cmd_name="${2}"
                shift 2
                ;;
            -cd|--command-description)
                var_cmd_description="${2}"
                shift 2
                ;;
            -o|--option)
                var_option="${2}"
                shift 2
                ;;
            -d|--description)
                var_description="${2}"
                shift 2
                ;;
            -t|--title)
                echo test
                var_title="${2}"
                shift 2
                ;;
            -h|--help)
                cli_helper -c "cli_helper" -cd "cli helper function for printing"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "cli_helper [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-c|--command-name" -d "Program command name"
                cli_helper -o "-cd|--command-description" -d "Program command description"
                cli_helper -o "-o|--option" -d "Options name"
                cli_helper -o "-t|--title" -d "Title of Secction"
                cli_helper -o "-d|--description" -d "Description of each section"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
    done
    if [ "${var_cmd_name}" != "" ]
    then
        printf "${var_cmd_name}"
        if [ "${var_cmd_description}" != "" ]
        then
            printf " - ${var_cmd_description}"
        fi
        printf "\n"
    elif [ "${var_title}" != "" ]
    then
        printf "${var_title}"
    elif [ "${var_option}" != "" ] && [ "${var_description}" != "" ]
    then
        printf "${var_prefix}${var_option}\n"
        printf "${var_prefix}${var_prefix}${var_description}\n"
    elif [ "${var_description}" != "" ]
    then
        printf "${var_prefix}${var_description}\n"
    fi
    printf "\n"
}

########################################################
####    Others
########################################################
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
            -h|--help)
                printt "printt test"
                return 0
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
    local label_width=$((32))
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
