#!/bin/bash
# alias
alias xc="xclip"
alias xv="xclip -o"
# function 
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
function setup
{
    watch_mem
}
function rv()
{
	echo "Record video for $1 second"
	ffmpeg -y -i /dev/video0 -t $1  ~/video_`date +%F`.avi
}
function pygrid()
{
    source /home/shaowu/lab/pyenv/default/bin/activate
	/home/shaowu/lab/github/pygrid/pygrid.py
    deactivate
}
