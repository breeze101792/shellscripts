#!/bin/bash
## alias ##
alias xc="xclip"
alias xv="xclip -o"
alias tstamp='date +%Y%m%d_%H%M%S'
alias cgrep='grep --color=always '

## functions ##
function retitle()
{
    print -Pn "\e]0;$@\a"
}
function lg_patch
{
    cvt --reduced 2440 1028 60
    xrandr --newmode "2440x1028R"  164.75  2440 2488 2520 2600  1028 1031 1041 1058 +hsync -vsync
    xrandr --addmode HDMI-0 "2440x1028R"
}
function watch_mem
{
    local threshold='512000'
    local interval='60'
    while true
    do
        local mem_ava=$(free | grep Mem | sed "s/ \+/ /g" | cut -d' ' -f 7)
        if [ $mem_ava -lt $threshold ];
        then
            notify-send -i /path//to/icon.png "Out of memory!!!" "Avaliable Memory:$mem_ava KB"
            sleep 10
        else
            echo "Avaliable Memory: $mem_ava KB"
            sleep $interval
        fi
    done

}
function rv()
{
	echo "Record video for $1 second"
    local video_path="${HOME}/media/videos/.recording"
    if [ ! -d ${video_path} ]
    then
        mkdir -p ${video_path}
    fi
	ffmpeg -y -i /dev/video0 -t $1  ${video_path}/video_`tstamp`.avi
}
bkfile()
{
   echo -e "Backup $1\n"
   mv $1 $1_$(tstamp).backup
}
logfile()
{
    local logfile=$1
    shift 1
    $@ 2>&1 | tee $logfile
}
cdwin()
{
    echo "I receive the variable --> $1"
    line=$(sed -e 's#^J:##' -e 's#\\#/#g' <<< "$1")
    cd "$line"
}
ctwin()
{
    CURRENT_PATH=`pwd`
    pushd $CURRENT_PATH &> /dev/null
    line=$(sed -e 's|/|\\|g' -e 's|net||g'<<< `pwd`)
    popd &> /dev/null
    echo "Path: \\\\"$HOST$line
}
mark()
{
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
    local hi_word=$1
    shift 1
    ccred=$(echo -e "\033[0;31m")
    ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    echo $ccred$hi_word$ccend
    $@ 2>&1 | sed -E -e "s%${hi_word}%${ccred}&${ccend}%ig"
}
# function __mark_genstr()
# {
#     local pattern_array=${1[@]}
#     local color_start=$(echo -e "\033[0;31m")
#     local color_end=$(echo -e "\033[0m")
#     local sed_str=""
#     echo ${1[*]}
#     for each_str in ${pattern_array[@]}
#     do
#         echo $each_str
#         $sed_str=echo -e "${sed_str} -e \"s%${each_str}%${ccred}&${ccend}%g\""
#     done
#     echo -e $sed_str

# }
# mark_test()
# {
#     local error_array=("[Ee]rr" "[Ee]rror")
#     local warning_array=("[Ww]arning")
#     __mark_genstr $error_array
#     return
#     local error_str="$(__mark_genstr $error_array)"
#     local warinig_str="$(__mark_genstr $warinig_array)"
#     # $@ 2>&1 | sed -E $error_array $warinig_array
#     echo -e "${error_array}"
#     $@ 2>&1 | sed -E $(__mark_genstr $error_array) $(__mark_genstr $warinig_array)

# }
mark_build()
{
    local ccred=$(echo -e "\033[0;31m")
    local ccyellow=$(echo -e "\033[0;33m")
    local ccend=$(echo -e "\033[0m")
    $@ 2>&1 | sed -E -e "s%undefined%$ccred&$ccend%ig" -e "s%fatl%$ccred&$ccend%ig" -e "s%error%$ccred&$ccend%ig" -e "s%fail%$ccred&$ccend%ig" -e "s%warning%$ccyellow&$ccend%ig"
}
wdiff()
{
    diff -rq $1 $2 | cut -f2 -d' '| uniq | sort
}
hex2bin()
{
    cat $1 | sed s/,//g | sed s/0x//g | xxd -r -p - $2
}
function epath()
{
    #echo "Export Path $1";
    # if grep -q $1 <<<$PATH;
    if echo ${PATH} | grep -q $1
    then
        echo "$1 has alread in your PATH";
        return;
    else
        export PATH=$1:$PATH;
    fi;

}
function pureshell()
{
    echo "Pure bash"
    #env -i sh --norc --noprofile -c "export TERM=xterm && sh"
    #env -i bash -c "export TERM=xterm && bash --norc --noprofile"
    #env -i bash -c "export TERM=xterm && bash --norc"
    #env -i bash -c "bash --norc --noprofile -c \"source ~/.bashrc_pure\""
    env -i bash -c "bash --norc -C ~/.purebashrc"
}
function bisync()
{
    local local_path=$1
    local remote_path=$2
    rsync -rtuv $local_path/* $remote_path
    rsync -rtuv $remote_path/* $local_path
}
function pln()
{
    ln -s `pwd`/$1 $2
}
