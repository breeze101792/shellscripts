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

###########################################################
## Options
###########################################################
export OPTION_VERBOSE=false

###########################################################
## Options
###########################################################
export ARG_PROGRAM_NAME="Config"
export ARG_CONFIG_DESCRIPTION_FILE=""
export ARG_CONFIG_TEMPLATE_PATH=""
export ARG_TARGET_PATH=""
export ARG_TARGET_CONFIG_NAME=""

# test -z "${ARG_CONFIG_DESCRIPTION_FILE}" && export ARG_CONFIG_DESCRIPTION_FILE="alacritty"
# test -z "${ARG_CONFIG_TEMPLATE_PATH}"    && export ARG_CONFIG_TEMPLATE_PATH="./alacritty.toml"
# test -z "${ARG_TARGET_PATH}"             && export ARG_TARGET_PATH="${HOME}/.config/alacritty/"
# test -z "${ARG_TARGET_CONFIG_NAME}"      && export ARG_TARGET_CONFIG_NAME="alacritty.toml"

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
    printf "    %s\n" "run test: ${VAR_SCRIPT_NAME} -d alacritty"
    echo "[Options]"
    printf "    %- 16s\t%s\n" "-d|--description" "Description file for setup config."
    printf "    %- 16s\t%s\n" "-c|--config-file" "Specify config template path."
    printf "    %- 16s\t%s\n" "-t|--target" "Specify target config path."
    printf "    %- 16s\t%s\n" "-n|--name" "Specify target config name."
    printf "    %- 16s\t%s\n" "-h|--help" "Print helping"
}
fInfo()
{
    local var_title_pading""

    fPrintHeader ${FUNCNAME[0]}
    printf "===========================================================\n"
    printf "==  Vars\n"
    printf "===========================================================\n"
    printf "==    %- 28s\t: %- 16s\n" "Script" "${VAR_SCRIPT_NAME}"
    printf "===========================================================\n"
    printf "==  Path\n"
    printf "===========================================================\n"
    printf "==    %- 28s\t: %- 16s\n" "Working Path" "${PATH_ROOT}"
    printf "===========================================================\n"
    printf "==  Options\n"
    printf "===========================================================\n"
    printf "==    %- 28s\t: %- 16s\n" "Verbose" "${OPTION_VERBOSE}"
    printf "===========================================================\n"
    printf "==  Args\n"
    printf "===========================================================\n"
    printf "==    %- 28s\t: %- 16s\n" "ARG_CONFIG_DESCRIPTION_FILE" "${ARG_CONFIG_DESCRIPTION_FILE}"
    printf "==    %- 28s\t: %- 16s\n" "ARG_CONFIG_TEMPLATE_PATH" "${ARG_CONFIG_TEMPLATE_PATH}"
    printf "==    %- 28s\t: %- 16s\n" "ARG_TARGET_PATH" "${ARG_TARGET_PATH}"
    printf "==    %- 28s\t: %- 16s\n" "ARG_TARGET_CONFIG_NAME" "${ARG_TARGET_CONFIG_NAME}"
    printf "===========================================================\n"
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
###########################################################
## Functions
###########################################################
function fexample()
{
    fPrintHeader ${FUNCNAME[0]}

}

function fSetup()
{
    fPrintHeader ${FUNCNAME[0]}
    var_root_path=${PATH_ROOT}
    var_template_file="${PATH_ROOT}/${ARG_CONFIG_TEMPLATE_PATH}"
    if test -e "${var_template_file}"; then
        var_template_file="${var_template_file}"
    else
        echo "Config file not exist. ${var_template_file}"
        exit 1
    fi

    if ! test -d "${ARG_TARGET_PATH}"; then
        mkdir "${ARG_TARGET_PATH}" || $(echo "Can't create ${ARG_TARGET_PATH}"; exit 1)
    fi

    echo "Check ${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}"
    if test -e "${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}" || test -L "${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}"; then
        printf "%s exist, overwrite it?(y/N)" "${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}"
        read var_ans
        if [ "${var_ans}" = "y" ]; then
            # backup
            mv "${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}" "${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}_backup_$(date +%s)"

            echo "Overwrite ${ARG_TARGET_CONFIG_NAME}"
            fEval ln -sf "${var_template_file}" "${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}"
        else
            echo "Ignore settings."
        fi
    else
        fEval ln -s "${var_template_file}" "${ARG_TARGET_PATH}/${ARG_TARGET_CONFIG_NAME}"
    fi

    echo -e "${DEF_COLOR_GREEN}!!! ${ARG_PROGRAM_NAME} Setup finished. !!!${DEF_COLOR_NORMAL}"

}
## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=true

    # 1st parse
    while [[ "$#" != 0 ]]; do
        case $1 in
            -d | --description)
                if test -f "${2}"; then
                    ARG_CONFIG_DESCRIPTION_FILE="${2}"
                    source "${ARG_CONFIG_DESCRIPTION_FILE}"
                    shift 1
                elif test -f "${2}/setup.conf"; then
                    ARG_CONFIG_DESCRIPTION_FILE="${2}/setup.conf"
                    source "${ARG_CONFIG_DESCRIPTION_FILE}"
                    shift 1
                else
                    echo "Please specify setup.conf."
                fi
                ;;
            *)
                # skip 
                break
                ;;
        esac
        shift 1
    done

    # 2nd parse
    while [[ "$#" != 0 ]]; do
        case $1 in
            -c | --config-file)
                if test -e "${2}"; then
                    ARG_CONFIG_TEMPLATE_PATH="${2}"
                    shift 1
                fi
                ;;
            -t | --target)
                if test -d "${2}"; then
                    ARG_TARGET_PATH="${2}"
                    shift 1
                fi
                ;;
            -n | --name)
                if test -n "${2}"; then
                    ARG_TARGET_CONFIG_NAME="${2}"
                    shift 1
                fi
                ;;
            -h | --help)
                fHelp
                exit 0
                ;;
            *)
                echo "Wrong args, $@"
                exit 1
                ;;
        esac
        shift 1
    done

    ## Download
    if [ ${flag_verbose} = true ]; then
        OPTION_VERBOSE=y
        fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi

    fSetup; fErrControl ${FUNCNAME[0]} ${LINENO}
}

fMain $@
