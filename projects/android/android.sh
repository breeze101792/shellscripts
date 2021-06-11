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
        eval adb -s "${HS_WORK_ENV_ANDROID_DEVICE_IP}" $(echo -e $@)
    fi
}
function an_shell()
{
    local var_timeout=3
    local flag_timeout=n
    local var_serial

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
            -h|--help)
                cli_helper -c "adb shell" -cd "adb shell function"
                cli_helper -t "SYNOPSIS"
                cli_helper -d "an_shell [Options] [Value]"
                cli_helper -t "Options"
                cli_helper -o "-s|--serial" -d "Set serial"
                cli_helper -o "-t|--timeout" -d "set command timeout "
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
        echo "No device ip found"
        echo "Set IP to: ${HS_WORK_ENV_ANDROID_DEVICE_IP}"
    else
        local dev_ip=$(echo $1: | cut -d':' -f1)
        local dev_port=$(echo $1: | cut -d':' -f2)
        if [ "${dev_port}" = "" ]
        then
            dev_port=5555
        fi
        export HS_WORK_ENV_ANDROID_DEVICE_IP=$dev_ip:$dev_port
    fi
    echo "Connect ${HS_WORK_ENV_ANDROID_DEVICE_IP}"
    # an_adb -nc disconnect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
    # an_adb -nc connect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
    # while ! an_adb -nc devices -l |grep product
    while ! an_adb -nc -t ${var_timeout} -s ${HS_WORK_ENV_ANDROID_DEVICE_IP} shell whoami |grep root
    do
        echo "Wait for reconnect."
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

        if ! an_adb -nc -t ${var_timeout} -s ${HS_WORK_ENV_ANDROID_DEVICE_IP} root
        then
            # echo "Root: Not Connected"
            an_adb -nc -t ${var_timeout} disconnect ${HS_WORK_ENV_ANDROID_DEVICE_IP}
            continue
        # else
        #     echo "Root: Connected\n"
        #     break
        fi
    done
    echo "Root: Connected\n"
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
    if froot ".repo" > /dev/null || froot "framework" > /dev/null && froot "vendor" > /dev/null  && froot "device" > /dev/null
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
                target_path=${an_root_path}/${1}*
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
