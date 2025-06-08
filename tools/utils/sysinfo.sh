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
        echo "${func_name} ${line_num}"
        exit ${ret_var}
    fi
}
fHelp()
{
    echo "${VAR_SCRIPT_NAME}"
    echo "[Example]"
    printf "    %s\n" "${VAR_SCRIPT_NAME} [sys|proc|dmi|cpu|gpu|all]"
    echo "[Options]"
    printf "    %- 16s\t%s\n" "-v|--verbose" "Print in verbose mode"
    printf "    %- 16s\t%s\n" "-h|--help" "Print helping"
}
fInfo()
{
    local var_title_pading""

    fPrintHeader "${FUNCNAME[0]}"
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


# --- BIOS info from /sys ---
fGetBiosSys() {
    fPrintHeader "BIOS Information from /sys/class/dmi/id"
    local SYS_DMI_PATH="/sys/class/dmi/id"

    if [ -d "$SYS_DMI_PATH" ]; then
        for field in bios_vendor bios_version bios_date board_name board_vendor product_name product_version; do
            if [ -f "$SYS_DMI_PATH/$field" ]; then
                echo "$field: $(< "$SYS_DMI_PATH/$field")"
            fi
        done
    else
        echo "DMI path not available: ${SYS_DMI_PATH}"
    fi
    fErrControl ${FUNCNAME[0]} ${LINENO}
}

# --- CPU info from /proc ---
fGetBiosProc() {
    fPrintHeader "CPU Info from /proc/cpuinfo"
    fEval "grep -i 'model name\\|vendor_id\\|flags' /proc/cpuinfo | head -n 10"
    fErrControl ${FUNCNAME[0]} ${LINENO}
}

# --- BIOS info via dmidecode ---
fGetBiosDmidecode() {
    fPrintHeader "BIOS Info from dmidecode"
    if command -v dmidecode &> /dev/null; then
        fEval -s "dmidecode -t bios | grep -E \"Vendor:|Version:|Release Date:\""
    else
        echo "dmidecode not found. Install it with: sudo apt install dmidecode"
    fi
    fErrControl ${FUNCNAME[0]} ${LINENO}
}

# --- CPU info detailed ---
fGetCpuInfo() {
    fPrintHeader "Detailed CPU Info"
    fEval "lscpu"
    echo ""
    echo "Available CPU governors:"
    if command -v cpufreq-info &>/dev/null; then
        fEval "cpufreq-info | grep \"available cpufreq governors\""
    else
        echo "(install cpufrequtils for more info)"
    fi
    fErrControl ${FUNCNAME[0]} ${LINENO}
}

# --- GPU info ---
fGetGpuInfo() {
    fPrintHeader "GPU Info"
    if command -v nvidia-smi &>/dev/null; then
        fEval "nvidia-smi --query-gpu=name,driver_version,power.draw,power.limit --format=csv"
    else
        echo "No NVIDIA GPU or driver. Falling back to lspci..."
        fEval "lspci | grep -i 'vga\\|3d\\|display'"
    fi
    fErrControl ${FUNCNAME[0]} ${LINENO}
}

## Main Functions
###########################################################
function fMain()
{
    local flag_verbose=false
    local var_action=""

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
            sys|proc|dmi|cpu|gpu|all)
                var_action="$1"
                ;;
            *)
                echo "Unknown Options: ${1}"
                fHelp
                exit 1
                ;;
        esac
        shift 1
    done

    if [ "${flag_verbose}" = true ]
    then
        OPTION_VERBOSE=y
        fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi

    case "${var_action}" in
        sys)
            fGetBiosSys
            ;;
        proc)
            fGetBiosProc
            ;;
        dmi)
            fGetBiosDmidecode
            ;;
        cpu)
            fGetCpuInfo
            ;;
        gpu)
            fGetGpuInfo
            ;;
        all|"")
            fGetBiosSys
            echo ""
            fGetBiosProc
            echo ""
            fGetBiosDmidecode
            echo ""
            fGetCpuInfo
            echo ""
            fGetGpuInfo
            ;;
        *)
            echo "Usage: ${VAR_SCRIPT_NAME} [sys|proc|dmi|cpu|gpu|all]"
            exit 1
            ;;
    esac
    fErrControl ${FUNCNAME[0]} ${LINENO}
}

fMain "$@"

