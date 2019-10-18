
function slink()
{
    local target_path=""
    if [ "$#" = "1" ]
    then
        target_path=$(realpath ${1})
    else
        target_path=$(realpath ${PWD})
    fi

    rm ${HS_ENV_SLINK_PATH}
    ln -sf  ${target_path} ${HS_ENV_SLINK_PATH}
    ls -al ${HS_ENV_SLINK_PATH}
}
bkfile()
{
   echo -e "Backup $1\n"
   mv $1 $1_$(tstamp).backup
}
logfile()
{
    local logname="logfile_`tstamp`.log"
    echo "$@" | tee $logname
    eval "$@" 2>&1 | tee -a $logname
}
function rln()
{
    ln -sf $(realpath $1) $2
}
function retitle()
{
    # print -Pn "\e]0;$@\a"
    echo -en "\033]0;$@\a"
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
cdwin()
{
    echo "I receive the variable --> $1"
    line=$(sed -e 's#^J:##' -e 's#\\#/#g' <<< "$1")
    echo "Path: $line"
    if [ -d ${line} ]
    then
        cd "$line"
    fi
}
ctwin()
{
    CURRENT_PATH=`pwd`
    pushd $CURRENT_PATH &> /dev/null
    line=$(sed -e 's|/|\\|g' -e 's|net||g' -e 's|shawn\.tseng\\||g'<<< `pwd`)
    popd &> /dev/null
    echo "Path: \\\\"$HOST$line
}
function bisync()
{
    local local_path=$1
    local remote_path=$2
    rsync -rtuv $local_path/* $remote_path
    rsync -rtuv $remote_path/* $local_path
}
function fcp_pattern()
{
    local pattern="$1"
    local from=$2
    local to=$3
    rsync -zarv --include="*/" --include="$pattern" --exclude="*" "$from" "$to"
    # rsync -rtuv --include="${pattern}" --exclude="*"  $local_path/* $remote_path
    # rsync -rtuv $remote_path/* $local_path
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
function link_folders()
{
    # echo Link args:$@, num:$#
    # something wrong with it
    # if [[ $# < 2 ]]
    # then
    #     echo "Need at least two para"
    #     return
    # fi
    local target_folder=$1
    mkdir ${target_folder}
    shift 1
    local src_path=($@)
    echo "link_folders->$@"
    for each_folder in ${src_path[@]}
    do
        local tmp_folder=$(realpath ${each_folder})
        echo "Link:${tmp_folder}"
        if [ -d ${tmp_folder} ]
        then
            ln -sf ${tmp_folder} ${target_folder}/
        else
            echo "Folder dosen't exist. ${tmp_folder}"
        fi
    done
}
function session
{
    local session_name=""
    if [ "$#" = "1" ]
    then
        local tmp_name=$(tmux ls |grep ${1}| cut -d ':' -f 1)
        if [ ${tmp_name} != "" ] &&  tmux ls
        then
            session_name=${tmp_name}
        else
            session_name=${1}
        fi
    else
        # session_name="Tmp Session"
        tmux ls
        return
    fi

    if tmux ls | grep ${session_name}
    then
        echo "Start session: ${session_name}"
        retitle ${session_name}
        tmux a -t ${session_name}
    else
        echo "Create session: ${session_name}"
        retitle ${session_name}
        tmux new -s ${session_name}
    fi
    # tmux a -t ${session_name} || tmux new -s ${session_name}
}
function print_title
{
    local content=$1
    local padding_char=' '
    local width=64
    # this is content + 1
    local content_cnt=$(eval echo ${content} | wc -m)
    content_cnt=$(($content_cnt-1))
    if ((${content_cnt} % 2 == 1))
    then
        content=${content}${padding_char}
    fi
    local content_pad_cnt=$(((${width} - 4*2 - ${content_cnt}) / 2))
    local pading=$(seq -s${padding_char} 0 ${content_pad_cnt} | tr -d '[:digit:]')
    # if [ "$#" = "1" ]
    # then
    #     local tmp_name=$(tmux ls |grep ${1}| cut -d ':' -f 1)
    # else
    #     # session_name="Tmp Session"
    #     tmux ls
    #     return
    # fi
    # seq -s'#' 0 $(tput cols) | tr -d '[:digit:]'
    seq -s'#' 0 ${width} | tr -d '[:digit:]'
    printf "####%s%s%s####\n" ${pading} ${content} ${pading}
    seq -s'#' 0 ${width} | tr -d '[:digit:]'

}
