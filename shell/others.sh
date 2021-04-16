########################################################
########################################################
#####                                              #####
#####    Others                                    #####
#####                                              #####
########################################################
########################################################

########################################################
#####    Usefull Function                          #####
########################################################
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
function doloop()
{
    local gen_list_cmd=$1
    local do_cmd=$2
    for each_input in $(eval ${gen_list_cmd})
    do
        echo ${do_cmd} $each_input
        # bash -c "${do_cmd} ${each_input}"
        eval "${do_cmd} \"${each_input}\""
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
function runtime()
{
    local source_file=$@
    local start_time=$(date +%s%N)
    eval ${source_file}
    local end_time=$(date +%s%N)

    # echo "$start_time, $end_time"
    local diff_time=$(( (${end_time} - ${start_time})/1000000 ))
    hs_print "[${diff_time}] source ${source_file}\n"
}

########################################################
#####    Others Function                           #####
########################################################
function xsettings()
{
    # .256 sec delay, 1 char/hz
    # xset r rate 200 40
    xset r rate 192 64
}
function audio_default()
{
    local audio_dev=$(pactl list sinks | grep Name |grep hdmi | cut -d ':' -f 2)
    echo "Set Default Audio Device to${audio_dev}"
    eval pactl set-default-sink "${audio_dev}"
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
function i3_reload()
{
    i3-msg reload
    i3-msg restart
}
function lg_patch
{
    cvt --reduced 2440 1028 60
    xrandr --newmode "2440x1028R"  164.75  2440 2488 2520 2600  1028 1031 1041 1058 +hsync -vsync
    xrandr --addmode HDMI-0 "2440x1028R"
}
function lab_addMode()
{
    export width=$1
    export height=$2

    cvt --reduced $width $height 60
    local res=$(cvt --reduced $width $height 60|grep R | sed 's/Modeline//g' )
    echo xrandr --newmode $res
    #xrandr --addmode HDMI-0 $(echo $res|cut -d' ' -f 1)

}
function vm_init()
{
    VBoxClient --clipboard
}
function gcc_setup()
{
    if [ "$1" != "clang"]
    then
        local gcc_ver=7
        alias gcc='gcc-$gcc_ver'
        alias cc='gcc-$gcc_ver'
        alias g++='g++-$gcc_ver'
        alias c++='c++-$gcc_ver'
    fi
}
########################################################
#####    Others Function                           #####
########################################################
function cdwin()
{
    echo "I receive the variable --> $1"
    line=$(sed -e 's#^J:##' -e 's#\\#/#g' <<< "$1")
    echo "Path: $line"
    if [ -d ${line} ]
    then
        cd "$line"
    fi
}
function ctwin()
{
    CURRENT_PATH=`pwd`
    pushd $CURRENT_PATH &> /dev/null
    line=$(sed -e 's|/|\\|g' -e 's|net||g' -e 's|shawn\.tseng\\||g'<<< `pwd`)
    popd &> /dev/null
    echo "Path: \\\\"$HOST$line
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
function sys_status()
{
    local cpu_num=$(nproc)
    local memory=$(free -h  | grep -i mem | tr -s ' ' | cut -d ' ' -f2)
    local sep="\n"

    # local contant=("$(printlc 'Hostname' $(hostname))" "$(printlc 'CPU(s)' ${cpu_num})" "$(printlc 'Memory' ${memory})")
    # echo $contant
    printt "$(printlc 'Hostname' $(hostname))${sep}$(printlc 'CPU(s)' ${cpu_num})${sep}$(printlc 'Memory' ${memory})"
}
function user_mount()
{
    # user_mount /dev/sda1 /mnt/tmp
    local uid=${UID}
    local gid=${GID}

    local target_dev=""
    local target_dir="/mnt/tmp"
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -p|--path)
                target_dir=$2
                shift 1
                ;;
            -d|--device)
                target_dev=$2
                shift 1
                ;;
            -h|--help)
                echo "user_mount"
                printlc -cp false -d "->" "-p|--path" "Mount point"
                printlc -cp false -d "->" "-d|--device" "Mount device"
                return 0
                ;;

            *)
                local excute_cmd="${excute_cmd}$@"
                break
                ;;
        esac
        shift 1
    done
    sudo mount -o uid=${uid},gid=${gid} ${target_dev} ${target_dir}
}
function join_by()
{
    local IFS="$1"; shift; echo "$*";
    # local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";
}
########################################################
#####    Project Functions                         #####
########################################################
# project commands
function proj_root()
{
    if [[ -z $PROJ_ROOT ]]
    then
        if groot ".hs_*proj"
        then
            return 0
        else
            return 1
        fi
    else
        cd $PROJ_ROOT
        return 0
    fi
}
function proj_man()
{
    echo "Test"
    for arg in $@
    do
        echo loop ${arg}
        case $arg in
            -l|--list-project)
                ls ${HS_PATH_PROJ}
                ;;
            -i=*|--init=*)
                echo "init"
                export PROJ_FILE=${arg#*=}
                echo "Select Project: ${PROJ_FILE}"
                source ${HS_PATH_PROJ}/${PROJ_FILE}
                proj_envsetup

                local proj_postfix="proj"
                local proj_prefix=".hs_"
                local proj_local_file=${proj_prefix}${PROJ_NAME}.${proj_postfix}
                touch ${proj_local_file}
                echo "# $PROJ_NAME" >> ${proj_local_file}
                printf "export PROJ_FILE=%s\n" ${PROJ_FILE} >> ${proj_local_file}
                echo "export PROJ_ROOT=$(realpath ${PWD})" >> ${proj_local_file}
                echo -e "export PROJ_DATE=\"`date`\"" >> ${proj_local_file}
                source ${proj_local_file}
                ;;
            # --xxxxxxx=*)
            #     REPO_CHECKOUT_DEPTH=${arg#*=}
            #     DO_SET_CHECKOUT_DEPTH=y
            #     ;;
            *)
                echo Unknown
                break
                ;;
        esac
    done
    echo "End"
}
function proj_refresh()
{
    local cpath=$(pwd)
    if proj_root
    then
        source .hs_*.proj
    fi

    if [ -f "${PROJ_FILE}" ]
    then
        echo "Select Project: $1"
        source ${PROJ_FILE}
    fi
}
########################################################
########################################################
#####                                              #####
#####    Canditate functions                       #####
#####                                              #####
########################################################
########################################################
alias drinking_reminder="reminder -i 3600 -l 'Drink Reminder' -c 'GO Drink Water'"
function reminder
{
    local interval='60'
    local label=""
    local content=""
    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -i|--interval)
                interval=$2
                shift 1
                ;;
            -l|--label)
                label=$2
                shift 1
                ;;
            -c|--content)
                content=$2
                shift 1
                ;;
            -h|--help)
                echo "reminder Usage"
                printlc -cp false -d "->" "-i|--interval" "Set interval"
                printlc -cp false -d "->" "-l|--label" "Set label"
                printlc -cp false -d "->" "-c|--content" "Set content"
                return 0
                ;;
            *)
                echo "Unknown Options"
                return 1
                ;;
        esac
        shift 1
    done

    while true
    do
        echo "Time stamp: $(date)"
        # notify-send -i /path//to/icon.png "Out of memory!!!" "Avaliable Memory:$mem_ava KB"
        notify-send "${label}" "${content}"
        sleep $interval
    done
}
