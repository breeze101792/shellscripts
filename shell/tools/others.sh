#!/bin/bash
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
function wifi()
{
    # local var_utility='sudo wpa_cli'
    local var_utility='sudo wpa_cli'
    local var_dev='wlan0'
    local var_action=''
    local var_psk=''
    local var_ssid=''
    local var_type=''
    local var_profile_idx=''
    # local var_command=('wpa_cli')
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -d|--device)
                var_dev="${2}"
                shift 1
                ;;
            -s|--scan)
                var_cmd="${var_utility} -i ${var_dev} scan"
                echo ${var_cmd}
                eval ${var_cmd}
                var_cmd="${var_utility} -i ${var_dev} scan_result"
                echo ${var_cmd}
                eval ${var_cmd}
                ;;
            -c|--connect)
                var_ssid="${2}"
                shift 1
                ;;
            -l|--list)
                # list all saved connection
                eval ${var_utility} -i ${var_dev} list_network
                ;;
            -e|--enable-network)
                var_profile_idx=$2
                # Connect first connection
                eval ${var_utility} -i ${var_dev} select_network ${var_profile_idx}
                # enable first connection
                eval ${var_utility} -i ${var_dev} enable_network ${var_profile_idx}
                shift 1
                ;;
            # Add profile
            -r|--remove-profile)
                var_action="remove"
                var_profile_idx=$2
                shift 1
                ;;
            -a|--add-profile)
                var_action="profile"
                ;;
            -i|--ssid)
                var_ssid="${2}"
                shift 1
                ;;
            -k|--passkey)
                var_psk="${2}"
                shift 1
                ;;
            # -t|--type)
            #     var_type="${2}"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "template" -cd "template function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "template [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-s|--scan" -d "scan wifi"
                cli_helper -o "-d|--device" -d "set device"
                cli_helper -o "-c|--connect" -d "connect ssid"
                cli_helper -o "-p|--password" -d "ssid password"
                cli_helper -o "-t|--type" -d "encrypt type"
                cli_helper -o "-l|--list" -d "List saved profile"
                cli_helper -o "-e|--enable-network" -d "enable saved netowrk with network ID"
                cli_helper -o "-r|--remove-profile" -d "remove netowrk profile"
                cli_helper -o "-a|--add-profile" -d "add netowrk profile"
                cli_helper -o "-k|--passkey" -d "add netowrk options, passkey"
                cli_helper -o "-i|--ssid" -d "add netowrk options, name/ssid"
                cli_helper -o "-h|--help" -d "Print help function "

                cli_helper -t "Wpa Commands"
                cli_helper -d "sudo wpa_supplicant -B -Dnl80211 -i wlan0 -dddd -c /proj/mtk19320/workspace/config/wpa_supplicant.conf -f ./wpa_supplicant.log"
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done

    if [ "${var_action}" = "remove" ]
    then
        eval ${var_utility} -i ${var_dev} remove_network ${var_profile_idx}
        eval ${var_utility} -i ${var_dev} list_network
    elif [ "${var_action}" = "profile" ]
    then
        var_scan_result=$(wifi -s | grep ${var_ssid})
        if test -z ${var_scan_result}
        then
            echo "${var_ssid} not found. ${var_scan_result}"
            return -1
        fi
        echo ${var_ssid}, ${var_scan_result}

        var_profile_idx=$(eval "${var_utility} -i ${var_dev} add_network")

        eval ${var_utility} -i ${var_dev} set_network ${var_profile_idx} ssid "\"\\\"${var_ssid}\"\\\""
        if echo ${var_scan_result} | grep 'WPA'
        then
            var_type='wpa'
            eval "${var_utility} -i ${var_dev} set_network ${var_profile_idx} psk \"\\\"${var_psk}\"\\\""
        elif echo ${var_scan_result} | grep 'WEA'
        then
            var_type='wep'
            eval ${var_utility} -i ${var_dev} set_network ${var_profile_idx} key_mgmt NONE
            eval "${var_utility} -i ${var_dev} set_network ${var_profile_idx} wep_key0 \"\\\"${var_psk}\"\\\""
        elif test -z ${var_psk}
        then
            echo 'Known connection type'
            eval "${var_utility} -i ${var_dev} set_network ${var_profile_idx} psk \"\\\"${var_psk}\"\\\""
        else
            var_type='none'
            eval ${var_utility} -i ${var_dev} set_network ${var_profile_idx} key_mgmt NONE
        fi
        echo "Add profile to ${var_ssid} with ${var_type}"
        eval ${var_utility} -i ${var_dev} enable_network ${var_profile_idx}
    fi

    if false
    then
        # 如果要连接加密方式是[WPA-PSK-CCMP+TKIP][WPA2-PSK-CCMP+TKIP][ESS] (wpa加密)，wifi名称是name，wifi密码是：psk。
        eval ${var_utility} -i wlan0 set_network 0 ssid '"name"'
        eval ${var_utility} -i wlan0 set_network 0 psk '"psk"'
        eval ${var_utility} -i wlan0 enable_network 0

        # 如果要连接加密方式是[WEP][ESS] (wep加密)，wifi名称是name，wifi密码是psk。
        eval ${var_utility} -i wlan0 set_network 0 ssid '"name"'
        eval ${var_utility} -i wlan0 set_network 0 key_mgmt NONE
        eval ${var_utility} -i wlan0 set_network 0 wep_key0 '"psk"'
        eval ${var_utility} -i wlan0 enable_network 0

        # 如果要连接加密方式是[ESS] (无加密)，wifi名称是name。
        eval ${var_utility} -i wlan0 set_network 0 ssid '"name"'
        eval ${var_utility} -i wlan0 set_network 0 key_mgmt NONE
        eval ${var_utility} -i wlan0 enable_network 0

        # list all saved connection
        wpa_cli -i wlan0 list_network
        # Connect first connection
        wpa_cli -i wlan0 select_network 0
        # enable first connection
        wpa_cli -i wlan0 enable_network 0
    fi
}
function screenshot()
{
    import -window root ./screenshot_$(date '+%Y%m%d-%H%M%S').png
}
function sysbench()
{
    for each_cpu in $(seq 1 "$(nproc)")
    do
        echo "Run Task ${each_cpu}"
        openssl speed rsa &
    done
    wait
}
function tokenizer()
{
    if [ "$#" = "0" ]
    then
        xargs echo | sed "s/\s\+/\n/g"
    else
        echo $@ | sed "s/\s\+/\n/g"
    fi
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
function doloop()
{
    local var_list_cmd=""
    local var_cmd=""
    local var_interval="0.5"
    local var_terminate_condiction='default'
    local flag_clean_on_start='n'

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -c|--cmd)
                var_cmd="${2}"
                shift 1
                ;;
            -l|--list)
                var_list_cmd="${2}"
                shift 1
                ;;
            -n|--number)
                var_list_cmd="seq 0 ${2}"
                shift 1
                ;;
            -i|--interval)
                var_interval="${2}"
                shift 1
                ;;
            -t|--terminate)
                var_terminate_condiction="${2}"
                shift 1
                ;;
            -cs|--clear)
                flag_clean_on_start="y"
                ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "doloop" -cd "doloop function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "doloop [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-c|--cmd" -d "do command with %p do replace by list item"
                cli_helper -o "-l|--list" -d "generate list command"
                cli_helper -o "-n|--number" -d "generate number seq command(Start from 0), accept one number input"
                cli_helper -o "-i|--interval" -d "Specify running interval, default is 0.5 seconds"
                cli_helper -o "-t|--terminate" -d "Specify terminate condiction, default/fail/success"
                cli_helper -o "-cs|--clear" -d "Clear screen in each start"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                if [ -z "${var_cmd}" ]
                then
                    var_cmd="${2}"
                fi
                break
                ;;
        esac
        shift 1
    done
    if [ -z "${var_list_cmd}" ]
    then
        var_list_cmd="seq 0 1000"
        flag_fail_on_terminate='y'
    fi

    if [ -z "${var_cmd}" ] && [ -z "${var_list_cmd}" ]
    then
        echo "Not command found. cmd:${var_cmd}, list:${var_list_cmd}"
        return 1
    fi

    local var_idx=0
    for each_input in $(eval ${var_list_cmd})
    do
        local tmp_cmd=$(printf "$(echo ${var_cmd} | sed 's/%p/%s/g' )" "${each_input}")
        local tmp_buf=("")
        tmp_buf+=("[${var_idx}@$(tstamp)]:\"${each_input}\":\"${tmp_cmd}\"\n")
        tmp_buf+=("===========================================\n")
        # bash -c "${var_cmd} ${each_input}"
        tmp_buf+=($(eval ${tmp_cmd} 2>&1))
        result=$?
        tmp_buf+=("\n")
        tmp_buf+=("Return Value: ${result}\n")
        tmp_buf+=("===========================================\n")

        if [ "${flag_clean_on_start}" = "y" ]
        then
            clear
        fi
        echo -e "${tmp_buf[@]}"

        # echo "[${var_idx}@$(tstamp)]:\"${each_input}\":\"${tmp_cmd}\""
        # echo "==========================================="
        # # bash -c "${var_cmd} ${each_input}"
        # eval "${tmp_cmd}"
        # result=$?
        # echo "Return Value: ${result}"
        # echo "==========================================="


        if [ "${var_terminate_condiction}" = "fail" ] && [ "${result}" != "0" ]
        then
            echo "Command fail at \"${each_input}\":\"${tmp_cmd}\""
            return ${result}
        elif [ "${var_terminate_condiction}" = "success" ] && [ "${result}" = "0" ]
        then
            echo "Command success at \"${each_input}\":\"${tmp_cmd}\""
            return ${result}
        fi
        sleep ${var_interval}
    done
}
# function looptimes()
# {
#     local times=10
#     local interval=3
#     while [[ "$#" != 0 ]]
#     do
#         case $1 in
#             -t|--times)
#                 times="${2}"
#                 shift 1
#                 ;;
#             -i|--interval)
#                 interval="${2}"
#                 shift 1
#                 ;;
#             -v|--verbose)
#                 flag_verbose="y"
#                 shift 1
#                 ;;
#             -h|--help)
#                 cli_helper -c "looptimes" -cd "looptimes function"
#                 cli_helper -t "SYNOPSIS"
#                 cli_helper -d "looptimes [Options] [Value]"
#                 cli_helper -t "Options"
#                 cli_helper -o "-t|--time" -d "times to loop"
#                 cli_helper -o "-i|--interval" -d "delay for each time"
#                 cli_helper -o "-h|--help" -d "Print help function "
#                 return 0
#                 ;;
#             *)
#                 break
#                 # echo "Wrong args, $@"
#                 # return -1
#                 ;;
#         esac
#         shift 1
#     done

#     for each_time in $(seq 0 ${times})
#     do
#         clear
#         echo Times: ${each_time}, update ${interval} seconds
#         echo cmd: $@
#         echo "==========================================="
#         eval $@
#         echo "==========================================="
#         echo "Return Value: $?"
#         sleep ${interval}
#     done
# }
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
function sinfo()
{
    local flag_info='n'
    local flag_audio="n"

    if [[ "$#" = "0" ]]
    then
        echo "Default action"
        flag_info='y'
    fi
    while [[ "$#" != 0 ]]
    do
        case $1 in
            # -a|--append)
            #     cmd_args+=("${2}")
            #     shift 1
            #     ;;
            --audio)
                flag_audio="y"
                shift 1
                ;;
            # -v|--verbose)
            #     flag_verbose="y"
            #     shift 1
            #     ;;
            -h|--help)
                cli_helper -c "sinfo" -cd "sinfo function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "sinfo [Options] [Value]"
                cli_helper -t "Options"
                # cli_helper -o "-a|--append" -d "append file extension on search"
                # cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    local var_hostname=

    if [ "${flag_info}" = "y" ]
    then
        local var_os="$(cat /etc/os-release | grep "^NAME=" | cut -d "\"" -f 2 )"
        local var_hostname="$(cat /etc/hostname)"
        local var_kernel="$(uname -r)"
        local var_cpu="$(cat /proc/cpuinfo | grep 'model name' | head -n 1 | cut -d ':' -f 2 | sed 's/^\s//g')"
        local var_gpu=$(lspci 2> /dev/null |grep VGA | cut -d ':' -f 3 | sed 's/^\s//g')
        local var_ram="$(free -h | grep Mem | sed 's/\s\+/ /g' | cut -d ' ' -f 3) / $(free -h | grep Mem | sed 's/\s\+/ /g' | cut -d ' ' -f 2)"
        local var_uptime="$(uptime | sed 's/\s\+/ /g' |cut -d " " -f 4 | sed 's/,//g')"
        local var_tmp="/"
        local var_disk_root="$(df -h / |tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 3) / $(df -h / | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 2) ($(df -h / | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 5))"
        local var_tmp="/home"
        local var_disk_home="$(df -h ${var_tmp} |tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 3) / $(df -h ${var_tmp} | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 2) ($(df -h ${var_tmp} | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 5))"
        local var_tmp="/tmp"
        local var_disk_tmp="$(df -h ${var_tmp} |tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 3) / $(df -h ${var_tmp} | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 2) ($(df -h ${var_tmp} | tail -n 1 | sed 's/\s\+/ /g' | cut -d ' ' -f 5))"
        local var_pproccess="$(ps -Ao pid,fname |grep "${PPID}" |grep -v "grep" | sed 's/[[:space:]]\+/ /g' |sed 's/^\s//g'| cut -d ' ' -f 2) (${PPID})"
        local var_editor="${EDITOR}"
        local var_ssh_client_ip=${SSH_CLIENT}
    fi


    if [ "${flag_info}" = "y" ]
    then
        echo "###############################################################"
        echo "####  System Info"
        echo "###############################################################"
        echo "####  Hardware"
        echo "##  CPU            : "${var_cpu}
        echo "##  GPU            : "${var_gpu}
        echo "##  Memory         : "${var_ram}
        echo "####  Software"
        echo "##  OS             : "${var_os}
        echo "##  Kernel         : "${var_kernel}
        echo "##  Hostname       : "${var_hostname}
        echo "####  Configs"
        echo "##  Parent Process : "${var_pproccess}
        echo "##  Uptime         : "${var_uptime}
        echo "##  Editor         : "${var_editor}
        echo "####  Disk"
        echo "##  Root Disk      : "${var_disk_root}
        echo "##  Home Disk      : "${var_disk_home}
        echo "##  TMP Disk       : "${var_disk_tmp}
        echo "###############################################################"
        echo "####  Other Info"
        echo "###############################################################"
        test -n ${var_ssh_client_ip} && echo "##  SSH Client IP  : ${var_ssh_client_ip}"
        # echo "##  Memory       : "$(free -h  | grep Mem | sed 's/\s\+/;/g' | cut -d ';' -f 4)
        # echo "##  Working Disk : "$(df -h . | tail -n 1 | sed 's/\s\+/;/g' | cut -d ';' -f 4-5)
        # echo "##  TMP Disk     : "$(df -h /tmp | tail -n 1 | sed 's/\s\+/;/g' | cut -d ';' -f 4-5)
        echo "###############################################################"
    fi

    if [ "${flag_audio}" = "y" ]
    then
        # pacmd "set-default-source alsa_output.pci-0000_04_01.0.analog-stereo.monitor"
        echo "###############################################################"
        echo "####  Input Source Info"
        echo "###############################################################"
        # pacmd list-sources | grep -e 'index:' -e device.string -e 'name:'
        arecord -l
        echo "###############################################################"
        echo "####  Output Info"
        echo "###############################################################"
        pacmd list-sinks | grep -e 'name:' -e 'index:'
    fi

}
function xkeyrate()
{
    local var_level=2
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -l|--level)
                var_level=${2}
                shift 1
                ;;
            -h|--help)
                cli_helper -c "xkeyrate" -cd "xkeyrate, adjust key board rate on x"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "xkeyrate [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-l|--level" -d "specify keyboard rate level "
                cli_helper -o "-h|--help" -d "Print help function "
                cli_helper -t "Options"
                cli_helper -d "level 0: rate 256 72"
                cli_helper -d "level 1: rate 200 64"
                cli_helper -d "level 2: rate 192 64"
                cli_helper -d "level 3: rate 160 64"
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done

    # .256 sec delay, 1 char/hz
    if [[ ${#} = 1 ]]
    then
        var_level=${1}
    fi

    if [[ ${var_level} = 0 ]]
    then
        xset r rate 256 72
    elif [[ ${var_level} = 1 ]]
    then
        xset r rate 200 64
    elif [[ ${var_level} = 2 ]]
    then
        xset r rate 192 64
    elif [[ ${var_level} = 3 ]]
    then
        xset r rate 160 64
    fi
}
function audio_default()
{
    local audio_dev=''
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -l|--list)
                local idx=1
                for each_dev in $(pactl list sinks | grep Name | cut -d ':' -f 2)
                do
                    echo "Dev ${idx}: ${each_dev}"
                    # echo "${each_dev}"
                    idx=$((${idx}+1))
                done
                return 0
                ;;
            -d|--dev)
                local idx=1
                for each_dev in $(pactl list sinks | grep Name | cut -d ':' -f 2)
                do
                    if [ "${idx}" = ${2} ]
                    then
                        audio_dev=${each_dev}
                    fi
                    idx=$((${idx}+1))
                done
                shift 1
                ;;
            -n|--name)
                local audio_dev=$2
                shift 1
                ;;
            -h|--help)
                cli_helper -c "audio_default" -cd "audio_default function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "audio_default [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-l|--list" -d "list audio devices"
                cli_helper -o "-d|--dev" -d "set default device with idx"
                cli_helper -o "-n|--name" -d "set default device with name"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                echo "Wrong args, $@"
                return -1
                ;;
        esac
        shift 1
    done
    # local audio_dev=$(pactl list sinks | grep Name |grep hdmi | cut -d ':' -f 2)
    echo "Set Default Audio Device to ${audio_dev}"
    eval pactl set-default-sink "${audio_dev}"
}
function rv()
{
    local var_cmd=""
    local var_video_path="${HS_PATH_MEDIA}/.recording"
    local var_file_name="rv_`tstamp`"
    local var_file_extension="mkv"
    local var_video_dev="/dev/video0"
    local var_video_codec="h265"
    local var_audio_dev="hw:0"
    local var_recording_time="3600"
    local var_video_input_formate="mjpeg"

    local flag_fake="n"
    local flag_audio="y"
    local flag_video="y"

    while [[ "$#" != 0 ]]
    do
        echo $1
        case $1 in
            -a|--audio)
                var_audio_dev="${2}"
                shift 1
                ;;
            -v|--video)
                var_video_dev="${2}"
                shift 1
                ;;
            -t|--time)
                var_recording_time="${2}"
                shift 1
                ;;
            -p|--path)
                var_video_path="${2}"
                shift 1
                ;;
            -n|--name)
                var_file_name="${2}"
                shift 1
                ;;
            --vdec)
                var_video_codec="${2}"
                shift 1
                ;;
            --file)
                var_video_path=""
                var_file_name="${2}"
                shift 1
                ;;
            --type)
                if [ "${2}" = "audio" ] || [ "${2}" = "a" ]
                then
                    flag_audio="y"
                    flag_video="n"
                elif [ "${2}" = "video" ] || [ "${2}" = "v" ]
                then
                    flag_audio="n"
                    flag_video="y"
                fi
                shift 1
                ;;
            -f|--fake)
                flag_fake="y"
                ;;
            -h|--help)
                cli_helper -c "rv" -cd "rv function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "rv [Options] [Value]"
                cli_helper -d "rv -a hw:2 -t 3600"
                cli_helper -t "Options"
                cli_helper -o "-p|--path" -d "recorder path"
                cli_helper -o "-n|--name" -d "recorder file name"
                cli_helper -o "-t|--time" -d "recording time"
                cli_helper -o "-v|--video" -d "video device"
                cli_helper -o "--vdec" -d "video codec, h265,h264,copy"
                cli_helper -o "-a|--audio" -d "audio device"
                cli_helper -o "-f|--fake" -d "fake run"
                cli_helper -o "--file" -d "recorder file"
                cli_helper -o "--type" -d "recorder type, default av, optinal audio, video"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done
    if [ -n "${var_video_path}" ] &&  [ ! -d ${var_video_path} ]
    then
        mkdir -p ${var_video_path}
    fi
    ## Old command
    ##############################################################
    # var_cmd="ffmpeg -y -i /dev/video0 -t $1  ${var_video_path}/video_`tstamp`.avi"
    # var_cmd="ffmpeg -f alsa -ac 2 -i hw:1,0 -f video4linux2 -i /dev/video0 -acodec ac3 -ab 128k -f matroska -s 1280x720 -vcodec libx264 -preset ultrafast -qp 16 -t $1  ${var_video_path}/video_`tstamp`.mkv"

    # var_cmd="ffmpeg -fflags +igndts -async 1 -f alsa -thread_queue_size 1024 -ac 2 -i hw:1 -f video4linux2 -i /dev/video0 -acodec aac -ab 128k -f matroska -vcodec libx265 -preset slow -crf 18 -t $1  ${var_video_path}/video_`tstamp`.mkv"
    ##############################################################

    # var_cmd="ffmpeg -async 1 -f alsa -thread_queue_size 1024 -ac 2 -i hw:1 -f video4linux2 -i /dev/video2 -acodec aac -ab 128k -f matroska -vcodec libx265 -preset slow -crf 18 -t $1  ${var_video_path}/video_`tstamp`.mkv"
    # var_cmd=("ffmpeg -async 1 -f alsa -thread_queue_size 1024 -ac 2 -i ${var_audio_dev} -f video4linux2 -i ${var_video_dev} -acodec aac -ab 128k -f matroska -vcodec libx265 -preset slow -crf 18 -t ${var_recording_time} ${var_video_path}/video_`tstamp`.mkv")
    var_cmd=("ffmpeg")
    var_cmd+=(" -async 1")

    if [ "${flag_audio}" = "y" ]
    then
        # Audio Settings
        var_cmd+=(" -f alsa")
        var_cmd+=(" -thread_queue_size 1024")
        var_cmd+=(" -ac 1") # audio channel
        var_cmd+=(" -i ${var_audio_dev}")
    fi

    if [ "${flag_video}" = "y" ]
    then
        # you can use followings command to list webcam formate
        # v4l2-ctl --list-formats-ext
        # ffmpeg -f v4l2 -list_formats all -i /dev/video0

        var_cmd+=(" -f video4linux2")

        ## Video Settings
        var_cmd+=(" -framerate 30")
        var_cmd+=(" -video_size 1280x720")
        # var_cmd+=(" -video_size 640x480")

        if [ "${var_video_input_formate}" = "mjpeg" ]
        then
            # pre compress, but fast decode
            var_cmd+=(" -input_format mjpeg")
        elif [ "${var_video_input_formate}" = "yuv422" ]
        then
            # raw video
            var_cmd+=(" -input_format yuyv422")
        fi


        var_cmd+=(" -i ${var_video_dev}")
    fi

    if [ "${flag_audio}" = "y" ]
    then
        var_cmd+=(" -acodec aac -ab 128k")
        var_file_extension="aac"
    fi

    if [ "${flag_video}" = "y" ]
    then
        # var_cmd+=(" -f matroska")
        ## Options
        # CRF: Constant Rate Factor
        if [ "${var_video_codec}" = "h265" ]
        then
            ## h265
            var_cmd+=(" -vcodec libx265 -preset slow -crf 18")
            var_file_extension="h265"
        elif [ "${var_video_codec}" = "h264" ]
        then
            ## h264
            var_cmd+=(" -vcodec libx264 -preset ultrafast -qp 16")
            var_file_extension="h264"
        elif [ "${var_video_codec}" = "copy" ]
        then
            ## raw formate
            var_cmd+=(" -codec:v copy")
            var_file_extension="nut"
        fi
        ## Others
    fi

    if [ "${flag_video}" = "y" ] && [ "${flag_audio}" = "y" ]
    then
        var_file_extension="mkv"
    fi

    # Output Settings
    var_cmd+=(" -t ${var_recording_time}")
    var_cmd+=(" ${var_video_path}/${var_file_name}.${var_file_extension}")
    # "-fflags +igndts" to regenerate DTS based on PTS

    if [ "${flag_fake}" = "y" ]
    then
        printf "%s\n" "${var_cmd}"
    else
        printf "%s\n" "${var_cmd}"
        eval "${var_cmd}"
        echo "----------------------------------------------------------------"
        printf "Recording File: %s\n" "${var_video_path}/${var_file_name}.${var_file_extension}"
    fi

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
    if [ "$1" != "clang" ]
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
    local var_input_path="$(pwd)"
    local var_output_path=""
    local var_convert="linux"
    local flag_fake="n"
    local flag_verbose="n"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            # -a|--append)
            #     cmd_args+=("${2}")
            #     shift 1
            #     ;;
            -l|--linux)
                var_convert="linux"
                ;;
            -w|--windows)
                var_convert="win"
                ;;
            -f|--fake)
                flag_fake="y"
                ;;
            -v|--verbose)
                flag_verbose="y"
                ;;
            -h|--help)
                cli_helper -c "cdwin" -cd "cdwin function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "cdwin [Options] [Value]"
                cli_helper -t "Options"
                # cli_helper -o "-a|--append" -d "append file extension on search"
                cli_helper -o "-w|--windows" -d "convert to windows path "
                cli_helper -o "-l|--linux" -d "convert to linux path "
                cli_helper -o "-f|--fake" -d "fake run "
                cli_helper -o "-v|--verbose" -d "Verbose print "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                var_input_path=$@
                break
                ;;
        esac
        shift 1
    done


    if [ "${flag_verbose}" = "y" ]
    then
        echo "Input Path --> ${var_input_path}"
    fi

    if [ "${var_convert}" = "linux" ]
    then
        line=$(sed -e 's#^J:##' -e 's#\\#/#g' <<< "${var_input_path}")
    elif [ "${var_convert}" = "win" ]
    then
        # line=$(sed -e 's|/|\\|g' -e 's|net||g' -e 's|shawn\.tseng\\||g'<<< ${var_input_path})
        line=$(sed -e 's|/|\\|g' <<< ${var_input_path})
    fi

    if [ "${flag_fake}" = "y" ]
    then
        echo -E "$line"
    else
        if [ -d ${line} ]
        then
            cd "$line"
        else
            echo "Path no found: $line"
        fi
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
    echo "link_folders->$*"
    for each_folder in "${src_path[@]}"
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
function user_mount()
{
    # user_mount /dev/sda1 /mnt/tmp
    local uid=$(id -u)
    local gid=$(id -g)

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
    for arg in "$@"
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
                echo "reminder -i 3600 -l 'Drink Reminder' -c 'GO Drink Water'"
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
