#!/bin/bash
###########################################################
## DEF
###########################################################
export DEF_COLOR_RED='\033[0;31m'
export DEF_COLOR_YELLOW='\033[0;33m'
export DEF_COLOR_GREEN='\033[0;32m'
export DEF_COLOR_NORMAL='\033[0m'

# --- Configuration ---
export DEF_IDLE_MINUTES=10          # Suspend if idle for this many minutes
export DEF_CHECK_INTERVAL=20        # How often to check (seconds)
export DEF_CPU_THRESHOLD=20          # % CPU usage to be considered "idle"
export DEF_NET_THRESHOLD=100000      # 100 KBytes sent+received to be considered "idle"
export DEF_INPUT_IDLE_THRESHOLD_MS=300000 # Milliseconds of input idle time to be considered "idle" (5 minutes)
export DEF_LOG_FILE="/tmp/auto_suspend.log"

###########################################################
## Vars
###########################################################
export VAR_SCRIPT_NAME="$(basename ${BASH_SOURCE[0]%=.})"
export VAR_CPU_CNT=$(nproc --all)
export VAR_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
export VAR_IFACE=""                 # Will be selected by user
export VAR_LAST_SSH_COUNT=0
export VAR_MAX_IDLE_CHECKS=0

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
    printf "    %s\n" "run script: .sh -v"
    echo "[Options]"
    printf "    %- 16s\t%s\n" "-v|--verbose" "Print in verbose mode"
    printf "    %- 16s\t%s\n" "-i|--idle-minutes" "Suspend if idle for this many minutes (default: ${DEF_IDLE_MINUTES})"
    printf "    %- 16s\t%s\n" "-c|--check-interval" "How often to check in seconds (default: ${DEF_CHECK_INTERVAL})"
    printf "    %- 16s\t%s\n" "-p|--cpu-threshold" "% CPU usage to be considered \"idle\" (default: ${DEF_CPU_THRESHOLD})"
    printf "    %- 16s\t%s\n" "-n|--net-threshold" "Bytes sent+received to be considered \"idle\" (default: ${DEF_NET_THRESHOLD})"
    printf "    %- 16s\t%s\n" "-x|--input-threshold" "Milliseconds of input idle time to be considered \"idle\" (default: ${DEF_INPUT_IDLE_THRESHOLD_MS})"
    printf "    %- 16s\t%s\n" "-h|--help" "Print helping"
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

# --- Logging functions ---
fLogDebug() {
    if [[ "$OPTION_VERBOSE" == true ]]; then
        echo "[DEBUG] $1"
    fi
}

fLog() {
    local message="$1"
    echo "$(date): $message" >> "$DEF_LOG_FILE"
}

# --- Select interface function ---
fSelectInterface() {
    local interfaces=($(ls /sys/class/net | grep -v lo))
    if [[ ${#interfaces[@]} -eq 1 ]]; then
        VAR_IFACE="${interfaces[0]}"
        echo "Only one network interface found: $VAR_IFACE. Auto-selecting."
        fLogDebug "Monitoring interface set to: $VAR_IFACE (auto-selected)"
    else
        echo "Available network interfaces:"
        for i in "${!interfaces[@]}"; do
            echo "  [$i] ${interfaces[$i]}"
        done
        read -p "Select the number of the interface to monitor: " idx
        VAR_IFACE="${interfaces[$idx]}"
        echo "Selected interface: $VAR_IFACE"
        fLogDebug "Monitoring interface set to: $VAR_IFACE"
    fi
}

# --- Helper: CPU usage ---
fGetCpuUsage() {
    local usage=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk '{print 100 - $8}')
    echo "$usage"
}

# --- Helper: Network usage ---
fGetNetworkUsage() {
    local RX1=$(cat /sys/class/net/$VAR_IFACE/statistics/rx_bytes)
    local TX1=$(cat /sys/class/net/$VAR_IFACE/statistics/tx_bytes)
    sleep 1
    local RX2=$(cat /sys/class/net/$VAR_IFACE/statistics/rx_bytes)
    local TX2=$(cat /sys/class/net/$VAR_IFACE/statistics/tx_bytes)
    local total=$(( (RX2 - RX1) + (TX2 - TX1) ))
    echo "$total"
}

# --- Helper: SSH session count ---
fGetSshUsage() {
    local ssh_count=$(ps -eo comm,args | grep -E "sshd(-session)?:.*@pts" | grep -v grep | wc -l)
    echo "$ssh_count"
}

# --- Helper: Input activity (mouse/keyboard) ---
fGetInputActivity() {
    if command -v xprintidle &> /dev/null; then
        local idle_ms=$(xprintidle)
        echo "$idle_ms"
    else
        fLogDebug "Warning: xprintidle not found. Cannot monitor keyboard/mouse activity."
        echo "999999999"
    fi
}

# --- Idle check function ---
fIsSystemIdle() {
    local logged_in_count=$(who | wc -l)
    local cpu_usage=$(fGetCpuUsage)
    local net_usage=$(fGetNetworkUsage)
    local ssh_count=$(fGetSshUsage)
    local input_idle_time=$(fGetInputActivity)

    fLogDebug "CPU Load: $cpu_usage"
    fLogDebug "Net triffic: $net_usage"
    fLogDebug "Logged-in users: $logged_in_count"
    fLogDebug "SSH session count: $ssh_count"
    fLogDebug "Input idle time: $input_idle_time ms"

    fLog "CPU=${cpu_usage}%, NET=${net_usage}B, USERS=${logged_in_count}, SSH=${ssh_count}, INPUT_IDLE=${input_idle_time}ms"

    # Only update SSH activity state if count changed
    if [[ "$ssh_count" -ne "$VAR_LAST_SSH_COUNT" ]]; then
        ssh_activity_counter=1
        VAR_LAST_SSH_COUNT=$ssh_count
        fLogDebug "SSH activity detected (count changed)."
    else
        ssh_activity_counter=0
        fLogDebug "No SSH activity change for $ssh_activity_counter check(s)."
    fi

    if [[ $(echo "$cpu_usage >= $DEF_CPU_THRESHOLD" | bc) -eq 1 ]]; then
        fLogDebug "Active detect. cpu_usage:$cpu_usage"
    fi
    if [[ $net_usage -ge $DEF_NET_THRESHOLD ]]; then
        fLogDebug "Active detect. net_usage:$net_usage"
    fi
    if [[ $ssh_activity_counter -ne 0 ]]; then
        fLogDebug "Active detect. ssh_activity_counter:$ssh_activity_counter"
    fi
    if [[ $input_idle_time -lt $DEF_INPUT_IDLE_THRESHOLD_MS ]]; then
        fLogDebug "Active detect. input_idle_time:$input_idle_time ms (threshold: $DEF_INPUT_IDLE_THRESHOLD_MS ms)"
    fi

    if [[ $(echo "$cpu_usage < $DEF_CPU_THRESHOLD" | bc) -eq 1 && $net_usage -lt $DEF_NET_THRESHOLD && $ssh_activity_counter -eq 0 && $input_idle_time -ge $DEF_INPUT_IDLE_THRESHOLD_MS ]]; then
        fLogDebug "System is idle."
        return 0
    else
        fLogDebug "System is active."
        return 1
    fi
}

# --- Main logic ---
fMain() {
    local flag_verbose=false
    local arg_idle_minutes=""
    local arg_check_interval=""
    local arg_cpu_threshold=""
    local arg_net_threshold=""
    local arg_input_threshold=""

    while [[ $# != 0 ]]
    do
        case $1 in
            # Options
            -v|--verbose)
                flag_verbose=true
                ;;
            -i|--idle-minutes)
                shift
                arg_idle_minutes="$1"
                ;;
            -c|--check-interval)
                shift
                arg_check_interval="$1"
                ;;
            -p|--cpu-threshold)
                shift
                arg_cpu_threshold="$1"
                ;;
            -n|--net-threshold)
                shift
                arg_net_threshold="$1"
                ;;
            -x|--input-threshold)
                shift
                arg_input_threshold="$1"
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

    if [ "${flag_verbose}" = true ]; then
        OPTION_VERBOSE=true
        fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi

    # Apply arguments if provided
    if [[ -n "$arg_idle_minutes" ]]; then
        DEF_IDLE_MINUTES="$arg_idle_minutes"
    fi
    if [[ -n "$arg_check_interval" ]]; then
        DEF_CHECK_INTERVAL="$arg_check_interval"
    fi
    if [[ -n "$arg_cpu_threshold" ]]; then
        DEF_CPU_THRESHOLD="$arg_cpu_threshold"
    fi
    if [[ -n "$arg_net_threshold" ]]; then
        DEF_NET_THRESHOLD="$arg_net_threshold"
    fi
    if [[ -n "$arg_input_threshold" ]]; then
        DEF_INPUT_IDLE_THRESHOLD_MS="$arg_input_threshold"
    fi

    fLogDebug "Starting auto-suspend idle monitor script..."
    fSelectInterface

    local idle_counter=0
    local ssh_activity_counter=0
    VAR_LAST_SSH_COUNT=$(fGetSshUsage)
    VAR_MAX_IDLE_CHECKS=$((DEF_IDLE_MINUTES * 60 / DEF_CHECK_INTERVAL))

    fLogDebug "Configured to suspend after $DEF_IDLE_MINUTES minutes of idleness."
    if [[ -f "$DEF_LOG_FILE" ]]; then
        rm -f "$DEF_LOG_FILE"
    fi

    if ! command -v xprintidle &> /dev/null; then
        fLogDebug "Warning: xprintidle not found. Please install it."
        return -1
    fi

    while true; do
        fLogDebug "## Running idle check loop... ##"
        if fIsSystemIdle; then
            idle_counter=$((idle_counter + 1))
            fLogDebug "Idle count: $idle_counter / $VAR_MAX_IDLE_CHECKS"
            fLog "Idle check $idle_counter / $VAR_MAX_IDLE_CHECKS"
            if [[ $idle_counter -ge $VAR_MAX_IDLE_CHECKS ]]; then
                fLog "System idle for $DEF_IDLE_MINUTES minutes. Suspending..."
                fLogDebug "Triggering system suspend..."
                echo "System suspend."
                systemctl suspend
                sleep 1
                echo "System wake up."
            fi
        else
            fLogDebug "Resetting idle counter to 0."
            idle_counter=0
        fi
        sleep "$DEF_CHECK_INTERVAL"
    done
}

# --- Run ---
fMain $@
