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
# export VAR_CPU_CNT=$(nproc --all)
export VAR_TIMESTAMP=$(date +%Y%m%d_%H%M%S)

export VAR_ASSIGNED_PIDS=()

###########################################################
## Options
###########################################################
export OPTION_VERBOSE=false
export OPTION_USE_ALT_PS_COMMAND=false
export OPTION_ENABLE_FOCUS_CHECK=false
export OPTION_DEFAULT_PATTERNS=("Renderer" "Safari" "Terminal" "Podcasts" "Messages" "Preview"  "Alacritty") # Default selected patterns
export OPTION_CUSTOM_PATTERNS=()

# Command                   Effect
# taskpolicy -c background  Strongly push to E-cores (low power)
# taskpolicy -c utility     Mildly low priority
# taskpolicy -c maintenance Background system-related tasks
# export OPTION_TASK_POLICY_MODE="background"
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
    printf "    %- 16s\t%s\n" "-v|--verbose" "Enable verbose output, showing more detailed information about script execution and process assignments."
    printf "    %- 16s\t%s\n" "-h|--help" "Display this help message and exit."
    printf "    %- 16s\t%s\n" "--hibernate" "Immediately put the system into hibernate mode (hibernatemode 25) and then sleep."
    printf "    %- 16s\t%s\n" "--sleep" "Immediately put the system into deep sleep mode (hibernatemode 3) and then sleep."
    printf "    %- 16s\t%s\n" "-g|--guardian" "Run the script in battery guardian mode, which automatically manages sleep/hibernate based on time of day and lid status."
    printf "    %- 16s\t%s\n" "-e|--efficiency" "Run the script in efficiency mode, continuously assigning specified processes to efficiency cores."
    printf "    %- 16s\t%s\n" "-r|--restore" "Restore all assigned processes to their normal priority and reset pmset to default sleep mode."
    printf "    %- 16s\t%s\n" "-o|--optimize-settings" "Optimize system settings like PowerNap and TCPKeepAlive for battery efficiency."
    printf "    %- 16s\t%s\n" "-a|--alt-ps" "Use an alternative 'ps' command for broader process detection across all users, useful if default patterns miss processes."
    printf "    %- 16s\t%s\n" "-f|--focus-check" "Enable detection of the frontmost application and assign its PID to efficiency cores, prioritizing the active app. (Currently not supported)"
    printf "    %- 16s\t%s\n" "-p|--patterns <list>" "Set the initial comma-separated list of default process name patterns to monitor (e.g., 'Chrome,Edge'). Overrides built-in defaults."
    printf "    %- 16s\t%s\n" "-c|--custom-patterns <list>" "Add custom comma-separated process name patterns to the existing list (e.g., 'MyGame,AnotherApp'). These are appended to default patterns."
    printf "    %- 16s\t%s\n" "Current Default Patterns" "${OPTION_DEFAULT_PATTERNS[*]}"
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
    printf "##    %s\t: %- 16s\n" "Use Alt PS Command" "${OPTION_USE_ALT_PS_COMMAND}"
    printf "##    %s\t: %- 16s\n" "Enable Focus Check" "${OPTION_ENABLE_FOCUS_CHECK}"
    printf "##    %s\t: %- 16s\n" "Default Patterns" "${OPTION_DEFAULT_PATTERNS[*]}"
    printf "##    %s\t: %- 16s\n" "Custom Patterns" "${OPTION_CUSTOM_PATTERNS[*]}"
    printf "###########################################################\n"
}
fParsePatterns()
{

        echo ${@}
    local input_string="${1}"
    local array_var_name="${2}" # The name of the array variable to modify

    # Create a temporary array to hold the parsed elements
    local temp_array=()
    IFS=',' read -r -a temp_array <<< "${input_string}"

    # Construct the command to assign the temporary array to the target array variable
    # This approach uses eval to set the array by name, ensuring elements with spaces and special characters are handled correctly.
    local assign_cmd="${array_var_name}=("
    for item in "${temp_array[@]}"; do
        # Use printf %q to safely quote each item for shell re-evaluation.
        # This handles spaces, quotes, and other special characters within the item.
        local escaped_item=$(printf %q "${item}")
        assign_cmd+="${escaped_item} "
    done
    assign_cmd+=")"

    # Execute the assignment command. This will modify the array variable
    # whose name was passed as the second argument.
    eval "${assign_cmd}"
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
fSleepUntil()
{
    # Input: HH:MM:SS , 16:32:23, sleep to next 16:32:23.
    local target_time_str="${1}"
    local current_timestamp=$(date +%s)
    local target_hour=$(echo "${target_time_str}" | cut -d':' -f1)
    local target_minute=$(echo "${target_time_str}" | cut -d':' -f2)
    local target_second=$(echo "${target_time_str}" | cut -d':' -f3)

    # Get today's date
    local today_date=$(date +%Y%m%d)

    # Calculate target timestamp for today
    local target_timestamp_today=$(date -j -f "%Y%m%d %H:%M:%S" "${today_date} ${target_hour}:${target_minute}:${target_second}" +%s 2>/dev/null)

    if [[ -z "${target_timestamp_today}" ]]; then
        echo "Error: Invalid time format. Please use HH:MM:SS."
        return 1
    fi

    local sleep_seconds=$((target_timestamp_today - current_timestamp))

    # If target time is in the past, calculate for tomorrow
    if [[ ${sleep_seconds} -le 0 ]]; then
        local tomorrow_date=$(date -v+1d +%Y%m%d)
        local target_timestamp_tomorrow=$(date -j -f "%Y%m%d %H:%M:%S" "${tomorrow_date} ${target_hour}:${target_minute}:${target_second}" +%s 2>/dev/null)
        if [[ -z "${target_timestamp_tomorrow}" ]]; then
            echo "Error: Could not calculate tomorrow's timestamp."
            return 1
        fi
        sleep_seconds=$((target_timestamp_tomorrow - current_timestamp))
    fi

    if [[ ${sleep_seconds} -gt 0 ]]; then
        echo "Sleeping until ${target_time_str} (for ${sleep_seconds} seconds)..."
        fSleepSeconds "${sleep_seconds}"
    else
        echo "Target time is already passed and cannot be reached today or tomorrow."
    fi
    return 0
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

## Get Functions
###########################################################
function fGetLidStatus()
{
    if ioreg -r -k AppleClamshellState -d 1 | grep -q '"AppleClamshellState" = Yes'; then
        echo "closed"
    else
        echo "open"
    fi
}
## Functions
###########################################################
function fexample()
{
    fPrintHeader ${FUNCNAME[0]}

}
function fHibernate()
{
    local timestamp=$(date "+%H:%M")
    echo "[$timestamp] Setting to hibernate mode."
    sudo pmset -b hibernatemode 25
    sleep 1
    sudo pmset sleepnow

    # sleep after 10 minutes, before setting it back.
    echo wiat for restore settings.
    sleep 60
    local timestamp=$(date "+%H:%M")
    echo "[$timestamp] Rollback to default mode."
    sudo pmset -b hibernatemode 3
}
function fDeepSleep()
{
    local timestamp=$(date "+%H:%M")
    echo "[$timestamp] Setting to hibernate mode."
    sudo pmset -b hibernatemode 3
    sleep 1
    sudo pmset sleepnow
}
function fOptimizeSettings()
{
    fPrintHeader ${FUNCNAME[0]}
    
    echo "Checking powernap and tcpkeepalive settings..."

    # Check and set ttyskeepawake
    local ttyskeepawake_status=$(pmset -g | grep "ttyskeepawake" | awk '{print $2}')
    if [[ "${ttyskeepawake_status}" == "1" ]]; then
        echo "ttyskeepawake is enabled. Disabling..."
        fEval "sudo pmset -b ttyskeepawake 0"
    else
        echo "ttyskeepawake is already disabled."
    fi

    # Check and set womp
    local womp_status=$(pmset -g | grep "womp" | awk '{print $2}')
    if [[ "${womp_status}" == "1" ]]; then
        echo "womp is enabled. Disabling..."
        fEval "sudo pmset -b womp 0"
    else
        echo "womp is already disabled."
    fi

    # Check and set networkoversleep
    local networkoversleep_status=$(pmset -g | grep "networkoversleep" | awk '{print $2}')
    if [[ "${networkoversleep_status}" == "1" ]]; then
        echo "networkoversleep is enabled. Disabling..."
        fEval "sudo pmset -b networkoversleep 0"
    else
        echo "networkoversleep is already disabled."
    fi

    # Check powernap
    local powernap_status=$(pmset -g | grep "powernap" | awk '{print $2}')
    if [[ "${powernap_status}" == "1" ]]; then
        echo "PowerNap is enabled. Disabling for battery mode..."
        fEval "sudo pmset -b powernap 0"
    else
        echo "PowerNap is already disabled."
    fi

    # Check tcpkeepalive
    local tcpkeepalive_status=$(pmset -g | grep "tcpkeepalive" | awk '{print $2}')
    if [[ "${tcpkeepalive_status}" == "1" ]]; then
        echo "TCPKeepAlive is enabled. Disabling for battery mode..."
        fEval "sudo pmset -b tcpkeepalive 0"
    else
        echo "TCPKeepAlive is already disabled."
    fi
    fEval "sudo pmset -g custom"
}
function fStartEfficiencyScript()
{
    fPrintHeader ${FUNCNAME[0]}

    local sleep_time=50

    # put script to background script.
    echo "Setting current script ($$) to efficiency cores."
    fEval "taskpolicy -b -p $$"
    echo "sent $$ bash"

    local timestamp=$(date "+%H:%M")
    echo "[$timestamp] Check on new spawn process."

    local ps_command=""
    if ${OPTION_USE_ALT_PS_COMMAND}; then
        ps_command="ps aux | grep -v grep | grep -v GPU | awk '\$1!=\"root\" && \$1!=\"Apple\" && \$1 !~ /^_/{ print \$2 }'"
    else
        local combined_patterns=("${OPTION_DEFAULT_PATTERNS[@]}" "${OPTION_CUSTOM_PATTERNS[@]}")
        local regex=$(IFS='|'; echo "${combined_patterns[*]}")
        ps_command="ps aux | grep -E '${regex}' | grep -v grep | grep -v GPU | grep -v server | awk '{print \$2}'"
    fi

    if [ "${OPTION_VERBOSE}" = 'y' ]; then
        echo "Executing ps command: ${ps_command}"
    fi

    # Main loop: monitor processes based on selected modes
    for pid in $(eval ${ps_command}); do
        if [[ ! " ${VAR_ASSIGNED_PIDS[@]} " =~ " ${pid} " ]]; then
            fEval "taskpolicy -b -p ${pid}"
            local full_path=$(ps -p ${pid} -o comm=)
            local process_name=$(echo "$full_path" | sed -E 's#.*/([^/]*\.app)/.*MacOS/##')
            if [ "${OPTION_VERBOSE}" = 'y' ]; then
                echo "Assigned '${process_name}' (PID ${pid}) to efficiency cores"
            fi
            VAR_ASSIGNED_PIDS+=(${pid})
        fi
    done

    # If Minecraft/Java detection is enabled, append relevant logic
    if ${OPTION_ENABLE_FOCUS_CHECK}; then
        local front_pid=$(osascript -e 'tell application "System Events" to get unix id of first process whose frontmost is true')

        if [[ -n "$front_pid" ]]; then
            echo "Frontmost process PID: $front_pid"
            echo "Sending PID $front_pid to efficiency cores."
            fEval "taskpolicy -b -p \"$front_pid\""
        else
            echo "Could not get frontmost application PID."
            # exit 1 # Do not exit, just log
        fi
    fi

}
function fStartEfficiencyScriptLoop()
{
    fPrintHeader ${FUNCNAME[0]}

    # 10 minutes.
    local sleep_time=600

    echo "Setting current script ($$) to efficiency cores."
    fEval "taskpolicy -b -p $$"
    echo "sent $$ bash"

    while true; do
        local timestamp=$(date "+%H:%M")
        echo "[$timestamp] Check on new spawn process."

        # local ps_command=""
        # if ${OPTION_USE_ALT_PS_COMMAND}; then
        #     ps_command="ps aux | grep -v grep | grep -v GPU | awk '\$1!=\"root\" && \$1!=\"Apple\" && \$1 !~ /^_/{ print \$2 }'"
        # else
        #     local combined_patterns=("${OPTION_DEFAULT_PATTERNS[@]}" "${OPTION_CUSTOM_PATTERNS[@]}")
        #     local regex=$(IFS='|'; echo "${combined_patterns[*]}")
        #     ps_command="ps aux | grep -E '${regex}' | grep -v grep | grep -v GPU | grep -v server | awk '{print \$2}'"
        # fi
        #
        # if [ "${OPTION_VERBOSE}" = 'y' ]; then
        #     echo "Executing ps command: ${ps_command}"
        # fi
        #
        # # Main loop: monitor processes based on selected modes
        # for pid in $(eval ${ps_command}); do
        #     if [[ ! " ${VAR_ASSIGNED_PIDS[@]} " =~ " ${pid} " ]]; then
        #         [[ $sleep_time -gt 200 ]] && sleep_time=$((sleep_time - 46))
        #         [[ $sleep_time -gt 90 ]]  && sleep_time=$((sleep_time - 19))
        #         [[ $sleep_time -gt 15 ]]  && sleep_time=$((sleep_time - 3))
        #         fEval "taskpolicy -b -p ${pid}"
        #         local full_path=$(ps -p ${pid} -o comm=)
        #         local process_name=$(echo "$full_path" | sed -E 's#.*/([^/]*\.app)/.*MacOS/##')
        #         echo "Assigned '${process_name}' (PID ${pid}) to efficiency cores"
        #         VAR_ASSIGNED_PIDS+=(${pid})
        #     fi
        # done
        #
        # # If Minecraft/Java detection is enabled, append relevant logic
        # if ${OPTION_ENABLE_FOCUS_CHECK}; then
        #     local front_pid=$(osascript -e 'tell application "System Events" to get unix id of first process whose frontmost is true')
        #
        #     if [[ -n "$front_pid" ]]; then
        #         echo "Frontmost process PID: $front_pid"
        #         echo "Sending PID $front_pid to efficiency cores."
        #         fEval "taskpolicy -b -p \"$front_pid\""
        #     else
        #         echo "Could not get frontmost application PID."
        #         # exit 1 # Do not exit, just log
        #     fi
        # fi
        fStartEfficiencyScript

        echo "Current sleep time: $sleep_time seconds"
        # echo -e "\\n\\n"
        sleep $sleep_time
    done
}
function fRestoreEfficiencyScript()
{
    fPrintHeader ${FUNCNAME[0]}

    local timestamp=$(date "+%H:%M")
    echo "[$timestamp] restore to normal mode."

    # restore it? or with commands.
    # Main loop: monitor processes based on selected modes
    for pid in ${VAR_ASSIGNED_PIDS[@]}; do
        fEval "taskpolicy -B -p ${pid}"
        local full_path=$(ps -p ${pid} -o comm=)
        local process_name=$(echo "$full_path" | sed -E 's#.*/([^/]*\.app)/.*MacOS/##')
        if [ "${OPTION_VERBOSE}" = 'y' ]; then
            echo "Restore '${process_name}' (PID ${pid}) to user initiated mode."
        fi
    done
}

function fBatteryGuardian()
{
    fPrintHeader ${FUNCNAME[0]}

    # Customizable time ranges
    local VAR_HIBERNATE_START_HOUR=0
    local VAR_HIBERNATE_END_HOUR=8 # Exclusive, so up to 06:59
    local VAR_SLEEP_UNTIL_NEXT_HOUR_START_HOUR=8
    local VAR_SLEEP_UNTIL_NEXT_HOUR_END_HOUR=24 # Exclusive, so up to 23:59
    local VAR_DEFAULT_SLEEP_SECONDS=3600 # Default sleep for an hour
    local VAR_WORKING_SLEEP_SECONDS=600 # Default sleep for an hour

    # initial sleep time.
    local sleep_time=5
    echo "Starting battery guardian."

    while true; do
        local timestamp=$(date "+%H:%M")
        local current_hour=$(date +%H)
        echo "[${timestamp}] new loop start."

        # Check what time it is.
        if [[ ${current_hour} -ge ${VAR_HIBERNATE_START_HOUR} && ${current_hour} -lt ${VAR_HIBERNATE_END_HOUR} ]]; then
            echo "[$timestamp] It's between ${VAR_HIBERNATE_START_HOUR}:00 and $((VAR_HIBERNATE_END_HOUR-1)):59. Initiating hibernate."
            local lid_status=$(fGetLidStatus)
            ## Long term hibernate.
            if [[ "${lid_status}" == "closed" ]]; then
                fHibernate
            else
                echo "[$timestamp] Lid is open. Skipping hibernate."
            fi
            # next wake up.
            sleep_time=$VAR_DEFAULT_SLEEP_SECONDS # After hibernate, wait for an hour before checking again
        elif [[ ${current_hour} -ge ${VAR_SLEEP_UNTIL_NEXT_HOUR_START_HOUR} && ${current_hour} -lt ${VAR_SLEEP_UNTIL_NEXT_HOUR_END_HOUR} ]]; then
            echo "[$timestamp] It's between ${VAR_SLEEP_UNTIL_NEXT_HOUR_START_HOUR}:00 and $((VAR_SLEEP_UNTIL_NEXT_HOUR_END_HOUR-1)):59. Working hour."
            # Working Stand by mode.
            if [[ "${lid_status}" == "closed" ]]; then
                echo "[$timestamp] Lid is closed."
            else
                echo "[$timestamp] Lid is open. Do efficent script."
                fStartEfficiencyScript
            fi

            # next wake up.
            sleep_time=$VAR_WORKING_SLEEP_SECONDS # wait for an hour before checking again
        else
            echo "[$timestamp] Current hour is ${current_hour}. Default sleep."
            sleep_time=${VAR_DEFAULT_SLEEP_SECONDS}
        fi

        echo "Current sleep time: ${sleep_time} seconds"
        sleep ${sleep_time}
    done
}

function fCleanupAndExit() {
    echo -e "\n${DEF_COLOR_YELLOW}Ctrl+C detected. Restoring processes to normal mode...${DEF_COLOR_NORMAL}"
    fRestoreEfficiencyScript
    echo "Restore pmset to sleep mode."
    sudo pmset -b hibernatemode 3
    echo "End of script."
    exit 0
}

## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false
    local flag_mode='guardian'

    trap fCleanupAndExit SIGINT

    while [[ $# != 0 ]]
    do
        case $1 in
            # Options
            -v|--verbose)
                flag_verbose=true
                ;;
            -h|--help)
                fHelp
                exit 0
                ;;
            --hibernate)
                fHibernate
                exit 0
                ;;
            --sleep)
                fDeepSleep
                exit 0
                ;;
            -g|--gurdian)
                flag_mode='gurdian'
                ;;
            -e|--efficiency)
                flag_mode='efficiency'
                ;;
            -r|--restore)
                flag_mode='normal'
                ;;
            -o|--optimize-settings)
                fOptimizeSettings
                exit 0
                ;;
            -a|--alt-ps)
                OPTION_USE_ALT_PS_COMMAND=true
                ;;
            -f|--focus-check)
                echo "Know we don't support it."
                # OPTION_ENABLE_FOCUS_CHECK=true
                ;;
            -p|--patterns)
                shift 1
                fParsePatterns "${1}" OPTION_DEFAULT_PATTERNS
                ;;
            -c|--custom-patterns)
                shift 1
                fParsePatterns "${1}" OPTION_CUSTOM_PATTERNS
                ;;
            *)
                echo "Unknown Options: ${1}"
                fHelp
                exit 1
                ;;
        esac
        shift 1
    done

    # Check if the script is run as root
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run with sudo or as root."
        exit 1
    fi

    if [ ${flag_verbose} = true ]
    then
        OPTION_VERBOSE=y
        fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi

    if [ ${flag_mode} = 'efficiency' ]
    then
        fStartEfficiencyScriptLoop; fErrControl ${FUNCNAME[0]} ${LINENO}
    elif [ ${flag_mode} = 'guardian' ]
    then
        fBatteryGuardian; fErrControl ${FUNCNAME[0]} ${LINENO}
    elif [ ${flag_mode} = 'normal' ]
    then
        fRestoreEfficiencyScript; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi
}

fMain "$@"
