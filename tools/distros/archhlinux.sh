#!/bin/bash
###########################################################
## Vars
###########################################################
export VAR_SCRIPT_NAME="$(basename ${BASH_SOURCE[0]%=.})"
export VAR_CPU_CNT=$(nproc --all)

export VAR_PKG_LIST=("")

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
function fpacman_init()
{
    fPrintHeader ${FUNCNAME[0]}
    pacman-key --init
    pacman-key --populate
    pacman -Sy archlinux-keyring

}
function flocalegen()
{
    fPrintHeader ${FUNCNAME[0]}
    sudo sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g"
    sudo locale.gen
}
function fpkg_basic()
{
    fPrintHeader ${FUNCNAME[0]}
    VAR_PKG_LIST+=("sudo")
    VAR_PKG_LIST+=("vim")
    VAR_PKG_LIST+=("tmux")
    VAR_PKG_LIST+=("openssh")
    VAR_PKG_LIST+=("zsh")

    VAR_PKG_LIST+=("base-devl")
    VAR_PKG_LIST+=("bc")
    VAR_PKG_LIST+=("dhcpcd")
    VAR_PKG_LIST+=("git")
    VAR_PKG_LIST+=("pkgfile")
    VAR_PKG_LIST+=("screen")
}
function fpkg_dev()
{
    VAR_PKG_LIST+=("python")
    VAR_PKG_LIST+=("rustup")
    VAR_PKG_LIST+=("cscope")
    VAR_PKG_LIST+=("ctags")
    VAR_PKG_LIST+=("virtualenv")
}
function fpkg_tools()
{
    # VAR_PKG_LIST+=("cppcheck")
    VAR_PKG_LIST+=("aria2")
    VAR_PKG_LIST+=("cscope")
    VAR_PKG_LIST+=("ctags")
    VAR_PKG_LIST+=("gzip")
    VAR_PKG_LIST+=("inetutils")
    VAR_PKG_LIST+=("nmap")
    VAR_PKG_LIST+=("p7zip-full")
    VAR_PKG_LIST+=("wget")
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
    sudo pacman -Syy
    echo "Install following pkgs: ${VAR_PKG_LIST[@]}"
    sudo pacman S ${VAR_PKG_LIST[@]}
}
## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false
    local flag_pkg_install=false
    local var_pkg_type=""

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
