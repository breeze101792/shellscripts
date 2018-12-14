#!/bin/bash
## alias ##
alias xc="xclip"
alias xv="xclip -o"
alias tstamp='date +%Y%m%d_%H%M%S'
#alias grep='grep --color=always -n '

## functions ##
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
    pushd $1 &> /dev/null
    line=$(sed -e 's|/|\\|g' -e 's|net||g'<<< `pwd`)
    popd &> /dev/null
    echo $line
}
mark()
{
    local hi_word=$1
    shift 1
    pathpat="(/[^/]*)+:[0-9]+"
    ccred=$(echo -e "\033[0;31m")
    ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    $@ 2>&1 | sed -E -e "/$hi_word/ s%$pathpat%$ccred&$ccend%g"
}
mark_err()
{
    pathpat="(/[^/]*)+:[0-9]+"
    ccred=$(echo -e "\033[0;31m")
    ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    $@ 2>&1 | sed -E -e "/[Uu]ndefined[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ff]atl[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ee]rror[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ww]arning[: ]/ s%$pathpat%$ccyellow&$ccend%g"
}
wdiff()
{
    diff -rq $1 $2 | cut -f2 -d' '| uniq | sort
}
hex2bin()
{
    cat $1 | sed s/,//g | sed s/0x//g | xxd -r -p - $2
}
epath()
{
    #echo "Export Path $1";
    if grep -q $1 <<<$PATH;
    then
        lprint 0 "$1 has alread in your PATH";
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
    env -i bash -c "export TERM=xterm && bash --norc"
    #env -i bash -c "bash --norc --noprofile -c \"source ~/.bashrc_pure\""
}
