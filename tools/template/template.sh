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
    printf "    %- 16s\t%s\n" "-v|--verbose" "Print in verbose mode"
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
    local var_commands=""
    local var_quiet_mode=false

    # Parse options for fEval
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -q|--quiet)
                var_quiet_mode=true
                shift
                ;;
            -s|--sudo)
                var_commands="sudo ${@:2}" # Take all remaining arguments as command
                shift $# # Consume all arguments
                break
                ;;
            *)
                var_commands="${@}" # Take all remaining arguments as command
                shift $# # Consume all arguments
                break
                ;;
        esac
    done

    if [[ -z "${var_commands}" ]]; then
        return -1
    fi

    if ! ${var_quiet_mode}; then
        echo -e "Executing: ${DEF_COLOR_YELLOW}${var_commands}${DEF_COLOR_NORMAL} "
    fi
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
fLogInfo()
{
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    printf "[%s][%s] %s\n" "${timestamp}" "${VAR_SCRIPT_NAME}" "${@}"
}
###########################################################
## Functions
###########################################################
function fexample()
{
    fPrintHeader ${FUNCNAME[0]}

}
## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false

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
}

# quote is test it under mac os.
fMain "$@"
