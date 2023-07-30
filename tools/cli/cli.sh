#!/bin/bash
###########################################################
## Vars
###########################################################
export VAR_SCRIPT_NAME="$(basename ${BASH_SOURCE[0]%=.})"
export VAR_CPU_CNT=$(nproc --all)

## Path
###########################################################
export PATH_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"

## Vars - UI Settings
###########################################################
export VAR_UI_WIDTH_PADDING=4
export VAR_UI_WIDTH=$(($(tput cols) - ${VAR_UI_WIDTH_PADDING} * 2))
export VAR_UI_HEIGT_PADDING=1
export VAR_UI_HEIGT=$(tput lines)

export VAR_UI_MENU_X_START=8
export VAR_UI_MENU_Y_START=20

## Vars - Defines
###########################################################
export DEF_ARROW_UP=KEY_UP
export DEF_ARROW_DOWN=KEY_DOWN
export DEF_ARROW_LEFT=KEY_LEFT
export DEF_ARROW_RIGHT=KEY_RIGHT
export DEF_ENTER=KEY_ENTER
export DEF_ESC=KEY_ESC

###########################################################
## Options
###########################################################
export OPTION_VERBOSE=false

## Vars - Customize Variables
###########################################################
###########################################################
export VAR_MENU_ENTRY=()
export VAR_MENU_FUNCTION=()

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
    printf "    %s\n" "run test: ./${VAR_SCRIPT_NAME}"
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
###########################################################
## Functions
###########################################################

## Control
###########################################################
function fUtil_ClearScreen()
{
    # echo -en "\ec"
    clear
}
function fReset()
{
    fUtil_ClearScreen
    stty sane;
    # Erase in Display: CSI n J
    # if n=0/NA clean all
    # if n=1 clean head to cursor
    # if n=2 clean all
    # if n=3 clean all & move back to scroll buffer
    # echo -en "\ec\e[37;44m\e[J";
    echo -en "\e[37;44m\e[J";
}
function fUtil_Mark()
{
    # show colors with ESC[30;47m
    # 30 is forground. 30-37, 90-97
    # 47 is background. 40-47, 100-107
    echo -en "\e[7m";
}
fUtil_Unmark()
{
    echo -en "\e[27m";
}
# unknown
function fUtil_Draw()
{
    # echo -en "\e%@\e(0";
    # setspecg0             Set G0 special chars. & line set       ^[(0
    echo -en "\e(0";
}
function fUtil_Write()
{
    # setusg0               Set United States G0 character set     ^[(B
    echo -en "\e(B";
}

function fUtil_SetCursor()
{
    local var_row=${1}
    local var_col=${2}
    # Cursor Position: move cursor to n col, m row
    echo -en "\e[${var_row};${var_col}H";
}
function fUtil_ReadKey()
{
    local var_esc=$(echo -en "\e")
    local var_csi=$(echo -en "\e[")

    local var_char=""
    local var_input_buffer=""
    local var_idx=0
    read -s -n 1 var_input_buffer 2>/dev/null >&2

    while [[ ${var_idx} < 3 ]]
    do
        read -t 0.005 -s -n 1 var_char 2>/dev/null >&2
        if [ -n ${var_char} ]
        then
            var_input_buffer="${var_input_buffer}${var_char}"
        else
            break
        fi
        var_idx=$((${var_idx} + 1))
    done

    case ${var_input_buffer} in
        "${var_csi}A")
            printf "${DEF_ARROW_UP}";
            ;;
        "${var_csi}B")
            printf "${DEF_ARROW_DOWN}";
            ;;
        "${var_csi}C")
            printf "${DEF_ARROW_RIGHT}";
            ;;
        "${var_csi}D")
            printf "${DEF_ARROW_LEFT}";
            ;;
        ## Vim Keys
        "k")
            printf "${DEF_ARROW_UP}";
            ;;
        "j")
            printf "${DEF_ARROW_DOWN}";
            ;;
        "l")
            printf "${DEF_ARROW_RIGHT}";
            ;;
        "h")
            printf "${DEF_ARROW_LEFT}";
            ;;
        "q")
            printf "${DEF_ESC}";
            ;;
        "${var_esc}")
            printf "${DEF_ESC}";
            ;;
        "")
            printf "${DEF_ENTER}";
            ;;
        *)
            # printf "Unsupported Key(idx=%d):'%s'" "%{var_idx}" "${var_input_buffer}";
            echo -en "${var_input_buffer}";
            ;;
    esac
}
## Others
###########################################################
function fFinalize() {
    # fUtil_ClearScreen
    # Enable Cursor :CSI?25h
    # Disable Cursor :CSI?25l
    echo -en "\e[?25h"
    echo -en "\ec"

    echo "Terminate script."
    exit 0
}

## Entry
###########################################################
function fFramework_DrawFrame()
{
    fUtil_SetCursor 0 0
    fUtil_Draw
    for each in $(seq 1 $((${VAR_UI_HEIGT} - 1)));do
        printf "\r% ${VAR_UI_WIDTH_PADDING}s% ${VAR_UI_WIDTH}s\n" "x" "x"
    done
    printf "\r% ${VAR_UI_WIDTH_PADDING}s% ${VAR_UI_WIDTH}s" "x" "x"
    fUtil_Write;
}
function fFramework_header()
{
    local header_msg="BASH SELECTION MENU"
    fUtil_Mark;
    fUtil_SetCursor 1 $((${VAR_UI_WIDTH_PADDING} + 1))
    printf "%- $((${VAR_UI_WIDTH} - 1))s" "${header_msg}"
    fUtil_Unmark;
}
function fFramework_footer()
{
    local footer_msg="ENTER - SELECT,NEXT"
    # FOOT;
    fUtil_Mark;
    fUtil_SetCursor ${VAR_UI_HEIGT} $((${VAR_UI_WIDTH_PADDING} + 1))
    printf "%- $((${VAR_UI_WIDTH} - 1))s" "${footer_msg}"
    fUtil_Unmark;
}
function fFramework()
{
    fFramework_DrawFrame
    fFramework_header
    fFramework_footer
}

function fInitialize()
{
    trap fFinalize INT
    # Reset to Initial State
    fUtil_ClearScreen
    # Enable Cursor :CSI?25h
    # Disable Cursor :CSI?25l
    echo -en "\e[?25l"
    # fMainMenu
}
function fEntry()
{
    # fPrintHeader ${FUNCNAME[0]}
    local var_input=""
    local var_menu_sel_idx=1
    local var_menu_cnt=0
    local var_menu_size=0

    local def_x_start=${VAR_UI_MENU_X_START}
    local def_y_start=${VAR_UI_MENU_Y_START}

    fInitialize
    fReset
    fFramework
    while true
    do

        ## Print Menu Item
        var_menu_cnt=0
        fUtil_SetCursor $((${def_x_start} + ${var_menu_cnt})) ${def_y_start}; printf "Char:${var_input}           "; var_menu_cnt=$((${var_menu_cnt} + 1));
        for each_entry in ${VAR_MENU_ENTRY[@]}
        do
            fUtil_SetCursor $((${def_x_start} + ${var_menu_cnt})) ${def_y_start}; printf "${each_entry}           "; var_menu_cnt=$((${var_menu_cnt} + 1));
        done

        ## Mark Menu Item
        var_menu_cnt=0
        if  [[ ${var_menu_cnt} = ${var_menu_sel_idx} ]]
        then
            fUtil_Mark; fUtil_SetCursor $((${def_x_start} + ${var_menu_cnt})) ${def_y_start}; printf "Char:${var_input} "; fUtil_Unmark;
        fi
        for each_entry in ${VAR_MENU_ENTRY[@]}
        do
            var_menu_cnt=$((${var_menu_cnt} + 1))
            if  [[ ${var_menu_cnt} = ${var_menu_sel_idx} ]]
            then
                fUtil_Mark; fUtil_SetCursor $((${def_x_start} + ${var_menu_cnt})) ${def_y_start}; printf "${each_entry} "; fUtil_Unmark;
            fi
        done

        var_menu_size=$((${var_menu_cnt} + 1 ))

        ## Read Key & Move cursor
        var_input="$(fUtil_ReadKey)"
        if [ "${var_input}" = "${DEF_ARROW_UP}" ]
        then
            var_menu_sel_idx=$((${var_menu_sel_idx} - 1))
        elif [ "${var_input}" = "${DEF_ARROW_DOWN}" ]
        then
            var_menu_sel_idx=$((${var_menu_sel_idx} + 1))
        elif [ "${var_input}" = "${DEF_ESC}" ]
        then
            fFinalize
        elif [ "${var_input}" = "${DEF_ENTER}" ]
        then
            var_menu_cnt=0
            if  [[ ${var_menu_cnt} = ${var_menu_sel_idx} ]]
            then
                pass
            fi

            for each_entry_function in ${VAR_MENU_FUNCTION[@]}
            do
                var_menu_cnt=$((${var_menu_cnt} + 1))
                if  [[ ${var_menu_cnt} = ${var_menu_sel_idx} ]]
                then
                    fReset
                    ${each_entry_function}
                    fUtil_Mark
                    printf "ENTER = main menu"
                    fUtil_Unmark
                    fUtil_ReadKey
                fi
            done
            # Redraw frame work for lazy drawing
            fFramework
        fi
        # Loop Cursor
        [[ ${var_menu_sel_idx} -lt 0 ]] && var_menu_sel_idx=$((${var_menu_size} - 1))
        [[ ${var_menu_sel_idx} -ge ${var_menu_size} ]] && var_menu_sel_idx=0

    done
}
## Menu APIs
###########################################################
function fMenu_AddEntry()
{
    if [  $# != 2 ]
    then
        echo "Entry Args not equal to 2:$@"
        fFinalize
    fi
    VAR_MENU_ENTRY+=("${1}")
    VAR_MENU_FUNCTION+=(${2})
}
## SubEntry
###########################################################
function fMenu_DummyEntry()
{
    echo 'test'
}
function fMenu_About()
{
    echo 'About'
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
    fMenu_AddEntry 'date' date
    fMenu_AddEntry 'About' fMenu_About
    fMenu_AddEntry 'Exit' fFinalize
    fEntry
    fUtil_ClearScreen
}

fMain $@
