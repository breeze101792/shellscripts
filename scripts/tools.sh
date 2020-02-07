########################################################
########################################################
#####                                              #####
#####    For HS Tools Functions                    #####
#####                                              #####
########################################################
########################################################
function slink()
{
    local target_path=""
    if [ "$#" = "1" ]
    then
        target_path=$(realpath ${1})
    else
        target_path=$(realpath ${PWD})
    fi

    rm ${HS_PATH_SLINK}
    ln -sf  ${target_path} ${HS_PATH_SLINK}
    ls -al ${HS_PATH_SLINK}
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
        if [ "${tmp_name}" != "" ] &&  tmux ls
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
        tmux a -dt ${session_name}
    else
        echo "Create session: ${session_name}"
        retitle ${session_name}
        pureshell tmux -2 new -s ${session_name}
    fi
    # tmux a -t ${session_name} || tmux new -s ${session_name}
}
function sed_replace()
{
    # replace $1 with $2 under this folder
    local pattern=$1
    local target_string=$2

    for each_file in $(grep -rn ${pattern} | cut -d ":" -f 1 | sort | uniq)
    do
        echo "Replacing ${pattern} with ${target_string} in ${each_file}"
        sed -i "s/${pattern}/${target_string}/g" $(realpath ${each_file})
    done
}
function sys_status()
{
    local cpu_num=$(nproc)
    local memory=$(free -h  | grep -i mem | tr -s ' ' | cut -d ' ' -f2)
    local sep="\n"

    # local contant=("$(printlc 'Hostname' $(hostname))" "$(printlc 'CPU(s)' ${cpu_num})" "$(printlc 'Memory' ${memory})")
    # echo $contant
    printt "$(printlc 'Hostname' $(hostname))${sep}$(printlc 'CPU(s)' ${cpu_num})${sep}$(printlc 'Memory' ${memory})"
}
function erun()
{
    # enhanced run
    local excute_cmd=""
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--Source-HS)
                local excute_cmd="source $HOME/tools/shellscripts/source.sh -p=$HOME/tools/shellscripts -s="${HS_ENV_SHELL}" --change-shell-path=n --silence=y && "
                ;;
            -h|--help)
                echo "erun"
                printlc -cp false -d "->" "-s|--Source-HS" "Source HS config"
                return 0
                ;;

            *)
                local excute_cmd="${excute_cmd}$@"
                break
                ;;
        esac
        shift 1
    done

    local start_time=$(date "+%Y-%m-%d_%H:%M:%S")
    echo "Start cmd: $(printc -c yellow ${excute_cmd})"
    printt "$(printlc -lw 32 -cw 0 -d " " "Start Jobs at ${start_time}" "")" | mark -s green "#"
    # mark_build "${excute_cmd}"
    eval "${excute_cmd}"
    local end_time=$(date "+%Y-%m-%d_%H:%M:%S")
    printt "$(printlc -lw 32 -cw 0 -d " " "Job Finished" "")\n$(printlc -lw 8 -cw 24 "Start" ${start_time})\n$(printlc -lw 8 -cw 24  "End" ${end_time})" | mark -s green "#"
    echo "Finished cmd: $(printc -c yellow ${excute_cmd})"
}
function renter()
{
    local cpath=$(realpath .)
    local idx=$((1))
    while true
    do
        local tmp_path=$(realpath . | rev | cut -d '/' -f ${idx}- |rev)
        if [ -d ${tmp_path} ]
        then
            echo "Goto ${tmp_path}"
            cd ${tmp_path}
        elif [ "${tmp_path}" = "/" ]
        then
            break
        fi
        idx=$((idx + 1))
        break
    done
    # cd ${HOME}
    # cd ${cpath}
}

