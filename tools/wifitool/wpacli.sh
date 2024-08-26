#!/bin/bash
###########################################################
## DEF
###########################################################
export DEF_COLOR_RED='\033[0;31m'
export DEF_COLOR_YELLOW='\033[0;33m'
export DEF_COLOR_GREEN='\033[0;32m'
export DEF_COLOR_NORMAL='\033[0m'

###########################################################
## Vars
###########################################################
export VAR_SCRIPT_NAME="$(basename ${BASH_SOURCE[0]%=.})"
export VAR_CPU_CNT=$(nproc --all)
export VAR_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
export VAR_WLAN_IF=wlan0
export VAR_WLAN_CURRENT_NETWORK_ID=""

# export VAR_TARGET_INFO=()

# For wifi settings
VAR_WLAN_TYPE="WPA_PSK"
VAR_WLAN_SSID=""
VAR_WLAN_BSSID=""
VAR_WLAN_USER=""
VAR_WLAN_PASSWORD=""

VAR_WLAN_METRIC=""
###########################################################
## Options
###########################################################
export OPTION_VERBOSE=false

###########################################################
## Path
###########################################################
export SCRIPT_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export PATH_ROOT="$(pwd)"

###########################################################
## Utils Functions
###########################################################
fPrintHeader()
{
    local msg=${1}
    printf "###########################################################\n"
    printf "###########################################################\n"
    printf "##  %- $((60-4-${#msg}))s  ##\n" "${msg}"
    printf "###########################################################\n"
    printf "###########################################################\n"
    printf ""
}
fErrControl()
{
    local ret_var=$?
    local func_name=${1}
    local line_num=${2}
    if [[ ${ret_var} == 0 ]]
    then
        return ${ret_var}
    else
        echo ${func_name} ${line_num}
        exit ${ret_var}
    fi
}
fHelp()
{
    echo "${VAR_SCRIPT_NAME}"
    echo "[Example]"
    printf "    %s\n" "run test: .sh -a"
    echo "[Options]"
    echo "    -i, --interface IFACE  Specify the WLAN interface."
    echo "    -t, --type TYPE        Specify the WLAN type. WPA_PSK, WPA_EAP"
    echo "    -s, --ssid SSID        Specify the WLAN SSID."
    echo "    -c, --config FILE      Source the specified configuration file."
    echo "    -m, --metric           Set the metric using the fSetMetric function."
    echo "    -h, --help             Print helping."
    echo ""
    echo "[Commands]"
    echo "    all                    Perform the 'all' action."
    echo "    add                    Add a new WLAN configuration."
    echo "    scan                   Scan for available WLAN networks."
    echo "    list                   List all WLAN configurations."
    echo "    enable NETWORK_ID      Enable the specified WLAN network by its ID."
    echo "    remove NETWORK_ID      Remove the specified WLAN network by its ID."
    echo ""
    echo "[Examples]"
    echo "    wpacli.sh -i wlan0 -t WPA_EAP -s MySSID add"
    echo "    wpacli.sh --interface wlan0 --ssid MySSID scan"
    echo "    wpacli.sh -c config.sh"
    echo "    wpacli.sh enable 1"
}            
fInfo()
{
    local var_title_pading""

    fPrintHeader ${FUNCNAME[0]}
    printf "###########################################################\n"
    printf "##  Vars\n"
    printf "###########################################################\n"
    printf "##    %s\t: %- 16s\n" "Script" "${VAR_SCRIPT_NAME}"
    printf "###########################################################\n"
    printf "##  Path\n"
    printf "###########################################################\n"
    printf "##    %s\t: %- 16s\n" "Working Path" "${PATH_ROOT}"
    printf "###########################################################\n"
    printf "##  Options\n"
    printf "###########################################################\n"
    printf "##    %s\t: %- 16s\n" "Verbose" "${OPTION_VERBOSE}"
    printf "###########################################################\n"
}
fSleepSeconds()
{
    local var_sleep_cnt=0
    if [ $# = 1 ]
    then
        var_sleep_cnt=${1}
    else
        return -1
    fi
    # only sleep for seconds
    for each_idx in $(seq 1 $var_sleep_cnt)
    do
        printf "\rSleeping (%d/%d)" ${each_idx} ${var_sleep_cnt}
        sleep 1
    done;
    printf "\nwakeup from sleep(${var_sleep_cnt})\n"
    return 1
}
fEval()
{
    local var_commands=0
    if [[ $# = 1 ]]
    then
        var_commands=${1}
    elif [[ $# > 1 ]]
    then
        if [[ "${1}" = "-s" ]]
        then
            shift 1
            var_commands="sudo ${@}"
        else
            var_commands=${@}
        fi
    else
        return -1
    fi
    echo -e "Executing: ${DEF_COLOR_YELLOW}${var_commands}${DEF_COLOR_NORMAL} "
    ${var_commands}
    return $?
}
fAskInput()
{
    local var_default_value=""
    local var_msg="value"
    if [[ $# = 1 ]]
    then
        var_default_value=${1}
    elif [[ $# > 1 ]]
    then
        var_default_value=${1}
        var_msg=${2}
    else
        return -1
    fi

    printf "Please enter for ${var_msg}(Default ${var_default_value}):" 1>&2
    read tmp_input
    if test -n "${tmp_input}"
    then
        echo "${tmp_input}"
    elif test -n "${var_default_value}"
    then
        echo "${var_default_value}"
    fi
    return 0
}
###########################################################
## Functions
###########################################################
function fexample()
{
    fPrintHeader ${FUNCNAME[0]}
}
function fWpaCli()
{
    fEval -s wpa_cli -i ${VAR_WLAN_IF} $@
}
function fSetMetric()
{
    local var_metric=""
    if [ $# -gt 0 ]
    then
        local var_metric=${1}
    fi

    while true
    do
        if ip route|grep default |grep ${VAR_WLAN_IF}
        then
            local tmp_cmd=($(ip route|grep default |grep wlan0 | sed "s/metric.*/metric ${var_metric}/g"))
            # sudo ifmetric ${var_metric}
            echo sudo ip route add ${tmp_cmd[@]}
            sudo ip route add ${tmp_cmd[@]}


            # Verify the connection
            # sudo iwconfig ${var_interface}
            # sudo ifconfig wlan0
            break
        else
            echo "Keep checking."
            sleep 1
        fi
    done
}
function fScan()
{
    # fPrintHeader ${FUNCNAME[0]}
    local var_tmp_scan_list='/tmp/.scan_list'
    local search_ssid=""
    if [ $# -gt 0 ]
    then
        search_ssid="$@"
    fi
        echo "Search SSID:${@}"

    fWpaCli scan
    sleep 2
    test -f ${var_tmp_scan_list} && rm ${var_tmp_scan_list}
    fWpaCli scan_result > ${var_tmp_scan_list}

    # cat ${var_tmp_scan_list}
    while IFS= read -r each_line
    do
        if echo ${each_line} |grep 'bssid' > /dev/null
        then
            continue
        fi
        if test -n "${search_ssid}"
        then
            if  echo ${each_line[@]} | grep ${search_ssid} > /dev/null
            then
                echo Found: ${each_line[@]}
                # VAR_TARGET_INFO=( ['bssid']="$(echo ${each_line[@]} | cut -d ' ' -f 1)" ['ssid']="$(echo ${each_line[@]} | cut -d ' ' -f 5)" )
                echo "$(echo ${each_line[@]} | cut -d ' ' -f 1)"
                return 1
            fi
        else
            echo ${each_line[@]}
        fi
    done < ${var_tmp_scan_list}
    test -f ${var_tmp_scan_list} && rm ${var_tmp_scan_list}
}
function fAddProfile_WPA_EAP()
{
    fPrintHeader ${FUNCNAME[0]}

    local var_interface="${VAR_WLAN_IF}"

    local var_ssid="${VAR_WLAN_SSID}"
    local var_bssid="${VAR_WLAN_BSSID}"
    local var_user="${VAR_WLAN_USER}"
    local var_password=""

    if test -z "${VAR_WLAN_PASSWORD}"
    then
        var_password=$(fAskInput ${VAR_WLAN_PASSWORD} "${var_ssid} password ")
    else
        var_password=${VAR_WLAN_PASSWORD}
    fi

    VAR_WLAN_CURRENT_NETWORK_ID=$(sudo wpa_cli -i ${var_interface} add_network)

    sudo wpa_cli -i ${var_interface}<<EOF
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} ssid "${var_ssid}"
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} key_mgmt WPA-EAP
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} eap PEAP
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} identity "${var_user}"
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} password "${var_password}"
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} phase2 "auth=MSCHAPV2"
quit
EOF
    if test -n "${var_bssid}"
    then
        sudo wpa_cli -i ${var_interface}<<EOF
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} bssid ${var_bssid}
quit
EOF
    fi

    sudo wpa_cli -i ${var_interface}<<EOF
enable_network ${VAR_WLAN_CURRENT_NETWORK_ID}
quit
EOF
}
function fAddProfile_WPA_PSK()
{

    local var_interface="${VAR_WLAN_IF}"

    local var_ssid="${VAR_WLAN_SSID}"
    local var_bssid="${VAR_WLAN_BSSID}"
    local var_password=$(fAskInput ${VAR_WLAN_PASSWORD} "${var_ssid} password ")

    VAR_WLAN_CURRENT_NETWORK_ID=$(sudo wpa_cli -i ${var_interface} add_network)

    sudo wpa_cli -i ${var_interface}<<EOF
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} ssid "${var_ssid}"
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} psk "${var_password}"
enable_network ${VAR_WLAN_CURRENT_NETWORK_ID}
quit
EOF

    if test -n "${var_bssid}"
    then
        sudo wpa_cli -i ${var_interface}<<EOF
set_network ${VAR_WLAN_CURRENT_NETWORK_ID} bssid ${var_bssid}
quit
EOF
    fi

    sudo wpa_cli -i ${var_interface}<<EOF
enable_network ${VAR_WLAN_CURRENT_NETWORK_ID}
quit
EOF

}
function fAddProfile()
{
    fPrintHeader ${FUNCNAME[0]}
    case ${VAR_WLAN_TYPE} in
        "WPA_PSK")
            fAddProfile_WPA_PSK
            ;;
        "WPA_EAP")
            fAddProfile_WPA_EAP
            ;;
        *)
            echo "Wrong args, $@"
            return -1
            ;;
    esac
}
function fAll
{
    fPrintHeader ${FUNCNAME[0]}

    fScan ${VAR_WLAN_SSID}
    if [ $? != 1 ]
    then
        echo "AP not found."
        exit 1
    fi
    fAddProfile

    fWpaCli enable_network ${VAR_WLAN_CURRENT_NETWORK_ID}

    sudo dhcpcd ${VAR_WLAN_IF}

    if test -n "${VAR_WLAN_METRIC}"
    then
        fSetMetric "${VAR_WLAN_METRIC}"
    fi
}
## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false
    local var_search_ssid=""
    local var_action="scan"

    # local VAR_WLAN_CURRENT_NETWORK_ID=0

    while [[ $# != 0 ]]
    do
        case $1 in
            # Options
            -i|--interface)
                VAR_WLAN_IF=$2
                shift 1
                ;;
            -t|--type)
                VAR_WLAN_TYPE=$2
                shift 1
                ;;
            -s|--ssid)
                VAR_WLAN_SSID=$2
                shift 1
                ;;
            -c|--config)
                source $2
                shift 1
                ;;
            -m|--metric)
                fSetMetric $2
                exit 0
                ;;
            "all")
                var_action="all"
                ;;
            "add"|"a")
                var_action="add"
                ;;
            "scan"|"s")
                var_action="scan"
                ;;
            "list"|"l")
                var_action="list"
                ;;
            "enable"|"e")
                var_action="enable"
                VAR_WLAN_CURRENT_NETWORK_ID=$2
                shift 1
                ;;
            "remove"|"r")
                var_action="remove"
                VAR_WLAN_CURRENT_NETWORK_ID=$2
                shift 1

                ;;
            -h|--help)
                fHelp
                exit 0
                ;;
            *)
                echo "Unknown Options: ${1}"
                fHelp
                exit 1
                ;;
        esac
        shift 1
    done

    ## Download
    if [ ${flag_verbose} = true ]
    then
        OPTION_VERBOSE=y
        fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi

    case "${var_action}" in
        "all")
            fAll
            ;;
        "add")
            fScan ${VAR_WLAN_SSID}
            if [ $? != 1 ]
            then
                echo "AP not found."
                exit 1
            fi
            fAddProfile
            ;;
        "scan")
            fScan
            ;;
        "list")
            fWpaCli list_network
            ;;
        "enable")
            fWpaCli enable_network ${VAR_WLAN_CURRENT_NETWORK_ID}
            ;;
        "remove")
            fWpaCli remove_network ${VAR_WLAN_CURRENT_NETWORK_ID}
    esac
}

fMain $@
