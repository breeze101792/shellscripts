#!/bin/bash
hs_print "Source Android(an) project"
if [ -z "${HS_WORK_ENV_ANDROID_DEVICE_IP}" ]
then
    export HS_WORK_ENV_ANDROID_DEVICE_IP=192.168.7.19
fi
alias acd="an_cd "
function an_setip()
{
    local target_ip=""
    local ip_domain="192.168.7"
    if [ "$#" = 0 ]
    then
        echo "No input IP found."
        echo "Device IP is: ${HS_WORK_ENV_ANDROID_DEVICE_IP}"
        return 0
    fi
    case $1 in
        -72)
            target_ip=${ip_domain}.72
            ;;
        -19)
            target_ip=${ip_domain}.19
            ;;
        -20)
            target_ip=${ip_domain}.20
            ;;
        -s|--set)
            target_ip=${2}
            shift
            ;;
        -h|--help)
            echo "setip Usage"
            printlc -cp false -d "->" "-19" "set ip to ${ip_domain}.19"
            printlc -cp false -d "->" "-20" "set ip to ${ip_domain}.20"
            printlc -cp false -d "->" "-72" "set ip to ${ip_domain}.72"
            printlc -cp false -d "->" "-s|--set" "set ip"
            return 0
            ;;
        *)
            target_ip=${ip_domain}.19
            ;;
    esac
    export HS_WORK_ENV_ANDROID_DEVICE_IP=${target_ip}
    echo "Device IP is: ${HS_WORK_ENV_ANDROID_DEVICE_IP}"

}
function an_adb()
{
    local var_timeout=3
    local var_serial
    local flag_timeout=n
    local flag_connect=y
    local var_ip=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--serial)
                an_setip -s ${2}
                shift 1
                ;;
            -t|--timeout)
                flag_timeout="y"
                var_timeout=${2}
                shift 1
                ;;
            -nc|--no-connect)
                flag_connect="n"
                ;;
            -h|--help)
                cli_helper -c "adb" -cd "adb function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "adb [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-s|--serial" -d "Set serial"
                cli_helper -o "-t|--timeout" -d "set command timeout "
                cli_helper -o "-nc|--no-connect" -d "no check connect on adb"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    if [ "${flag_connect}" = "y" ] && [ "$(adb -s ${HS_WORK_ENV_ANDROID_DEVICE_IP} shell echo connected)" != "connected" ]
    then
        an_connect
    fi

    if [ "${flag_timeout}" = "y" ]
    then
        timeout ${var_timeout} adb -s ${HS_WORK_ENV_ANDROID_DEVICE_IP} $@
    else
        # echo adb -s ${HS_WORK_ENV_ANDROID_DEVICE_IP} $@
        # eval ANDROID_ADB_SERVER_PORT=12345 adb -s "${HS_WORK_ENV_ANDROID_DEVICE_IP}" $(echo -e $@)
        eval adb -s "${HS_WORK_ENV_ANDROID_DEVICE_IP}" $(echo -e $@)
    fi
}
function an_shell()
{
    local var_timeout=3
    local flag_timeout=n
    local var_serial
    local flag_echo="n"

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--serial)
                an_setip -s ${2}
                shift 1
                ;;
            -t|--timeout)
                flag_timeout="y"
                var_timeout=${2}
                shift 1
                ;;
            -e|--echo)
                flag_echo="y"
                ;;
            -h|--help)
                cli_helper -c "adb shell" -cd "adb shell function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "an_shell [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-s|--serial" -d "Set serial"
                cli_helper -o "-t|--timeout" -d "set command timeout "
                cli_helper -o "-e|--echo" -d "echo mode "
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    if [ "${flag_timeout}" = "y" ]
    then
        echo "> $@"
    fi
    if [ "${flag_timeout}" = "y" ]
    then
        an_adb -t ${var_timeout} shell $@
    else
        an_adb shell $@
    fi
}
function an_push()
{
    local var_timeout=3
    local flag_timeout=n
    local var_serial
    local var_file=""
    local var_target=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -s|--serial)
                an_setip -s ${2}
                shift 1
                ;;
            -h|--help)
                cli_helper -c "adb push" -cd "adb push function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "an_push [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-s|--serial" -d "Set serial"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                if [[ $# = 2 ]]
                then
                    var_file=${1}
                    var_target=${2}
                    shift 2
                fi

                break
                ;;
        esac
        shift 1
    done
    if [ "${var_file}" = "" ] && [ "${var_target}" = "" ]
    then
        echo "No target found"
        return
    fi

    echo  "push ${var_file} to ${var_target}"
    local var_md5_ori=$(an_shell "ls ${var_target}| grep $(basename ${var_file}) | xargs md5sum ")
    local var_md5_src=$(md5sum ${var_file})
    an_adb push  ${var_file} ${var_target}
    local var_md5_target=$(an_shell "ls ${var_target}| grep $(basename ${var_file}) | xargs md5sum ")
    echo an_shell "ls ${var_target}| grep $(basename ${var_file}) | xargs md5sum "
    echo "Orignal:${var_md5_ori}"
    echo "source :${var_md5_src}"
    echo "target :${var_md5_target}"
}
function an_connect()
{
    # local dev_ip="192.168.7.19"
    # local dev_ip="10.248.198.13"
    local var_timeout=2
    if [[ $# != 1 ]]
    then
        local dev_ip=$(echo ${HS_WORK_ENV_ANDROID_DEVICE_IP}: | cut -d':' -f1)
        local dev_port=$(echo ${HS_WORK_ENV_ANDROID_DEVICE_IP}: | cut -d':' -f2)
    else
        local dev_ip=$(echo $1: | cut -d':' -f1)
        local dev_port=$(echo $1: | cut -d':' -f2)
    fi
    if [ "${dev_port}" = "" ]
    then
        dev_port=5555
    fi
    export HS_WORK_ENV_ANDROID_DEVICE_IP=$dev_ip:$dev_port
    echo "Set IP to: ${HS_WORK_ENV_ANDROID_DEVICE_IP}"

    while ping -W 5 -c 1 $(echo ${HS_WORK_ENV_ANDROID_DEVICE_IP}| cut -d ':' -f 1) -q | grep "0 received"
    do
        echo "Try to ping ${HS_WORK_ENV_ANDROID_DEVICE_IP}"
    done

    # echo "Connect ${HS_WORK_ENV_ANDROID_DEVICE_IP}"

    # an_adb -nc disconnect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
    # an_adb -nc connect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
    # while ! an_adb -nc devices -l |grep product
    while ! an_adb -nc -t ${var_timeout} -s ${HS_WORK_ENV_ANDROID_DEVICE_IP} shell whoami |grep root > /dev/null
    do
        # echo "Wait for reconnect."
        # an_adb -nc connect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
        if ! an_adb -nc -t ${var_timeout} connect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
        then
            # echo "Status: Not Connected"
            an_adb -nc -t ${var_timeout} disconnect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
            continue
        # else
        #     echo "Status: Connected\n"
        fi
        sleep 1

        local tmp_ret=$(an_adb -nc -t ${var_timeout} -s ${HS_WORK_ENV_ANDROID_DEVICE_IP} root)
        # echo ${tmp_ret}
        if $(echo ${tmp_ret} | grep 'cannot run as root' > /dev/null)
        then
            echo "ADB Connected\n"
            return 0
        elif [ "${tmp_ret}" = "false" ]
        then
            # echo "Root: Not Connected"
            an_adb -nc -t ${var_timeout} disconnect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
            continue
        # else
        #     # echo "Root ADB Connected"
        #     break
        fi
    done
    echo "Root ADB Connected"
    return 0
}

function an_cd()
{
    echo "Android Enhanced cd"
    local cpath=$(pwd)
    local target_path=${cpath}
    local an_root_path=""

    local an_sys_path=""
    local an_framworks_path=""
    local an_kernel_path=""
    local an_hw_path=""
    local an_vend_path=""
    local an_dev_path=""
    local an_ext_path=""
    local an_out_path=""

    ############################################################
    ####    Path Finder
    ############################################################
    if froot -m ".repo" > /dev/null || froot -m "framework" > /dev/null && froot -m "vendor" > /dev/null  && froot -m "device" > /dev/null
    then
        an_root_path=$(pwd)
        echo "Locate android root: $an_root_path"
    else
        cd ${cpath}
        echo "Android not recognize"
        return 1
    fi

    [ -z ${an_sys_path} ] && an_sys_path=${an_root_path}/system
    [ -z ${an_framworks_path} ] && an_framworks_path=${an_root_path}/frameworks
    [ -z ${an_kernel_path} ] && an_kernel_path=${an_root_path}/kernel
    [ -z ${an_hw_path} ] && an_hw_path=${an_root_path}/hardware
    [ -z ${an_vend_path} ] && an_vend_path=${an_root_path}/vendor
    [ -z ${an_dev_path} ] && an_dev_path=${an_root_path}/device
    [ -z ${an_ext_path} ] && an_ext_path=${an_root_path}/external
    [ -z ${an_out_path} ] && an_out_path=${an_root_path}/out

    target_path=${an_root_path}

    ############################################################
    ####    Checking Path
    ############################################################
    while [[ "$#" != 0 ]]
    do
        case $1 in
            -v|vend|vendor)
                local tmp_path=$(echo ${an_vend_path})
                if [ -n "${2}" ] && ( [ "${2}" = "google" ] )
                then
                    target_path=${tmp_path}/google
                    echo "vendor to ${2}"
                elif [ -n "${2}" ]
                then
                    target_path=${tmp_path}/${2}
                    echo "vendor to ${2}"
                else
                    target_path=${tmp_path}
                fi
                shift 1
                ;;
            -d|dev|device)
                local tmp_path=$(echo ${an_dev_path})
                if [ -n "${2}" ] && ( [ "${2}" = "google" ] )
                then
                    target_path=${tmp_path}/google
                    echo "device to ${2}"
                elif [ -n "${2}" ]
                then
                    target_path=${tmp_path}/${2}
                    echo "device to ${2}"
                else
                    target_path=${tmp_path}
                fi
                shift 1
                ;;
            -s|sys|system)
                local tmp_path=$(echo ${an_sys_path})
                if [ -n "${2}" ] && ( [ "${2}" = "root" ] )
                then
                    target_path=${tmp_path}/core/rootdir
                    echo "system to ${2}"
                elif [ -n "${2}" ]
                then
                    target_path=${tmp_path}/${2}
                    echo "system to ${2}"
                else
                    target_path=${tmp_path}
                fi
                shift 1
                ;;
            -f|framework)
                local tmp_path=$(echo ${an_framworks_path})
                if [ -n "${2}" ] && ( [ "${2}" = "av" ] )
                then
                    target_path=${tmp_path}/av
                    echo "framework to ${2}"
                elif [ -n "${2}" ]
                then
                    target_path=${tmp_path}/${2}
                    echo "framework to ${2}"
                else
                    target_path=${tmp_path}
                fi
                shift 1
                ;;
            -k|kernel)
                local tmp_path=$(echo ${an_kernel_path})
                if [ -n "${2}" ] && ( [ "${2}" = "google" ] )
                then
                    target_path=${tmp_path}/google
                    echo "kernel to ${2}"
                elif [ -n "${2}" ]
                then
                    target_path=${tmp_path}/${2}
                    echo "kernel to ${2}"
                else
                    target_path=${tmp_path}
                fi
                shift 1
                ;;
            -e|external)
                local tmp_path=$(echo ${an_ext_path})
                if [ -n "${2}" ] && ( [ "${2}" = "google" ] )
                then
                    target_path=${tmp_path}/google
                    echo "external to ${2}"
                elif [ -n "${2}" ]
                then
                    target_path=${tmp_path}/${2}
                    echo "external to ${2}"
                else
                    target_path=${tmp_path}
                fi
                shift 1
                ;;
            -o|out|output)
                local tmp_path=$(echo ${an_out_path})
                if [ -n "${2}" ] && ( [ "${2}" = "target" ] && [ "${2}" = "dev" ]  )
                then
                    target_path=${tmp_path}/target/product/*/
                    echo "out to ${2}"
                elif [ -n "${2}" ]
                then
                    target_path=${tmp_path}/${2}
                    echo "out to ${2}"
                else
                    # target_path=${tmp_path}
                    target_path=${tmp_path}/target/product/*/
                fi
                shift 1
                ;;
            -h|--help)
                echo "an_cd|acd"
                printlc -cp false -d "->" "-v|vend|vendor" "cd to target path"
                printlc -cp false -d "->" "-d|dev|device" "cd to target path"
                printlc -cp false -d "->" "-s|sys|system" "cd to target path"
                printlc -cp false -d "->" "-f|framework" "cd to target path"
                printlc -cp false -d "->" "-k|kernel" "cd to target path"
                printlc -cp false -d "->" "-o|out|output" "cd to target path"
                printlc -cp false -d "->" "-e|external" "cd to target path"
                return 0
                ;;

            *)
                if [ -d "${an_root_path}/${1}" ]
                then
                    target_path=${an_root_path}/${1}
                else
                    target_path=${an_root_path}/${1}*
                fi
                ;;
        esac
        shift 1
    done

    target_path=$(file ${target_path} | cut -d ":" -f 1)

    if [ -d "${target_path}" ]
    then
        echo goto ${target_path} | mark -s green ${target_path}
        # eval "cd ${target_path}"
        cd ${target_path}
        ls
        return 0
    else
        echo "Can't find ${target_path}"
        cd ${cpath}
        return 1
    fi
}
function an_remote()
{
    local var_skey_prefix="an_shell input"
    local var_skey_args=" "
    local var_cmd=""

    while [[ "$#" != 0 ]]
    do
        case $1 in
            -h|--help)
                cli_helper -c "an_remote" -cd "remote keyboard emulation"
                cli_helper -d "Please Launch ydotoold & launch in bash."
                cli_helper -t "SYNOPSIS"
                cli_helper -d "an_remote [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-h|--help" -d "Print help function "
                return 0
                ;;
            *)
                break
                ;;
        esac
        shift 1
    done

    # only bash work & please do ydotoold first
    if [ "${HS_ENV_SHELL}" != "bash" ]
    then
        echo "Only Support in Bash. Currently use ${HS_ENV_SHELL}"
        return 1
    fi
    local var_promote="Key>"
    local var_input=""
    local var_previous=""
    local var_target_key=""

    local var_start=0
    local var_end=0
    local var_time=0

    printf "Please Type Any Key.\n"
    while IFS= read -s -r -n 1 var_input
    do
        echo "->\"${var_input}\""
        var_end=$(date +%s%N)
        var_target_key=""
        case ${var_input} in
            '')
                # echo "Enter dected"
                var_target_key="ENTER"
                ;;
            ${uparrow})
                # echo "up dected"
                ;;
            $'\x16')
                # echo "Ctrl + v dected"
                var_target_key="ctrl+v"
                ;;
            $'\x18')
                # echo "Ctrl + x dected"
                var_target_key="ctrl+x"
                ;;
            $'\x01')
                # echo "Ctrl + a dected"
                var_target_key="ctrl+a"
                ;;
            $'\x14')
                # echo "Ctrl + t dected"
                var_target_key="ctrl+t"
                ;;
            $'\x17')
                # echo "Ctrl + w dected"
                var_target_key="ctrl+w"
                ;;
            $'\x0c')
                # echo "Ctrl + l dected"
                var_target_key="ctrl+l"
                ;;
            $'\x7f')
                # echo "backspace dected"
                var_target_key="BACK"
                ;;
            ' ')
                # echo "Space dected"
                var_target_key=" "
                ;;
        esac

        # local var_time=$(expr ${var_end} - ${var_start})
        # echo "Time Space:${var_end} - ${var_start} = ${var_time}"
        # echo $(test ${var_time} -le 20000000 )
        if [ ${var_time} -le 20000000 ]
        then
            # echo "Enter double key press"
            case ${var_previous}${var_input} in
                '[A')
                    # echo "Enter Arror Up"
                    var_target_key="DPAD_UP"
                    ;;
                '[B')
                    # echo "Enter Arror Down"
                    var_target_key="DPAD_DOWN"
                    ;;
                '[C')
                    # echo "Enter Arror Right"
                    var_target_key="DPAD_RIGHT"
                    ;;
                '[D')
                    # echo "Enter Arror Left"
                    var_target_key="DPAD_LEFT"
                    ;;
                '[1')
                    # echo "HOME dected"
                    var_target_key="HOME"
                    ;;
                $'\x1b'$'\x1b')
                    # echo "esc dected"
                    var_target_key="esc"
                    ;;
            esac
        fi
        var_previous=${var_input}

        # printf "\r%s" ${var_input}
        if [ "${var_target_key}" = "" ] && ([ "${var_input}" = "[" ] || [ "${var_input}"  = $'\x1b' ])
        then
            var_start=${var_end}
            continue
        fi

        # printf "%s %s\n" ${var_promote} ${var_target_key}
        if [ "${var_target_key}" = "" ]
        then
            printf "%s %s\n" "${var_promote}" "${var_input}"
            var_skey_args="text"
            var_cmd="${var_skey_prefix} ${var_skey_args} \"${var_input}\""
        else
            printf "%s %s\n" "${var_promote}" "${var_target_key}"
            var_skey_args="keyevent"
            var_cmd="${var_skey_prefix} ${var_skey_args} \"${var_target_key}\""
        fi
        # echo ${var_cmd}
        eval "${var_cmd}" 2> /dev/null
    done
    printf "\n"
}
