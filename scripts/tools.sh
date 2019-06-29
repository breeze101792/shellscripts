
function tftp_set()
{
    rm ${HS_ENV_TFTP_PATH}
    ln -sf  `pwd`/$1 ${HS_ENV_TFTP_PATH}
    ls -al ${HS_ENV_TFTP_PATH}
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
    bash -c "$@" 2>&1 | tee $logname
}
function pln()
{
    ln -sf `pwd`/$1 $2
}
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
function vm_init()
{
    VBoxClient --clipboard
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
