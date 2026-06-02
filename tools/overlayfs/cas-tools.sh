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

export VAR_TARGET_NAME=""
export VAR_BASE_DIR=""
export VAR_OVERLAYFS_WORK_SPACE=""

###########################################################
## Options
###########################################################
export OPTION_VERBOSE=false

###########################################################
## Path
###########################################################
export SCRIPT_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export PATH_ROOT="$(pwd)"
export PATH_CASWS_ROOT="/mnt/casws"
export PATH_OVERLAY_ROOT="${PATH_CASWS_ROOT}/overlay"
export PATH_REFERENCE_ROOT="${PATH_CASWS_ROOT}/reference"
export PATH_WORKSPACE_ROOT="${PATH_CASWS_ROOT}/workspace"

###########################################################
## Utils Functions
###########################################################
fPrintHeader()
{
    local msg=${1}
    printf "###########################################################\n"
    printf "##  %- $((60-4-${#msg}))s  ##\n" "${msg}"
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
## OverlayFS Functions
###########################################################
fHelp()
{
    echo "${VAR_SCRIPT_NAME} — OverlayFS mount helper"
    echo ""
    echo "Directly manage OverlayFS mounts. Creates a writable overlay on top of"
    echo "a read-only base directory using linux overlay filesystem."
    echo ""
    echo "[Subcommands / Actions]"
    echo "  (default)        Mount a new overlay (requires -b and -t)"
    echo "  -l|--list|ls     List all existing overlays under the overlay root"
    echo "  -r|--remove|rm   Unmount and delete overlay(s) — accepts multiple names"
    echo "[Options]"
    printf "    %- 22s%s\n" "-b|--base <dir>" "Base directory (lower layer, read-only)"
    printf "    %- 22s%s\n" "-t|--target-name <name>" "Name of the overlay workspace to create"
    printf "    %- 22s%s\n" "-o|--overlay-root <dir>" "Path to store overlays (default: ${PATH_OVERLAY_ROOT})"
    printf "    %- 22s%s\n" "-v|--verbose" "Print full configuration details before acting"
    printf "    %- 22s%s\n" "-h|--help" "Show this help message"
    echo ""
    echo "[Examples]"
    printf "    %s\n" "  Mount an overlay : ${VAR_SCRIPT_NAME} -b /path/to/base -t my_feature"
    printf "    %s\n" "  List overlays    : ${VAR_SCRIPT_NAME} -l"
    printf "    %s\n" "  Remove overlays  : ${VAR_SCRIPT_NAME} -r feat_a feat_b"
    printf "    %s\n" "  Custom root      : ${VAR_SCRIPT_NAME} -b /src -t dev -o /tmp/overlays"
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
function fof_setup()
{
    # fPrintHeader ${FUNCNAME[0]}

    if ! test -d "${VAR_BASE_DIR}"; then
        echo "Base folder not found! ${VAR_BASE_DIR}"
        exit 1
    fi

    if [ -z "$VAR_TARGET_NAME" ]; then
        echo "Usage: $0 <feature_name>"
        exit 1
    fi

    PATH_OVERLAY_ROOT="$(realpath ${PATH_OVERLAY_ROOT})"
    VAR_BASE_DIR="$(realpath ${VAR_BASE_DIR})"

    # check if empty
    if ! test -d "${PATH_OVERLAY_ROOT}"; then
        mkdir -p "${PATH_OVERLAY_ROOT}"
    fi

    VAR_OVERLAYFS_WORK_SPACE="${PATH_OVERLAY_ROOT}/${VAR_TARGET_NAME}"

}
function fof_create_overlay()
{
    fPrintHeader ${FUNCNAME[0]}

    # VAR_TARGET_NAME=${1}
    # PATH_OVERLAY_ROOT="$(pwd)/overlays"
    # VAR_BASE_DIR="$(pwd)/main"
    # VAR_OVERLAYFS_WORK_SPACE="${PATH_OVERLAY_ROOT}/${VAR_TARGET_NAME}"

    # 1. Create the infrastructure folders
    mkdir -p "${VAR_OVERLAYFS_WORK_SPACE}/upper" "${VAR_OVERLAYFS_WORK_SPACE}/work" "${VAR_OVERLAYFS_WORK_SPACE}/merged"

    # 2. Mount the Overlay
    # Note: This requires sudo
    sudo mount -t overlay overlay \
        -o lowerdir="${VAR_BASE_DIR}",upperdir="${VAR_OVERLAYFS_WORK_SPACE}/upper",workdir="${VAR_OVERLAYFS_WORK_SPACE}/work" \
        "${VAR_OVERLAYFS_WORK_SPACE}/merged"

    ## create scripts.
    #####################################################
    echo "#!/bin/bash" >> ${VAR_OVERLAYFS_WORK_SPACE}/mount.sh
    echo sudo mount -t overlay overlay \
        -o lowerdir="${VAR_BASE_DIR}",upperdir="${VAR_OVERLAYFS_WORK_SPACE}/upper",workdir="${VAR_OVERLAYFS_WORK_SPACE}/work" \
        "${VAR_OVERLAYFS_WORK_SPACE}/merged" >> ${VAR_OVERLAYFS_WORK_SPACE}/mount.sh

    echo "#!/bin/bash" >> ${VAR_OVERLAYFS_WORK_SPACE}/umount.sh
    echo sudo umount "${VAR_OVERLAYFS_WORK_SPACE}/merged" >> ${VAR_OVERLAYFS_WORK_SPACE}/umount.sh

    echo "${VAR_BASE_DIR}" > "${VAR_OVERLAYFS_WORK_SPACE}/$(basename ${VAR_BASE_DIR})"
    #####################################################

    echo "Overlay created at ${VAR_OVERLAYFS_WORK_SPACE}/merged"

    # 3. Enter the merged view and fix the branch
    # cd "${VAR_OVERLAYFS_WORK_SPACE}/merged"
    # We create a new branch so we don't mess up the 'main' branch pointer
    # git checkout -b "overlay/${VAR_TARGET_NAME}"

}
function fof_remove()
{
    for each_target in ${@}; do
        local tmp_merged="${PATH_OVERLAY_ROOT}/${each_target}/merged"
        local tmp_work="${PATH_OVERLAY_ROOT}/${each_target}"
        if ! test -d ${tmp_merged}; then
            echo ${tmp_merged} not found.
            continue
        fi
        if mountpoint -q ${tmp_merged}; then
            # echo umount ${tmp_merged}
            sudo umount ${tmp_merged} || (echo "Umount fail." &&  continue)

        fi

        if ! mountpoint -q ${tmp_merged}; then
            echo "Remove ${each_target} success"
            rm -rf ${tmp_work}
        else
            echo "Remove ${each_target} fail"
        fi
    done
}
## CAS Functions
###########################################################
fCAS_Help()
{
    echo "${VAR_SCRIPT_NAME} — CAS (Content-Addressed Storage) workspace manager"
    echo ""
    echo "High-level workspace tool built on OverlayFS. Manages named workspaces"
    echo "backed by reference snapshots (tags). Each workspace is an isolated"
    echo "overlay where changes are written to an upper layer while the reference"
    echo "remains read-only."
    echo ""
    echo "[Subcommands]"
    printf "    %- 22s%s\n" "new|create [name]" "Create a workspace (uses latest reference if none given)"
    printf "    %- 22s%s\n" "remount" "Re-mount all overlays that have a mount.sh script"
    printf "    %- 22s%s\n" "ls" "List all overlay workspaces"
    printf "    %- 22s%s\n" "ls-tag" "List available reference tags (base snapshots)"
    printf "    %- 22s%s\n" "rm <targets...>" "Unmount and remove workspace overlay(s)"
    printf "    %- 22s%s\n" "overlay|--overlay" "Pass through to raw overlay mode (see -h in that mode)"
    echo "[Options]"
    printf "    %- 22s%s\n" "-r|--reference <tag>" "Reference tag to use as base (default: most recent)"
    printf "    %- 22s%s\n" "-v|--verbose" "Print full configuration details before acting"
    printf "    %- 22s%s\n" "-h|--help" "Show this help message"
    echo ""
    echo "[Paths]"
    printf "    %- 22s%s\n" "overlay root" "${PATH_OVERLAY_ROOT}"
    printf "    %- 22s%s\n" "reference root" "${PATH_REFERENCE_ROOT}"
    printf "    %- 22s%s\n" "workspace root" "${PATH_WORKSPACE_ROOT}"
    echo ""
    echo "[Examples]"
    printf "    %s\n" "  Create workspace  : ${VAR_SCRIPT_NAME} new my_fix"
    printf "    %s\n" "  From specific tag : ${VAR_SCRIPT_NAME} create my_fix -r v1.0"
    printf "    %s\n" "  List workspaces   : ${VAR_SCRIPT_NAME} ls"
    printf "    %s\n" "  List tags         : ${VAR_SCRIPT_NAME} ls-tag"
    printf "    %s\n" "  Remove workspace  : ${VAR_SCRIPT_NAME} rm my_fix"
    printf "    %s\n" "  Re-mount all      : ${VAR_SCRIPT_NAME} remount"
}

function fCAS_setup()
{
    PATH_OVERLAY_ROOT="$(realpath ${PATH_OVERLAY_ROOT})"
    PATH_REFERENCE_ROOT="$(realpath ${PATH_REFERENCE_ROOT})"
    PATH_WORKSPACE_ROOT="$(realpath ${PATH_WORKSPACE_ROOT})"
    VAR_SUDO=""

    # check if empty
    if ! test -d "${PATH_OVERLAY_ROOT}"; then
        echo "Creating ${PATH_OVERLAY_ROOT}"
        ${VAR_SUDO} mkdir -p "${PATH_OVERLAY_ROOT}"
    fi
    if ! test -d "${PATH_REFERENCE_ROOT}"; then
        echo "Creating ${PATH_REFERENCE_ROOT}"
        ${VAR_SUDO} mkdir -p "${PATH_REFERENCE_ROOT}"
    fi
    if ! test -d "${PATH_WORKSPACE_ROOT}"; then
        echo "Creating ${PATH_WORKSPACE_ROOT}"
        ${VAR_SUDO} mkdir -p "${PATH_WORKSPACE_ROOT}"
    fi

    if ! test -d "${PATH_CASWS_ROOT}"; then
        echo "We may have not permission to create CASWS(${PATH_CASWS_ROOT})."
    fi

    # we may need this for permission.
    if false; then
        echo "Change permission"
        sudo chgrp users overlay reference workspace
        sudo chmod g+w  overlay reference workspace
    fi

}
## Main Functions
###########################################################
function fOF_Main()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false
    local var_action="overlay"
    local var_target_list=()

    while [[ $# != 0 ]]
    do
        case $1 in
            # Options
            -b|--base)
                VAR_BASE_DIR=$2
                shift 1
                ;;
            -t|--target-name)
                VAR_TARGET_NAME=$2
                shift 1
                ;;
            -o|--overlay-root)
                PATH_OVERLAY_ROOT=$2
                shift 1
                ;;
            -l|--list|ls)
                var_action="list"
                ;;
            -r|--remove|rm)
                shift 1
                var_action="remove"
                var_target_list=($@)
                break
                ;;
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

    if [ "${var_action}" = "overlay" ]; then
        fof_setup
        fof_create_overlay
    elif [ "${var_action}" = "list" ]; then
        ls ${PATH_OVERLAY_ROOT}
    elif [ "${var_action}" = "remove" ]; then
        fof_remove ${var_target_list[@]}
    fi
}

function fCAS_Main()
{
    local flag_verbose=false
    local var_action=""
    local var_target_list=()

    while [[ $# != 0 ]]
    do
        case $1 in
            # Main
            --overlay|overlay)
                fOF_Main $@
                return $?
                ;;
            # Operations
            remount)
                var_action="remount"
                ;;
            ls)
                var_action="list"
                ;;
            ls-tag)
                var_action="list-tag"
                ;;
            rm)
                var_action="remove"
                shift 1
                var_target_list=("${@}")
                break
                ;;
            new|create)
                var_action="create"
                if [[ "${#}" -ge "2" ]] && ! [[ $2 =~ -.* ]]
                then
                    VAR_TARGET_NAME="${2}"
                    shift 1
                else
                    echo "Please specify target"
                    return -1
                fi
                ;;
            # Options
            -r|--reference)
                if test -d "${PATH_REFERENCE_ROOT}/$2"; then
                    VAR_BASE_DIR=${PATH_REFERENCE_ROOT}/$2
                    shift 1
                else
                    echo "${PATH_REFERENCE_ROOT}/$2, not found"
                    return -1
                fi
                ;;
            # -t|--target-name)
            #     VAR_TARGET_NAME=$2
            #     shift 1
            #     ;;
            -v|--verbose)
                flag_verbose=true
                ;;
            -h|--help)
                fCAS_Help
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

    fCAS_setup

    ## Download
    if [ ${flag_verbose} = true ]
    then
        OPTION_VERBOSE=y
        fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi

    if [ "${var_action}" = "remount" ]; then
        for each_cas in $(ls ${PATH_OVERLAY_ROOT}); do
            tmp_each_cas=${PATH_OVERLAY_ROOT}/${each_cas}
            if test -f ${tmp_each_cas}/mount.sh;then
                echo "Re-mount ${each_cas}"
            fi
        done
    elif [ "${var_action}" = "list" ]; then
        ls ${PATH_OVERLAY_ROOT}
    elif [ "${var_action}" = "list-tag" ]; then
        ls ${PATH_REFERENCE_ROOT}
    elif [ "${var_action}" = "remove" ]; then
        # fof_remove ${var_target_list[@]}
        fOF_Main rm ${var_target_list[@]}

        for each_target in ${var_target_list[@]}; do
            local tmp_merged="${PATH_OVERLAY_ROOT}/${each_target}/merged"
            local tmp_link="${PATH_WORKSPACE_ROOT}/${each_target}"

            if test -d ${tmp_merged}; then
                echo ${tmp_merged} not removed.
                continue
            fi

            if ! test -e ${tmp_link}; then
                echo "Remove link ${tmp_link}."
                rm ${tmp_link}
            fi
        done

    elif [ "${var_action}" = "create" ]; then

        if test -z "${VAR_BASE_DIR}"; then
            tmp_file=$(ls -t ${PATH_REFERENCE_ROOT} | head -n 1)
            if test -d "${PATH_REFERENCE_ROOT}/${tmp_file}"; then
                VAR_BASE_DIR=${PATH_REFERENCE_ROOT}/${tmp_file}
            fi
        fi
        if test -z "${VAR_TARGET_NAME}"; then
            echo "No target name found ${VAR_TARGET_NAME}"
            return -1
        elif test -d "${PATH_OVERLAY_ROOT}/${VAR_TARGET_NAME}"; then
            echo "Target exist. ${VAR_TARGET_NAME}"
            return -1
        fi

        fOF_Main

        if test -d "${PATH_OVERLAY_ROOT}/${VAR_TARGET_NAME}/merged"; then
            echo "${VAR_TARGET_NAME} create successfully."
            ln -s "${PATH_OVERLAY_ROOT}/${VAR_TARGET_NAME}/merged" ${PATH_WORKSPACE_ROOT}/${VAR_TARGET_NAME}
        fi
    else
        echo "Unknown actions, ${var_action}"
    fi
}

# quote is test it under mac os.
fCAS_Main "$@"
