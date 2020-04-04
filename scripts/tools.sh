########################################################
########################################################
#####                                              #####
#####    For HS Tools Functions                    #####
#####                                              #####
########################################################
########################################################

########################################################
#####    File Function                             #####
########################################################
function clipboard()
{
    if [ "$#" = 0 ]
    then
        eval "clipboard -g"
        return 0
    fi
    while true
    do
        if [ "$#" = 0 ]
        then
            break
        fi
        case $1 in
            -s|--set-clipboard)
                hs_config -s "${HS_VAR_CLIPBOARD}" "${2}"
                shift 1
                ;;
            -g|--get-clipboard)
                hs_config -g "${HS_VAR_CLIPBOARD}"
                ;;
            -d|--get-current-dir)
                # get current dir
                hs_config -g "${HS_VAR_CURRENT_DIR}"
                ;;
            -h|--help)
                echo "Clibboard Usage"
                printlc -cp false -d "->" "-s|--set-clipboard" "Set Clipbboard"
                printlc -cp false -d "->" "-g|--get-clipboard" "Get Clipbboard"
                printlc -cp false -d "->" "-d|--get-current-dir" "Get current dir vars"
                return 0
                ;;
            *)
                echo "Unknown Options"
                return 1
                ;;
        esac
        shift 1
    done
}
bkfile()
{
   echo -e "Backup $1\n"
   mv $1 $1_$(tstamp).backup
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
function bisync()
{
    local local_path=$1
    local remote_path=$2
    rsync -rtuv $local_path/* $remote_path
    rsync -rtuv $remote_path/* $local_path
}
function renter()
{
    local cpath=$(realpath ${PWD})
    local idx=$((1))
    while true
    do
        local tmp_path=$(pwd | rev | cut -d '/' -f ${idx}- |rev)
        if [ -d ${tmp_path} ]
        then
            echo "Goto ${tmp_path}"
            cd $(realpath ${tmp_path})
            break
        elif [ "${tmp_path}" = "/" ]
        then
            break
        fi
        idx=$((idx + 1))
    done
    # cd ${HOME}
    # cd ${cpath}
}
function extract()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2|*.tbz2)
                tar xvjf $1
                ;;
            *.tar.xz)
                tar xvJf $1
                ;;
            *.tar.gz|*.tgz)
                tar xvzf $1
                ;;
            *.bz2)
                bunzip2 $1
                ;;
            *.rar)
                unrar x $1
                ;;
            *.gz)
                gunzip $1
                ;;
            *.tar)
                tar xvf $1
                ;;
            *.zip)
                unzip $1
                ;;
            *.Z)
                uncompress $1
                ;;
            *.7z)
                7z x $1
                ;;
            *)
                echo "Unknown file type, use 7z to extract it"
                7z x $1
                ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
function tstamp()
{
    date +%Y%m%d_%H%M%S
}
