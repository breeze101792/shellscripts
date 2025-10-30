#!/bin/bash
###########################################################
## Vars
###########################################################
export VAR_SCRIPT_NAME="$(basename ${BASH_SOURCE[0]%=.})"
export VAR_CPU_CNT=$(nproc --all)

export VAR_PKG_LIST=("build-essential")

###########################################################
## Options
###########################################################
export OPTION_VERBOSE=false

###########################################################
## Path
###########################################################
export PATH_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"

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
    printf "    %- 16s\t%s\n" "-p|--pkg" "Instal pkg groups, basic/tools/dev/all"
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
###########################################################
## Functions
###########################################################
function fexample()
{
    fPrintHeader ${FUNCNAME[0]}

}
function fapt_init()
{
    fPrintHeader ${FUNCNAME[0]}
    sudo apt install ca-certificates

}
function fpkg_basic()
{
    fPrintHeader ${FUNCNAME[0]}
    VAR_PKG_LIST+=("screen")
    VAR_PKG_LIST+=("tmux")
    VAR_PKG_LIST+=("vim")
    VAR_PKG_LIST+=("nvim")
    # VAR_PKG_LIST+=("dhcpcd")
    # if you want to start this, make sure that not net work conflict
    # VAR_PKG_LIST+=("dhcpcd5")
    # put it to different function.
    # VAR_PKG_LIST+=("openssh-server")
}
function fpkg_dev()
{
    # VAR_PKG_LIST+=("python")
    VAR_PKG_LIST+=("build-essential")
    VAR_PKG_LIST+=("python3-dev")
    VAR_PKG_LIST+=("cscope")
    VAR_PKG_LIST+=("universal-ctags")
    # we use uv.
    # VAR_PKG_LIST+=("virtualenv")
}
function fpkg_tools()
{
    VAR_PKG_LIST+=("nmap")
    VAR_PKG_LIST+=("p7zip-full")
    VAR_PKG_LIST+=("pbzip2")
}
function fpkg_install()
{
    local var_pkg_type=$1
    fPrintHeader ${FUNCNAME[0]}

    case ${var_pkg_type} in
        "basic")
            fpkg_basic
            ;;
        "tools")
            fpkg_tools
            ;;
        "dev")
            fpkg_dev
            ;;
        "all")
            fpkg_basic
            fpkg_tools
            fpkg_dev
            ;;
        *)
            echo "Wrong args, $@"
            return -1
            ;;
    esac
    echo "Update pkg list"
    sudo apt update
    echo "Install following pkgs: ${VAR_PKG_LIST[@]}"
    sudo apt install ${VAR_PKG_LIST[@]}
}
function fdev_install()
{
    local var_pkg_type=$1
    fPrintHeader ${FUNCNAME[0]}

    case ${var_pkg_type} in
        "wpa")
            fpkg_dev_wpa_supplicant
            ;;
        "module")
            fpkg_dev_linux_module
            ;;
        "all")
            fpkg_dev_linux_module
            fpkg_dev_wpa_supplicant
            ;;
        *)
            echo "Wrong args, $@"
            return -1
            ;;
    esac
    # echo "Update pkg list"
    # sudo apt update
    # echo "Install following pkgs: ${VAR_PKG_LIST[@]}"
    # sudo apt install ${VAR_PKG_LIST[@]}
}
function fpkg_dev_wpa_supplicant()
{
    # install library once
    VAR_PKG_LIST+=("install")
    VAR_PKG_LIST+=("libdbus-1-dev")
    VAR_PKG_LIST+=("libnl-genl-3-dev")
    VAR_PKG_LIST+=("libnl-route-3-dev")
    VAR_PKG_LIST+=("libssl-dev")
}
function fpkg_dev_linux_module()
{
    # install wireless module dev
    VAR_PKG_LIST+=("g++ bison flex autoconf")
    VAR_PKG_LIST+=("gcc")
    VAR_PKG_LIST+=("libdbus-1-dev")
    VAR_PKG_LIST+=("libnl-3-dev")
    VAR_PKG_LIST+=("libnl-genl-3-dev")
    VAR_PKG_LIST+=("libnl-route-3-dev")
    VAR_PKG_LIST+=("libssl-dev")
    VAR_PKG_LIST+=("make")
    VAR_PKG_LIST+=("net-tools")
    VAR_PKG_LIST+=("pkg-config")
}
## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false
    local flag_pkg_install=false
    local var_pkg_type=""
    local var_dev_type=""

    while [[ $# != 0 ]]
    do
        case $1 in
            # Options
            -v|--verbose)
                flag_verbose=true
                ;;
            -p|--pkg)
                flag_pkg_install=true
                var_pkg_type=$2
                shift 1
                ;;
            -d|--dev)
                flag_pkg_install=true
                var_pkg_type=$2
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
    if [ ${flag_pkg_install} = true ]
    then
        fpkg_install ${var_pkg_type}; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi
}

fMain $@
