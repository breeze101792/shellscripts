#!/bin/bash
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
# alias ls='ls --color=auto'
alias l='ls -a --color=auto'
alias ll='l -lh'
alias llt='ll -t'
alias xc="xclip"
alias xv="xclip -o"
alias tstamp='date +%Y%m%d_%H%M%S'
alias cgrep='grep --color=always '
alias sgrep='grep --color=always -rnIi  '
alias vim='TERM=xterm-256color && vim '
alias vi='TERM=xterm-256color && vim -m '
########################################################
#####    Functions                                 #####
########################################################
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
    pattern=$1
    # echo Looking for $pattern
    find . -iname "*$pattern*"

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
    echo -e "${label}${label_padding}${divide_char}${content_padding}${content}"
}
