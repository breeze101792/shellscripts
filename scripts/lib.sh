#!/bin/bash
## alias ##
alias ls='ls --color=auto --group-directories-first -X '
# alias ls='ls --color=auto'
alias ll='ls -alh'
alias llt='ls -alht'
alias l='ls -a'
alias xc="xclip"
alias xv="xclip -o"
alias tstamp='date +%Y%m%d_%H%M%S'
alias cgrep='grep --color=always '
alias sgrep='grep --color=always -rnIi  '
alias vim='TERM=xterm-256color && vim '
## functions ##
function ffind()
{
    pattern=$1
    echo Looking for $pattern
    find . -name "*$pattern*"

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
    if [ -f ~/.purebashrc ]
    then
        # the purebashrc shour contain execu
        env -i bash -c "export TERM=xterm && source ~/.purebashrc && bash -norc"
    else
        env -i bash -c "export TERM=xterm && bash --norc"
    fi

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
    ln -sf `pwd`/$1 $2
}
function groot()
{
    local cpath=$(pwd)
    local tmp_path=$cpath
    locat target_path=""
    local target=''

    if (( $# >= 1 ))
    then
        target=$1
    else
        target=".git"
    fi
    local path_array=(`echo $cpath | sed 's/\//\n/g'`)
    for each_folder in $path_array
    do
        if [ $each_folder = $target ]
        then
            cd `echo $cpath | sed "s/$each_folder.*/$each_folder/g"`
            echo goto $each_folder
            return
        fi
    done
    # wallk through files
    while ! ls -a $tmp_path | grep $target;
    do
        pushd $tmp_path > /dev/null
        tmp_path=`pwd`
        if [ $(pwd) = '/' ];
        then
            echo 'Hit the root'
            popd > /dev/null
            return
        fi
        popd > /dev/null
        target_path=$tmp_path
        tmp_path=$tmp_path"/.."
    done
    echo "goto $target_path"
    cd $target_path
}
