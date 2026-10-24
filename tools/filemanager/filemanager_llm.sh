#!/usr/bin/env bash
export PATH_SCRIPT_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"

export HSFM_NAME="HSFM"
###########################################################
## Flags
###########################################################
test -z ${HSFM_RUNNING} && export HSFM_RUNNING=0
export HSFM_DEBUG=false
export HSFM_PERFORMANCE_DEBUG=false

# Use LS_COLORS to color hsfm.
# (On by default if available)
# (Ignores HSFM_COL1)
export HSFM_LS_COLORS=1

# Show/Hide hidden files on open.
# (On by default)
export HSFM_ENABLE_HIDDEN=1

export HSFM_FILE_PICKER=0

# read dir mode
# def of read mode
export DEF_TERM_READ_DIR_MODE_NONE=0
export DEF_TERM_READ_DIR_MODE_SORT=1
export DEF_TERM_READ_DIR_MODE_LS=2
export DEF_TERM_READ_DIR_MODE_FAST_LS=3
# For mac use, sort by command.
export DEF_TERM_READ_DIR_MODE_LS_SORT=4
export DEF_TERM_READ_DIR_MODE_FIND=10
# FIXME, default use exp to test stabibility
export HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_FAST_LS}

## Env
# this is only work on run time.
export HSFM_ENV_LEFT_HAND_MODE=0

## TERMINAL Args/Size Options
###########################################################
# Terminal Args
export VAR_TERM_READ_ARGS=()
export VAR_TERM_DIR_LS_ARGS=()
export VAR_TERM_FILE_ARGS=""

# Terminal Atrib
export VAR_TERM_HEIGHT=0
export VAR_TERM_WIDTH=0

## Terminal UI control
export VAR_TERM_STATUS_LINE_CNT=2
export VAR_TERM_TAB_LINE_HEIGHT=2

# sub win
export VAR_TERM_SUBWIN_UPPER_SIZE=10
export VAR_TERM_SUBWIN_BOTTOM_SIZE=12

export VAR_TERM_SUBWIN_RIGHT_SIZE=20
export VAR_TERM_SUBWIN_LEFT_SIZE=20

# Main window
export VAR_TERM_MAINWIN_START_IDX=(0 0)
export VAR_TERM_MAINWIN_HEIGHT=0
export VAR_TERM_MAINWIN_WIDTH=0

## TERMINAL Vars
###########################################################
## Tab Line vars
#-----------------
export VAR_TERM_TAB_LINE_IDX=0
export VAR_TERM_TAB_LINE_BUFFER=""
export VAR_TERM_TAB_LINE_LIST_PATH
export VAR_TERM_TAB_LINE_LIST_START_IDX
export VAR_TERM_TAB_LINE_LIST_IDX


## Main window vars
#-----------------
export VAR_TERM_WIN_CURRENT_CURSOR=0
export VAR_TERM_CONTENT_SCROLL_IDX=0
export VAR_TERM_CONTENT_SCROLL_START_IDX=0

export VAR_TERM_DIR_LIST_CNT=0
export VAR_TERM_DIR_FILE_LIST=()
export VAR_TERM_DIR_FILE_INFO_LIST=()

# Directory model state (L2). Declared with the other terminal vars so the
# loader never touches an unset name.
FM_DIR_PREV_IDX=0
FM_DIR_BACKUP=()
FM_DIR_SEARCH_ACTIVE=

export VAR_TERM_OPEN_FILE=""

# Buffer
export VAR_TERM_PRINT_BUFFER_ENABLE=false
export VAR_TERM_PRINT_BUFFER=""
export VAR_TERM_KEY_BUFFER_INPUT=""
export VAR_TERM_KEY_CURRENT_INPUT=""

# Marks
export VAR_TERM_FILE_PRE=""
export VAR_TERM_FILE_POST=""
export VAR_TERM_MARK_PRE=""
export VAR_TERM_MARK_POST=""

# Flags
export VAR_TERM_FLAG_FIND_PREVIOUS=0
export VAR_TERM_FLAG_RESET_IDX=false

## Sub Windows
#-----------------
export DEF_TERM_WIN_TYPE_HIDDEN=0
export DEF_TERM_WIN_TYPE_MSG=1
export DEF_TERM_WIN_TYPE_TASK=2

export VAR_TERM_UPPERWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
export VAR_TERM_LEFTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
export VAR_TERM_RIGHTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
export VAR_TERM_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}

# msg win
export VAR_TERM_MSGWIN_BUFFER=()
export VAR_TERM_MSGWIN_SCROLL_IDX=""

# task win
export VAR_TERM_TASKWIN_BUFFER=("Main task running.")
export VAR_TERM_TASKWIN_SCROLL_IDX=""

## Status Line
#-----------------
export VAR_TERM_MARKED_FILE_LIST=()
export VAR_TERM_MARK_DIR=""
export VAR_TERM_SELECTION_FILE_LIST=()
export VAR_TERM_FILE_PROGRAM=()

## Cmd line
#-----------------
export VAR_TERM_CMD_HISTORY_MAX=100
export VAR_TERM_CMD_HISTORY
export VAR_TERM_SEARCH_HISTORY
export VAR_TERM_FIND_HISTORY

export VAR_TERM_CMD_INPUT_BUFFER=""

# Line editor state (L4). Written by fedit_* only; read by the view so a
# resize repaints the live line.
FM_ED_ACTIVE=0
FM_ED_PREFIX=""
FM_ED_FUNC="command"
FM_ED_DRIVER="mode"
FM_ED_BUF=""
FM_ED_POSTBUF=""
FM_ED_HISTIDX=0
FM_ED_BACKUP=""
FM_ED_CMD=""
FM_ED_ARGS=""
FM_ED_COMP_MODE_LIST=()
FM_ED_COMP_MODE_IDX=0
FM_ED_COMP_MODE_PATH_CMD=""
FM_ED_COMP_PROMPT_LIST=()
FM_ED_COMP_PROMPT_IDX=0
export VAR_TERM_CMD_LIST=( "redraw" "help" "exit" "shell" "cd" "reenter" "colorscheme")
VAR_TERM_CMD_LIST+=( "set" "title" "config")
# Debug
VAR_TERM_CMD_LIST+=( "debug" "select" "stat" "eval" "dump" "test" "task" "msg")
# File operation
VAR_TERM_CMD_LIST+=( "mkdir" "touch" "rename" "search" "find" "sort" "backfile" )
# Tab operation
VAR_TERM_CMD_LIST+=( "quitngo" "tabclose" "tabcloseright" "tabcloseleft" "tabcloseothers" "tabcloseduplicate")
# Open ralted.
VAR_TERM_CMD_LIST+=( "open" "editor" "vim" "hex" "media" "play" "image" "preview" "unzip" "extract")

export VAR_TERM_SELECT_CMD_LIST=( "compress" )
# VAR_TERM_SELECT_CMD_LIST+=( "copy" "remove" "paste" )

## Terminal mode
###########################################################
## Mode
export DEF_TERM_MODE_NORMAL='normal'
export DEF_TERM_MODE_VISUAL='visual'
export DEF_TERM_MODE_SELECT='select'
export DEF_TERM_MODE_SEARCH='search'
export DEF_TERM_MODE_FIND='find'
export DEF_TERM_MODE_COMMAND='command'

# Line editor driver and flavor names.
export DEF_ED_DRIVER_MODE='mode'
export DEF_ED_DRIVER_PROMPT='prompt'
export DEF_ED_FUNC_WAIT='wait'
export DEF_ED_FUNC_CONFIRM='confirm'
# Fractional escape-sequence wait, bash 4 and later only.
export DEF_ED_READ_TIMEOUT=0.02

export VAR_TERM_VISUAL_START_IDX=0
export VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_NORMAL}"

## Others
export VAR_TERM_SEARCH_END_EARLY=0

###########################################################
## HSFM Vars Options
###########################################################

## Path & file
###########################################################
#This is the setting file.
export HSFM_FILE_CONFIG="${HOME}/.hsfm.sh"
# CD on exit helper file
# Default: '${XDG_CACHE_HOME}/hsfm/hsfm.d'
#          If not using XDG, '${HOME}/.cache/hsfm/hsfm.d' is used.
export HSFM_PATH_CACHE="${HOME}/.cache/hsfm"
export HSFM_FILE_RUNTIME_ENV=${HSFM_PATH_CACHE}/hsfm_runtimeenv.sh
export HSFM_FILE_SESSION=${HSFM_PATH_CACHE}/hsfm_session.sh
export HSFM_FILE_CD_LASTPATH=${HSFM_PATH_CACHE}/hsfm_last.sh
export HSFM_FILE_MESSAGE=${HSFM_PATH_CACHE}/hsfm_message.log
export HSFM_FILE_LOGS=${HSFM_PATH_CACHE}/hsfm_logs.sh

# Trash Directory
# Default: '${XDG_DATA_HOME}/hsfm/trash'
#          If not using XDG, '${XDG_DATA_HOME}/hsfm/trash' is used.
export HSFM_PATH_TRASH="${HOME}/.trash"

## Themes & colors
###########################################################
# FG                                # BG
# Code 	Color                       # Code 	Color
# 39 	Default foreground color    # 49 	Default background color
# 30 	Black                       # 40 	Black
# 31 	Red                         # 41 	Red
# 32 	Green                       # 42 	Green
# 33 	Yellow                      # 43 	Yellow
# 34 	Blue                        # 44 	Blue
# 35 	Magenta                     # 45 	Magenta
# 36 	Cyan                        # 46 	Cyan
# 37 	Light gray                  # 47 	Light gray
# 90 	Dark gray                   # 100 	Dark gray
# 91 	Light red                   # 101 	Light red
# 92 	Light green                 # 102 	Light green
# 93 	Light yellow                # 103 	Light yellow
# 94 	Light blue                  # 104 	Light blue
# 95 	Light magenta               # 105 	Light magenta
# 96 	Light cyan                  # 106 	Light cyan
# 97 	White                       # 107 	White
###########################################################
export HSFM_COLOR_THEME="color"

# black scheme, low profile.
# Cursor color [0\-9]
export HSFM_COLOR_CURSOR

# Selection color [0\-9] (copied/moved files)
export HSFM_COLOR_SELECTION

# Title
export HSFM_COLOR_TITLE

# tab bar
export HSFM_COLOR_TAB
export HSFM_COLOR_TAB_SELECTION
export HSFM_COLOR_TAB_LEBEL

# bookmark bar
export HSFM_COLOR_TAB_BOOKMARK

# Status bar
export HSFM_COLOR_STATUS
export HSFM_COLOR_STATUS_LABEL

# Float win
export HSFM_COLOR_FLOAT_WIN
export HSFM_COLOR_FLOAT_WIN_LABEL

## HSFM ENV
###########################################################
export HSFM_ENV_TITLE="HSFM"

# Text Editor
export HSFM_TEXT_EDITOR="vim"
export HSFM_MEDIA_PLAYER="vlc"
export HSFM_PICTURE_VIEWER="loupe"

# File Opener
export HSFM_OPENER="xdg-open"

# File Attributes Command
export HSFM_STAT_CMD="stat"

# Enable or disable CD on exit.
# Default: '1'
export HSFM_CD_ON_EXIT=1

# Trash Command
# Default: 'mv'
#          Define a custom program to use to trash files.
#          The program will be passed the list of selected files
#          and directories.
export HSFM_TRASH_CMD=""

# Favourites (Bookmarks) (keys 1-9) (dir or file)
export HSFM_FAV0=${PWD}
export HSFM_FAV1=~
export HSFM_FAV2=~/documents
export HSFM_FAV3=~/downloads
export HSFM_FAV4=
export HSFM_FAV5=~/workspace
export HSFM_FAV6=~/lab
export HSFM_FAV7=~/projects
export HSFM_FAV8=~/media
export HSFM_FAV9=${HSFM_PATH_CACHE}

if test -d "documents"; then
    export HSFM_FAV2=~/documents
elif test -d "Documents"; then
    export HSFM_FAV2=~/Documents
fi
if test -d "downloads"; then
    export HSFM_FAV3=~/downloads
elif test -d "Downloads"; then
    export HSFM_FAV3=~/Downloads
fi

# Dir alias. Parallel arrays: bash 3.2 has no associative arrays.
export HSFM_DIR_ALIAS_KEY=("home" "log")
export HSFM_DIR_ALIAS_PATH=("${HOME}" "/var/log")

# File format.
# Customize the item string.
# Format ('%f' is the current file): "str%fstr"
# Example (Add a tab before files): HSFM_FILE_FORMAT="\t%f"
export HSFM_FILE_FORMAT="%f"

# Mark format.
# Customize the marked item string.
# Format ('%f' is the current file): "str%fstr"
# Example (Add a ' >' before files): HSFM_MARK_FORMAT="> %f"
export HSFM_MARK_FORMAT="%f*"

# LS settings
# Default use extension to sort.
export HSFM_LS_SORTING="-X"
## Keybindings
###########################################################

### Moving around.
# Show help info
export HSFM_KEY_HELP="H"
export HSFM_KEY_REFRESH="r"

# Go to child directory.
export HSFM_KEY_CHILD1="l"
export HSFM_KEY_CHILD2=$'\e[C' # Right Arrow
export HSFM_KEY_CHILD3=""      # Enter / Return

# Go to parent directory.
export HSFM_KEY_PARENT1="h"
export HSFM_KEY_PARENT2=$'\e[D' # Left Arrow
export HSFM_KEY_PARENT3=$'\177' # Backspace
export HSFM_KEY_PARENT4=$'\\b'   # Backspace (Older terminals)

# Go to previous directory.
export HSFM_KEY_PREVIOUS="-"

# Search/find
export HSFM_KEY_SEARCH="/"
export HSFM_KEY_FIND="?"

# Spawn a shell.
export HSFM_KEY_SHELL="!"

# Scroll down.
export HSFM_KEY_SCROLL_DOWN1="j"
export HSFM_KEY_SCROLL_DOWN2=$'\e[B' # Down Arrow

# Scroll up.
export HSFM_KEY_SCROLL_UP1="k"
export HSFM_KEY_SCROLL_UP2=$'\e[A'   # Up Arrow

# Go to top and bottom.
export HSFM_KEY_TO_TOP="g"
export HSFM_KEY_TO_BOTTOM="G"

# Go to dirs.
export HSFM_KEY_OPEN_CMD=":"
export HSFM_KEY_GO_HOME="~"
export HSFM_KEY_GO_TRASH="z"

# Tab Ops
export HSFM_KEY_GO_PREVIOUS_TAB=$'\x08'
export HSFM_KEY_GO_NEXT_TAB=$'\x0c'
export HSFM_KEY_OPEN_TAB='t'
export HSFM_KEY_CLOSE_TAB='w'
export HSFM_KEY_MOVE_TAB_PREVIOUS='H'
export HSFM_KEY_MOVE_TAB_NEXT='L'

# Toggle message win.
export HSFM_KEY_TOGGLE_MSGWIN="m"

# Toggle task win.
export HSFM_KEY_TOGGLE_TASKWIN="T"

### Miscellaneous
# Show file attributes.
export HSFM_KEY_ATTRIBUTES="i"

# LS Toggle hidden files.
export HSFM_KEY_HIDDEN="."
export HSFM_KEY_SORTING="S"

# Toggle executable flag.
# export HSFM_KEY_EXECUTABLE="X"

### File operations.
export HSFM_KEY_QUICK_EDIT="e"
export HSFM_KEY_YANK="y"
export HSFM_KEY_CUT="x"
export HSFM_KEY_TRASH="d"
export HSFM_KEY_PASTE="p"

# Mode switch
export HSFM_KEY_VISUAL_SELECT="V"
export HSFM_KEY_SELECTION="s"

###########################################################
## L0 Driver
## stdout and escape emission, print buffer, terminal modes, rectangle drawing.
###########################################################

###########################################################
## Source file
###########################################################
# source ${PATH_SCRIPT_ROOT}/winmgr.sh

###########################################################
## Utility Functions
###########################################################
futility_stream_purify() {
    sed "s/ /_/g" | sed -r "s/[^0-9a-zA-Z._-]/_/g" | sed -r "s/\[_\]\+/_/g" | sed -r "s/^_//g" | sed -r "s/_$//g" | tr -s '_'
}

###########################################################
## Terminal Functions
###########################################################
fterminal_print() {
    if [ ${VAR_TERM_PRINT_BUFFER_ENABLE} = true ]
    then
        local tmp_buf=""
        printf -v tmp_buf "$@"
        VAR_TERM_PRINT_BUFFER+="${tmp_buf}"
    else
        fterminal_flush
        printf "$@"
    fi
}

fterminal_flush() {
    printf "%s" "${VAR_TERM_PRINT_BUFFER}"
    VAR_TERM_PRINT_BUFFER_ENABLE=false
    VAR_TERM_PRINT_BUFFER=""
}

fterminal_setup() {
    # Setup the terminal for the TUI.
    # '\e[?1049h': Use alternative screen buffer.
    # '\e[?7l':    Disable line wrapping.
    # '\e[?25l':   Hide the cursor.
    # '\e[2J':     Clear the screen.
    # '\e[1;Nr':   Limit scrolling to scrolling area.
    #              Also sets cursor to (0,0).
    fterminal_print '\e[?1049h\e[?7l\e[?25l\e[2J\e[1;%sr' "$VAR_TERM_MAINWIN_HEIGHT"

    # Hide echoing of user input
    stty -echo
}

fterminal_reset() {
    # Reset the terminal to a useable state (undo all changes).
    # '\e[?7h':   Re-enable line wrapping.
    # '\e[?25h':  Unhide the cursor.
    # '\e[2J':    Clear the terminal.
    # '\e[;r':    Set the VAR_TERM_CONTENT_SCROLL_IDX region to its default value.
    #             Also sets cursor to (0,0).
    # '\e[?1049l: Restore main screen buffer.
    # fterminal_print '\e[?7h\e[?25h\e[2J\e[;r\e[?1049l'
    fterminal_print '\e[?7h\e[?25h\e[;r\e[?1049l'

    # Show user input.
    stty echo
}

fterminal_clear() {
    # Only clear the scrolling window (dir item list).
    # '\e[%sH':    Move cursor to bottom of VAR_TERM_CONTENT_SCROLL_IDX area.
    # '\e[9999C':  Move cursor to right edge of the terminal.
    # '\e[1J':     Clear screen to top left corner (from cursor up).
    # '\e[2J':     Clear screen fully (if using tmux) (fixes clear issues).
    # '\e[1;%sr':  Clearing the screen resets the VAR_TERM_CONTENT_SCROLL_IDX region(?). Re-set it.
    #              Also sets cursor to (0,0).
    # fterminal_print '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
    #        "$((VAR_TERM_HEIGHT-2))" "${TMUX:+\e[2J}" "$VAR_TERM_MAINWIN_HEIGHT"
    fterminal_print '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
        "$((VAR_TERM_HEIGHT))" "${TMUX:+\e[2J}" "$(($VAR_TERM_MAINWIN_HEIGHT+$VAR_TERM_TAB_LINE_HEIGHT))"
}

###########################################################
## raw draw Functions
###########################################################
fterminal_draw_window() {
    local def_padding=0
    #  6 Args with order
    local var_start_line=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + ${VAR_TERM_MAINWIN_HEIGHT}))
    local var_start_col=0
    local var_width=${VAR_TERM_WIDTH}
    local var_height=${VAR_TERM_SUBWIN_BOTTOM_SIZE}
    local var_win_title="[MSG WIN]"
    local var_buffer=("${VAR_TERM_MSGWIN_BUFFER[@]}")

    if [[ "${#}" -ge "5" ]]
    then
        var_start_line=${1}
        var_start_col=${2}
        var_width=${3}
        var_height=${4}
        var_win_title="[${5}]"
        shift 5
        var_buffer=("${@}")
    fi

    # Test center
    ############################################################################
    # var_width=$((${VAR_TERM_WIDTH}/2))
    # var_height=$((${VAR_TERM_HEIGHT}/2))
    # var_start_line=$((${VAR_TERM_HEIGHT}/4))
    # var_start_col=$((${VAR_TERM_WIDTH}/4))
    # flog_msg "ORI WH: ${VAR_TERM_HEIGHT}/${VAR_TERM_WIDTH}, WH: ${var_width}/${var_height}, POS: ${var_start_line}/${var_start_col}"
    ############################################################################

    # Update length, only print the latest lines. 
    if [[ ${#var_buffer[@]} -gt $((var_height - 1 - def_padding)) ]]
    then
        var_buffer=("${var_buffer[@]: -$((var_height - 1 - def_padding))}")
    else
        var_buffer=("${var_buffer[@]}")
    fi

    fterminal_print '\e7'

    fterminal_print '\e[%sH\e[%sm%*s\e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_FLOAT_WIN_LABEL}" \
           "${var_width}"
    fterminal_print '\e[%sH\e[%sm %s \e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_FLOAT_WIN_LABEL}" \
           "${var_win_title}"

    local var_cnt=0
    while read each_line || ((var_cnt < var_height - 1));
    do
        local var_line_buf=""
        # clean lines
        fterminal_print '\e[%sH\e[%sm%*s\e[m' \
            "$((var_start_line + 1 + var_cnt));${var_start_col}" \
            "${HSFM_COLOR_FLOAT_WIN}" \
            "${var_width}"

        # Draw lines
        if test -n "${each_line}"
        then
            fterminal_print '\e[%sH\e[%sm%s\e[m' \
                "$((var_start_line + 1 + var_cnt));${var_start_col}" \
                "${HSFM_COLOR_FLOAT_WIN}" \
                " ${each_line:0:$((var_width - 2))} "
        fi
        ((var_cnt++))
    done << EOF
$(for each_line in "${var_buffer[@]}"; do printf "${each_line}\n"; done)
EOF

    fterminal_print '\e8'
}

###########################################################
## L1 View
## geometry, every draw_*, message and status output. Reads; never owns model state.
###########################################################

fterminal_get_size() {
    # Get terminal size ('stty' is POSIX and always available).
    # This can't be done reliably across all bash versions in pure bash.
    read -r VAR_TERM_HEIGHT VAR_TERM_WIDTH < <(stty size)

    # Max list items that fit in the VAR_TERM_CONTENT_SCROLL_IDX area.
    # ((VAR_TERM_MAINWIN_HEIGHT=VAR_TERM_HEIGHT-3))
    # ((VAR_TERM_MAINWIN_HEIGHT=VAR_TERM_HEIGHT-VAR_TERM_TAB_LINE_HEIGHT-VAR_TERM_STATUS_LINE_CNT))

    ## size calculation.
    local var_subwin_width=0
    local var_subwin_height=0

    if [ ${VAR_TERM_UPPERWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_height = VAR_TERM_SUBWIN_UPPER_SIZE))
    fi
    if [ ${VAR_TERM_LEFTWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_width = VAR_TERM_SUBWIN_LEFT_SIZE))
    fi

    VAR_TERM_MAINWIN_START_IDX=($((1 + var_subwin_width)) $((1 + VAR_TERM_TAB_LINE_HEIGHT + var_subwin_height)) )

    if [ ${VAR_TERM_RIGHTWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_width = var_subwin_width + VAR_TERM_SUBWIN_RIGHT_SIZE))
    fi
    if [ ${VAR_TERM_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_height = var_subwin_height + VAR_TERM_SUBWIN_BOTTOM_SIZE))
    fi

    ((VAR_TERM_MAINWIN_WIDTH=VAR_TERM_WIDTH - var_subwin_width))
    ((VAR_TERM_MAINWIN_HEIGHT=VAR_TERM_HEIGHT-VAR_TERM_TAB_LINE_HEIGHT-VAR_TERM_STATUS_LINE_CNT - var_subwin_height))
}

###########################################################
## Drawing Functions
###########################################################
fterminal_redraw() {
    # Redraw the current window.
    # If 'full' is passed, re-fetch the directory list.
    local tmp_buffer=""
    [[ $1 == full ]] && {
        fterminal_read_dir
        if [ ${VAR_TERM_FLAG_RESET_IDX} = true ]
        then
            VAR_TERM_CONTENT_SCROLL_IDX=0
            VAR_TERM_WIN_CURRENT_CURSOR=0
            VAR_TERM_FLAG_RESET_IDX=false
        fi
    }

    ## Update ENV
    # order is important, don't change it.
    # clear before redraw, avoid glict/search result incorrect.
    VAR_TERM_PRINT_BUFFER_ENABLE=true

    # Update status height
    # FIXME, don't use status cnt for calc.
    # if [ ${VAR_TERM_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    # then
    #     VAR_TERM_STATUS_LINE_CNT=$((${VAR_TERM_SUBWIN_BOTTOM_SIZE} + 2))
    # else
    #     VAR_TERM_STATUS_LINE_CNT=2
    # fi

    ## Setup Terminal Env
    fterminal_get_size
    fterminal_clear

    ## Draw left vertical win
    # TODO

    ## Draw right vertical win
    # TODO

    ## Draw upper win
    # TODO

    ## Draw bottom win
    if [ ${VAR_TERM_BOTTOMWIN_SHOW} = ${DEF_TERM_WIN_TYPE_MSG} ]
    then
        fterminal_draw_msgwin
    elif [ ${VAR_TERM_BOTTOMWIN_SHOW} = ${DEF_TERM_WIN_TYPE_TASK} ]
    then
        fterminal_draw_taskwin
    fi

    ## Draw main win
    fterminal_draw_dir

    ## Draw control UI
    fterminal_draw_tab_line
    fterminal_draw_status_line
    fterminal_draw_command_line

    fterminal_flush
}

fterminal_draw_dir() {
    # Print the max directory items that fit in the VAR_TERM_CONTENT_SCROLL_IDX area.
    local var_scroll_new_start
    local var_win_new_cursor
    local var_scroll_len=$(($VAR_TERM_MAINWIN_HEIGHT - 1))
    local var_scroll_distance=$(($VAR_TERM_MAINWIN_HEIGHT - 3))

    # When going up the directory tree, place the cursor on the position
    # of the previous directory.
    if ((VAR_TERM_FLAG_FIND_PREVIOUS == 1))
    then
        ((VAR_TERM_CONTENT_SCROLL_IDX=FM_DIR_PREV_IDX))
        # ((VAR_TERM_CONTENT_SCROLL_START_IDX=FM_DIR_PREV_IDX))

        # Clear the directory history. We're here now.
        VAR_TERM_FLAG_FIND_PREVIOUS=0
    fi

    # Update idx for previous store.
    if [[ ${VAR_TERM_CONTENT_SCROLL_IDX} -ge ${#VAR_TERM_DIR_FILE_LIST[@]} ]]
    then
        if [[ ${VAR_TERM_MAINWIN_HEIGHT} -gt ${#VAR_TERM_DIR_FILE_LIST[@]} ]]
        then
            VAR_TERM_CONTENT_SCROLL_IDX=$(( ${#VAR_TERM_DIR_FILE_LIST[@]} -1 ))
            VAR_TERM_CONTENT_SCROLL_START_IDX=0
            VAR_TERM_WIN_CURRENT_CURSOR=0
        else
            VAR_TERM_CONTENT_SCROLL_IDX=$(( ${#VAR_TERM_DIR_FILE_LIST[@]} -1 ))
            VAR_TERM_CONTENT_SCROLL_START_IDX=0
            VAR_TERM_WIN_CURRENT_CURSOR=${VAR_TERM_CONTENT_SCROLL_IDX}
        fi
    # elif [[ ${VAR_TERM_CONTENT_SCROLL_IDX} -gt ${#VAR_TERM_DIR_FILE_LIST[@]} ]]
    # then
    #     VAR_TERM_CONTENT_SCROLL_IDX=0
    #     VAR_TERM_CONTENT_SCROLL_START_IDX=0
    #     VAR_TERM_WIN_CURRENT_CURSOR=0
    fi
    # flog_msg_debug "${VAR_TERM_CONTENT_SCROLL_IDX} -gt ${#VAR_TERM_DIR_FILE_LIST[@]}"
    local dbg_case="0"

    # Page arithmetic. Inputs: the cursor index in the list
    # (VAR_TERM_CONTENT_SCROLL_IDX), the first painted index
    # (VAR_TERM_CONTENT_SCROLL_START_IDX), the stored cursor row
    # (VAR_TERM_WIN_CURRENT_CURSOR). Outputs: var_scroll_new_start, the first
    # index to paint, and var_win_new_cursor, the row the cursor lands on.
    #
    # The branches are tested in this order, first match wins:
    #   0  cursor inside the current page                 keep the page
    #   1  cursor exactly one page past the start         scroll one page down
    #   2  cursor one row above the start                 scroll one page up,
    #                                                     or pin to the top
    #   3  list shorter than the window, or near the top  pin to the top
    #   4  cursor within one window of the end            pin to the bottom
    #   5  stored cursor row below the window             follow the cursor
    #   *  anything else                                  keep the cursor row
    #
    # Order of the writes below: both values are computed first, then the index,
    # then the start, then the terminal cursor moves, then the row is stored.
    if ((VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX < VAR_TERM_MAINWIN_HEIGHT)) && 
        ((VAR_TERM_CONTENT_SCROLL_IDX >= VAR_TERM_CONTENT_SCROLL_START_IDX)); then
        # No need to update page, since it could shows all content.
        # also check if if we are going to the previous page
        ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_START_IDX))
        ((var_win_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX))
        dbg_case="0"
    elif ((VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX == VAR_TERM_MAINWIN_HEIGHT)); then
        # Go to next page, add one for conveint
        ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_START_IDX + var_scroll_distance + 1))
        ((var_win_new_cursor=VAR_TERM_WIN_CURRENT_CURSOR-var_scroll_distance))
        dbg_case="1"
    # elif ((VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX >= VAR_TERM_MAINWIN_HEIGHT)); then
    elif ((VAR_TERM_CONTENT_SCROLL_IDX + 1 == VAR_TERM_CONTENT_SCROLL_START_IDX)); then
        # Go to previous page, add one for conveint
        # check if hit the top.
        if ((VAR_TERM_CONTENT_SCROLL_START_IDX > var_scroll_distance))
        then
            ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_IDX - var_scroll_distance))
            ((var_win_new_cursor=var_scroll_distance))
        else
            ((var_scroll_new_start=0))
            ((var_win_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX))
        fi
        dbg_case="2"
    # This will handle other case.
    elif ((VAR_TERM_DIR_LIST_CNT < VAR_TERM_MAINWIN_HEIGHT || VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_MAINWIN_HEIGHT)); then
        # To the top.
        # If the list in shorter then window, or the scroll idx == 0
        ((var_scroll_new_start=0))
        ((var_win_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX))
        # flog_msg "1/$var_scroll_new_start/$var_win_new_cursor"
        dbg_case="3"
    elif ((VAR_TERM_CONTENT_SCROLL_IDX + VAR_TERM_MAINWIN_HEIGHT > VAR_TERM_DIR_LIST_CNT)); then
        # To the bottom.
        # If the list is greater then win size, and in the last page
        ((var_scroll_new_start=VAR_TERM_DIR_LIST_CNT-VAR_TERM_MAINWIN_HEIGHT + 1))
        ((var_win_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX - var_scroll_new_start))
        # flog_msg "2/$var_scroll_new_start/$var_win_new_cursor"
        dbg_case="4"
    elif ((VAR_TERM_WIN_CURRENT_CURSOR > VAR_TERM_MAINWIN_HEIGHT - 1)); then
        # handle cursor out of showing screen.
        # its for redraw and cursor been covered.
        ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_IDX-VAR_TERM_MAINWIN_HEIGHT - 1))
        ((var_win_new_cursor=VAR_TERM_MAINWIN_HEIGHT - 1))
        dbg_case="5"
    else
        # This is for error handle.
        # If in the midddle of the dir list.
        ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_IDX-VAR_TERM_WIN_CURRENT_CURSOR))
        ((var_win_new_cursor=VAR_TERM_WIN_CURRENT_CURSOR))
        # flog_msg "else/$var_scroll_new_start/$var_win_new_cursor"
        dbg_case="others"
    fi
    # flog_msg_debug "Case: ${dbg_case}, ${var_scroll_new_start}:${var_win_new_cursor}"

    # Update Scroll index
    ((VAR_TERM_CONTENT_SCROLL_IDX=var_win_new_cursor+var_scroll_new_start))
    ((VAR_TERM_CONTENT_SCROLL_START_IDX=var_scroll_new_start))
    # flog_msg_debug "dbg case ${dbg_case}: ${VAR_TERM_CONTENT_SCROLL_IDX}/${VAR_TERM_CONTENT_SCROLL_START_IDX}/${FM_DIR_PREV_IDX}"

    # local var_col_offset=15
    # Reset cursor position.
    # fterminal_print '\e[H'
    # fterminal_print '\e[%s;%sH' "$((1 + ${VAR_TERM_TAB_LINE_HEIGHT}))" "${var_col_offset}"

    # FIXME, impl current window
    # if true; then
    if false; then
        ################################################################
        # Test
        for ((idx=0;idx<=var_scroll_len;idx++)); {

            if [[ -z ${VAR_TERM_DIR_FILE_LIST[$((var_scroll_new_start + idx))]} ]]; then
                break
            fi

            flog_msg_debug "fterminal_draw_file_line $((${VAR_TERM_WIDTH}/2)) 0 80 $((var_scroll_new_start + idx))"
            fterminal_draw_file_line "$((var_scroll_new_start + idx))" 0 0
        }
        for ((idx=0;idx<=var_scroll_len;idx++)); {

            if [[ -z ${VAR_TERM_DIR_FILE_LIST[$((var_scroll_new_start + idx))]} ]]; then
                break
            fi

            flog_msg_debug "fterminal_draw_file_line $((${VAR_TERM_WIDTH}/2)) 0 80 $((var_scroll_new_start + idx))"
            fterminal_draw_file_line "$((var_scroll_new_start + idx))" $((${VAR_TERM_WIDTH} / 2)) 0 $((${VAR_TERM_WIDTH} / 2))
        }

    else
        ################################################################
        for ((idx=0;idx<=var_scroll_len;idx++)); {
            # Don't print one too many newlines.
            # if ((idx > 0))
            # then
            #     fterminal_print '\e[%s;%sH' "$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + idx))" "${var_col_offset}"
            #     # fterminal_print '\n'
            # fi

            if [[ -z ${VAR_TERM_DIR_FILE_LIST[$((var_scroll_new_start + idx))]} ]]; then
                break
            fi

            fterminal_draw_file_line "$((var_scroll_new_start + idx))"
        }
    fi

    # Move the cursor to its new position if it changed.
    # If the variable 'var_win_new_cursor' is empty, the cursor
    # is moved to line '0'.
    fterminal_print '\e[%sH' "$(($var_win_new_cursor+1+VAR_TERM_TAB_LINE_HEIGHT))"
    # fterminal_print '\e[%sH' "$((${var_win_new_cursor} + ${VAR_TERM_TAB_LINE_HEIGHT}))"
    ((VAR_TERM_WIN_CURRENT_CURSOR=var_win_new_cursor))
}

fterminal_draw_file_line() {
    # If the dir item doesn't exist, end here.
    if [[ ${#VAR_TERM_DIR_FILE_LIST[@]} -eq 0 ]] || [[ -z ${VAR_TERM_DIR_FILE_LIST[$1]} ]]; then
        return
    fi
    # Format the VAR_TERM_DIR_FILE_LIST item and print it.
    local var_content_idx=$1

    # args max width
    if [[ ${#} -ge 3 ]]
    then
        local args_col_offset=${2}
        local args_line_offset=${3}
    else
        local args_col_offset=${VAR_TERM_MAINWIN_START_IDX[0]}
        local args_line_offset=${VAR_TERM_MAINWIN_START_IDX[1]}
        # local args_col_offset=0
        # local args_line_offset=0
        # flog_msg_debug "${args_col_offset}:${args_line_offset}"
    fi

    local var_file_name=${VAR_TERM_DIR_FILE_LIST[$var_content_idx]##*/}
    # local var_file_name=${VAR_TERM_DIR_FILE_LIST[$var_content_idx]}
    local var_file_ext=${var_file_name##*.}
    local var_format
    local var_postfix
    local var_prefix
    # local var_file_info="$(ls -al $PWD | grep ${var_file_name}\$ | sed 's/ [^ ]\+$//')"
    local var_file_info="${VAR_TERM_DIR_FILE_INFO_LIST[$var_content_idx]}"

    # Directory.
    if [[ -d "${VAR_TERM_DIR_FILE_LIST[$var_content_idx]}" ]]; then
        # Check if symbolic link
        if [[ -h ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
            var_format+=\\e[${ln:-01;36}m
        else
            var_format+=\\e[${di:-1;-32}m
        fi
        var_postfix+=/

    # Symbolic Link.
    elif [[ -h ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} && ! -e ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${mi:-01;31;7}m

    # Block special file.
    elif [[ -b ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${bd:-40;33;01}m

    # Character special file.
    elif [[ -c ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${cd:-40;33;01}m

    # Executable file.
    elif [[ -x ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${ex:-01;32}m

    # Symbolic Link.
    elif [[ -h ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${ln:-01;36}m

    # Fifo file.
    elif [[ -p ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${pi:-40;33}m

    # Socket file.
    elif [[ -S ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${so:-01;35}m

    # Color files that end in a pattern as defined in LS_COLORS.
    # 'BASH_REMATCH' is an array that stores each REGEX match.
    elif [[ $HSFM_LS_COLORS == 1 &&
            $ls_patterns &&
            $var_file_name =~ ($ls_patterns)$ ]]; then
        match=${BASH_REMATCH[0]}
        var_file_ext=ls_${match//[^a-zA-Z0-9=\\;]/_}
        var_format+=\\e[${!var_file_ext:-${fi:-37}}m

    # Color files based on file extension and LS_COLORS.
    # Check if file extension adheres to POSIX naming
    # standard before checking if its a variable.
    elif [[ $HSFM_LS_COLORS == 1 &&
            $var_file_ext != "$var_file_name" &&
            $var_file_ext =~ ^[a-zA-Z0-9_]*$ ]]; then
        var_file_ext=ls_${var_file_ext}
        var_format+=\\e[${!var_file_ext:-${fi:-37}}m

    else
        var_format+=\\e[${fi:-37}m
    fi

    # If the VAR_TERM_DIR_FILE_LIST item is under the cursor.
    (($var_content_idx == VAR_TERM_CONTENT_SCROLL_IDX)) &&
        var_format+="\\e[${HSFM_COLOR_CURSOR}m"

    # If the VAR_TERM_DIR_FILE_LIST item is marked for operation.
    if [[ ${VAR_TERM_MARKED_FILE_LIST[$var_content_idx]} == "${VAR_TERM_DIR_FILE_LIST[$var_content_idx]:-null}" ]];then
        var_format+=\\e[${HSFM_COLOR_SELECTION}m${VAR_TERM_MARK_PRE}
        var_prefix=${VAR_TERM_MARK_POST}
    else
        var_prefix=$(printf "% ${#VAR_TERM_MARK_POST}s" "")
    fi

    # Escape the directory string.
    # Remove all non-printable characters.
    var_file_name=${var_file_name//[^[:print:]]/^[}
    tmp_line_offset=0

    # FIXME, Its a patch, after impl visual scroll, remove the following code.
    if ((var_content_idx - VAR_TERM_CONTENT_SCROLL_START_IDX >= VAR_TERM_MAINWIN_HEIGHT))
    then
        # to next page
        # flog_msg_debug "file line, Next page"
        ((VAR_TERM_CONTENT_SCROLL_START_IDX=$var_content_idx-$VAR_TERM_MAINWIN_HEIGHT+1))
        # tmp_line_offset=$((${args_line_offset}))
        tmp_line_offset=$((${args_line_offset} + ${var_content_idx} - ${VAR_TERM_CONTENT_SCROLL_START_IDX}))
    elif ((var_content_idx < VAR_TERM_CONTENT_SCROLL_START_IDX))
    then
        # to previous page
        # flog_msg_debug "file line, Previous page"
        ((VAR_TERM_CONTENT_SCROLL_START_IDX=var_content_idx))
        # tmp_line_offset=$((${args_line_offset}))
        tmp_line_offset=$((${args_line_offset} + ${var_content_idx} - ${VAR_TERM_CONTENT_SCROLL_START_IDX}))
    else
        # flog_msg_debug "file line, within page"
        # within page
        tmp_line_offset=$((${args_line_offset} + ${var_content_idx} - ${VAR_TERM_CONTENT_SCROLL_START_IDX}))
    fi

    # flog_msg_debug "${1}:${tmp_line_offset}:${args_col_offset}"
    fterminal_print '\e[%s;%sH' "${tmp_line_offset}" "${args_col_offset}"

    local tmp_content="${var_prefix}${var_file_info} ${VAR_TERM_FILE_PRE}${var_file_name}${VAR_TERM_FILE_POST}${var_postfix}"

    local var_content_width=${VAR_TERM_MAINWIN_WIDTH}
    # This is for marking with line length
    # if (( ${#tmp_content} > ${VAR_TERM_MAINWIN_WIDTH})); then
    #     local var_content_width=${VAR_TERM_MAINWIN_WIDTH}
    # else
    #     local var_content_width=${#tmp_content}
    # fi

    fterminal_print "%b%- ${var_content_width}s\e[m" \
        "${var_format}" \
        "${tmp_content:0:${var_content_width}}"
}

fterminal_draw_tab_line() {
    local var_left=""
    local var_center=" "
    local var_left_cnt=""
    local var_right=" "
    local var_right_cnt=""
    local var_spacing=""
    local var_content_cnt=""


    # Status_line to print when files are marked for operation.
    local var_tab_selected_buf=""
    local var_tab_list_pre_buf=""
    local var_tab_list_post_buf=""
    local var_tab_seperator="|"
    local def_tab_start_line=1

    if [ ${HSFM_PERFORMANCE_DEBUG} = true ]
    then
        flog_msg_debug "Enter fterminal_draw_tab_line, $((var_run_tab_cnt++))"
    fi
    # flog_msg_debug "Tab info: ${VAR_TERM_TAB_LINE_IDX}-${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]##*/}"
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # Escape the directory string.
    # Remove all non-printable characters.
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"

    # FIXME, when in /, PWD return empty, so default give it /.
    VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="${PWD:-/}"
    # VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(pwd)"

    # flog_msg_debug "[${PWD}]$VAR_TERM_TAB_LINE_IDX-${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
    for each_idx in "${!VAR_TERM_TAB_LINE_LIST_PATH[@]}"
    do
        # flog_msg_debug "Tab: ${each_idx}-${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]##*/}"
        if ! test -d "${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}"
        then
            flog_msg "Empty idx found. ${each_idx}-${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}"
            VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]="${HOME}"
            # continue
        fi
        local tmp_path=${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]##*/}
        if [ "${VAR_TERM_TAB_LINE_IDX}" = "${each_idx}" ]
        then
            var_tab_selected_buf=" ${each_idx} ${tmp_path:-/} "
            var_right=" $((${each_idx} + 1))/${#VAR_TERM_TAB_LINE_LIST_PATH[@]} "
        elif [[ "${VAR_TERM_TAB_LINE_IDX}" -gt "${each_idx}" ]]
        then
            var_tab_list_pre_buf=${var_tab_list_pre_buf}" ${each_idx} ${tmp_path:-/} ${var_tab_seperator}"
        else
            var_tab_list_post_buf=${var_tab_list_post_buf}"${var_tab_seperator} ${each_idx} ${tmp_path:-/} "
        fi
    done

    var_left+=" ${HSFM_ENV_TITLE} "

    # update buffer
    var_left_cnt="$((${#var_left} + ${#var_tab_list_pre_buf}+ ${#var_tab_selected_buf} + ${#var_tab_list_post_buf}))"
    var_right_cnt="${#var_right}"
    ((var_content_cnt=VAR_TERM_WIDTH-var_left_cnt-var_right_cnt))
    [[ ${var_content_cnt} < 0 ]] && ((${var_content_cnt}=0))
    # flog_msg "test-> ${var_content_cnt}/$VAR_TERM_WIDTH"
    var_spacing=$(printf "% ${var_content_cnt}s" "")


    # Escape the directory string.
    # Remove all non-printable characters.
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # local var_pwd_escaped=${PWD//[^[:print:]]/^[}

    # '\e7':       Save cursor position.
    #              This is more widely supported than '\e[s'.
    # '\e[%sH':    Move cursor to bottom of the terminal.
    # '\e[30;41m': Set foreground and background colors.
    # '%*s':       Insert enough spaces to fill the screen width.
    #              This sets the background color to the whole line
    #              and fixes issues in 'screen' where '\e[K' doesn't work.
    # '\r':        Move cursor back to column 0 (was at EOL due to above).
    # '\e[m':      Reset text formatting.
    # '\e[H\e[K':  Clear line below fterminal_draw_status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.
    # fterminal_print '\e7\e[%sH\e[%s;%sm%*s\r%s %s%s\e[m\e[%sH\e[K\e8' \

    fterminal_print "\e7\e[%sH\r\e[%sm%s\e[%sm%s\e[%sm%s\e[%sm%s\e[%sm%s\e[m\e8" \
           "$((def_tab_start_line))" \
           "${HSFM_COLOR_TITLE}" \
           "${var_left}" \
           "${HSFM_COLOR_TAB}" \
           "${var_tab_list_pre_buf}" \
           "${HSFM_COLOR_TAB_SELECTION}" \
           "${var_tab_selected_buf}" \
           "${HSFM_COLOR_TAB}" \
           "${var_tab_list_post_buf}${var_spacing}" \
           "${HSFM_COLOR_TAB_LEBEL}" \
           "${var_right}"

    fterminal_draw_bookmark_line
}

fterminal_draw_bookmark_line() {
    # bookmark bar
    local def_bookmark_start_line=2
    local tmp_bookmark_buf=""
    local tmp_cnt=0
    if [ ${HSFM_PERFORMANCE_DEBUG} = true ]
    then
        flog_msg_debug "Enter fterminal_draw_bookmark_line, $((var_run_bk_cnt++))"
    fi
    for each_fav in "${!HSFM_FAV@}"
    do
        # we ignore 0 for current path.
        if test -n "${!each_fav}" && [ "${tmp_cnt}" != '0' ]
        then
            tmp_bookmark_buf+=" ${tmp_cnt}: ${!each_fav##*/} |"
        fi
        ((tmp_cnt++))
    done

    fterminal_print '\e7\e[%sH\e[%sm%*s\r BM |%s \e[m\e8' \
           "${def_bookmark_start_line}" \
           "${HSFM_COLOR_TAB_BOOKMARK}" \
           "${VAR_TERM_WIDTH}" "" \
           "${tmp_bookmark_buf}"

           # "1 :${HSFM_FAV1##*/} | 2:${HSFM_FAV2##*/} | 3:${HSFM_FAV3##*/} | 4:${HSFM_FAV4##*/} | 5:${HSFM_FAV5##*/} | 6:${HSFM_FAV6##*/} | 7:${HSFM_FAV7##*/} | 8:${HSFM_FAV8##*/} | 9:${HSFM_FAV9##*/}"
}

fterminal_draw_status_line() {
    # Status_line to print when files are marked for operation.
    local var_mark_ui="[${#VAR_TERM_MARKED_FILE_LIST[@]} selected]"
    local var_left=""
    local var_center=" "
    local var_left_cnt=""
    local var_right=" "
    local var_right_cnt=""
    local var_spacing=""
    local var_content_cnt=""
    local var_pwd_escaped=""

    # Escape the directory string.
    # Remove all non-printable characters.
    if test -n "${VAR_TERM_OPEN_FILE}" && test -f "${VAR_TERM_OPEN_FILE}"
    then
        var_pwd_escaped=${VAR_TERM_OPEN_FILE//[^[:print:]]/^[}
    else
        var_pwd_escaped=${PWD//[^[:print:]]/^[}
    fi

    if [ ${HSFM_PERFORMANCE_DEBUG} = true ]
    then
        flog_msg_debug "Enter fterminal_draw_status_line, $((var_run_status_cnt++))"
    fi

    ## Update content
    var_left=" ${VAR_TERM_MODE_CURRENT} "
    var_left+="${VAR_TERM_MARKED_FILE_LIST[*]:+${var_mark_ui}}"
    var_center+="${1:-${var_pwd_escaped:-/}}"

    # only shows printable chars.
    if [[ ${#VAR_TERM_KEY_CURRENT_INPUT} -ne 0 ]] && [[ "${VAR_TERM_KEY_CURRENT_INPUT}" =~ [a-zA-Z0-9!-~] ]]; then
        # flog_msg_debug "$(echo ${VAR_TERM_KEY_CURRENT_INPUT}|xxd - )"
        var_right+=$(printf "Key %- 5s" "${VAR_TERM_KEY_CURRENT_INPUT}")
    fi

    if [[ ${#VAR_TERM_SELECTION_FILE_LIST[@]} -ne 0 ]]
    then
        # var_right+="Sel: ${#VAR_TERM_SELECTION_FILE_LIST[@]} "
        var_right+=$(printf "Sel %s" "${#VAR_TERM_SELECTION_FILE_LIST[@]}")
    fi
    # var_right+="($((VAR_TERM_CONTENT_SCROLL_IDX + 1))/$((VAR_TERM_DIR_LIST_CNT + 1))) "
    var_right+=$(printf "% 4s/%- 4s" "$((VAR_TERM_CONTENT_SCROLL_IDX + 1))" "$((VAR_TERM_DIR_LIST_CNT + 1))")
    # var_right+="$(date '+%Y/%m/%d')"

    ## calc spacing
    var_left_cnt="${#var_left}"
    var_right_cnt="${#var_right}"
    var_center_cnt="${#var_center}"
    ((var_content_cnt=VAR_TERM_WIDTH-var_left_cnt-var_right_cnt))
    [[ ${var_content_cnt} < 0 ]] && var_content_cnt=0

    if ((var_content_cnt < ${var_center_cnt})); then
        var_center=${var_center:var_center_cnt-var_content_cnt:var_content_cnt}
        var_center=" ${var_center#*/}"
        var_center_cnt="${#var_center}"
    fi
    # flog_msg "test-> ${var_content_cnt}/$VAR_TERM_WIDTH"
    var_spacing=$(printf "% $((var_content_cnt - ${var_center_cnt}))s" "")

    ## Update content
    # '\e7':       Save cursor position.
    #              This is more widely supported than '\e[s'.
    # '\e[%sH':    Move cursor to bottom of the terminal.
    # '\e[30;41m': Set foreground and background colors.
    # '%*s':       Insert enough spaces to fill the screen width.
    #              This sets the background color to the whole line
    #              and fixes issues in 'screen' where '\e[K' doesn't work.
    # '\r':        Move cursor back to column 0 (was at EOL due to above).
    # '\e[m':      Reset text formatting.
    # '\e[H\e[K':  Clear line below fterminal_draw_status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.

    fterminal_print "\e7\e[%sH\r\e[%sm%s\e[%sm%s\e[%sm%s\e[m\e8" \
           "$((VAR_TERM_HEIGHT-1))" \
           "${HSFM_COLOR_STATUS_LABEL}" \
           "${var_left}" \
           "${HSFM_COLOR_STATUS}" \
           "${var_center}${var_spacing}" \
           "${HSFM_COLOR_STATUS_LABEL}" \
           "${var_right}"
}

fterminal_draw_command_line() {

    if [[ "${FM_ED_ACTIVE}" = "1" ]] ||
        [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_COMMAND}" ] ||
        [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_SEARCH}" ] ||
        [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_FIND}" ]
    then
        fterminal_print '\e[?25l\e[%sH' "$VAR_TERM_HEIGHT"
        fterminal_print $'\r%s\e[K%s\e[?25h' "$(fedit_line)" "$(printf "\e[%dD" "$(fedit_cursor_offset)")"
    else
        fterminal_print '\e7\e[%sH\e[K\e[?25l\e8' "$VAR_TERM_HEIGHT"
    fi
}

# FIXME, need impl a way to acept win type, for input purpose.
fterminal_draw_miniwin()
{
    local var_start_line=$((${VAR_TERM_HEIGHT}/4))
    local var_start_col=$((${VAR_TERM_WIDTH}/4))
    local var_width=$((${VAR_TERM_WIDTH}/2))
    local var_height=$((${VAR_TERM_HEIGHT}/2))
    local var_win_title="Action WIN"
    local var_buffer=()
    var_buffer+=("Action ongoing")
    var_buffer+=("$@")

    fterminal_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "${var_buffer[@]}"
}

# its an exp miniwin.
fterminal_draw_checkwin() {

    local var_start_line=$((${VAR_TERM_HEIGHT}/4))
    local var_start_col=$((${VAR_TERM_WIDTH}/4))
    local var_width=$((${VAR_TERM_WIDTH}/2))
    local var_height=$((${VAR_TERM_HEIGHT}/2))
    local var_win_title="Check WIN"
    local var_buffer=()
    var_buffer+=("Action ongoing")
    var_buffer+=("$@")

    fterminal_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "${var_buffer[@]}"
    # sleep 2

    fterminal_redraw full
    return 0
}

fterminal_draw_msgwin()
{
    local var_start_col=0
    local var_start_line=$((${VAR_TERM_MAINWIN_START_IDX[1]} + ${VAR_TERM_MAINWIN_HEIGHT}))
    # local var_start_line=20
    local var_width=${VAR_TERM_WIDTH}
    local var_height=${VAR_TERM_SUBWIN_BOTTOM_SIZE}
    local var_win_title="Message WIN"
    local var_buffer=("${VAR_TERM_MSGWIN_BUFFER[@]}")

    fterminal_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "${var_buffer[@]}"
}

fterminal_draw_taskwin()
{
    local var_start_col=0
    local var_start_line=$((${VAR_TERM_MAINWIN_START_IDX[1]} + ${VAR_TERM_MAINWIN_HEIGHT}))
    local var_width=${VAR_TERM_WIDTH}
    local var_height=${VAR_TERM_SUBWIN_BOTTOM_SIZE}
    local var_win_title="Task WIN"
    local var_buffer=("${VAR_TERM_TASKWIN_BUFFER[@]}")

    fterminal_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "${var_buffer[@]}"
}

flog_msg_debug()
{
    # if [ ${HSFM_DEBUG} = true ]
    # then
    #     printf "%s\n" "$*" >> ${HSFM_FILE_MESSAGE}
    # fi
    # printf -v VAR_TERM_MSGWIN_BUFFER "%s\n" "$*" >> ${HSFM_FILE_MESSAGE}
    #
    local var_max_msg_cnt=20
    if [[ ${#VAR_TERM_MSGWIN_BUFFER[@]} -gt $((var_max_msg_cnt * 2)) ]]
    then

        VAR_TERM_MSGWIN_BUFFER=("${VAR_TERM_MSGWIN_BUFFER[@]: -$var_max_msg_cnt}")
        VAR_TERM_MSGWIN_BUFFER=("${VAR_TERM_MSGWIN_BUFFER[@]}" "Drop message. Current cnt: ${#VAR_TERM_MSGWIN_BUFFER[@]}")
    else
        VAR_TERM_MSGWIN_BUFFER=("${VAR_TERM_MSGWIN_BUFFER[@]}")
    fi
    VAR_TERM_MSGWIN_BUFFER=("${VAR_TERM_MSGWIN_BUFFER[@]}" "$@")
    if [ ${VAR_TERM_BOTTOMWIN_SHOW} = ${DEF_TERM_WIN_TYPE_MSG} ]
    then
        fterminal_draw_msgwin
    fi
}

flog_msg()
{
    fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_HEIGHT"
    fterminal_print '\r\e[%sH\e[?25h\e[2K%s' "$VAR_TERM_HEIGHT" "$*"
    fterminal_print '\e[?25l\e8'
}

###########################################################
## L2 Workspace
## directory list, tabs, marks, cursor and scroll numbers, file getters.
###########################################################

fterminal_mark_toggle() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$VAR_TERM_MARK_DIR" ]] &&
        VAR_TERM_MARKED_FILE_LIST=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${VAR_TERM_DIR_FILE_LIST[0]} == empty && -z ${VAR_TERM_DIR_FILE_LIST[1]} ]] &&
        return

    if [[ $1 == all ]]; then
        if ((${#VAR_TERM_MARKED_FILE_LIST[@]} != ${#VAR_TERM_DIR_FILE_LIST[@]})); then
            VAR_TERM_MARKED_FILE_LIST=("${VAR_TERM_DIR_FILE_LIST[@]}")
            VAR_TERM_MARK_DIR=$PWD
        else
            VAR_TERM_MARKED_FILE_LIST=()
        fi

        fterminal_redraw
    else
        if [[ ${VAR_TERM_MARKED_FILE_LIST[$1]} == "${VAR_TERM_DIR_FILE_LIST[$1]}" ]]; then
            unset 'VAR_TERM_MARKED_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]'

        else
            VAR_TERM_MARKED_FILE_LIST[$1]="${VAR_TERM_DIR_FILE_LIST[$1]}"
            VAR_TERM_MARK_DIR=$PWD
        fi

        # Clear line before changing it.
        fterminal_print '\e[K'
        fterminal_draw_file_line "$1"
    fi

    # Find the program to use.
    # case "$2" in
    #     ${HSFM_KEY_YANK:=y}|${HSFM_KEY_YANK_ALL:=Y}) VAR_TERM_FILE_PROGRAM=(fselect_copy) ;;
    #     ${HSFM_KEY_CUT:=m}|${HSFM_KEY_MOVE_ALL:=M}) VAR_TERM_FILE_PROGRAM=(mv -i)  ;;
    #     ${HSFM_KEY_LINK:=s}|${HSFM_KEY_LINK_ALL:=S}) VAR_TERM_FILE_PROGRAM=(ln -s)  ;;
    #
    #     # These are 'hsfm' functions.
    #     ${HSFM_KEY_TRASH:=d}|${HSFM_KEY_TRASH_ALL:=D})
    #         VAR_TERM_FILE_PROGRAM=(fselect_remove)
    #     ;;
    #
    #     ${HSFM_KEY_BULK_RENAME:=b}|${HSFM_KEY_BULK_RENAME_ALL:=B})
    #         VAR_TERM_FILE_PROGRAM=(fselect_rename)
    #     ;;
    # esac

    # fterminal_draw_status_line
}

fterminal_mark_reset() {
    VAR_TERM_MARKED_FILE_LIST=()
}

fterminal_mark_add() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$VAR_TERM_MARK_DIR" ]] &&
        VAR_TERM_MARKED_FILE_LIST=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${VAR_TERM_DIR_FILE_LIST[0]} == empty && -z ${VAR_TERM_DIR_FILE_LIST[1]} ]] &&
        return

    {
        if [[ ${VAR_TERM_MARKED_FILE_LIST[$1]} != "${VAR_TERM_DIR_FILE_LIST[$1]}" ]]; then
            VAR_TERM_MARKED_FILE_LIST[$1]="${VAR_TERM_DIR_FILE_LIST[$1]}"
            VAR_TERM_MARK_DIR=$PWD
        fi

        # Clear line before changing it.
        fterminal_print '\e[K'
        fterminal_draw_file_line "$1"
    }

    # fterminal_draw_status_line
}

fterminal_mark_remove() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$VAR_TERM_MARK_DIR" ]] &&
        VAR_TERM_MARKED_FILE_LIST=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${VAR_TERM_DIR_FILE_LIST[0]} == empty && -z ${VAR_TERM_DIR_FILE_LIST[1]} ]] &&
        return

    {
        if [[ ${VAR_TERM_MARKED_FILE_LIST[$1]} == "${VAR_TERM_DIR_FILE_LIST[$1]}" ]]; then
            unset 'VAR_TERM_MARKED_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]'
        fi

        # Clear line before changing it.
        fterminal_print '\e[K'
        fterminal_draw_file_line "$1"
    }

    # fterminal_draw_status_line
}

# Directory pipeline (L2).
#
# A source prints one raw line per entry. The ingest parses those lines into the
# two published lists. Feed the ingest with a here-doc, never a pipe: the pipe
# would run it in a subshell and the lists would be lost.
fdirsrc_find()
{
    local var_pattern=$1
    local var_find_args=("")

    timeout 10 find "${PWD}" ${var_find_args[@]} -name "${var_pattern}" 2>&1
}

fdirsrc_ls()
{
    local var_pattern=$1
    local var_ls_args=(${VAR_TERM_DIR_LS_ARGS[@]})

    if test -n "${HSFM_LS_SORTING}"
    then
        var_ls_args+=("${HSFM_LS_SORTING}")
    fi

    ls ${var_ls_args[@]} "${PWD}"/${var_pattern} 2>&1
}

fdirsrc_ls_sort()
{
    local var_pattern=$1
    local var_ls_args=(${VAR_TERM_DIR_LS_ARGS[@]})

    if test -n "${HSFM_LS_SORTING}"
    then
        var_ls_args+=("${HSFM_LS_SORTING}")
    fi

    ls ${var_ls_args[@]} "${PWD}"/${var_pattern} | sort -rk1,1 2>&1
}

fdir_ingest()
{
    local var_item_index=0
    local var_line
    local var_item
    local var_info
    # Entries that failed to stat are appended after the readable ones, as the
    # original two-list flush did.
    local var_denied_item_list=()
    local var_denied_info_list=()

    # No -r: the callers rely on backslash processing, as the loops did.
    while read var_line;
    do
        if ! [[ "${var_line}" =~ / ]]
        then
            continue
        fi
        if [[ ${var_line} =~ ^ls:* ]]
        then
            # Access fail
            var_line="${var_line/: Permission denied/}"
            var_line="${var_line/cannot access /}"

            var_info="Permission denied"
            var_item=${var_line/*: /}
            var_item=${var_item//\'/}

            var_denied_item_list+=("${var_item}")
            var_denied_info_list+=("${var_info}")

            flog_msg_debug "${var_item}"
            continue
        else
            var_line="${var_line%% ->*}"

            var_info="${var_line%% /*}"
            var_item=${var_line/#*[0-9]? \//\/}
        fi

        if [[ -d ${var_item} ]]
        then
            VAR_TERM_DIR_FILE_LIST+=("${var_item}")
            VAR_TERM_DIR_FILE_INFO_LIST+=("${var_info}")

            # Find the position of the child directory in the
            # parent directory list.
            [[ ${var_item} == "${OLDPWD}" ]] &&
                ((FM_DIR_PREV_IDX=var_item_index))
        else
            VAR_TERM_DIR_FILE_LIST+=("${var_item}")
            VAR_TERM_DIR_FILE_INFO_LIST+=("${var_info}")
        fi
        ((var_item_index++))
    done

    if [[ ${#var_denied_item_list[@]} -ge 1 ]]
    then
        VAR_TERM_DIR_FILE_LIST+=("${var_denied_item_list[@]}")
        VAR_TERM_DIR_FILE_INFO_LIST+=("${var_denied_info_list[@]}")
    fi
}

# Set FM_DIR_PREV_IDX to the position of $OLDPWD in the published list.
# The path is data: a fixed-string whole-line match, first hit only.
fdir_prev_index()
{
    local var_index=""

    if test -z "${OLDPWD}"
    then
        FM_DIR_PREV_IDX=0
        return 0
    fi

    var_index=$(printf '%s\n' "${VAR_TERM_DIR_FILE_LIST[@]}" |
        grep -n -F -x -- "${OLDPWD}" 2>/dev/null | head -n 1 | cut -d: -f1)

    if test -z "${var_index}"
    then
        FM_DIR_PREV_IDX=0
    else
        FM_DIR_PREV_IDX=$((var_index - 1))
    fi
}

fterminal_read_dir() {
    # Read a directory to an array and sort it directories first.
    local var_pattern="*"
    local var_dirs
    local var_files
    local var_item_index=0

    local item

    VAR_TERM_DIR_FILE_LIST=()
    VAR_TERM_DIR_FILE_INFO_LIST=()
    # NOTE. Clear VAR_TERM_DIR_FILE_LIST & use it directly to avoid VAR_TERM_DIR_FILE_LIST index issue on BSD

    if [[ "${#}" -eq "1" ]]
    then
        var_pattern="*$1*"
    fi

    # Set window name.
    fterminal_print '\e]2;hsfm: %s\e'\\ "$PWD"

    # If '$PWD' is '/', unset it to avoid '//'.
    [[ $PWD == / ]] && PWD=

    # set flags.
    shopt_flags=(s u)
    shopt -"${shopt_flags[$HSFM_ENABLE_HIDDEN]}" dotglob

    # tmp_start=$(date +%N)
    if [[ ${HSFM_READ_DIR_MODE} == ${DEF_TERM_READ_DIR_MODE_NONE} ]]
    then
        VAR_TERM_DIR_FILE_LIST=("$PWD"/${var_pattern})

        # Update previous index.
        fdir_prev_index
    elif [[ ${HSFM_READ_DIR_MODE} == ${DEF_TERM_READ_DIR_MODE_SORT} ]]
    then
        # for some reason, we should sort in seperate loop.
        # sort for dir first
        # for item in "$PWD"/*; do
        for item in "$PWD"/${var_pattern}; do

            if [[ -d $item ]]; then
                var_dirs+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")

            # Find the position of the child directory in the
            # parent directory list.
            [[ $item == "$OLDPWD" ]] &&
                ((FM_DIR_PREV_IDX=var_item_index))
                            ((var_item_index++))
            fi
        done

        for item in "$PWD"/*; do
            if [[ -f $item ]]; then
                var_files+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
            fi
        done
    # with find.
    elif [[ $HSFM_READ_DIR_MODE == ${DEF_TERM_READ_DIR_MODE_FIND} ]]
    then
        fdir_ingest << EOF
$(fdirsrc_find "${var_pattern}")
EOF
    elif [[ $HSFM_READ_DIR_MODE == ${DEF_TERM_READ_DIR_MODE_LS} ]]
    then
        fdir_ingest << EOF
$(fdirsrc_ls "${var_pattern}")
EOF
    elif [[ $HSFM_READ_DIR_MODE == ${DEF_TERM_READ_DIR_MODE_LS_SORT} ]]
    then
        fdir_ingest << EOF
$(fdirsrc_ls_sort "${var_pattern}")
EOF
    elif [[ $HSFM_READ_DIR_MODE == ${DEF_TERM_READ_DIR_MODE_FAST_LS} ]] || true
    then
        # ${DEF_TERM_READ_DIR_MODE_LS}
        local var_ls_args=(${VAR_TERM_DIR_LS_ARGS[@]})
        if test -n "${HSFM_LS_SORTING}"
        then
            var_ls_args+=("${HSFM_LS_SORTING}")
        fi
        # var_ls_args+=("--time-style=+%Y-%m-%d-%H:%M,")
        var_ls_args+=("--time-style=+%Y-%m-%d-%H:%M")
        var_ls_args+=("--quote-name")

        # local tmp_ls_output="$(ls ${var_ls_args[*]} ${PWD}/${var_pattern})"
        local tmp_ls_output=$(ls ${var_ls_args[*]} "${PWD}"/${var_pattern})
        # flog_msg_debug "LS args: 'ls ${var_ls_args[*]} ${PWD}/${var_pattern}'"

        # flog_msg_debug "Fast mode:idx[0]=>'${tmp_ls_output[0]}'"
        # flog_msg_debug "LS args: '${var_ls_args[*]}'"

        # mapfile -t tmp_ls_info < <(echo "$tmp_ls_output" | cut -d ',' -f 1)
        # mapfile -t tmp_ls_file < <(echo "$tmp_ls_output" | cut -d ',' -f 2)

        # mapfile -t tmp_ls_info < <(echo "$tmp_ls_output" | cut -d ',' -f 1)
        # mapfile -t tmp_ls_file < <(echo "$tmp_ls_output" | cut -d ',' -f 2- | sed "s/^ //g" | sed "s/ -> .*$//g")

        mapfile -t tmp_ls_info < <(echo "$tmp_ls_output" | cut -d '"' -f 1 | sed "s/ $//g")
        mapfile -t tmp_ls_file < <(echo "$tmp_ls_output" | cut -d '"' -f 2 | sed "s/ -> .*$//g")

        # Debug
        # for each_item in "${tmp_ls_info[@]}";do
        #     flog_msg_debug "info Item=>${each_item}"
        # done
        #
        # for each_item in "${tmp_ls_file[@]}";do
        #     flog_msg_debug "file Item=>${each_item}"
        # done

        # if [[ "${#tmp_ls_file[@]}" -eq "1" ]]
        if ! ([[ "${#tmp_ls_file[@]}" -eq "1" ]] && [ "${tmp_ls_file[0]}" = "." ])
        then
            VAR_TERM_DIR_FILE_LIST=("${tmp_ls_file[@]}")
            VAR_TERM_DIR_FILE_INFO_LIST=("${tmp_ls_info[@]}")

            # Update previous index.
            fdir_prev_index
        # else
        #     flog_msg_debug "Empty folder"
        fi

    fi
    # tmp_end=$(date +%N)
    # flog_msg_debug "Read Dir Time: $((tmp_end - tmp_start))"

    # sort for dir first
    # VAR_TERM_DIR_FILE_LIST=("${var_dirs[@]}" "${var_files[@]}")

    # Indicate that the directory is empty.
    [[ -z ${VAR_TERM_DIR_FILE_LIST[0]} ]] &&
        VAR_TERM_DIR_FILE_LIST[0]=empty

    ((VAR_TERM_DIR_LIST_CNT=${#VAR_TERM_DIR_FILE_LIST[@]}-1))

    # Save the original dir in a second VAR_TERM_DIR_FILE_LIST as a backup.
    FM_DIR_BACKUP=("${VAR_TERM_DIR_FILE_LIST[@]}")
}

fterminal_tab_reset_contex() {
    local var_tab_id=$1

    VAR_TERM_CONTENT_SCROLL_START_IDX=0
    VAR_TERM_CONTENT_SCROLL_IDX=0
    VAR_TERM_WIN_CURRENT_CURSOR=$((VAR_TERM_CONTENT_SCROLL_START_IDX - VAR_TERM_CONTENT_SCROLL_IDX))
    # flog_msg_debug "Store: ${VAR_TERM_TAB_LINE_LIST_START_IDX[var_tab_id]}/${VAR_TERM_TAB_LINE_LIST_IDX[var_tab_id]}/${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"
}

fterminal_tab_save_contex() {
    local var_tab_id=${1}

    VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]="${PWD}"
    VAR_TERM_TAB_LINE_LIST_START_IDX[var_tab_id]="${VAR_TERM_CONTENT_SCROLL_START_IDX}"
    VAR_TERM_TAB_LINE_LIST_IDX[var_tab_id]="${VAR_TERM_CONTENT_SCROLL_IDX}"
    # flog_msg_debug "Store: ${VAR_TERM_TAB_LINE_LIST_START_IDX[var_tab_id]}/${VAR_TERM_TAB_LINE_LIST_IDX[var_tab_id]}/${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"
}

fterminal_tab_load_contex() {
    local var_tab_id=${1}

        # echo "${VAR_TERM_DIR_FILE_INFO_LIST[@]}"
    if test -d "${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"
    then
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"

        # Read the directory again. A cached list is stale, and serializing one
        # needs a separator that a file name may contain.
        fterminal_read_dir

        VAR_TERM_CONTENT_SCROLL_START_IDX=${VAR_TERM_TAB_LINE_LIST_START_IDX[var_tab_id]}
        VAR_TERM_CONTENT_SCROLL_IDX=${VAR_TERM_TAB_LINE_LIST_IDX[var_tab_id]}
        VAR_TERM_WIN_CURRENT_CURSOR=$((VAR_TERM_CONTENT_SCROLL_START_IDX - VAR_TERM_CONTENT_SCROLL_IDX))
    else
        cd "${HOME}"

        VAR_TERM_CONTENT_SCROLL_START_IDX=0
        VAR_TERM_CONTENT_SCROLL_IDX=0
        VAR_TERM_WIN_CURRENT_CURSOR=$((VAR_TERM_CONTENT_SCROLL_START_IDX - VAR_TERM_CONTENT_SCROLL_IDX))
        flog_msg "Folder not found. back to HOME folder. '${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}'"
    fi
    # flog_msg_debug "Load: ${VAR_TERM_WIN_CURRENT_CURSOR}${VAR_TERM_CONTENT_SCROLL_START_IDX}/${VAR_TERM_CONTENT_SCROLL_IDX}/${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"
}

fterminal_tab_remove() {
    local var_tab_start_idx=${1}
    local each_idx

    each_idx=${var_tab_start_idx}
    while ((${each_idx} < ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}))
    do
        if ((${each_idx} + 1 <  ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}))
        then
            VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]="${VAR_TERM_TAB_LINE_LIST_PATH[$((${each_idx} + 1))]}"
            VAR_TERM_TAB_LINE_LIST_START_IDX[${each_idx}]="${VAR_TERM_TAB_LINE_LIST_START_IDX[$((${each_idx} + 1))]}"
            VAR_TERM_TAB_LINE_LIST_IDX[${each_idx}]="${VAR_TERM_TAB_LINE_LIST_IDX[$((${each_idx} + 1))]}"
        elif ((${each_idx} + 1 == ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}))
        then
            tmp_remove_pattern="hsfm_removed"
            VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]=${tmp_remove_pattern}
            VAR_TERM_TAB_LINE_LIST_PATH=(${VAR_TERM_TAB_LINE_LIST_PATH[@]/${tmp_remove_pattern}})

            VAR_TERM_TAB_LINE_LIST_START_IDX[${each_idx}]=${tmp_remove_pattern}
            VAR_TERM_TAB_LINE_LIST_START_IDX=(${VAR_TERM_TAB_LINE_LIST_START_IDX[@]/${tmp_remove_pattern}})

            VAR_TERM_TAB_LINE_LIST_IDX[${each_idx}]=${tmp_remove_pattern}
            VAR_TERM_TAB_LINE_LIST_IDX=(${VAR_TERM_TAB_LINE_LIST_IDX[@]/${tmp_remove_pattern}})
            break
        fi
        ((each_idx+=1))
    done

}

fterminal_tab_swap_contex() {
    local var_tab_id_a=${1}
    local var_tab_id_b=${2}
    local tmp_path
    local tmp_start_idx
    local tmp_idx

    tmp_path=${VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_a}]}
    tmp_start_idx=${VAR_TERM_TAB_LINE_LIST_START_IDX[${var_tab_id_a}]}
    tmp_idx=${VAR_TERM_TAB_LINE_LIST_IDX[${var_tab_id_a}]}

    VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_a}]=${VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_b}]}
    VAR_TERM_TAB_LINE_LIST_START_IDX[${var_tab_id_a}]=${VAR_TERM_TAB_LINE_LIST_START_IDX[${var_tab_id_b}]}
    VAR_TERM_TAB_LINE_LIST_IDX[${var_tab_id_a}]=${VAR_TERM_TAB_LINE_LIST_IDX[${var_tab_id_b}]}

    VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_b}]=${tmp_path}
    VAR_TERM_TAB_LINE_LIST_START_IDX[${var_tab_id_b}]=${tmp_start_idx}
    VAR_TERM_TAB_LINE_LIST_IDX[${var_tab_id_b}]=${tmp_idx}
}

fprase_mime_type() {
    # Get a file's mime_type.
    # mime_type=$(file "-${VAR_TERM_FILE_ARGS:-biL}" "$1" 2>/dev/null)
    echo $(file "-${VAR_TERM_FILE_ARGS:-biL}" "$*" 2>/dev/null)
}

fget_cursor_file() {
    # echo ${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}
    printf "%s\n" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
}

fget_selection_file() {
    echo ${VAR_TERM_SELECTION_FILE_LIST[@]}
}

###########################################################
## L3 Commands
## cmd_*, vcmd_*, file operations, fsys_open, scroll and tab actions.
## May call only fprompt_wait and fprompt_confirm in L4.
###########################################################

###########################################################
## Env Functions
###########################################################
fenv_left_hande_mode() {
    local args_value="$1"

    if [ "${args_value}" = "on" ]
    then
        HSFM_ENV_LEFT_HAND_MODE=1

        # to left hande
        HSFM_KEY_CHILD1="g"
        HSFM_KEY_PARENT1="s"
        HSFM_KEY_SCROLL_DOWN1="f"
        HSFM_KEY_SCROLL_UP1="d"
    elif [ "${args_value}" = "off" ]
    then
        HSFM_ENV_LEFT_HAND_MODE=0

        # restore to right hand
        HSFM_KEY_CHILD1="l"
        HSFM_KEY_PARENT1="h"
        HSFM_KEY_SCROLL_DOWN1="j"
        HSFM_KEY_SCROLL_UP1="k"
    else
        flog_msg "Unknown value: ${args_value}"
        return -1
    fi
    return 0
}

###########################################################
## GUI Functions
###########################################################

fgui_scroll_up() {
    # '\e[1L': Insert a line above the cursor.
    # '\e[A':  Move cursor up a line.
    if ((VAR_TERM_CONTENT_SCROLL_IDX > 0))
    then
        VAR_TERM_PRINT_BUFFER_ENABLE=true
        ((VAR_TERM_CONTENT_SCROLL_IDX--))

        fterminal_draw_file_line "$((VAR_TERM_CONTENT_SCROLL_IDX+1))"

        if ((VAR_TERM_WIN_CURRENT_CURSOR < 1)); then
            # fterminal_print '\e[L'
            fterminal_redraw
            return 0
        else
            fterminal_print '\e[A'
            ((VAR_TERM_WIN_CURRENT_CURSOR--))
        fi
        fterminal_draw_file_line $VAR_TERM_CONTENT_SCROLL_IDX

        # fterminal_draw_status_line
        fterminal_flush
    fi
}

fgui_scroll_down() {
    if ((VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_DIR_LIST_CNT))
    then
        VAR_TERM_PRINT_BUFFER_ENABLE=true

        ((VAR_TERM_CONTENT_SCROLL_IDX++))

        if ((VAR_TERM_WIN_CURRENT_CURSOR + 1 < VAR_TERM_MAINWIN_HEIGHT))
        then
            fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX-1))
            ((VAR_TERM_WIN_CURRENT_CURSOR++))
        else
            # FIXME, it's a patch to avoid glitch
            # clear the first content line
            # fterminal_draw_tab_line
            # fterminal_print "\e[$((VAR_TERM_MAINWIN_HEIGHT + VAR_TERM_TAB_LINE_HEIGHT))H"
            # fterminal_draw_dir

            # Draw new page, this is not partial update.
            fterminal_redraw
            return 0
        fi
        fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX))

        # fterminal_draw_status_line
        fterminal_flush
    fi
}

# FIXME, i dont want to seperate two simlar function for different mode
fgui_scroll_up_visual() {
    # '\e[1L': Insert a line above the cursor.
    # '\e[A':  Move cursor up a line.
    if ((VAR_TERM_CONTENT_SCROLL_IDX > 0))
    then
        VAR_TERM_PRINT_BUFFER_ENABLE=true
        if [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ ${VAR_TERM_CONTENT_SCROLL_IDX} -gt ${VAR_TERM_VISUAL_START_IDX} ]]
        then
            fterminal_mark_remove "$VAR_TERM_CONTENT_SCROLL_IDX"
        fi
        ((VAR_TERM_CONTENT_SCROLL_IDX--))

        fterminal_draw_file_line "$((VAR_TERM_CONTENT_SCROLL_IDX+1))"

        if ((VAR_TERM_WIN_CURRENT_CURSOR < 1)); then
            fterminal_print '\e[L'
        else
            fterminal_print '\e[A'
            ((VAR_TERM_WIN_CURRENT_CURSOR--))
        fi
        fterminal_draw_file_line $VAR_TERM_CONTENT_SCROLL_IDX
        if [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ $VAR_TERM_CONTENT_SCROLL_IDX -lt $VAR_TERM_VISUAL_START_IDX ]]
        then
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
        fi
        # fterminal_draw_tab_line
        # fterminal_draw_status_line
        fterminal_flush
    fi
}

fgui_scroll_down_visual() {
    if ((VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_DIR_LIST_CNT))
    then
        VAR_TERM_PRINT_BUFFER_ENABLE=true

        # We need to mark on visula mode
        if [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ ${VAR_TERM_CONTENT_SCROLL_IDX} -lt ${VAR_TERM_VISUAL_START_IDX} ]]
        then
            fterminal_mark_remove "$VAR_TERM_CONTENT_SCROLL_IDX"
        fi
        ((VAR_TERM_CONTENT_SCROLL_IDX++))

        fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX-1))
        fterminal_print "\n"

        if ((VAR_TERM_WIN_CURRENT_CURSOR + 1 < VAR_TERM_MAINWIN_HEIGHT))
        then
            ((VAR_TERM_WIN_CURRENT_CURSOR++))
        else
            # FIXME, it's a patch to avoid glitch
            # clear the first content line
            fterminal_draw_tab_line
            fterminal_print "\e[$((VAR_TERM_MAINWIN_HEIGHT + VAR_TERM_TAB_LINE_HEIGHT))H"
        fi

        if [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ $VAR_TERM_CONTENT_SCROLL_IDX -gt $VAR_TERM_VISUAL_START_IDX ]]
        then
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
        else
            fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX))
        fi
        # fterminal_draw_status_line
        fterminal_flush
    fi
}

fgui_scroll_top_visual() {
    if ((VAR_TERM_CONTENT_SCROLL_IDX == 0)); then
        return
    fi
    VAR_TERM_PRINT_BUFFER_ENABLE=true

    VAR_TERM_CONTENT_SCROLL_IDX=0
    fterminal_mark_reset

    local start_idx=${VAR_TERM_VISUAL_START_IDX}
    local end_idx=${VAR_TERM_CONTENT_SCROLL_IDX}

    if ((start_idx > end_idx)); then
        local tmp=${start_idx}
        start_idx=${end_idx}
        end_idx=${tmp}
    fi

    for ((i=start_idx; i<=end_idx; i++)); do
        fterminal_mark_add "$i"
    done
    # we need to remove the marked line previously.
    fterminal_redraw
}

fgui_scroll_bottom_visual() {
    if ((VAR_TERM_CONTENT_SCROLL_IDX == VAR_TERM_DIR_LIST_CNT)); then
        return
    fi
    VAR_TERM_PRINT_BUFFER_ENABLE=true

    VAR_TERM_CONTENT_SCROLL_IDX=${VAR_TERM_DIR_LIST_CNT}
    fterminal_mark_reset

    local start_idx=${VAR_TERM_VISUAL_START_IDX}
    local end_idx=${VAR_TERM_CONTENT_SCROLL_IDX}

    if ((start_idx > end_idx)); then
        local tmp=${start_idx}
        start_idx=${end_idx}
        end_idx=${tmp}
    fi

    for ((i=start_idx; i<=end_idx; i++)); do
        fterminal_mark_add "$i"
    done
    # we need to remove the marked line previously.
    fterminal_redraw
}

fgui_tab_go_previous()
{
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        [[ ${VAR_TERM_TAB_LINE_IDX} -eq 0 ]]
        then
            flog_msg "PREVIOUS_TAB ignored."
            return
        else
            fterminal_tab_save_contex ${VAR_TERM_TAB_LINE_IDX}
            VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
            VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX - 1))
            cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
            fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
            # fterminal_redraw full
            fterminal_redraw
            flog_msg "Go PREVIOUS_TAB."
    fi
}

fgui_tab_go_next()
{
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        (( ${VAR_TERM_TAB_LINE_IDX} + 1 == ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} )) ||
        ! test -d "${VAR_TERM_TAB_LINE_LIST_PATH[(( ${VAR_TERM_TAB_LINE_IDX} + 1))]}"
    then
        flog_msg "NEXT_TAB ignored."
        return
    else
        fterminal_tab_save_contex ${VAR_TERM_TAB_LINE_IDX}
        VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
        VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX + 1))
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
        fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
        fterminal_redraw
        flog_msg "Go NEXT_TAB"
    fi
}

fgui_tab_move_previous()
{
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        [[ ${VAR_TERM_TAB_LINE_IDX} -eq 0 ]]
    then
        flog_msg "MOVE_PREVIOUS_TAB ignored."
        return
    else
        fterminal_tab_save_contex ${VAR_TERM_TAB_LINE_IDX}
        fterminal_tab_swap_contex ${VAR_TERM_TAB_LINE_IDX} $(($VAR_TERM_TAB_LINE_IDX - 1))
        # tmp_preserved_path=${VAR_TERM_TAB_LINE_LIST_PATH[$((${VAR_TERM_TAB_LINE_IDX}-1))]}
        # VAR_TERM_TAB_LINE_LIST_PATH[$((${VAR_TERM_TAB_LINE_IDX} - 1))]="$(realpath .)"
        # VAR_TERM_TAB_LINE_LIST_PATH[$((${VAR_TERM_TAB_LINE_IDX}))]="${tmp_preserved_path}"
        VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX - 1))

        fterminal_redraw
        flog_msg "Move to PREVIOUS_TAB."
    fi
}

fgui_tab_move_next()
{
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        (( ${VAR_TERM_TAB_LINE_IDX} + 1 == ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} )) ||
        ! test -d ${VAR_TERM_TAB_LINE_LIST_PATH[(( ${VAR_TERM_TAB_LINE_IDX} + 1))]}

    then
        flog_msg "MOVE_NEXT_TAB ignored."
        return
    else
        fterminal_tab_save_contex ${VAR_TERM_TAB_LINE_IDX}
        fterminal_tab_swap_contex ${VAR_TERM_TAB_LINE_IDX} $(($VAR_TERM_TAB_LINE_IDX + 1))
        # tmp_preserved_path=${VAR_TERM_TAB_LINE_LIST_PATH[$((${VAR_TERM_TAB_LINE_IDX}+1))]}
        # VAR_TERM_TAB_LINE_LIST_PATH[$((${VAR_TERM_TAB_LINE_IDX}+1))]="$(realpath .)"
        # VAR_TERM_TAB_LINE_LIST_PATH[$((${VAR_TERM_TAB_LINE_IDX}))]="${tmp_preserved_path}"
        VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX + 1))

        fterminal_redraw
        flog_msg "Move to NEXT_TAB"
    fi
}

fgui_tab_open()
{
    VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"

    # move tab to insert a new tab.
    ((each_idx=${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
    while ((${each_idx} > ${VAR_TERM_TAB_LINE_IDX})) &&  ((each_idx != VAR_TERM_TAB_LINE_IDX))
    do
        VAR_TERM_TAB_LINE_LIST_PATH[$((${each_idx} + 1))]="${VAR_TERM_TAB_LINE_LIST_PATH[$((${each_idx}))]}"
        ((each_idx-=1))
    done

    fterminal_tab_save_contex ${VAR_TERM_TAB_LINE_IDX}
    VAR_TERM_TAB_LINE_IDX=$((${VAR_TERM_TAB_LINE_IDX} + 1))

    if test -d "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
    then
        cd "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
    fi
    fterminal_tab_reset_contex ${VAR_TERM_TAB_LINE_IDX}
    # VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
    fterminal_redraw full
}

fgui_tab_duplicate()
{
    VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"

    # move tab to insert a new tab.
    ((each_idx=${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
    while ((${each_idx} > ${VAR_TERM_TAB_LINE_IDX})) &&  ((each_idx != VAR_TERM_TAB_LINE_IDX))
    do
        VAR_TERM_TAB_LINE_LIST_PATH[$((${each_idx} + 1))]="${VAR_TERM_TAB_LINE_LIST_PATH[$((${each_idx}))]}"
        ((each_idx-=1))
    done

    fterminal_tab_save_contex ${VAR_TERM_TAB_LINE_IDX}
    VAR_TERM_TAB_LINE_IDX=$((${VAR_TERM_TAB_LINE_IDX} + 1))

    # if test -d "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
    # then
    #     cd "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
    # fi
    fterminal_tab_reset_contex ${VAR_TERM_TAB_LINE_IDX}
    # VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
    fterminal_redraw full
}

fgui_tab_close()
{
    local var_action=${1:- }
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]]
    then
        # flog_msg "CLOSE_TAB ignored."
        exit 0
    elif [ "${var_action}" = "right" ];then
        # flog_msg "CLOSE_TAB_RIGHT."
        tmp_current_idx=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
        if (( ${VAR_TERM_TAB_LINE_IDX} + 1 >= ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} ));then
            flog_msg "Ignore CLOSE_TAB_RIGHT."
            return 0
        fi

        while ((tmp_current_idx > VAR_TERM_TAB_LINE_IDX));do
            # flog_msg_debug "${tmp_current_idx}: ${VAR_TERM_TAB_LINE_LIST_PATH[tmp_current_idx]}"
            fterminal_tab_remove ${tmp_current_idx}
            ((tmp_current_idx = tmp_current_idx - 1))
        done

        VAR_TERM_TAB_LINE_IDX=${tmp_current_idx}

        # fterminal_redraw full
        # flog_msg "Tab closed."
    elif [ "${var_action}" = "left" ];then
        # flog_msg "CLOSE_TAB_LEFT."
        tmp_current_idx=$((${VAR_TERM_TAB_LINE_IDX} - 1))
        if (( VAR_TERM_TAB_LINE_IDX <= 0));then
            flog_msg "Ignore CLOSE_TAB_LEFT."
            return 0
        fi
        # flog_msg_debug ${tmp_current_idx} < ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}
        while ((tmp_current_idx >= 0));do
            flog_msg_debug "${tmp_current_idx}: ${VAR_TERM_TAB_LINE_LIST_PATH[tmp_current_idx]}"

            fterminal_tab_remove ${tmp_current_idx}
            ((tmp_current_idx = tmp_current_idx - 1))
        done

        VAR_TERM_TAB_LINE_IDX=0
        # fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
        # cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
        #
        # fterminal_redraw full
        # flog_msg "Tab closed."
    elif [ "${var_action}" = "others" ];then
        # flog_msg_debug "Right: ${VAR_TERM_TAB_LINE_IDX} / ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}"
        tmp_current_idx=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))

        while ((tmp_current_idx >= 0));do
            # flog_msg_debug "${tmp_current_idx}: ${VAR_TERM_TAB_LINE_LIST_PATH[tmp_current_idx]}"
            if (( tmp_current_idx != VAR_TERM_TAB_LINE_IDX ));then
                fterminal_tab_remove ${tmp_current_idx}
            # else
            #     flog_msg_debug "Skip current tab."
            fi
            ((tmp_current_idx = tmp_current_idx - 1))
        done

        VAR_TERM_TAB_LINE_IDX=0
        # fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
        # cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
        #
        # fterminal_redraw full
        # flog_msg "Tab closed."
    elif [ "${var_action}" = "duplicate" ];then
        # flog_msg_debug "Duplicate: ${VAR_TERM_TAB_LINE_IDX} / ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}"
        tmp_current_idx=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))

        while ((tmp_current_idx >= 1));do
            local var_current_path=${VAR_TERM_TAB_LINE_LIST_PATH[${tmp_current_idx}]}
            local found_duplicate=false

            # flog_msg_debug "Checking tab[${tmp_current_idx}]: ${var_current_path}"
            for each_idx in $(seq 0 $((tmp_current_idx - 1))); do
                local tmp_path=${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}
                # flog_msg_debug "${each_idx}: ${tmp_path},${var_current_path} "
                if [ "${tmp_path}" = "${var_current_path}" ] ; then
                    fterminal_tab_remove ${tmp_current_idx}
                    found_duplicate=true
                    break
                fi
            done

            if [ "${found_duplicate}" = "false" ]; then
                ((tmp_current_idx = tmp_current_idx - 1))
            fi
        done

        if [[ ${VAR_TERM_TAB_LINE_IDX} -ge ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} ]]
        then
            VAR_TERM_TAB_LINE_IDX=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
        fi

        fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
    else
        fterminal_tab_remove ${VAR_TERM_TAB_LINE_IDX}

        if [[ ${VAR_TERM_TAB_LINE_IDX} -ne 0 ]]
        then
            VAR_TERM_TAB_LINE_IDX=$((VAR_TERM_TAB_LINE_IDX - 1 ))
        fi

        fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"

        # fterminal_redraw full
        # flog_msg "Tab closed."
    fi

    # fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
    # cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"

    fterminal_redraw full
    flog_msg "Tab closed."
}

cmd_newsearch()
{
    local var_pattern="$*"

    fterminal_read_dir "*${var_pattern}*"

    # Draw the search results on screen.
    VAR_TERM_CONTENT_SCROLL_IDX=0
    fterminal_redraw

}

cmd_find()
{
    local var_pattern="$*"

    local var_read_mode=${HSFM_READ_DIR_MODE}
    # find
    HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_FIND}
    fterminal_read_dir "*${var_pattern}*"
    HSFM_READ_DIR_MODE=${var_read_mode}

    # Draw the search results on screen.
    VAR_TERM_CONTENT_SCROLL_IDX=0
    fterminal_redraw
}

cmd_search()
{
    local var_pattern="$*"
    # Search on keypress if search passed as an argument.
    # '\e[?25l': Hide the cursor.
    fterminal_print '\e[?25l'

    fterminal_read_dir "*${var_pattern}*"
    # if [[ $HSFM_READ_DIR_MODE == 0 ]]
    # then
    #     # Use a greedy glob to search.
    #     VAR_TERM_DIR_FILE_LIST=("$PWD"/*"$var_pattern"*)
    #     ((VAR_TERM_DIR_LIST_CNT=${#VAR_TERM_DIR_FILE_LIST[@]}-1))
    #     VAR_TERM_DIR_FILE_INFO_LIST=()
    # else
    #     VAR_TERM_DIR_FILE_LIST=("$PWD"/*"$var_pattern"*)
    #     ((VAR_TERM_DIR_LIST_CNT=${#VAR_TERM_DIR_FILE_LIST[@]}-1))
    #     VAR_TERM_DIR_FILE_INFO_LIST=()
    # fi

    # Draw the search results on screen.
    VAR_TERM_CONTENT_SCROLL_IDX=0
    fterminal_redraw

    # '\e[%sH':  Move cursor back to cmd-line.
    # '\e[?25h': Unhide the cursor.
    fterminal_print '\e[%sH\e[?25h' "$VAR_TERM_HEIGHT"
}

cmd_rename()
{
    local var_new_name="$@"
    if [[ -e $var_new_name ]]; then
        flog_msg "warn: '$var_new_name' already exists."

    elif [[ -w ${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]} ]]; then
        mv "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" "${PWD}/${var_new_name}"
        fterminal_redraw full
    else
        flog_msg "warn: no write access to file."
    fi
}

cmd_backfile()
{
    local var_original_file="${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
    local var_original_name="$(basename ${var_original_file})"
    local var_original_path="$(dirname ${var_original_file})"
    local var_timestamp=$(date +%Y%m%d_%H%M%S)
    local var_new_file="$var_original_path/backup_${var_timestamp}_${var_original_name}"

    if [[ -e $var_new_file ]]; then
        flog_msg "warn: '$var_new_file' already exists."
    elif [[ -w ${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]} ]]; then
        cp "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" "${var_new_file}"
        fterminal_redraw full
    else
        flog_msg "warn: no write access to file."
    fi
}

cmd_mkdir()
{
    local var_dir_name="$@"
    if [[ -e $var_dir_name ]]; then
        flog_msg "warn: '$var_dir_name' already exists."

    elif [[ -w $PWD ]]; then
        mkdir -p "${PWD}/${var_dir_name}"
        fterminal_redraw full

    else
        flog_msg "warn: no write access to dir."
    fi
}

cmd_touch()
{
    local var_dir_name="$@"
    if [[ -e $var_dir_name ]]; then
        flog_msg "warn: '$var_dir_name' already exists."

    elif [[ -w $PWD ]]; then
        : > "$var_dir_name"
        fterminal_redraw full

    else
        flog_msg "warn: no write access to dir."
    fi
}

# Resolve a command argument to a file: the argument when it is a file,
# otherwise the file under the cursor.
fcmd_file_get()
{
    local var_arg=$*

    if test -f "${var_arg}"
    then
        printf '%s\n' "${var_arg}"
    else
        fget_cursor_file
    fi
}

cmd_editor()
{
    local var_file=$(fcmd_file_get "$*")

    if [[ -f "${var_file}" ]]; then
        fterminal_reset

        if command -v "${HSFM_TEXT_EDITOR%% *}" 2>&1 > /dev/null;then
            # NOTE. VIDE_SH_TITLE use on the title of xim/vim projects.
            VIDE_SH_TITLE="${HSFM_ENV_TITLE}" ${HSFM_TEXT_EDITOR} "${var_file}"
        else
            flog_msg "warn: command '$HSFM_TEXT_EDITOR' not found"
        fi

        fterminal_setup
        fterminal_redraw
    else
        flog_msg "warn: '$var_file' not opened"
    fi
}

cmd_hex()
{
    local var_file=$(fcmd_file_get "$*")

    if ! command -v xxd 2>&1 > /dev/null; then
        flog_msg "warn: 'xxd' not found."
        return 1
    fi

    if [[ -f "${var_file}" ]]; then
        fterminal_reset

        xxd "${var_file}" |less

        fterminal_setup
        fterminal_redraw
    else
        flog_msg "warn: '$var_file' not opened"
    fi
}

cmd_media()
{
    local var_file=$(fcmd_file_get "$*")
    if [[ -f "${var_file}" ]]; then
        nohup "${HSFM_MEDIA_PLAYER}" "${var_file}" &>/dev/null &
        disown
    else
        flog_msg "warn: '${var_file}' not opened"
    fi
}

cmd_image()
{
    local var_file=$(fcmd_file_get "$*")
    if [[ -f "${var_file}" ]]; then
        nohup "${HSFM_PICTURE_VIEWER}" "${var_file}" &>/dev/null &
        disown
    else
        flog_msg "warn: '${var_file}' not opened"
    fi
}

cmd_preview()
{
    local var_file=$(fcmd_file_get "$*")

    VAR_TERM_PRINT_BUFFER_ENABLE=true
    fterminal_clear

    fterminal_draw_tab_line
    fterminal_draw_status_line
    fterminal_flush

    fterminal_print '\e[%sH\r' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    # fterminal_print '\e[%sH\rPreview File: %s\e[K\n' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))" "${var_file}"
    if command -v "catimg" 2>&1 > /dev/null; then
        local tmp_padding=1
        local tmp_height=$((${VAR_TERM_HEIGHT} - ${tmp_padding} - ${VAR_TERM_TAB_LINE_HEIGHT} - ${VAR_TERM_STATUS_LINE_CNT}))
        local tmp_args=("")

        # FIXME, disable true color, only for preview.
        tmp_args+=("-t")

        printf "$(catimg ${tmp_args[@]} -c -H ${tmp_height} ${var_file})"
    else
        printf "catimg not found. Please install catimg.\n"
    fi

    fprompt_wait "Press Enter Key To Continue..."
    fterminal_redraw
}

cmd_extract()
{
    local var_file=""
    local var_file_type=""
    local var_cmd=""
    local var_extrace_name=""

    if [[ "${#}" -ge "2" ]]
    then
        var_file_type="${1}"
        var_file="${2}"
    elif [[ "${#}" -ge "1" ]] && test -f "$1"
    then
        var_file_type="${1}"
        var_file="${1}"
    else
        var_file_type="${1}"
        var_file="$(fget_cursor_file)"
    fi

    if [ -f "${var_file}" ] ; then
        var_extrace_name=($(echo "${var_file##*/}"| futility_stream_purify))
        var_extrace_name="${var_extrace_name[*]}"
        # var_file=($(realpath "${var_file}"))
        # FIXME, not support reltive path.
        var_file="${var_file}"

        # Create extracting path
        local tmp_extrace_path="${var_extrace_name}_extracted"
        if [[ -e "${tmp_extrace_path}" ]]; then
            local tmp_time=$(date +%s)
            local tmp_extrace_path="${var_extrace_name}_extracted_${tmp_time}"
            mkdir "${tmp_extrace_path}"
            pushd "${tmp_extrace_path}" > /dev/null
            if ! eval "${var_cmd}" > /dev/null; then
                rm -rf "${tmp_extrace_path}"
            fi
            popd > /dev/null
        else
            mkdir "${tmp_extrace_path}"
        fi

    else
        flog_msg "'${var_file}' is not a valid file!"
        return 1
    fi
    case "${var_file_type}" in
        *tar.bz2|*tbz2)
            var_cmd="tar xvjf '${var_file}'"
            ;;
        *tar.gz|*tgz)
            var_cmd="tar xvzf '${var_file}'"
            ;;
        *tar.xz)
            var_cmd="tar xvJf '${var_file}'"
            ;;
        *bz2)
            var_cmd="bunzip2 '${var_file}'"
            ;;
        *rar)
            var_cmd="unrar x '${var_file}'"
            ;;
        *zip)
            var_cmd="unzip '${var_file}'"
            ;;
        *Z)
            var_cmd="uncompress '${var_file}'"
            ;;
        *tar)
            var_cmd="tar xvf '${var_file}'"
            ;;
        # *gz)
        #     var_cmd="gunzip -k '${var_file}'"
        #     ;;
        *7z|*gz)
            var_cmd="7z x '${var_file}'"
            ;;
        *)
            flog_msg "Unknown file type, use 7z to extract it"
            var_cmd="7z x '${var_file}'"
            ;;
    esac

    # flog_msg_debug "Creating folder file -${tmp_extrace_path[@]}-."

    fterminal_draw_miniwin "Start extract files."

    flog_msg "Starting extract file ${var_file}."
    flog_msg_debug "Eval: ${var_cmd}"

    pushd "${tmp_extrace_path}" > /dev/null
    if ! eval "${var_cmd}" > /dev/null; then
        rm -rf "${tmp_extrace_path}"
    fi
    popd > /dev/null

    # for redraw miniwin, we must redraw.
    fterminal_redraw full
    if [[ -e "${tmp_extrace_path}" ]]; then
        flog_msg "Extract file to '${tmp_extrace_path}'"
    else
        flog_msg "Extract file fail '${tmp_extrace_path}'"
    fi
}

cmd_shell()
{
    local var_file="$@"

    fterminal_clear
    fterminal_reset

    # Add hsfm on ps1
    bash --init-file <(echo ". \"$HOME/.bashrc\"; export HSFM_RUNNING=1; export PS1=\"[HSFM]\$PS1\"; cd ${PWD}")

    fterminal_setup
    fterminal_redraw
}

cmd_sort()
{
    local var_name=""
    case $1 in
        a*|alph|n*|none)
            HSFM_LS_SORTING="-U"
            var_name="none"
           ;;
        s*|size)
            HSFM_LS_SORTING="-S"
            var_name="size"
            ;;
        t*|time)
            HSFM_LS_SORTING="-t"
            var_name="time"
            ;;
        v*|version)
            HSFM_LS_SORTING="-v"
            var_name="version"
            ;;
        e*|extension)
            HSFM_LS_SORTING="-X"
            var_name="extension"
           ;;
        *)
            flog_msg "Sorting Options: none/size/time/version/extension, default use none."
            return 0
            ;;
    esac
    fterminal_redraw full
    flog_msg "Sorting: ${var_name}"
}

# Resolve a directory alias ("home", "log") to a path.
fenv_dir_alias_get()
{
    local var_key=$1
    local var_idx

    for var_idx in "${!HSFM_DIR_ALIAS_KEY[@]}"; do
        if [ "${HSFM_DIR_ALIAS_KEY[${var_idx}]}" = "${var_key}" ]
        then
            printf '%s\n' "${HSFM_DIR_ALIAS_PATH[${var_idx}]}"
            return 0
        fi
    done

    return 1
}

cmd_cd()
{
    local var_dir_path="$*"
    if test -d "${var_dir_path}"
    then
        # cd $@
        fsys_open "${var_dir_path}"

        # FIXME, it didn't use anymore, remove it.
        # backup cursor
        # NOTE. It's a patch for storing cursor position, cuse fcommand_handler will restore it.
        fterminal_print '\e7'

        flog_msg "Change dir to: ${var_dir_path}"
    else
        local var_dir_alias
        if var_dir_alias=$(fenv_dir_alias_get "${var_dir_path}") && test -d "${var_dir_alias}"
        then
            fsys_open "${var_dir_alias}"

            # backup cursor
            # NOTE. It's a patch for storing cursor position, cuse fcommand_handler will restore it.
            fterminal_print '\e7'

            flog_msg "Change dir to: '${var_dir_path}' -> '${var_dir_alias}'"
            return 0
        fi

        flog_msg "${var_dir_path} not found."
        return 1
    fi
    return 0
}

cmd_reenter()
{
    local var_dir_path="$(realpath ${PWD})"
    if test -d "${var_dir_path}"
    then
        # cd $@
        fsys_open "${var_dir_path}"

        # FIXME, it didn't use anymore, remove it.
        # backup cursor
        # NOTE. It's a patch for storing cursor position, cuse fcommand_handler will restore it.
        fterminal_print '\e7'

        flog_msg "Change dir to: ${var_dir_path}"
    else
        flog_msg "No dir found. ${var_dir_path}"
    fi
    return 0
}

cmd_select()
{
    fterminal_clear
    fterminal_draw_tab_line
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    {
        fterminal_print 'Program: %s\n' "${VAR_TERM_FILE_PROGRAM}"
        fterminal_print 'File list: %s files slected.\n' ${#VAR_TERM_SELECTION_FILE_LIST[@]}
        for each_file in "${VAR_TERM_SELECTION_FILE_LIST[@]}"; do
            if test -e "${each_file}"; then
                # fterminal_print '%s\n' "$(ls -ld ${each_file})"
                fterminal_print '    %s\n' "${each_file}"
            else
                fterminal_print '    %s => Not found.\n' "${each_file}"
            fi
        done
    }
    fterminal_draw_tab_line
    fterminal_draw_status_line
    # read -ern 1
    fprompt_wait "Press Enter Key To Continue..."
    fterminal_redraw
}

cmd_stat()
{
    fterminal_clear
    fterminal_draw_tab_line
    # fterminal_draw_status_line "File info"
    # fterminal_print "\n"
    # fHelp $@
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    stat "$(fget_cursor_file)"
    fterminal_draw_tab_line
    fterminal_draw_status_line
    fprompt_wait "Press Enter Key To Continue..."
    fterminal_redraw
}

cmd_disk()
{
    fterminal_clear
    fterminal_draw_tab_line
    # fterminal_draw_status_line "File info"
    # fterminal_print "\n"
    # fHelp $@
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    df -h
    fterminal_draw_tab_line
    fterminal_draw_status_line
    fprompt_wait "Press Enter Key To Continue..."
    fterminal_redraw
}

cmd_dump()
{
    fterminal_clear
    fterminal_draw_tab_line
    local var_print_cnt=0
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))"
    ################################################################
    fterminal_print '\e[%sH\r## %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_PATH"
    for each_var in ${!HSFM_PATH_@}
    do
        if [[ ${var_print_cnt} -gt ${VAR_TERM_MAINWIN_HEIGHT} ]]
        then
            break
        fi
        fterminal_print '\e[%sH\r    %- 24s: %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done

    fterminal_print '\e[%sH\r## %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_FILE"
    for each_var in ${!HSFM_FILE_@}
    do
        if [[ ${var_print_cnt} -gt ${VAR_TERM_MAINWIN_HEIGHT} ]]
        then
            break
        fi
        fterminal_print '\e[%sH\r    %- 24s: %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done

    fterminal_print '\e[%sH\r## %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_FAV"
    for each_var in ${!HSFM_FAV@}
    do
        if [[ ${var_print_cnt} -gt ${VAR_TERM_MAINWIN_HEIGHT} ]]
        then
            break
        fi
        fterminal_print '\e[%sH\r    %- 24s: %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done
    ################################################################
    fterminal_draw_tab_line
    fterminal_draw_status_line
    fprompt_wait "Press Enter Key To Continue..."
    fterminal_redraw
}

cmd_help()
{
    fterminal_clear
    fterminal_draw_tab_line
    fterminal_draw_status_line "Help info"
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    fHelp $@
    fprompt_wait "Press Enter Key To Continue..."
    fterminal_redraw
}

# Show the requested bottom window, or hide it when it is already showing.
fcmd_bottomwin_toggle()
{
    if [ ${VAR_TERM_BOTTOMWIN_SHOW} != ${1} ]
    then
        VAR_TERM_BOTTOMWIN_SHOW=${1}
    else
        VAR_TERM_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
    fi

    fterminal_redraw
}

cmd_msg()
{
    fcmd_bottomwin_toggle "${DEF_TERM_WIN_TYPE_MSG}"
}

cmd_task()
{
    fcmd_bottomwin_toggle "${DEF_TERM_WIN_TYPE_TASK}"
}

cmd_debug()
{
    if [ ${1} = on ]
    then
        HSFM_DEBUG=true
    else
        HSFM_DEBUG=false
    fi
}

cmd_eval()
{
    local var_cmd=""
    if [[ "${#}" -eq "0" ]]
    then
        flog_msg "No command specify."
        return 0
    elif ! command -v $1 2>&1 > /dev/null
    then
        flog_msg "No command ${1} found."
        return 0
    fi

    fterminal_clear
    fterminal_draw_tab_line
    # fterminal_draw_status_line "File info"
    # fterminal_print "\n"
    # fHelp $@
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    printf "Excute: '%s'\n" "${*}"
    printf "%s\n" "################################################################################"
    eval ${@}

    fterminal_draw_tab_line
    fterminal_draw_status_line
    fprompt_wait "Press Enter Key To Continue..."
    fterminal_redraw
}

cmd_title()
{
    if [[ "${#}" -ge "1" ]]
    then
        HSFM_ENV_TITLE="$@"
        fterminal_draw_tab_line
    else
        flog_msg "${HSFM_ENV_TITLE}"
    fi
}

cmd_set()
{
    if [[ "${#}" -lt "2" ]]
    then
        flog_msg "No enough args number."
        return -1
    fi
    local args_variable=$1
    local args_value=$2

    case ${args_variable} in
        read)
            if [ "${args_value}" = "${DEF_TERM_READ_DIR_MODE_LS}" ] || [ "${args_value}" = "ls" ]
            then
                HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_LS}
            elif [ "${args_value}" = "${DEF_TERM_READ_DIR_MODE_SORT}" ] || [ "${args_value}" = "sort" ]
            then
                HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_SORT}
            elif [ "${args_value}" = "${DEF_TERM_READ_DIR_MODE_NONE}" ] || [ "${args_value}" = "none" ]
            then
                HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_NONE}
            elif [ "${args_value}" = "${DEF_TERM_READ_DIR_MODE_FAST_LS}" ] || [ "${args_value}" = "fast" ]
            then
                HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_FAST_LS}
            elif [ "${args_value}" = "${DEF_TERM_READ_DIR_MODE_LS_SORT}" ] || [ "${args_value}" = "mac" ]
            then
                HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_LS_SORT}
            else
                flog_msg "Unknown value: ${args_value}"
                return -1
            fi
            ;;
        hidden)
            if [ "${args_value}" = "on" ]
            then
                HSFM_ENABLE_HIDDEN=1
            elif [ "${args_value}" = "off" ]
            then
                HSFM_ENABLE_HIDDEN=0
            else
                flog_msg "Unknown value: ${args_value}"
                return -1
            fi
            ;;
        left)
            if ! fenv_left_hande_mode "${args_value}"; then
                return -1
            fi
            ;;
        *)
            flog_msg "Unknown variable name: ${args_variable}"
            return -1
            ;;
    esac
    fterminal_redraw full
    flog_msg "Set ${args_variable} ${args_value}"
}

cmd_colorscheme()
{
    fsetup_theme $1
    fterminal_redraw full
}

cmd_test()
{
    # local tmp_cmd="sleep 5"
    # flog_msg_debug "${tmp_cmd} Entered."
    # {
    #     flog_msg_debug "${tmp_cmd} started."
    #     eval "${tmp_cmd}"
    #     flog_msg_debug "${tmp_cmd} finished."
    # } &
    fterminal_draw_checkwin
}

cmd_tabclose()
{
    fgui_tab_close
}

cmd_tabcloseright()
{
    fgui_tab_close right
}

cmd_tabcloseleft()
{
    fgui_tab_close left
}

cmd_tabcloseothers()
{
    fgui_tab_close others
}

cmd_tabcloseduplicate()
{
    fgui_tab_close duplicate
}

cmd_quitngo()
{
    : "${HSFM_FILE_CD_LASTPATH}"

    [[ -w $HSFM_FILE_CD_LASTPATH ]] &&
        rm "$HSFM_FILE_CD_LASTPATH"

    [[ ${HSFM_CD_ON_EXIT:=1} == 1 ]] &&
        fterminal_print '%s\n' "$PWD" > "$HSFM_FILE_CD_LASTPATH"

    exit 0
}

cmd_config()
{
    local var_file="${HSFM_FILE_CONFIG}"
    fterminal_reset

    if command -v "${HSFM_TEXT_EDITOR%% *}" 2>&1 > /dev/null;then
        ${HSFM_TEXT_EDITOR} "${var_file}"
    elif command -v "vim" 2>&1 > /dev/null;then
        vim "${var_file}"
    elif command -v "vi" 2>&1 > /dev/null;then
        vi "${var_file}"
    elif command -v "nano" 2>&1 > /dev/null;then
        nano "${var_file}"
    else
        flog_msg "warn: no editor found. editor: '$HSFM_TEXT_EDITOR'"
    fi

    fterminal_setup
    fterminal_redraw
}

cmd_exit()
{
    exit 0
}

fsys_open() {
    local var_file=""
    flog_msg_debug "Open '$*'"
    if test -e "$*"; then
        var_file="${*}"
    else
        var_file="$(fget_cursor_file)"
    fi

    # Open directories and files.
    if [[ -d "${var_file}/" ]]; then
        FM_DIR_SEARCH_ACTIVE=
        VAR_TERM_SEARCH_END_EARLY=
        if test -r "${var_file:-/}"; then
            cd "${var_file:-/}" || :
            flog_msg_debug "Enter $var_file"
            fterminal_redraw full
        else
            flog_msg "Access fail on: ${var_file:-/}"
        fi

    elif [[ -f "${var_file}" ]]; then
        VAR_TERM_OPEN_FILE=""
        while test -z "${VAR_TERM_OPEN_FILE}"; do
            VAR_TERM_OPEN_FILE="${var_file}"
            local tmp_file_type=($(fprase_mime_type "$var_file"))
            tmp_file_type=${tmp_file_type[@]}

            # cli preview
            case "${tmp_file_type}" in
                # image/*)
                #     cmd_preview "$var_file"
                #     break
                #     ;;
                text/* | *x-empty* | *json*)
                    cmd_editor "$var_file"
                    break
                    ;;
                application/zip*)
                    # cmd_unzip "$var_file"
                    cmd_extract "zip" "$var_file"
                    break
                    ;;
                application/x-tar* | application/x-xz*)
                    cmd_extract "tar" "$var_file"
                    break
                    ;;
            esac

            # Try with file extension.
            case "${var_file##*.}" in
                tar | Z | xz | zip | 7z | gz | rar | tbz2 | tgz)
                    cmd_extract "$var_file"
                    break
                    ;;
            esac

            # Figure out what kind of file we're working with.
            # Open all text-based files in '$HSFM_TEXT_EDITOR'.
            # Everything else goes through 'xdg-open'/'open'.
            if [[ $DISPLAY ]]; then
                # case "${tmp_file_type}" in
                #     # audio/*)
                #     #     cmd_media "$var_file"
                #     #     break
                #     #     ;;
                #     # video/*)
                #     #     cmd_media "$var_file"
                #     #     break
                #     #     ;;
                #     # image/*)
                #     #     cmd_image "$var_file"
                #     #     break
                #     #     ;;
                # esac

                # 'nohup':  Make the process immune to hangups.
                # '&':      Send it to the background.
                # 'disown': Detach it from the shell.
                if test -n "${HSFM_OPENER}" && command -v ${HSFM_OPENER%% *} >/dev/null; then
                    flog_msg_debug "Open file via ${HSFM_OPENER}"
                    nohup "${HSFM_OPENER}" "$var_file" &>/dev/null &
                    disown
                    break
                fi
            fi

            flog_msg "Unknown file type: '${tmp_file_type}'"
        done
    fi
    VAR_TERM_OPEN_FILE=""
}

## Visual CMD Function
###########################################################
# IMPL, it's an template command function for both vcmd/cmd
vcmd_compress()
{
    # currently only take one args.
    local arg_file_name="${1:-}"
    # flog_msg_debug "compress:$@"
    local var_compress_cmd=""
    local var_file_ext=""
    local var_base_name=""
    local var_stem=""
    if command -v "zip"
    then
        var_compress_cmd="zip -j"
        var_file_ext="zip"
    elif command -v "tar"
    then
        var_compress_cmd="tar -C ${PWD} -cvJf "
        var_file_ext="txz"
    else
        flog_msg "No zip or tar/xz found."
        return -1
    fi

    [[ ${VAR_TERM_SELECTION_FILE_LIST[*]} ]] && {
        [[ ! -w $PWD ]] && {
        flog_msg "warn: no write access to dir."
            return -1
        }
        if test -z "${arg_file_name}"
        then
            if [[ ${#VAR_TERM_SELECTION_FILE_LIST[@]} -eq 1 ]]
            then
                var_base_name="${VAR_TERM_SELECTION_FILE_LIST[0]##*/}"
                var_stem="${var_base_name%.*}"
                # A dotfile has no stem to keep; keep the whole name.
                [[ -n "${var_stem}" ]] || var_stem="${var_base_name}"
                arg_file_name="${PWD}/${var_stem}.${var_file_ext}"
            else
                arg_file_name="${PWD##*/}.${var_file_ext}"
            fi
        fi

        if test -e "${arg_file_name}"
        then
            flog_msg "${arg_file_name} exist, skip compression."
            return 0
        fi

        local tmp_cmd="${var_compress_cmd} '${arg_file_name}' "
        for each_file in "${VAR_TERM_SELECTION_FILE_LIST[@]}"
        do
            tmp_cmd+="'${each_file}' "
        done
        # tmp_cmd+="./"
        flog_msg "Compress started."
        flog_msg_debug "excute: ${tmp_cmd}"
        fterminal_draw_miniwin "Start Compress files."
        eval "${tmp_cmd}"
        if [ $? != 0 ]
        then
            fterminal_redraw full
            flog_msg "File compression fail."
            return -1
        fi

        fmode_setup "${DEF_TERM_MODE_NORMAL}"
        # fterminal_setup
        fterminal_redraw full
        flog_msg "Compress finished."
    }
}

## File Operation Function
###########################################################
fselect_execute()
{
    local flag_block=true
    if [ ${flag_block} = true ]
    then
        fselect_execute_block
    else
        # FIXME, we'll ask thing on UI, it will block background execute.
        fselect_execute_background
    fi
}

fselect_execute_background()
{
    [[ ${VAR_TERM_SELECTION_FILE_LIST[*]} ]] && {
        [[ ! -w $PWD ]] && {
            flog_msg "warn: no write access to dir."
            return
        }

        # fterminal_print '\e[1mhsfm\e[m: %s\n' "Running ${VAR_TERM_FILE_PROGRAM[0]}"
        local tmp_cmd="${VAR_TERM_FILE_PROGRAM[@]} "
        for each_file in "${VAR_TERM_SELECTION_FILE_LIST[@]}"
        do
            tmp_cmd+="'${each_file}' "
        done
        tmp_cmd+="./"

        #==========================
        {
            flog_msg_debug "${VAR_TERM_FILE_PROGRAM} started."
            eval "${tmp_cmd}"
            flog_msg_debug "${VAR_TERM_FILE_PROGRAM} finished."
        } &
        #==========================

        VAR_TERM_SELECTION_FILE_LIST=()
        fmode_setup "${DEF_TERM_MODE_NORMAL}"
        fterminal_setup
        fterminal_redraw full
    }
}

fselect_execute_block()
{
    [[ ${VAR_TERM_SELECTION_FILE_LIST[*]} ]] && {
        [[ ! -w $PWD ]] && {
            flog_msg "warn: no write access to dir."
            return
        }

        # Clear the screen to make room for a prompt if needed.
        # fterminal_clear
        # fterminal_reset

        stty echo
        # fterminal_print '\e[1mhsfm\e[m: %s\n' "Running ${VAR_TERM_FILE_PROGRAM[0]}"
        local tmp_cmd="${VAR_TERM_FILE_PROGRAM[@]} "
        for each_file in "${VAR_TERM_SELECTION_FILE_LIST[@]}"
        do
            tmp_cmd+="'${each_file}' "
        done
        tmp_cmd+="./"
        flog_msg "${VAR_TERM_FILE_PROGRAM} started."
        fterminal_draw_miniwin "Start ${VAR_TERM_FILE_PROGRAM}"
        eval "${tmp_cmd}"
        # "${VAR_TERM_FILE_PROGRAM[@]}" "${VAR_TERM_SELECTION_FILE_LIST[@]}" .
        stty -echo

        # VAR_TERM_SELECTION_FILE_LIST=()
        fmode_setup "${DEF_TERM_MODE_NORMAL}"
        fterminal_setup
        fterminal_redraw full
        flog_msg "${VAR_TERM_FILE_PROGRAM} finished."
    }
}

fselect_copy() {
    local flag_overwrite=false
    local flag_duplicate=false
    local var_target_folder=${@:$#}

    # flog_msg_debug "Arsgs: ${#},${@}, => ${@:1}, |=> ${var_target_folder}"
    # FIXME, don't trash on different device/big file size
    for ((i=1;i<${#};i++)); {
        local tmp_file="${@:i:1}"
        if test -e "${tmp_file##*/}"
        then

            if [ ${flag_overwrite} = false ] && [ ${flag_duplicate} = false ]
            then
                fprompt_confirm "${tmp_file##*/} exist. Overwrite(a.all/y.yes/d.duplicate/n.no/c.cancel/s.skip)? "

                case $VAR_TERM_CMD_INPUT_BUFFER in
                    'y'|'Y')
                        cp -R -f "${tmp_file}" "${var_target_folder}"
                        ;;
                    'c'|'C')
                        flog_msg_debug "Copy Abort."
                        break
                        ;;
                    's'|'S')
                        flog_msg_debug "Skip copy ${tmp_file} to $(realpath ${var_target_folder})"
                        continue
                        ;;
                    'a'|'A')
                        cp -R -f "${tmp_file}" "${var_target_folder}"
                        flag_overwrite=true
                        ;;
                    'd'|'D')
                        cp -R "${tmp_file}" "${var_target_folder}/copy_$(date +%s)_${tmp_file##*/}"
                        flag_duplicate=true
                        ;;
                    'n'|'N')
                        cp -R "${tmp_file}" "${var_target_folder}/copy_$(date +%s)_${tmp_file##*/}"
                        ;;
                    *)
                        # Unknown answer: duplicate, as the old wildcard arm did.
                        cp -R "${tmp_file}" "${var_target_folder}/copy_$(date +%s)_${tmp_file##*/}"
                        ;;
                esac
            elif [ ${flag_overwrite} = true ]
            then
                cp -R -f "${tmp_file}" "${var_target_folder}"
            else
                cp -R "${tmp_file}" "${var_target_folder}/copy_$(date +%s)_${tmp_file##*/}"
            fi
        else
            # flog_msg_debug "No exist: ${tmp_file}"
            cp -iR "${tmp_file}" "${var_target_folder}"
        fi
        flog_msg_debug "Copy: ${tmp_file} to $(realpath ${var_target_folder})"
    }
}

fselect_remove() {
    # Trash a file.
    fprompt_confirm "trash [$(($#-1))] items? [y/n]: "

    [[ $VAR_TERM_CMD_INPUT_BUFFER != y ]] &&
        return

    if [[ $HSFM_TRASH_CMD ]]; then
        # Pass all but the last argument to the user's
        # custom script. command is used to prevent this function
        # from conflicting with commands named "fselect_remove".
        command "$HSFM_TRASH_CMD" "${@:1:$#-1}"

    else
        # FIXME, don't trash on different device/big file size
        rm -rf "${@:1:$#-1}"

        # test -d "${HSFM_PATH_TRASH}" || mkdir -p "${HSFM_PATH_TRASH}"
        # cd "$HSFM_PATH_TRASH" || flog_msg "error: Can't cd to trash directory."
        #
        # if cp -alf "$@" &>/dev/null; then
        #     rm -r "${@:1:$#-1}"
        # else
        #     flog_msg "mv -f $@"
        #     mv -f "$@"
        # fi
        #
        # # Go back to where we were.
        # cd "$OLDPWD" ||:
    fi
}

fselect_rename() {
    # Bulk rename files using '$HSFM_TEXT_EDITOR'.
    rename_file=${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/fselect_rename
    VAR_TERM_MARKED_FILE_LIST=("${@:1:$#-1}")

    # Save marked files to a file and open them for editing.
    fterminal_print '%s\n' "${VAR_TERM_MARKED_FILE_LIST[@]##*/}" > "$rename_file"
    "${HSFM_TEXT_EDITOR:-vi}" "$rename_file"

    # Read the renamed files to an array.
    IFS=$'\n' read -d "" -ra changed_files < "$rename_file"

    # If the user deleted a line, stop here.
    ((${#VAR_TERM_MARKED_FILE_LIST[@]} != ${#changed_files[@]})) && {
        rm "$rename_file"
        flog_msg "error: Line mismatch in rename file. Doing nothing."
        return
    }

    fterminal_print '%s\n%s\n' \
        "# This file will be executed when the editor is closed." \
        "# Clear the file to abort." > "$rename_file"

    # Construct the rename commands.
    for ((i=0;i<${#VAR_TERM_MARKED_FILE_LIST[@]};i++)); {
        [[ ${VAR_TERM_MARKED_FILE_LIST[i]} != "${PWD}/${changed_files[i]}" ]] && {
            fterminal_print 'mv -i -- %q %q\n' \
                "${VAR_TERM_MARKED_FILE_LIST[i]}" "${PWD}/${changed_files[i]}"
            local renamed=1
        }
    } >> "$rename_file"

    # Let the user double-check the commands and execute them.
    ((renamed == 1)) && {
        "${HSFM_TEXT_EDITOR:-vi}" "$rename_file"

        source "$rename_file"
        rm "$rename_file"
    }

    # Fix terminal settings after '$HSFM_TEXT_EDITOR'.
    fterminal_setup
}

###########################################################
## L4 Input and modes
## key decoding, mode state machine, line editor.
###########################################################

fterminal_read_key() {
    # local REPLY
    read "${VAR_TERM_READ_ARGS[@]}" -srn 1
    local ret_value=$?
    if [ "${VAR_TERM_KEY_BUFFER_INPUT}" != "" ]
    then
        REPLY="${VAR_TERM_KEY_BUFFER_INPUT}${REPLY}"
        VAR_TERM_KEY_BUFFER_INPUT=""
    fi
    if [[ ${REPLY} == $'\e' ]]
    then
        local tmp_buffer="${REPLY}"
        read "${VAR_TERM_READ_ARGS[@]}" -rsn 1

        if [[ ${tmp_buffer}${REPLY} == $'\e\e' ]]; then
            # fast esc
            REPLY=${REPLY}
            VAR_TERM_KEY_CURRENT_INPUT="^"
            return ${ret_value}
        elif [[ ${tmp_buffer}${REPLY} == $'\e[' ]]; then
            tmp_buffer="${tmp_buffer}${REPLY}"
            read "${VAR_TERM_READ_ARGS[@]}" -rsn 1
        fi

        if [[ "${REPLY}" =~ ^-?[0-9]+$ ]]; then
            # Handle F5~F12/Home/Ins/Del/PgD/PgU.
            tmp_buffer="${tmp_buffer}${REPLY}"
            read "${VAR_TERM_READ_ARGS[@]}" -rsn 1

            if [[ "${REPLY}" = "~" ]]; then
                # tmp_buffer="${tmp_buffer}${REPLY}"
                REPLY=${tmp_buffer}${REPLY}
            else
                tmp_buffer="${tmp_buffer}${REPLY}"
                read "${VAR_TERM_READ_ARGS[@]}" -rsn 1

                REPLY=${tmp_buffer}${REPLY}
            fi

        elif [[ "${REPLY}" = 'O' ]]; then
            # Handle F1~F4
            tmp_buffer="${tmp_buffer}${REPLY}"
            read "${VAR_TERM_READ_ARGS[@]}" -rsn 1
            REPLY=${tmp_buffer}${REPLY}
        else
            REPLY=${tmp_buffer}${REPLY}
        fi

        # REPLY=${tmp_buffer}${REPLY}
        VAR_TERM_KEY_CURRENT_INPUT="^"${REPLY:1}
        # flog_msg_debug "${VAR_TERM_KEY_CURRENT_INPUT}"
    elif [[ ${ret_value} ]]
    then
        VAR_TERM_KEY_CURRENT_INPUT="${REPLY}"
    else
        VAR_TERM_KEY_CURRENT_INPUT=""
    fi

    # if test -n "${REPLY}"
    # then
    #     fterminal_draw_status_line
    # fi

    return ${ret_value}
}

fterminal_read_key_timeout() {
    local var_input_timeout=${1:-1}

    read -t ${var_input_timeout} -srn 1
    local ret_value=$?

    if [[ ${ret_value} ]]
    then
        VAR_TERM_KEY_CURRENT_INPUT+="+${REPLY}"
    fi
    # if test -n "${REPLY}"
    # then
    #     fterminal_draw_status_line
    # fi
    return ${ret_value}
}

fmode_setup()
{

    case ${1} in
        "${DEF_TERM_MODE_VISUAL}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_VISUAL}"
            # setup visual mode
            VAR_TERM_VISUAL_START_IDX=$VAR_TERM_CONTENT_SCROLL_IDX
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
            VAR_TERM_SELECTION_FILE_LIST=()
            fterminal_draw_command_line
            ;;
        "${DEF_TERM_MODE_SELECT}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_SELECT}"
            # setup selection mode
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
            VAR_TERM_SELECTION_FILE_LIST=()
            fterminal_draw_command_line
            ;;
        "${DEF_TERM_MODE_COMMAND}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_COMMAND}"
            fedit_begin ":" "${DEF_TERM_MODE_COMMAND}" "${DEF_ED_DRIVER_MODE}"
            fterminal_draw_command_line
            ;;
        "${DEF_TERM_MODE_SEARCH}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_SEARCH}"
            fedit_begin "/" "${DEF_TERM_MODE_SEARCH}" "${DEF_ED_DRIVER_MODE}"
            fterminal_draw_command_line
            ;;
        "${DEF_TERM_MODE_FIND}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_FIND}"
            fedit_begin "?" "${DEF_TERM_MODE_FIND}" "${DEF_ED_DRIVER_MODE}"
            fterminal_draw_command_line
            ;;
        *|"${DEF_TERM_MODE_NORMAL}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_NORMAL}"
            fterminal_mark_reset
            # we don't flush command on enter normal mode, it will erase message.
            ;;
    esac
    fterminal_draw_status_line
    # fterminal_draw_command_line
}

fnormal_mode_handler() {

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fsys_open "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            ;;
        # Open VAR_TERM_DIR_FILE_LIST item.
        # 'C' is what bash sees when the right arrow is pressed
        # ('\e[C' or '\eOC').
        ${HSFM_KEY_CHILD1:=l} | \
            ${HSFM_KEY_CHILD2:=$'\e[C'} | \
            ${HSFM_KEY_CHILD4:=$'\eOC'})
            # only check if it's directory.
            if test -d "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"; then
                VAR_TERM_FLAG_RESET_IDX=true
                fsys_open "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            elif test -f "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"; then
                local tmp_mine=$(fprase_mime_type "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}")
                local tmp_info=$(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}")
                # flog_msg "File info(${tmp_mine%%;*}):$(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" | tail -n 1 | cut -d ':' -f2)"
                flog_msg "File info(${tmp_mine%%;*}):${tmp_info##*:}"
            else
                flog_msg "File access failed."
            fi
            ;;

        # Go to the parent directory.
        # 'D' is what bash sees when the left arrow is pressed
        # ('\e[D' or '\eOD').
        # '\177' and '\b' are what bash sometimes sees when the backspace
        # key is pressed.
        ${HSFM_KEY_PARENT1:=h} | \
            ${HSFM_KEY_PARENT2:=$'\e[D'} | \
            ${HSFM_KEY_PARENT3:=$'\177'} | \
            ${HSFM_KEY_PARENT4:=$'\b'} | \
            ${HSFM_KEY_PARENT5:=$'\eOD'})
            # If a search was done, clear the results and open the current dir.
            if ((FM_DIR_SEARCH_ACTIVE == 1 && VAR_TERM_SEARCH_END_EARLY != 1)); then
                fsys_open "$PWD"

            # If '$PWD' is '/', do nothing.
            elif [[ $PWD && $PWD != / ]]; then
                VAR_TERM_FLAG_FIND_PREVIOUS=1
                if test -z "${PWD%/*}"; then
                    fsys_open "/"
                else
                    fsys_open "${PWD%/*}"
                fi
            fi
            ;;

        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j} | \
            ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'} | \
            ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            fgui_scroll_down
            ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k} | \
            ${HSFM_KEY_SCROLL_UP2:=$'\e[A'} | \
            ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            fgui_scroll_up
            ;;

        # Go to top.
        ${HSFM_KEY_TO_TOP:=g})
            ((VAR_TERM_CONTENT_SCROLL_IDX != 0)) && {
                VAR_TERM_CONTENT_SCROLL_IDX=0
                fterminal_redraw
            }
            ;;

        # Go to bottom.
        ${HSFM_KEY_TO_BOTTOM:=G})
            ((VAR_TERM_CONTENT_SCROLL_IDX != VAR_TERM_DIR_LIST_CNT)) && {
                ((VAR_TERM_CONTENT_SCROLL_IDX = VAR_TERM_DIR_LIST_CNT))
                fterminal_redraw
            }
            ;;

        # Tab selcet
        ${HSFM_KEY_GO_PREVIOUS_TAB})
            fgui_tab_go_previous
            ;;

        ${HSFM_KEY_GO_NEXT_TAB})
            fgui_tab_go_next
            ;;
        ${HSFM_KEY_MOVE_TAB_PREVIOUS})
            fgui_tab_move_previous
            ;;

        ${HSFM_KEY_MOVE_TAB_NEXT})
            fgui_tab_move_next
            ;;
        ${HSFM_KEY_OPEN_TAB})
            fgui_tab_open
            ;;
        ${HSFM_KEY_CLOSE_TAB})
            fgui_tab_close
            ;;

        ${HSFM_KEY_VISUAL_SELECT:="V"})
            fmode_setup "${DEF_TERM_MODE_VISUAL}"
            # fterminal_redraw
            ;;
        ${HSFM_KEY_SELECTION})
            fmode_setup "${DEF_TERM_MODE_SELECT}"
            # fterminal_redraw
            ;;

        # Show hidden files.
        ${HSFM_KEY_HIDDEN:=.})
            # 'a=a>0?0:++a': Toggle between both values of 'shopt_flags'.
            #                This also works for '3' or more values with
            #                some modification.
            if [[ ${HSFM_ENABLE_HIDDEN} == 0 ]]; then
                HSFM_ENABLE_HIDDEN=1
            else
                HSFM_ENABLE_HIDDEN=0
            fi
            # shopt_flags=(u s)
            # shopt -"${shopt_flags[$HSFM_ENABLE_HIDDEN]}" dotglob
            fterminal_redraw full
            # flog_msg "Hidden: $HSFM_ENABLE_HIDDEN/${shopt_flags[$HSFM_ENABLE_HIDDEN]}"
            ;;
        # Toggle sorting method
        ${HSFM_KEY_SORTING})
            if [ "${HSFM_LS_SORTING}" = "" ]; then
                HSFM_LS_SORTING="-t"
                var_name="time"
            else
                HSFM_LS_SORTING="-X"
                var_name="extension"
            fi
            fterminal_redraw full
            flog_msg "Sorting: ${var_name}.${HSFM_LS_SORTING}"
            ;;

        # Spawn a shell.
        ${HSFM_KEY_SHELL:=!})
            cmd_shell
            ;;

        # Search.
        ${HSFM_KEY_SEARCH:=/})
            fmode_setup "${DEF_TERM_MODE_SEARCH}"
            ;;
        "${HSFM_KEY_FIND:=?}")
            fmode_setup "${DEF_TERM_MODE_FIND}"
            ;;

        # FIXME, remove this fake command.
        F)
            fcommand_handler "${DEF_TERM_MODE_SEARCH}"

            # If the search came up empty, fterminal_redraw the current dir.
            if [[ -z ${VAR_TERM_DIR_FILE_LIST[*]} ]]; then
                VAR_TERM_DIR_FILE_LIST=("${FM_DIR_BACKUP[@]}")
                ((VAR_TERM_DIR_LIST_CNT = ${#VAR_TERM_DIR_FILE_LIST[@]} - 1))
                fterminal_redraw
                FM_DIR_SEARCH_ACTIVE=
            else
                FM_DIR_SEARCH_ACTIVE=1
            fi
            ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            fmode_setup "${DEF_TERM_MODE_COMMAND}"
            ;;
        # FIXME, remove this fake command.
        C)
            # FIXME, if command change cursor pos, it will be resotre to wier position
            fcommand_handler "${DEF_TERM_MODE_COMMAND}"
            # fmode_setup "${DEF_TERM_MODE_COMMAND}"
            ;;

        # Show file attributes.
        ${HSFM_KEY_ATTRIBUTES:=x})
            [[ -e "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" ]] && {
                cmd_stat "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            }
            ;;

        # Show help info.
        ${HSFM_KEY_HELP:=H})
            # fcommand_handler "help" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
            cmd_help "$@"
            ;;

        # Go to '$HOME'.
        ${HSFM_KEY_GO_HOME:='~'})
            fsys_open ~
            ;;

        # Go to trash.
        ${HSFM_KEY_GO_TRASH:=t})
            fsys_open "$HSFM_PATH_TRASH"
            ;;

        # Go to previous dir.
        ${HSFM_KEY_PREVIOUS:=-})
            fsys_open "$OLDPWD"
            ;;

        # # Refresh current dir.
        ${HSFM_KEY_REFRESH:=r})
            fterminal_redraw full
            flog_msg "Window Refreshed."
            ;;
        ${HSFM_KEY_TOGGLE_MSGWIN})
            if [ ${VAR_TERM_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_MSG} ]
            then
                VAR_TERM_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_MSG}
            else
                VAR_TERM_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
            fi
            fterminal_redraw
            ;;
        ${HSFM_KEY_TOGGLE_TASKWIN})
            if [ ${VAR_TERM_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_TASK} ]
            then
                VAR_TERM_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_TASK}
            else
                VAR_TERM_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
            fi
            fterminal_redraw
            ;;

        # Directory favourites.
        [0-9])
            tmp_favorite_name="HSFM_FAV${1}"
            tmp_favorite="${!tmp_favorite_name}"

            [[ $tmp_favorite ]] &&
                fsys_open "$tmp_favorite"
            ;;

        # File operation
        # HSFM_KEY_QUICK_EDIT
        ${HSFM_KEY_QUICK_EDIT:=e})
            # Sets a threshold to prevent accidental opening.
            var_threshold_quick_open_size=102400
            if [[ -e "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" ]]; then
                cmd_editor "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            fi
            ;;
        ${HSFM_KEY_YANK:=y})
            VAR_TERM_FILE_PROGRAM=(fselect_copy)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}")
            fterminal_redraw
            flog_msg "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]} yanked."
            ;;
        ${HSFM_KEY_CUT:=m})
            VAR_TERM_FILE_PROGRAM=(mv -i)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}")
            fterminal_redraw
            flog_msg "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]} cuted."
            ;;
        ${HSFM_KEY_TRASH:=d})
            VAR_TERM_FILE_PROGRAM=(fselect_remove)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}")
            fselect_execute
            # flog_msg "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]} removed."
            ;;
        ${HSFM_KEY_PASTE})
            fselect_execute
            ;;

        ## Second level list
        '\')
            fterminal_read_key_timeout 1
            case ${REPLY} in
                a)
                    fterminal_mark_toggle "all"
                    fmode_setup "${DEF_TERM_MODE_SELECT}"
                    ;;
                d)
                    fgui_tab_duplicate
                    ;;
            esac
            ;;
        q)
            fterminal_read_key_timeout 1
            case ${REPLY} in
                q)
                    fgui_tab_close
                    # cmd_exit
                    ;;
                g)
                    # quit & go
                    cmd_quitngo
                    # cmd_exit
                    ;;
                a)
                    cmd_exit
                    ;;
            esac
            ;;
    esac
    fterminal_flush
}

# File-operation arm shared by the visual and selection handlers.
fhandler_file_op()
{
    case ${1} in
        yank)
            VAR_TERM_FILE_PROGRAM=(fselect_copy)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files yanked."
            ;;
        cut)
            VAR_TERM_FILE_PROGRAM=(mv -i)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files cuted."
            ;;
        trash)
            VAR_TERM_FILE_PROGRAM=(fselect_remove)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fselect_execute
            ;;
    esac
}

fhandler_quit()
{
    fmode_setup "${DEF_TERM_MODE_NORMAL}"
    fterminal_redraw
}

fvisual_mode_handler() {

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            ;;
        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j} | \
            ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'} | \
            ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            fgui_scroll_down_visual
            ;;
        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k} | \
            ${HSFM_KEY_SCROLL_UP2:=$'\e[A'} | \
            ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            fgui_scroll_up_visual
            ;;
        # Go to top.
        ${HSFM_KEY_TO_TOP:=g})
            fgui_scroll_top_visual
            ;;

        # Go to bottom.
        ${HSFM_KEY_TO_BOTTOM:=G})
            fgui_scroll_bottom_visual
            ;;
        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # FIXME, if command change cursor pos, it will be resotre to wier position
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")
            fcommand_handler "${DEF_TERM_MODE_COMMAND}"
            ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            fhandler_file_op "yank"
            ;;
        ${HSFM_KEY_CUT:=m})
            fhandler_file_op "cut"
            ;;
        ${HSFM_KEY_TRASH:=d})
            fhandler_file_op "trash"
            ;;
        q | $'\e')
            fhandler_quit
            ;;
    esac
}

fselection_mode_handler() {

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            ;;
        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j} | \
            ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'} | \
            ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            fgui_scroll_down
            ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k} | \
            ${HSFM_KEY_SCROLL_UP2:=$'\e[A'} | \
            ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            fgui_scroll_up
            ;;
        # Go to top.
        ${HSFM_KEY_TO_TOP:=g})
            ((VAR_TERM_CONTENT_SCROLL_IDX != 0)) && {
                VAR_TERM_CONTENT_SCROLL_IDX=0
                fterminal_redraw
            }
            ;;

        # Go to bottom.
        ${HSFM_KEY_TO_BOTTOM:=G})
            ((VAR_TERM_CONTENT_SCROLL_IDX != VAR_TERM_DIR_LIST_CNT)) && {
                ((VAR_TERM_CONTENT_SCROLL_IDX = VAR_TERM_DIR_LIST_CNT))
                fterminal_redraw
            }
            ;;

        ${HSFM_KEY_SELECTION})
            fterminal_mark_toggle "$VAR_TERM_CONTENT_SCROLL_IDX" "$1"
            ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # FIXME, if command change cursor pos, it will be resotre to wier position
            fcommand_handler "${DEF_TERM_MODE_COMMAND}"
            ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            fhandler_file_op "yank"
            ;;
        ${HSFM_KEY_CUT:=m})
            fhandler_file_op "cut"
            ;;
        ${HSFM_KEY_TRASH:=d})
            fhandler_file_op "trash"
            ;;
        q | $'\e')
            fhandler_quit
            ;;
    esac
}

###########################################################
## Line editor
## One core, two drivers. The core changes state only; each driver renders.
## fedit_key returns 0 continue, 1 submit, 2 cancel.
###########################################################
fedit_begin()
{
    local var_prefix=$1
    local var_func=$2
    local var_driver=$3

    FM_ED_PREFIX="${var_prefix}"
    FM_ED_FUNC="${var_func}"
    FM_ED_DRIVER="${var_driver}"
    FM_ED_ACTIVE=1
    FM_ED_BUF=""
    FM_ED_POSTBUF=""
    FM_ED_HISTIDX=0
    FM_ED_BACKUP=""

    # A stale completion list must not leak into the next session.
    FM_ED_COMP_MODE_LIST=()
    FM_ED_COMP_MODE_IDX=0
    FM_ED_COMP_MODE_PATH_CMD=""
    FM_ED_COMP_PROMPT_LIST=()
    FM_ED_COMP_PROMPT_IDX=0

    VAR_TERM_CMD_INPUT_BUFFER=""
}

fedit_end()
{
    case "${FM_ED_DRIVER}" in
        "${DEF_ED_DRIVER_MODE}")
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_COMMAND}" && -z "${VAR_TERM_CMD_INPUT_BUFFER}" ]]
            then
                fterminal_print '\r\e[K\e[?25l'
            fi
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            ;;
        "${DEF_ED_DRIVER_PROMPT}")
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_COMMAND}" && -z "${VAR_TERM_CMD_INPUT_BUFFER}" ]]
            then
                fterminal_print '\r\e[K\e[?25l\e8'
            fi
            # The prompt completion slot does not survive the session.
            FM_ED_COMP_PROMPT_LIST=()
            FM_ED_COMP_PROMPT_IDX=0
            ;;
    esac

    FM_ED_ACTIVE=0
}

fedit_line()
{
    printf '%s%s%s ' "${FM_ED_PREFIX}" "${FM_ED_BUF}" "${FM_ED_POSTBUF}"
}

fedit_cursor_offset()
{
    printf '%s' "$(( ${#FM_ED_POSTBUF} + 1 ))"
}

# One history list per flavor. Wait and confirm prompts have none.
fedit_history_name()
{
    case "${FM_ED_FUNC}" in
        "${DEF_TERM_MODE_COMMAND}")
            printf 'VAR_TERM_CMD_HISTORY'
            ;;
        "${DEF_TERM_MODE_SEARCH}")
            printf 'VAR_TERM_SEARCH_HISTORY'
            ;;
        "${DEF_TERM_MODE_FIND}")
            [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]] || return 1
            printf 'VAR_TERM_FIND_HISTORY'
            ;;
        *)
            return 1
            ;;
    esac
}

fhist_append()
{
    local var_name=$1
    local var_value=$2
    local var_count

    eval "var_count=\${#${var_name}[@]}"
    if [[ ${var_count} -ge ${VAR_TERM_CMD_HISTORY_MAX} ]]
    then
        # Drop the oldest entry, then add the new one.
        eval "${var_name}=(\"\${${var_name}[@]:1}\")"
    fi
    eval "${var_name}+=(\"\${var_value}\")"
}

fedit_history_up()
{
    local var_name
    local var_count
    local var_idx

    var_name=$(fedit_history_name) || return 0
    eval "var_count=\${#${var_name}[@]}"

    if [[ ${FM_ED_HISTIDX} -eq 0 ]]
    then
        FM_ED_BACKUP="${FM_ED_BUF}${FM_ED_POSTBUF}"
    fi

    if [[ $((FM_ED_HISTIDX + 1)) -le ${var_count} ]]
    then
        ((FM_ED_HISTIDX++))
        var_idx=$((var_count - FM_ED_HISTIDX))
        eval "FM_ED_BUF=\${${var_name}[${var_idx}]}"
        FM_ED_POSTBUF=""
    fi
}

fedit_history_down()
{
    local var_name
    local var_count
    local var_idx

    var_name=$(fedit_history_name) || return 0
    eval "var_count=\${#${var_name}[@]}"

    if [[ ${FM_ED_HISTIDX} -eq 1 ]]
    then
        FM_ED_BUF="${FM_ED_BACKUP}"
        FM_ED_POSTBUF=""
        ((FM_ED_HISTIDX--))
    elif [[ ${FM_ED_HISTIDX} -ne 0 ]]
    then
        ((FM_ED_HISTIDX--))
        var_idx=$((var_count - FM_ED_HISTIDX))
        eval "FM_ED_BUF=\${${var_name}[${var_idx}]}"
        FM_ED_POSTBUF=""
    fi
}

fedit_comp_reset()
{
    if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_PROMPT}" ]]
    then
        FM_ED_COMP_PROMPT_LIST=()
        FM_ED_COMP_PROMPT_IDX=0
    else
        FM_ED_COMP_MODE_LIST=()
        FM_ED_COMP_MODE_IDX=0
        FM_ED_COMP_MODE_PATH_CMD=""
    fi
}

# One completion engine, two state slots. The list is built once per session and
# cycled on each tab press.
fedit_complete()
{
    local var_slot
    local var_wordlist=()
    local var_tail="${FM_ED_BUF}"

    case "${FM_ED_DRIVER}" in
        "${DEF_ED_DRIVER_PROMPT}")
            # Wait and confirm take no completion.
            case "${FM_ED_FUNC}" in
                "${DEF_TERM_MODE_COMMAND}"|"${DEF_TERM_MODE_SEARCH}") var_slot="FM_ED_COMP_PROMPT" ;;
                *) return 0 ;;
            esac
            ;;
        *)
            var_slot="FM_ED_COMP_MODE"
            ;;
    esac

    if eval "[[ \${#${var_slot}_LIST[@]} -eq 0 ]]"
    then
        eval "${var_slot}_LIST=()"
        eval "${var_slot}_IDX=0"
        eval "${var_slot}_PATH_CMD=\"\""

        if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" && "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_COMMAND}" ]]
        then
            local var_cmd="${FM_ED_BUF%% *}"
            local var_args="${FM_ED_BUF##${var_cmd}}"
            local var_path=""

            if test -n "${var_cmd}" && test -n "${var_args}"
            then
                # Path completion, first argument only.
                var_path=${FM_ED_BUF#* }
                if test -n "${var_path}" && test -e ${var_path%/*}
                then
                    IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -f ${var_path})
                    eval "${var_slot}_PATH_CMD=\"\${var_cmd}\""
                    var_tail="${var_path}"
                fi
            else
                IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${VAR_TERM_CMD_LIST[*]}" ${FM_ED_BUF})
            fi
        elif [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
        then
            IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${VAR_TERM_SELECT_CMD_LIST[*]}" ${FM_ED_BUF})
        elif [[ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_NORMAL}" ]]
        then
            IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${VAR_TERM_CMD_LIST[*]}" ${FM_ED_BUF})
        else
            IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${VAR_TERM_SELECT_CMD_LIST[*]}" ${FM_ED_BUF})
        fi

        eval "${var_slot}_LIST+=(\"\${var_wordlist[@]}\" \"\${var_tail}\")"
    fi

    if eval "[[ -n \${${var_slot}_LIST[\${${var_slot}_IDX}]} ]]"
    then
        if eval "[[ -n \${${var_slot}_PATH_CMD} ]]"
        then
            eval "FM_ED_BUF=\"\${${var_slot}_PATH_CMD} \${${var_slot}_LIST[\${${var_slot}_IDX}]}\""
        else
            eval "FM_ED_BUF=\${${var_slot}_LIST[\${${var_slot}_IDX}]}"
        fi
        eval "(( ${var_slot}_IDX = ${var_slot}_IDX >= \${#${var_slot}_LIST[@]} - 1 ? 0 : ++${var_slot}_IDX ))"
    fi
}

# Read up to two characters of a sequence. bash 3.2 has no fractional read -t,
# so there it takes only what is already buffered instead of blocking.
fedit_read_seq()
{
    local var_seq=""

    if ((BASH_VERSINFO[0] > 3))
    then
        read -t "${DEF_ED_READ_TIMEOUT}" -rsn 2 var_seq
    else
        read -t 0 -rsn 2 var_seq
    fi

    printf '%s' "${var_seq}"
}

fedit_escape_drain()
{
    fedit_read_seq >/dev/null
}

# Read the rest of an escape sequence and print the whole key.
fedit_escape_read()
{
    local var_key=$'\e'
    local var_rest

    var_rest=$(fedit_read_seq)

    if [[ "${var_key}${var_rest}" == $'\e\e['* ]]
    then
        # Two escapes: the second one starts a new sequence.
        fedit_read_seq >/dev/null
    elif [[ "${var_key}${var_rest}" == $'\e['* ]]
    then
        var_key+="${var_rest}"
        var_rest=$(fedit_read_seq)
    fi

    printf '%s' "${var_key}${var_rest}"
}

fedit_key()
{
    local var_key=$1
    local var_count

    case ${var_key} in
        # Move forward: take one character back from the tail.
        $'\e[C')
            var_count=${#FM_ED_POSTBUF}
            if [[ "${var_count}" -ne 0 ]]
            then
                FM_ED_BUF+="${FM_ED_POSTBUF:0:1}"
                FM_ED_POSTBUF=${FM_ED_POSTBUF:1:$var_count-1}
            fi
            ;;
        # Move backward: move the last character to the tail.
        $'\e[D')
            var_count=${#FM_ED_BUF}
            if [[ "${var_count}" -ne 0 ]]
            then
                FM_ED_POSTBUF="${FM_ED_BUF:$var_count-1:1}${FM_ED_POSTBUF}"
                FM_ED_BUF=${FM_ED_BUF:0:$var_count-1}
            fi
            ;;
        $'\e[B')
            fedit_history_down
            ;;
        $'\e[A')
            fedit_history_up
            ;;
        # ':' clears the line, command flavor only.
        ":")
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_COMMAND}" ]]
            then
                FM_ED_BUF=""
            fi
            ;;
        $'\177' | $'\b')
            FM_ED_BUF=${FM_ED_BUF%?}
            fedit_comp_reset
            ;;
        $'\t')
            fedit_complete
            ;;
        "")
            VAR_TERM_CMD_INPUT_BUFFER="${FM_ED_BUF}${FM_ED_POSTBUF}"
            return 1
            ;;
        $'\e')
            VAR_TERM_CMD_INPUT_BUFFER=""
            return 2
            ;;
        $'\e'*)
            # A sequence the key decoder already handled.
            ;;
        $'\x12')
            # Ctrl-R inserts the selection, mode driver only.
            if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
            then
                fterminal_read_key_timeout 1
                case ${REPLY} in
                    \")
                        FM_ED_BUF+=$(fget_selection_file)
                        ;;
                esac
            else
                FM_ED_BUF+=${var_key}
                fedit_comp_reset
            fi
            ;;
        # Replace '~' with '$HOME'.
        "~")
            FM_ED_BUF+=$HOME
            ;;
        *)
            FM_ED_BUF+=${var_key}
            fedit_comp_reset
            ;;
    esac

    return 0
}

fedit_submit()
{
    VAR_TERM_CMD_INPUT_BUFFER="${FM_ED_BUF}${FM_ED_POSTBUF}"

    case "${FM_ED_FUNC}" in
        "${DEF_TERM_MODE_SEARCH}")
            [[ -n "${VAR_TERM_CMD_INPUT_BUFFER}" ]] &&
                fhist_append "VAR_TERM_SEARCH_HISTORY" "${VAR_TERM_CMD_INPUT_BUFFER}"
            fedit_end
            return 0
            ;;
        "${DEF_TERM_MODE_FIND}")
            cmd_find "${VAR_TERM_CMD_INPUT_BUFFER}"
            [[ -n "${VAR_TERM_CMD_INPUT_BUFFER}" ]] &&
                fhist_append "VAR_TERM_FIND_HISTORY" "${VAR_TERM_CMD_INPUT_BUFFER}"
            fedit_end
            return 0
            ;;
    esac

    if [[ "${FM_ED_FUNC}" != "${DEF_TERM_MODE_COMMAND}" ]]
    then
        fedit_end
        return 0
    fi

    if [[ -z "${VAR_TERM_CMD_INPUT_BUFFER}" ]]
    then
        fedit_end
        return 0
    fi

    fhist_append "VAR_TERM_CMD_HISTORY" "${VAR_TERM_CMD_INPUT_BUFFER}"
    fedit_dispatch
    fedit_end
}

fedit_cancel()
{
    fedit_escape_drain
    VAR_TERM_CMD_INPUT_BUFFER=""

    case "${FM_ED_DRIVER}" in
        "${DEF_ED_DRIVER_MODE}")
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_SEARCH}" ]]
            then
                fterminal_redraw full
            else
                fterminal_print '\r\e[K\e[?25l'
            fi
            ;;
        "${DEF_ED_DRIVER_PROMPT}")
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_SEARCH}" ]]
            then
                fterminal_redraw full
            else
                fterminal_print '\r\e[K\e[?25l\e8'
            fi
            FM_ED_COMP_PROMPT_LIST=()
            FM_ED_COMP_PROMPT_IDX=0
            ;;
    esac

    FM_ED_ACTIVE=0
}

# One dispatch table. The family follows the ambient mode at submit time.
fedit_dispatch()
{
    local var_family="cmd_"

    if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_PROMPT}" && "${VAR_TERM_MODE_CURRENT}" != "${DEF_TERM_MODE_COMMAND}" ]]
    then
        var_family="vcmd_"
    fi

    FM_ED_CMD=$(echo ${VAR_TERM_CMD_INPUT_BUFFER} | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 1)
    # The trailing space is a workaround for an argument-less command.
    FM_ED_ARGS=$(echo "${VAR_TERM_CMD_INPUT_BUFFER} " | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 2-)

    case ${FM_ED_CMD} in
        !*)
            # '!command' runs the shell, mode driver only.
            if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
            then
                cmd_eval "${VAR_TERM_CMD_INPUT_BUFFER#!}"
            else
                fterminal_print '\r\e[K Command "'${FM_ED_CMD}'" not found.\e[?25l\e8'
            fi
            ;;
        "redraw")
            fterminal_redraw full
            ;;
        "open")
            fsys_open ${FM_ED_ARGS}
            ;;
        "vim" | "edit")
            cmd_editor "${FM_ED_ARGS}"
            ;;
        "media" | "play")
            cmd_media "${FM_ED_ARGS}"
            ;;
        "image")
            cmd_image "${FM_ED_ARGS}"
            ;;
        "preview")
            cmd_preview "${FM_ED_ARGS}"
            ;;
        "echo")
            flog_msg "${FM_ED_ARGS}"
            ;;
        *)
            if command -v ${var_family}${FM_ED_CMD} >/dev/null
            then
                ${var_family}${FM_ED_CMD} ${FM_ED_ARGS}
                # We should not clear msg, after running.
                if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
                then
                    fterminal_print '\e[?25l'
                else
                    fterminal_print '\e[?25l\e8'
                fi
            else
                fterminal_print '\r\e[K Command "'${FM_ED_CMD}'" not found.\e[?25l\e8'
            fi
            ;;
    esac
}

# Driver A: one key per call, driven by fCore.
fcommand_mode_handler()
{
    local var_key=$*

    fterminal_print '\e[?25l\e[%sH' "$VAR_TERM_HEIGHT"

    fedit_key "${var_key}"
    case $? in
        0)
            fterminal_print $'\r%s\e[K%s\e[?25h' "$(fedit_line)" "$(printf "\e[%dD" "$(fedit_cursor_offset)")"
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_SEARCH}" ]]
            then
                cmd_newsearch "${FM_ED_BUF}${FM_ED_POSTBUF}"
            fi
            ;;
        1)
            fedit_submit
            ;;
        2)
            fedit_cancel
            ;;
    esac

    return 0
}

fcommand_handler()
{
    ## Pre settings.
    ################################################################
    # new functon for handle all commands
    # fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_HEIGHT"

    ## Main handler
    ################################################################
    case ${1} in
        "${DEF_TERM_MODE_COMMAND}")
            fcommand_line_interact "${HSFM_KEY_OPEN_CMD}" "${DEF_TERM_MODE_COMMAND}"
            # fterminal_print '\e[?25l\e8'
            ;;
        "${DEF_TERM_MODE_SEARCH}")
            fcommand_line_interact "${HSFM_KEY_SEARCH}" "${DEF_TERM_MODE_SEARCH}"
            fterminal_redraw
            ;;
    esac

    ## Post settings.
    ################################################################
    # Unset tab completion variables since we're done.
    # unset comp c

    # '\e[2K':   Clear the entire fcommand_line_check on finish.
    # '\e[?25l': Hide the cursor.
    # '\e8':     Restore cursor position.
    # fterminal_print '\e[2K\e[?25l\e8'
    # fterminal_print '\e[?25l\e8'

    # we don't need fterminal_redraw after commands running
    # this will be clear after fterminal_redraw
    # fterminal_redraw

}

# Driver B: owns the read loop, the prompt rendering and the input flush.
fcommand_line_interact()
{
    local var_prompt
    local var_read_reply=""

    fedit_begin "${1}" "${2:-}" "${DEF_ED_DRIVER_PROMPT}"

    fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_HEIGHT"

    while true
    do
        var_prompt=$'\r\e[K'"$(fedit_line)$(printf "\e[%dD" "$(fedit_cursor_offset)")"
        IFS= read -rsn 1 -p "${var_prompt}" var_read_reply 2>&1 || break

        if [[ ${var_read_reply} == $'\e' ]]
        then
            var_read_reply=$(fedit_escape_read)
        fi

        fedit_key "${var_read_reply}"
        case $? in
            0)
                if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_SEARCH}" ]]
                then
                    cmd_search "${FM_ED_BUF}${FM_ED_POSTBUF}"
                fi
                # Drop input typed ahead.
                read -t 0 -rsn 100 _
                ;;
            1)
                fedit_submit
                break
                ;;
            2)
                fedit_cancel
                break
                ;;
        esac
    done
}

# A command can open a prompt while its own session is still live, and there is
# one global editor state. The prompt borrows it and hands it back.
fprompt_open()
{
    local var_prefix=$1
    local var_func=$2
    local var_saved_prefix="${FM_ED_PREFIX}"
    local var_saved_func="${FM_ED_FUNC}"
    local var_saved_driver="${FM_ED_DRIVER}"
    local var_saved_active="${FM_ED_ACTIVE}"
    local var_saved_buf="${FM_ED_BUF}"
    local var_saved_postbuf="${FM_ED_POSTBUF}"
    local var_saved_histidx="${FM_ED_HISTIDX}"
    local var_saved_backup="${FM_ED_BACKUP}"
    local var_saved_mode_list=("${FM_ED_COMP_MODE_LIST[@]}")
    local var_saved_mode_idx="${FM_ED_COMP_MODE_IDX}"
    local var_saved_mode_path="${FM_ED_COMP_MODE_PATH_CMD}"
    local var_saved_prompt_list=("${FM_ED_COMP_PROMPT_LIST[@]}")
    local var_saved_prompt_idx="${FM_ED_COMP_PROMPT_IDX}"

    fcommand_line_interact "${var_prefix}" "${var_func}"

    FM_ED_PREFIX="${var_saved_prefix}"
    FM_ED_FUNC="${var_saved_func}"
    FM_ED_DRIVER="${var_saved_driver}"
    FM_ED_ACTIVE="${var_saved_active}"
    FM_ED_BUF="${var_saved_buf}"
    FM_ED_POSTBUF="${var_saved_postbuf}"
    FM_ED_HISTIDX="${var_saved_histidx}"
    FM_ED_BACKUP="${var_saved_backup}"
    FM_ED_COMP_MODE_LIST=("${var_saved_mode_list[@]}")
    FM_ED_COMP_MODE_IDX="${var_saved_mode_idx}"
    FM_ED_COMP_MODE_PATH_CMD="${var_saved_mode_path}"
    FM_ED_COMP_PROMPT_LIST=("${var_saved_prompt_list[@]}")
    FM_ED_COMP_PROMPT_IDX="${var_saved_prompt_idx}"
}

fprompt_wait()
{
    fprompt_open "${1}" "${DEF_ED_FUNC_WAIT}"
}

fprompt_confirm()
{
    fprompt_open "${1}" "${DEF_ED_FUNC_CONFIRM}"
}


###########################################################
## L5 Lifecycle
## config, persistence, traps, help, fCore, fMain.
###########################################################

fterminal_resize_win()
{
    fterminal_get_size
    fterminal_redraw
    # print size to prevent buffering
    # flog_msg "Window resized"
}

fHSFM_exit()
{
    HSFM_RUNNING=0
    fsave_settings
    fterminal_clear
    fterminal_reset
    fterminal_print "FM finished.\n"
    # exit 0
}

###########################################################
## Load/Save session
###########################################################
fsave_env() {
    if test -f ${HSFM_FILE_RUNTIME_ENV}
    then
        rm ${HSFM_FILE_RUNTIME_ENV}
    fi
    ## Save history
    if [[ "${#VAR_TERM_CMD_HISTORY[@]}" -ge "1" ]]
    then
        echo "#!/bin/bash" >> ${HSFM_FILE_RUNTIME_ENV}
        echo "export VAR_TERM_CMD_HISTORY" >> ${HSFM_FILE_RUNTIME_ENV}
        for each_history in "${VAR_TERM_CMD_HISTORY[@]}"
        do
            echo "VAR_TERM_CMD_HISTORY+=(\"${each_history}\")" >> ${HSFM_FILE_RUNTIME_ENV}
        done
    fi

    ## Save history
    if [[ "${#VAR_TERM_SEARCH_HISTORY[@]}" -ge "1" ]]
    then
        echo "export VAR_TERM_SEARCH_HISTORY" >> ${HSFM_FILE_RUNTIME_ENV}
        for each_history in "${VAR_TERM_SEARCH_HISTORY[@]}"
        do
            echo "VAR_TERM_SEARCH_HISTORY+=(\"${each_history}\")" >> ${HSFM_FILE_RUNTIME_ENV}
        done
    fi
    if [[ "${#VAR_TERM_FIND_HISTORY[@]}" -ge "1" ]]
    then
        echo "export VAR_TERM_FIND_HISTORY" >> ${HSFM_FILE_RUNTIME_ENV}
        for each_history in "${VAR_TERM_FIND_HISTORY[@]}"
        do
            echo "VAR_TERM_FIND_HISTORY+=(\"${each_history}\")" >> ${HSFM_FILE_RUNTIME_ENV}
        done
    fi

    # Save runtime env
    echo "export HSFM_COLOR_THEME=${HSFM_COLOR_THEME}" >> ${HSFM_FILE_RUNTIME_ENV}
    echo "export HSFM_READ_DIR_MODE=${HSFM_READ_DIR_MODE}" >> ${HSFM_FILE_RUNTIME_ENV}
    echo "export HSFM_LS_SORTING=${HSFM_LS_SORTING}" >> ${HSFM_FILE_RUNTIME_ENV}
}

fsave_session() {
    ## Save tab 
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]]
    then
        return 0
    fi

    if test -f ${HSFM_FILE_SESSION}
    then
        rm ${HSFM_FILE_SESSION}
    fi

    echo "#!/bin/bash" >> ${HSFM_FILE_SESSION}

    echo "export VAR_TERM_TAB_LINE_IDX=${VAR_TERM_TAB_LINE_IDX}" >> ${HSFM_FILE_SESSION}
    echo "export VAR_TERM_TAB_LINE_LIST_PATH" >> ${HSFM_FILE_SESSION}
    for each_tab in "${VAR_TERM_TAB_LINE_LIST_PATH[@]}"
    do
        echo "VAR_TERM_TAB_LINE_LIST_PATH+=(\"${each_tab}\")" >> ${HSFM_FILE_SESSION}
    done

    # The directory lists are read from disk again on restore.
    echo "cd '${PWD}'" >> ${HSFM_FILE_SESSION}
}

fload_session() {
    if test -f ${HSFM_FILE_SESSION}
    then
        source ${HSFM_FILE_SESSION}
        flog_msg_debug "Load Session Tab: ${VAR_TERM_TAB_LINE_IDX}-${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]##*/}"
    else
        # load sessio fail, start a new one.
        VAR_TERM_TAB_LINE_IDX=0
        VAR_TERM_TAB_LINE_LIST_PATH=("${PWD}")
    fi
}

fload_env() {
    if test -f ${HSFM_FILE_RUNTIME_ENV}
    then
        source ${HSFM_FILE_RUNTIME_ENV}
    fi
}

fsave_settings() {
    fsave_env
    fsave_session
}

###########################################################
## Others
###########################################################
fsetup_env_cache() {
    # Setup patch env
    export HSFM_FILE_RUNTIME_ENV=${HSFM_PATH_CACHE}/hsfm_runtimeenv.sh
    export HSFM_FILE_SESSION=${HSFM_PATH_CACHE}/hsfm_session.sh
    export HSFM_FILE_CD_LASTPATH=${HSFM_PATH_CACHE}/hsfm_last.sh
    export HSFM_FILE_MESSAGE=${HSFM_PATH_CACHE}/hsfm_message.log
    export HSFM_FILE_LOGS=${HSFM_PATH_CACHE}/hsfm_logs.sh
}

fsetup_env() {
    # Figure out the current operating system to set some specific variables.
    # '$OSTYPE' typically stores the name of the OS kernel.
    case $OSTYPE in
        # Mac OS X / macOS.
        darwin*)
            HSFM_OPENER=""
            VAR_TERM_FILE_ARGS=bIL

            VAR_TERM_DIR_LS_ARGS=("--color=none")
            VAR_TERM_DIR_LS_ARGS+=("-h -ld ")

            # FIXME, not tested.
            # VAR_TERM_DIR_LS_ARGS+=("--time-style=long-iso")
            # VAR_TERM_DIR_LS_ARGS+=("-quote-name")

            # Patch
            # HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_LS}
            HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_LS_SORT}

        ;;

        linux*|*)
            # HSFM_OPENER=
            VAR_TERM_FILE_ARGS=biL

            VAR_TERM_DIR_LS_ARGS=("--color=none")
            VAR_TERM_DIR_LS_ARGS+=("--group-directories-first")
            VAR_TERM_DIR_LS_ARGS+=("-h -ld ")

            # VAR_TERM_DIR_LS_ARGS+=("--time-style=long-iso")
            # VAR_TERM_DIR_LS_ARGS+=("--time-style=+%Y-%m-%d-%H:%M,")

            #other args
            # VAR_TERM_DIR_LS_ARGS+=("-quote-name")
            # VAR_TERM_DIR_LS_ARGS+=("--tabsize=8")
            # VAR_TERM_DIR_LS_ARGS+=("-1")
        ;;
    esac
    fsetup_env_cache
}

fsetup_options() {

    # source config file if exist.
    test -f ${HSFM_FILE_CONFIG} && {
        source ${HSFM_FILE_CONFIG}
    }
    # Some options require some setup.
    # This function is called once on open to parse
    # select options so the operation isn't repeated
    # multiple times in the code.

    # Format for normal files.
    [[ $HSFM_FILE_FORMAT == *%f* ]] && {
        VAR_TERM_FILE_PRE=${HSFM_FILE_FORMAT/'%f'*}
        VAR_TERM_FILE_POST=${HSFM_FILE_FORMAT/*'%f'}
    }

    # Format for marked files.
    # Use affixes provided by the user or use defaults, if necessary.
    if [[ $HSFM_MARK_FORMAT == *%f* ]]; then
        VAR_TERM_MARK_PRE=${HSFM_MARK_FORMAT/'%f'*}
        VAR_TERM_MARK_POST=${HSFM_MARK_FORMAT/*'%f'}
    else
        VAR_TERM_MARK_PRE=""
        VAR_TERM_MARK_POST="*"
    fi

    # Find supported 'file' arguments.
    # file -I &>/dev/null || : "${VAR_TERM_FILE_ARGS:=biL}"

    # Setup bookmark
    for each_fav in "${!HSFM_FAV@}"
    do
        if eval "test -d \"${!each_fav}\""
        then
            eval "${each_fav}='${!each_fav%%/}'"
        else
            eval "${each_fav}=''"
        fi
    done
}

fsetup_shell()
{
    # Handle a directory as the first argument.
    # 'cd' is a cheap way of finding the full path to a directory.
    # It updates the '$PWD' variable on successful execution.
    # It handles relative paths as well as '../../../'.
    #
    # # '||:': Do nothing if 'cd' fails. We don't care.
    # cd "${2:-$1}" &>/dev/null ||:

    # bash 5 and some versions of bash 4 don't allow SIGWINCH to interrupt
    # a 'read' command and instead wait for it to complete. In this case it
    # causes the window to not fterminal_redraw on resize until the user has pressed
    # a key (causing the read to finish). This sets a read timeout on the
    # affected versions of bash.
    # NOTE: This shouldn't affect idle performance as the loop doesn't do
    # anything until a key is pressed.
    # SEE: https://github.com/dylanaraps/hsfm/issues/48
    ((BASH_VERSINFO[0] > 3)) &&
        VAR_TERM_READ_ARGS=(-t 0.05)

    ((${HSFM_LS_COLORS:=1} == 1)) &&
        fexport_ls_colors

    # Move to read dir to set opt.
    # ((${HSFM_ENABLE_HIDDEN:=0} == 1)) &&
    #     shopt -s dotglob

    # Create the trash and cache directory if they don't exist.
    mkdir -p "${HSFM_PATH_CACHE}"

    # 'nocaseglob': Glob case insensitively (Used for case insensitive search).
    # 'nullglob':   Don't expand non-matching globs to themselves.
    shopt -s nocaseglob nullglob

    # Trap the exit signal (we need to reset the terminal to a useable state.)
    # trap 'fterminal_reset' EXIT
    # trap "trap - SIGTERM && fHSFM_exit &&kill -- -$$" SIGINT SIGTERM EXIT
    trap "fHSFM_exit" SIGINT SIGTERM EXIT

    # Trap the window resize signal (handle window resize events).
    trap 'fterminal_resize_win' WINCH
}

fexport_ls_colors() {
    # Parse the LS_COLORS variable and declare each file type
    # as a separate variable.
    # Format: ':.ext=0;0:*.jpg=0;0;0:*png=0;0;0;0:'
    [[ -z $LS_COLORS ]] && {
        HSFM_LS_COLORS=0
        flog_msg_debug "LS_COLORS is empty. use default one."
        local LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:"
        # return
    }

    # Turn $LS_COLORS into an array.
    IFS=: read -ra ls_cols <<< "$LS_COLORS"

    for ((i=0;i<${#ls_cols[@]};i++)); {
        # Separate patterns from file types.
        [[ ${ls_cols[i]} =~ ^\*[^\.] ]] &&
            ls_patterns+="${ls_cols[i]/=*}|"

        # Prepend 'ls_' to all LS_COLORS items
        # if they aren't types of files (symbolic links, block files etc.)
        [[ ${ls_cols[i]} =~ ^(\*|\.) ]] && {
            ls_cols[i]=${ls_cols[i]#\*}
            ls_cols[i]=ls_${ls_cols[i]#.}
        }
    }

    # Strip non-ascii characters from the string as they're
    # used as a key to color the dir items and variable
    # names in bash must be '[a-zA-z0-9_]'.
    ls_cols=("${ls_cols[@]//[^a-zA-Z0-9=\\;]/_}")

    # Store the patterns in a '|' separated string
    # for use in a REGEX match later.
    ls_patterns=${ls_patterns//\*}
    ls_patterns=${ls_patterns%?}

    # Define the ls_ variables.
    # 'declare' can't be used here as variables are scoped
    # locally. 'declare -g' is not available in 'bash 3'.
    # 'export' is a viable alternative.
    export "${ls_cols[@]}" &>/dev/null
}

fsetup_theme() {
    local var_colorscheme=""
    if [[ "${#}" -ge "1" ]]
    then
        var_colorscheme="${1}"
    else
        var_colorscheme="${HSFM_COLOR_THEME}"
    fi
    
    if [ $var_colorscheme = "black" ] ||  [ $var_colorscheme = "default" ]; then
        # black scheme, low profile.
        # Cursor color [0\-9]
        export HSFM_COLOR_CURSOR="1;37;40"
        # Selection color [0\-9] (copied/moved files)
        export HSFM_COLOR_SELECTION="100"
        # Title
        export HSFM_COLOR_TITLE="97;40"
        # tab bar
        export HSFM_COLOR_TAB="97;40"
        export HSFM_COLOR_TAB_SELECTION="32;40"
        export HSFM_COLOR_TAB_LEBEL="97;40"
        # bookmark bar
        export HSFM_COLOR_TAB_BOOKMARK="97;40"
        # Status bar
        export HSFM_COLOR_STATUS="97;40"
        export HSFM_COLOR_STATUS_LABEL="97;40"

        # Float win
        export HSFM_COLOR_FLOAT_WIN="97;40"
        export HSFM_COLOR_FLOAT_WIN_LABEL="97;40"
    elif [ $var_colorscheme = "color" ]; then
        # Cursor color [0\-9]
        export HSFM_COLOR_CURSOR="1;37;7"
        # Selection color [0\-9] (copied/moved files)
        export HSFM_COLOR_SELECTION="100"
        # Title
        export HSFM_COLOR_TITLE="30;104"
        # tab bar
        export HSFM_COLOR_TAB="97;100"
        export HSFM_COLOR_TAB_SELECTION="30;43"
        export HSFM_COLOR_TAB_LEBEL="30;43"
        # bookmark bar
        export HSFM_COLOR_TAB_BOOKMARK="97;40"
        # Status bar
        export HSFM_COLOR_STATUS="97;100"
        export HSFM_COLOR_STATUS_LABEL="30;43"

        # Float win
        export HSFM_COLOR_FLOAT_WIN="97;100"
        export HSFM_COLOR_FLOAT_WIN_LABEL="30;47"
    else
        flog_msg "Theme ${var_colorscheme} not found."
        return -1
    fi
    HSFM_COLOR_THEME=${var_colorscheme}
}

fHelp_keymap() {
    fterminal_print "[KeyMap]\n"
    fterminal_print "\n%s\n" "## Movement."
    fterminal_print "    % -32s: %s\n"  "Go to child directory"          "${HSFM_KEY_CHILD1}, ${HSFM_KEY_CHILD2}, ${HSFM_KEY_CHILD3}"
    fterminal_print "    % -32s: %s\n"  "Go to parent directory"         "${HSFM_KEY_PARENT1}, ${HSFM_KEY_PARENT2}, ${HSFM_KEY_PARENT3}, ${HSFM_KEY_PARENT4}"
    fterminal_print "    % -32s: %s\n"  "Scroll down"                    "${HSFM_KEY_SCROLL_DOWN1}, ${HSFM_KEY_SCROLL_DOWN2}"
    fterminal_print "    % -32s: %s\n"  "Scroll up"                      "${HSFM_KEY_SCROLL_UP1}, ${HSFM_KEY_SCROLL_UP2}"
    fterminal_print "    % -32s: %s\n"  "Go to top"                      "${HSFM_KEY_TO_TOP}"
    fterminal_print "    % -32s: %s\n"  "Go to bottom"                   "${HSFM_KEY_TO_BOTTOM}"
    fterminal_print "    % -32s: %s\n"  "Go to previous directory"       "${HSFM_KEY_PREVIOUS}"
    fterminal_print "    % -32s: %s\n"  "Go to home"                     "${HSFM_KEY_GO_HOME}"
    fterminal_print "    % -32s: %s\n"  "Go to trash"                    "${HSFM_KEY_GO_TRASH}"

    fterminal_print "\n%s\n" "## Tab operations."
    fterminal_print "    % -32s: %s\n"  "Go to previous tab"             "${HSFM_KEY_GO_PREVIOUS_TAB}"
    fterminal_print "    % -32s: %s\n"  "Go to next tab"                 "${HSFM_KEY_GO_NEXT_TAB}"
    fterminal_print "    % -32s: %s\n"  "Open new tab"                   "${HSFM_KEY_OPEN_TAB}"
    fterminal_print "    % -32s: %s\n"  "Close current tab"              "${HSFM_KEY_CLOSE_TAB}"
    fterminal_print "    % -32s: %s\n"  "Move tab previous"              "${HSFM_KEY_MOVE_TAB_PREVIOUS}"
    fterminal_print "    % -32s: %s\n"  "Move tab next"                  "${HSFM_KEY_MOVE_TAB_NEXT}"

    fterminal_print "\n%s\n" "## Mode switches."
    fterminal_print "    % -32s: %s\n"  "Visual select mode"             "${HSFM_KEY_VISUAL_SELECT}"
    fterminal_print "    % -32s: %s\n"  "Selection mode"                 "${HSFM_KEY_SELECTION}"
    fterminal_print "    % -32s: %s\n"  "Command mode"                   "${HSFM_KEY_OPEN_CMD}"
    fterminal_print "    % -32s: %s\n"  "Search mode"                    "${HSFM_KEY_SEARCH}"
    fterminal_print "    % -32s: %s\n"  "Find mode"                      "${HSFM_KEY_FIND}"

    fterminal_print "\n%s\n" "## File operations."
    fterminal_print "    % -32s: %s\n"  "Yank (copy)"                    "${HSFM_KEY_YANK}"
    fterminal_print "    % -32s: %s\n"  "Cut (move)"                     "${HSFM_KEY_CUT}"
    fterminal_print "    % -32s: %s\n"  "Trash (delete)"                 "${HSFM_KEY_TRASH}"
    fterminal_print "    % -32s: %s\n"  "Paste"                          "${HSFM_KEY_PASTE}"

    fterminal_print "\n%s\n" "## Miscellaneous."
    fterminal_print "    % -32s: %s\n"  "Show file attributes"           "${HSFM_KEY_ATTRIBUTES}"
    fterminal_print "    % -32s: %s\n"  "Toggle hidden files"            "${HSFM_KEY_HIDDEN}"
    fterminal_print "    % -32s: %s\n"  "Toggle sorting"                 "${HSFM_KEY_SORTING}"
    fterminal_print "    % -32s: %s\n"  "Spawn a shell"                  "${HSFM_KEY_SHELL}"
    fterminal_print "    % -32s: %s\n"  "Show help info"                 "${HSFM_KEY_HELP}"
    fterminal_print "    % -32s: %s\n"  "Refresh window"                 "${HSFM_KEY_REFRESH}"
    fterminal_print "    % -32s: %s\n"  "Toggle message window"          "${HSFM_KEY_TOGGLE_MSGWIN}"
    fterminal_print "    % -32s: %s\n"  "Toggle task window"             "${HSFM_KEY_TOGGLE_TASKWIN}"
}

fHelp_commands() {
    echo "FileManager"
    fterminal_print "[Options]\n"
    fterminal_print "    %- 16s\t%s\n" "-s|-setup   " "Copy hsfm config file."
    fterminal_print "    %- 16s\t%s\n" "-d|--debug  " "Enable debug flag."
    fterminal_print "    %- 16s\t%s\n" "--cache-path" "Specify cache path."
    # fterminal_print "    %- 16s\t%s\n" "-r|--restore" "restore previous session."
    fterminal_print "    %- 16s\t%s\n" "-n|--new" "Open new session session."
    fterminal_print "    %- 16s\t%s\n" "-l|--last   " "Print last path & remove the last path file."
    fterminal_print "    %- 16s\t%s\n" "--history   " "Store history."
    fterminal_print "[Commands]\n"
    fterminal_print "    % -16s: %s\n"  "redraw" "Redraws the current window."
    fterminal_print "    % -16s: %s\n"  "help" "Shows help information. Accepts 'key' or 'map' for keybindings."
    fterminal_print "    % -16s: %s\n"  "exit" "Exits the file manager."
    fterminal_print "    % -16s: %s\n"  "shell" "Spawns a new shell."
    fterminal_print "    % -16s: %s\n"  "cd" "Changes the current directory."
    fterminal_print "    % -16s: %s\n"  "reenter" "Re-enters the current directory."
    fterminal_print "    % -16s: %s\n"  "colorscheme" "Changes the color scheme (e.g., 'black', 'color')."
    fterminal_print "    % -16s: %s\n"  "set" "Sets various options (e.g., 'set read fast', 'set hidden on')."
    fterminal_print "    % -16s: %s\n"  "title" "Sets the window title."
    fterminal_print "    % -16s: %s\n"  "config" "Opens the configuration file in the default editor."
    fterminal_print "    % -16s: %s\n"  "debug" "Toggles debug mode ('on'/'off')."
    fterminal_print "    % -16s: %s\n"  "select" "Shows selected files."
    fterminal_print "    % -16s: %s\n"  "stat" "Displays file attributes for the current file."
    fterminal_print "    % -16s: %s\n"  "eval" "Evaluates a shell command."
    fterminal_print "    % -16s: %s\n"  "dump" "Dumps HSFM environment variables."
    fterminal_print "    % -16s: %s\n"  "test" "Runs a test function."
    fterminal_print "    % -16s: %s\n"  "task" "Toggles the task window."
    fterminal_print "    % -16s: %s\n"  "msg" "Toggles the message window."
    fterminal_print "    % -16s: %s\n"  "mkdir" "Creates a new directory."
    fterminal_print "    % -16s: %s\n"  "touch" "Creates a new empty file."
    fterminal_print "    % -16s: %s\n"  "rename" "Renames the current file."
    fterminal_print "    % -16s: %s\n"  "search" "Searches for files in the current directory."
    fterminal_print "    % -16s: %s\n"  "find" "Finds files recursively from the current directory."
    fterminal_print "    % -16s: %s\n"  "sort" "Sorts files by 'none', 'size', 'time', 'version', or 'extension'."
    fterminal_print "    % -16s: %s\n"  "backfile" "Creates a backup of the current file."
    fterminal_print "    % -16s: %s\n"  "quitngo" "Quits and changes to the current directory in the parent shell."
    fterminal_print "    % -16s: %s\n"  "tabclose" "Closes the current tab."
    fterminal_print "    % -16s: %s\n"  "tabcloseright" "Closes tabs to the right of the current tab."
    fterminal_print "    % -16s: %s\n"  "tabcloseleft" "Closes tabs to the left of the current tab."
    fterminal_print "    % -16s: %s\n"  "tabcloseothers" "Closes all other tabs except the current one."
    fterminal_print "    % -16s: %s\n"  "tabcloseduplicate" "Closes duplicate tabs."
    fterminal_print "    % -16s: %s\n"  "open" "Opens the current file with the default opener."
    fterminal_print "    % -16s: %s\n"  "editor" "Opens the current file in the default text editor."
    fterminal_print "    % -16s: %s\n"  "vim" "Opens the current file in Vim."
    fterminal_print "    % -16s: %s\n"  "hex" "Opens the current file in a hex viewer (xxd)."
    fterminal_print "    % -16s: %s\n"  "media" "Opens the current file in the default media player."
    fterminal_print "    % -16s: %s\n"  "play" "Opens the current file in the default media player."
    fterminal_print "    % -16s: %s\n"  "image" "Opens the current file in the default image viewer."
    fterminal_print "    % -16s: %s\n"  "preview" "Previews the current file (requires catimg for images)."
    fterminal_print "    % -16s: %s\n"  "unzip" "Extracts a zip archive."
    fterminal_print "    % -16s: %s\n"  "extract" "Extracts various archive types."
    fterminal_print "    % -16s: %s\n"  "disk" "Displays disk usage information."

    fterminal_print "\n%s\n" "## Selection Commands."
    fterminal_print "    % -16s: %s\n"  "compress" "Compresses selected files."

    fterminal_print "\n%s\n" "## TODO Function."
    fterminal_print "    %s\n"  "The following functions are under construction."
    fterminal_print "    %s\n"  "#. Background task & task manager."
}

fHelp() {
    local help_type=$1
    if [ "${help_type}" = "key" ] || [ "${help_type}" = "map" ]
    then
        fHelp_keymap $@
    else
        fHelp_commands $@
    fi
}

# '--verbose' diagnostics. fMain calls them before the UI exists, so they write
# to stderr.
fInfo()
{
    printf '%s\n' "hsfm: verbose mode" >&2
}

fErrControl()
{
    printf '%s\n' "hsfm: ${1:-?}:${2:-?}" >&2
}

## Core Function
###########################################################
function fCore() {
    # restore runtime env.
    fload_env

    fsetup_env
    fsetup_options
    fsetup_shell
    fsetup_theme "${HSFM_COLOR_THEME}"

    fterminal_get_size
    fterminal_setup
    fterminal_redraw full

    flog_msg_debug "HSFM initialized."

    HSFM_RUNNING=1
    # Vintage infinite loop.
    for ((;HSFM_RUNNING;)); {
        # read "${VAR_TERM_READ_ARGS[@]}" -srn 1 && {
        fterminal_read_key && {
            case ${VAR_TERM_MODE_CURRENT} in
                "${DEF_TERM_MODE_VISUAL}")
                    fvisual_mode_handler "$REPLY"
                    ;;
                "${DEF_TERM_MODE_SELECT}")
                    fselection_mode_handler "$REPLY"
                    ;;
                "${DEF_TERM_MODE_COMMAND}"|"${DEF_TERM_MODE_SEARCH}"|"${DEF_TERM_MODE_FIND}")
                    fcommand_mode_handler "$REPLY"
                    ;;
                *|"${DEF_TERM_MODE_NORMAL}")
                    fnormal_mode_handler "$REPLY"
                    ;;
                esac
                # FIXME, temporailly disable draw status line during keytyping.
                # fterminal_draw_status_line
                # Discard following input
                # read -t 0 -rsn 10000 _
            }

        # Exit if there is no longer a terminal attached.
        [[ -t 1 ]] || exit 1
    }
}

## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false
    local flag_load_session="false"
    local var_new_path=""

    while [[ $# != 0 ]]
    do
        case $1 in
            -l|--last-path)
                if [[ "${#}" -ge "2" ]] && ! [[ $2 =~ -.* ]]
                then
                    if test -f "${HSFM_FILE_CD_LASTPATH}"
                    then
                        cat ${HSFM_FILE_CD_LASTPATH}

                        if [[ "$2" = "flush" ]]
                        then
                            rm ${HSFM_FILE_CD_LASTPATH}
                        fi
                    else
                        exit 1
                    fi
                else
                    # Don't print to stdio, some will use it for cd.
                    if cat ${HSFM_FILE_CD_LASTPATH} 2> /dev/null
                    then
                        exit 0
                    else
                        exit 1
                    fi
                fi
                exit 0

                ;;
            -d|--debug)
                HSFM_DEBUG=true
                ;;
            --history)
                # Store file name in a file on open instead of using 'HSFM_OPENER'.
                # Used in 'hsfm.vim'.
                HSFM_FILE_PICKER=1
                ;;
            -n|--new)
                flag_load_session=false
                ;;
            -r|-restore)
                flag_load_session=true
                ;;
            -s|-setup)
                if ! test -f "${HSFM_FILE_CONFIG}"
                then
                    cp $(dirname ${BASH_SOURCE[0]})/hsfm_template.sh ${HSFM_FILE_CONFIG}
                    echo "File copied."
                    return 0
                else
                    echo "File exits."
                    exit 1
                fi
                ;;
            --cache-path)

                if [[ "${#}" -ge "2" ]] && ! [[ $2 =~ -.* ]]
                then
                    export HSFM_PATH_CACHE="${2}"
                    fsetup_env_cache
                    shift 1
                fi
                ;;
            # Options
            -v|--verbose)
                flag_verbose=true
                ;;
            -t|--test)
                export HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_FAST_LS}
                ;;
            -h|--help)
                fHelp
                exit 0
                ;;
            *)
                if test -d "$*"; then
                    var_new_path="$(realpath ${*})"
                else
                    echo "Unknown Options: ${1}"
                    fHelp
                    exit 1
                fi
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

    if [[ $HSFM_RUNNING = 1 ]]
    then
        echo "HSFM is running. Status: $HSFM_RUNNING"
        exit 1
    fi

    if [ "${flag_load_session}" = "true" ]
    then
        fload_session
    else
        VAR_TERM_TAB_LINE_IDX=0
        VAR_TERM_TAB_LINE_LIST_PATH=("${PWD}")
    fi

    # add new for page.
    if test -n ${var_new_path} && test -d "${var_new_path}"; then
        local new_abs_path="$(realpath ${var_new_path})"
        local flash_found_tab=false
        for each_idx in "${!VAR_TERM_TAB_LINE_LIST_PATH[@]}"; do
            local tmp_path=${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}
            flog_msg_debug "${each_idx}: ${tmp_path}, ${new_abs_path}"
            if [ "${tmp_path}" = "${new_abs_path}" ] ; then
                VAR_TERM_TAB_LINE_IDX=${each_idx}
                flash_found_tab=true
                # break
            fi
        done

        if [ ${flash_found_tab} = false ]
        then
            flog_msg_debug "Open$(pwd), ${var_new_path}"
            # cd ${var_new_path}
            # flog_msg_debug "New Path: ${var_new_path}"
            # TODO, use api for create new page?
            VAR_TERM_TAB_LINE_LIST_PATH+=("${var_new_path}")
            # 0 base idx.
            VAR_TERM_TAB_LINE_IDX=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
            cd ${var_new_path}
        fi
    fi


    if [[ $HSFM_DEBUG = true ]]
    then
        # Record stderr
        fCore 2> >(tee ${HSFM_FILE_LOGS} >&2)
    else
        fCore
    fi
}

# Sourceable: only run when executed, not when sourced by the test harness.
[[ "${BASH_SOURCE[0]}" == "$0" ]] && fMain "$@"
