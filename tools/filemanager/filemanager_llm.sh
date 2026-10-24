#!/usr/bin/env bash

# Namespaces
# ----------
# HSFM_*  External configuration. A user's ~/.hsfm.sh sets these, so the names
#         are a contract; a few are also written to the cache files.
# DEF_*   Constants. Read-only after load.
# FM_*    Internal state, owned by one layer:
#           FM_VIEW_*   L1  geometry, buffers, display formats
#           FM_DIR_*    L2  directory list, cursor, scroll, marks, tabs
#           FM_CMD_*    L3  the pending command and its operands
#           FM_INPUT_*  L4  key decoding and the mode state machine
#           FM_ED_*     L4  line editor
#           FM_ENV_*    L5  per-platform command arguments
#           FM_*        L5  process state
#
# Rules: every name is declared in this header; one layer writes each variable;
# a 'local' never reuses one of these names, because bash scopes dynamically.
#
# Frozen by the on-disk format, do not rename: VAR_TERM_CMD_HISTORY,
# VAR_TERM_SEARCH_HISTORY, VAR_TERM_FIND_HISTORY, VAR_TERM_TAB_LINE_IDX,
# VAR_TERM_TAB_LINE_LIST_PATH, HSFM_COLOR_THEME, HSFM_READ_DIR_MODE,
# HSFM_LS_SORTING, HSFM_PATH_CACHE, HSFM_FILE_CONFIG. The cache files are
# sourced as bash, so renaming one silently drops a user's history or session.

###########################################################
## Constants (DEF_*)
###########################################################

# read dir mode
# def of read mode
export DEF_TERM_READ_DIR_MODE_NONE=0
export DEF_TERM_READ_DIR_MODE_SORT=1
export DEF_TERM_READ_DIR_MODE_LS=2
export DEF_TERM_READ_DIR_MODE_FAST_LS=3
# For mac use, sort by command.
export DEF_TERM_READ_DIR_MODE_LS_SORT=4
export DEF_TERM_READ_DIR_MODE_FIND=10
export DEF_TERM_WIN_TYPE_HIDDEN=0
export DEF_TERM_WIN_TYPE_MSG=1
export DEF_TERM_WIN_TYPE_TASK=2
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

###########################################################
## External configuration (HSFM_*)
## A user's ~/.hsfm.sh sets these. The names are a contract.
###########################################################

# Use LS_COLORS to color hsfm.
# (On by default if available)
# (Ignores HSFM_COL1)
export HSFM_LS_COLORS=1

# Show/Hide hidden files on open.
# (On by default)
export HSFM_ENABLE_HIDDEN=1
export HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_FAST_LS}
#This is the setting file.
export HSFM_FILE_CONFIG="${HOME}/.hsfm.sh"
# CD on exit helper file
# Default: '${XDG_CACHE_HOME}/hsfm/hsfm.d'
#          If not using XDG, '${HOME}/.cache/hsfm/hsfm.d' is used.
export HSFM_PATH_CACHE="${HOME}/.cache/hsfm"
# Trash Directory
# Default: '${XDG_DATA_HOME}/hsfm/trash'
#          If not using XDG, '${XDG_DATA_HOME}/hsfm/trash' is used.
export HSFM_PATH_TRASH="${HOME}/.trash"
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

# Text Editor
export HSFM_TEXT_EDITOR="vim"
export HSFM_MEDIA_PLAYER="vlc"
export HSFM_PICTURE_VIEWER="loupe"

# File Opener
export HSFM_OPENER="xdg-open"

# File Attributes Command

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
## Internal state (FM_*)
## One owner per block: FM_VIEW_*, FM_DIR_*, FM_INPUT_*, FM_ED_*,
## FM_CMD_*, FM_ENV_*, and process state in FM_*.
###########################################################

test -z ${FM_RUNNING} && export FM_RUNNING=0
export FM_DEBUG=false
export FM_PERF_DEBUG=false
export FM_FILE_PICKER=0
# this is only work on run time.
export FM_LEFT_HAND_MODE=0
# Terminal Args
export FM_INPUT_READ_ARGS=()
export FM_ENV_DIR_LS_ARGS=()
export FM_ENV_FILE_ARGS=""

# Terminal Atrib
export FM_VIEW_HEIGHT=0
export FM_VIEW_WIDTH=0

export FM_VIEW_STATUS_LINE_CNT=2
export FM_VIEW_TAB_LINE_HEIGHT=2

# sub win
export FM_VIEW_SUBWIN_TOP_SIZE=10
export FM_VIEW_SUBWIN_BOTTOM_SIZE=12

export FM_VIEW_SUBWIN_RIGHT_SIZE=20
export FM_VIEW_SUBWIN_LEFT_SIZE=20

# Main window
export FM_VIEW_MAINWIN_START_IDX=(0 0)
export FM_VIEW_MAINWIN_HEIGHT=0
export FM_VIEW_MAINWIN_WIDTH=0

export VAR_TERM_TAB_LINE_IDX=0
export VAR_TERM_TAB_LINE_LIST_PATH
export FM_DIR_TAB_START_IDX
export FM_DIR_TAB_CURSOR_IDX

export FM_DIR_CURSOR_ROW=0
export FM_DIR_SCROLL_IDX=0
export FM_DIR_SCROLL_START_IDX=0

export FM_DIR_LIST_CNT=0
export FM_DIR_FILE_LIST=()
export FM_DIR_FILE_INFO_LIST=()

# Directory model state (L2). Declared with the other terminal vars so the
# loader never touches an unset name.
FM_DIR_PREV_IDX=0
FM_DIR_BACKUP=()
FM_DIR_SEARCH_ACTIVE=

export FM_CMD_OPEN_FILE=""

# Buffer
export FM_VIEW_PRINT_BUFFER_ENABLE=false
export FM_VIEW_PRINT_BUFFER=""
export FM_INPUT_KEY_BUFFER=""
export FM_INPUT_KEY=""

# Marks
export FM_VIEW_FILE_PRE=""
export FM_VIEW_FILE_POST=""
export FM_VIEW_MARK_PRE=""
export FM_VIEW_MARK_POST=""

# Flags
export FM_DIR_FLAG_FIND_PREVIOUS=0
export FM_DIR_FLAG_RESET_IDX=false

export FM_VIEW_UPPERWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
export FM_VIEW_LEFTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
export FM_VIEW_RIGHTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
export FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}

# msg win
export FM_VIEW_MSGWIN_BUFFER=()

# task win
export FM_VIEW_TASKWIN_BUFFER=("Main task running.")

export FM_DIR_MARKED_LIST=()
export FM_DIR_MARK_DIR=""
export FM_CMD_SELECTION_LIST=()
export FM_CMD_FILE_PROGRAM=()

export FM_ED_HISTORY_MAX=100
export VAR_TERM_CMD_HISTORY
export VAR_TERM_SEARCH_HISTORY
export VAR_TERM_FIND_HISTORY

export FM_ED_COMMIT=""

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
export FM_ED_CMD_LIST=( "redraw" "help" "exit" "shell" "cd" "reenter" "colorscheme")
FM_ED_CMD_LIST+=( "set" "title" "config")
# Debug
FM_ED_CMD_LIST+=( "debug" "select" "stat" "eval" "dump" "test" "task" "msg")
# File operation
FM_ED_CMD_LIST+=( "mkdir" "touch" "rename" "search" "find" "sort" "backfile" )
# Tab operation
FM_ED_CMD_LIST+=( "quitngo" "tabclose" "tabcloseright" "tabcloseleft" "tabcloseothers" "tabcloseduplicate")
# Open ralted.
FM_ED_CMD_LIST+=( "open" "editor" "vim" "hex" "media" "play" "image" "preview" "unzip" "extract")

export FM_ED_VCMD_LIST=( "compress" )
# FM_ED_VCMD_LIST+=( "copy" "remove" "paste" )

export FM_INPUT_VISUAL_START=0
export FM_INPUT_MODE="${DEF_TERM_MODE_NORMAL}"

export FM_DIR_SEARCH_END_EARLY=0

export FM_FILE_RUNTIME_ENV=${HSFM_PATH_CACHE}/hsfm_runtimeenv.sh
export FM_FILE_SESSION=${HSFM_PATH_CACHE}/hsfm_session.sh
export FM_FILE_CD_LASTPATH=${HSFM_PATH_CACHE}/hsfm_last.sh
export FM_FILE_MESSAGE=${HSFM_PATH_CACHE}/hsfm_message.log
export FM_FILE_LOGS=${HSFM_PATH_CACHE}/hsfm_logs.sh
export FM_ENV_TITLE="HSFM"
# Dir alias. Parallel arrays: bash 3.2 has no associative arrays.
export FM_DIR_ALIAS_KEY=("home" "log")
export FM_DIR_ALIAS_PATH=("${HOME}" "/var/log")

###########################################################
## L0 Driver
## stdout and escape emission, print buffer, terminal modes, rectangle drawing.
###########################################################

###########################################################
## Utility Functions
###########################################################
fout_sanitize_name() {
    sed "s/ /_/g" | sed -r "s/[^0-9a-zA-Z._-]/_/g" | sed -r "s/\[_\]\+/_/g" | sed -r "s/^_//g" | sed -r "s/_$//g" | tr -s '_'
}

###########################################################
## Terminal Functions
###########################################################
fout_print() {
    if [ ${FM_VIEW_PRINT_BUFFER_ENABLE} = true ]
    then
        local tmp_buf=""
        printf -v tmp_buf "$@"
        FM_VIEW_PRINT_BUFFER+="${tmp_buf}"
    else
        fout_flush
        printf "$@"
    fi
}

fout_flush() {
    printf "%s" "${FM_VIEW_PRINT_BUFFER}"
    FM_VIEW_PRINT_BUFFER_ENABLE=false
    FM_VIEW_PRINT_BUFFER=""
}

fout_setup() {
    # Setup the terminal for the TUI.
    # '\e[?1049h': Use alternative screen buffer.
    # '\e[?7l':    Disable line wrapping.
    # '\e[?25l':   Hide the cursor.
    # '\e[2J':     Clear the screen.
    # '\e[1;Nr':   Limit scrolling to scrolling area.
    #              Also sets cursor to (0,0).
    fout_print '\e[?1049h\e[?7l\e[?25l\e[2J\e[1;%sr' "$FM_VIEW_MAINWIN_HEIGHT"

    # Hide echoing of user input
    stty -echo
}

fout_reset() {
    # Reset the terminal to a useable state (undo all changes).
    # '\e[?7h':   Re-enable line wrapping.
    # '\e[?25h':  Unhide the cursor.
    # '\e[2J':    Clear the terminal.
    # '\e[;r':    Set the FM_DIR_SCROLL_IDX region to its default value.
    #             Also sets cursor to (0,0).
    # '\e[?1049l: Restore main screen buffer.
    fout_print '\e[?7h\e[?25h\e[;r\e[?1049l'

    # Show user input.
    stty echo
}

fout_clear() {
    # Only clear the scrolling window (dir item list).
    # '\e[%sH':    Move cursor to bottom of FM_DIR_SCROLL_IDX area.
    # '\e[9999C':  Move cursor to right edge of the terminal.
    # '\e[1J':     Clear screen to top left corner (from cursor up).
    # '\e[2J':     Clear screen fully (if using tmux) (fixes clear issues).
    # '\e[1;%sr':  Clearing the screen resets the FM_DIR_SCROLL_IDX region(?). Re-set it.
    #              Also sets cursor to (0,0).
    #        "$((FM_VIEW_HEIGHT-2))" "${TMUX:+\e[2J}" "$FM_VIEW_MAINWIN_HEIGHT"
    fout_print '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
        "$((FM_VIEW_HEIGHT))" "${TMUX:+\e[2J}" "$(($FM_VIEW_MAINWIN_HEIGHT+$FM_VIEW_TAB_LINE_HEIGHT))"
}

###########################################################
## raw draw Functions
###########################################################
fout_draw_window() {
    local def_padding=0
    #  6 Args with order
    local var_start_line=$((1 + ${FM_VIEW_TAB_LINE_HEIGHT} + ${FM_VIEW_MAINWIN_HEIGHT}))
    local var_start_col=0
    local var_width=${FM_VIEW_WIDTH}
    local var_height=${FM_VIEW_SUBWIN_BOTTOM_SIZE}
    local var_win_title="[MSG WIN]"
    local var_buffer=("${FM_VIEW_MSGWIN_BUFFER[@]}")

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
    # var_width=$((${FM_VIEW_WIDTH}/2))
    # var_height=$((${FM_VIEW_HEIGHT}/2))
    # var_start_line=$((${FM_VIEW_HEIGHT}/4))
    # var_start_col=$((${FM_VIEW_WIDTH}/4))
    ############################################################################

    # Update length, only print the latest lines. 
    if [[ ${#var_buffer[@]} -gt $((var_height - 1 - def_padding)) ]]
    then
        var_buffer=("${var_buffer[@]: -$((var_height - 1 - def_padding))}")
    else
        var_buffer=("${var_buffer[@]}")
    fi

    fout_print '\e7'

    fout_print '\e[%sH\e[%sm%*s\e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_FLOAT_WIN_LABEL}" \
           "${var_width}"
    fout_print '\e[%sH\e[%sm %s \e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_FLOAT_WIN_LABEL}" \
           "${var_win_title}"

    local var_cnt=0
    while read each_line || ((var_cnt < var_height - 1));
    do
        local var_line_buf=""
        # clean lines
        fout_print '\e[%sH\e[%sm%*s\e[m' \
            "$((var_start_line + 1 + var_cnt));${var_start_col}" \
            "${HSFM_COLOR_FLOAT_WIN}" \
            "${var_width}"

        # Draw lines
        if test -n "${each_line}"
        then
            fout_print '\e[%sH\e[%sm%s\e[m' \
                "$((var_start_line + 1 + var_cnt));${var_start_col}" \
                "${HSFM_COLOR_FLOAT_WIN}" \
                " ${each_line:0:$((var_width - 2))} "
        fi
        ((var_cnt++))
    done << EOF
$(for each_line in "${var_buffer[@]}"; do printf "${each_line}\n"; done)
EOF

    fout_print '\e8'
}

###########################################################
## L1 View
## geometry, every draw_*, message and status output. Reads; never owns model state.
###########################################################

fview_get_size() {
    # Get terminal size ('stty' is POSIX and always available).
    # This can't be done reliably across all bash versions in pure bash.
    read -r FM_VIEW_HEIGHT FM_VIEW_WIDTH < <(stty size)

    # Max list items that fit in the FM_DIR_SCROLL_IDX area.

    ## size calculation.
    local var_subwin_width=0
    local var_subwin_height=0

    if [ ${FM_VIEW_UPPERWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_height = FM_VIEW_SUBWIN_TOP_SIZE))
    fi
    if [ ${FM_VIEW_LEFTWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_width = FM_VIEW_SUBWIN_LEFT_SIZE))
    fi

    FM_VIEW_MAINWIN_START_IDX=($((1 + var_subwin_width)) $((1 + FM_VIEW_TAB_LINE_HEIGHT + var_subwin_height)) )

    if [ ${FM_VIEW_RIGHTWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_width = var_subwin_width + FM_VIEW_SUBWIN_RIGHT_SIZE))
    fi
    if [ ${FM_VIEW_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    then
        ((var_subwin_height = var_subwin_height + FM_VIEW_SUBWIN_BOTTOM_SIZE))
    fi

    ((FM_VIEW_MAINWIN_WIDTH=FM_VIEW_WIDTH - var_subwin_width))
    ((FM_VIEW_MAINWIN_HEIGHT=FM_VIEW_HEIGHT-FM_VIEW_TAB_LINE_HEIGHT-FM_VIEW_STATUS_LINE_CNT - var_subwin_height))
}

###########################################################
## Drawing Functions
###########################################################
fview_redraw() {
    # Redraw the current window.
    # If 'full' is passed, re-fetch the directory list.
    local tmp_buffer=""
    [[ $1 == full ]] && {
        fdir_read
        if [ ${FM_DIR_FLAG_RESET_IDX} = true ]
        then
            FM_DIR_SCROLL_IDX=0
            FM_DIR_CURSOR_ROW=0
            FM_DIR_FLAG_RESET_IDX=false
        fi
    }

    ## Update ENV
    # order is important, don't change it.
    # clear before redraw, avoid glict/search result incorrect.
    FM_VIEW_PRINT_BUFFER_ENABLE=true

    # Update status height
    # FIXME, don't use status cnt for calc.
    # if [ ${FM_VIEW_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_HIDDEN} ]
    #     FM_VIEW_STATUS_LINE_CNT=$((${FM_VIEW_SUBWIN_BOTTOM_SIZE} + 2))

    ## Setup Terminal Env
    fview_get_size
    fout_clear

    ## Draw left vertical win
    # TODO

    ## Draw right vertical win
    # TODO

    ## Draw upper win
    # TODO

    ## Draw bottom win
    if [ ${FM_VIEW_BOTTOMWIN_SHOW} = ${DEF_TERM_WIN_TYPE_MSG} ]
    then
        fview_draw_msgwin
    elif [ ${FM_VIEW_BOTTOMWIN_SHOW} = ${DEF_TERM_WIN_TYPE_TASK} ]
    then
        fview_draw_taskwin
    fi

    ## Draw main win
    fview_draw_dir

    ## Draw control UI
    fview_draw_tab_line
    fview_draw_status_line
    fview_draw_command_line

    fout_flush
}

fview_draw_dir() {
    # Print the max directory items that fit in the FM_DIR_SCROLL_IDX area.
    local var_scroll_new_start
    local var_win_new_cursor
    local var_scroll_len=$(($FM_VIEW_MAINWIN_HEIGHT - 1))

    # When going up the directory tree, place the cursor on the position
    # of the previous directory.
    if ((FM_DIR_FLAG_FIND_PREVIOUS == 1))
    then
        ((FM_DIR_SCROLL_IDX=FM_DIR_PREV_IDX))

        # Clear the directory history. We're here now.
        FM_DIR_FLAG_FIND_PREVIOUS=0
    fi

    # Update idx for previous store.
    if [[ ${FM_DIR_SCROLL_IDX} -ge ${#FM_DIR_FILE_LIST[@]} ]]
    then
        if [[ ${FM_VIEW_MAINWIN_HEIGHT} -gt ${#FM_DIR_FILE_LIST[@]} ]]
        then
            FM_DIR_SCROLL_IDX=$(( ${#FM_DIR_FILE_LIST[@]} -1 ))
            FM_DIR_SCROLL_START_IDX=0
            FM_DIR_CURSOR_ROW=0
        else
            FM_DIR_SCROLL_IDX=$(( ${#FM_DIR_FILE_LIST[@]} -1 ))
            FM_DIR_SCROLL_START_IDX=0
            FM_DIR_CURSOR_ROW=${FM_DIR_SCROLL_IDX}
        fi
    # elif [[ ${FM_DIR_SCROLL_IDX} -gt ${#FM_DIR_FILE_LIST[@]} ]]
    fi
    local dbg_case="0"

    # Page arithmetic. Inputs: the cursor index in the list
    # (FM_DIR_SCROLL_IDX), the first painted index
    # (FM_DIR_SCROLL_START_IDX), the stored cursor row
    # (FM_DIR_CURSOR_ROW). Outputs: var_scroll_new_start, the first
    # index to paint, and var_win_new_cursor, the row the cursor lands on.
    #
    # The branches are tested in this order, first match wins:
    #   0  cursor inside the current page                 keep the page
    #   1  cursor one row past the bottom                 scroll one row down
    #   2  cursor one row above the start                 scroll one row up
    #   3  list shorter than the window, or near the top  pin to the top
    #   4  cursor within one window of the end            pin to the bottom
    #   5  stored cursor row below the window             follow the cursor
    #   *  anything else                                  keep the cursor row
    #
    # Order of the writes below: both values are computed first, then the index,
    if ((FM_DIR_SCROLL_IDX - FM_DIR_SCROLL_START_IDX < FM_VIEW_MAINWIN_HEIGHT)) &&
        ((FM_DIR_SCROLL_IDX >= FM_DIR_SCROLL_START_IDX)); then
        # No need to update page, since it could shows all content.
        # also check if if we are going to the previous page
        ((var_scroll_new_start=FM_DIR_SCROLL_START_IDX))
        ((var_win_new_cursor=FM_DIR_SCROLL_IDX - FM_DIR_SCROLL_START_IDX))
        dbg_case="0"
    elif ((FM_DIR_SCROLL_IDX - FM_DIR_SCROLL_START_IDX == FM_VIEW_MAINWIN_HEIGHT)); then
        # One row past the bottom: shift the window by one row, the cursor
        # stays on the last visible row.
        ((var_scroll_new_start=FM_DIR_SCROLL_START_IDX + 1))
        ((var_win_new_cursor=FM_VIEW_MAINWIN_HEIGHT - 1))
        dbg_case="1"
    # elif ((FM_DIR_SCROLL_IDX - FM_DIR_SCROLL_START_IDX >= FM_VIEW_MAINWIN_HEIGHT)); then
    elif ((FM_DIR_SCROLL_IDX + 1 == FM_DIR_SCROLL_START_IDX)); then
        # One row above the top: shift the window up by one row, the cursor
        # stays on the first visible row.
        ((var_scroll_new_start=FM_DIR_SCROLL_START_IDX - 1))
        ((var_win_new_cursor=0))
        dbg_case="2"
    # This will handle other case.
    elif ((FM_DIR_LIST_CNT < FM_VIEW_MAINWIN_HEIGHT || FM_DIR_SCROLL_IDX < FM_VIEW_MAINWIN_HEIGHT)); then
        # To the top.
        # If the list in shorter then window, or the scroll idx == 0
        ((var_scroll_new_start=0))
        ((var_win_new_cursor=FM_DIR_SCROLL_IDX))
        dbg_case="3"
    elif ((FM_DIR_SCROLL_IDX + FM_VIEW_MAINWIN_HEIGHT > FM_DIR_LIST_CNT)); then
        # To the bottom.
        # If the list is greater then win size, and in the last page
        ((var_scroll_new_start=FM_DIR_LIST_CNT-FM_VIEW_MAINWIN_HEIGHT + 1))
        ((var_win_new_cursor=FM_DIR_SCROLL_IDX - var_scroll_new_start))
        dbg_case="4"
    elif ((FM_DIR_CURSOR_ROW > FM_VIEW_MAINWIN_HEIGHT - 1)); then
        # handle cursor out of showing screen.
        # its for redraw and cursor been covered.
        ((var_scroll_new_start=FM_DIR_SCROLL_IDX-FM_VIEW_MAINWIN_HEIGHT - 1))
        ((var_win_new_cursor=FM_VIEW_MAINWIN_HEIGHT - 1))
        dbg_case="5"
    else
        # This is for error handle.
        # If in the midddle of the dir list.
        ((var_scroll_new_start=FM_DIR_SCROLL_IDX-FM_DIR_CURSOR_ROW))
        ((var_win_new_cursor=FM_DIR_CURSOR_ROW))
        dbg_case="others"
    fi

    # Update Scroll index
    ((FM_DIR_SCROLL_IDX=var_win_new_cursor+var_scroll_new_start))
    ((FM_DIR_SCROLL_START_IDX=var_scroll_new_start))

    # local var_col_offset=15
    # Reset cursor position.

    # FIXME, impl current window
    # if true; then
    if false; then
        ################################################################
        # Test
        for ((idx=0;idx<=var_scroll_len;idx++)); {

            if [[ -z ${FM_DIR_FILE_LIST[$((var_scroll_new_start + idx))]} ]]; then
                break
            fi

            fview_log_debug "fview_draw_file_line $((${FM_VIEW_WIDTH}/2)) 0 80 $((var_scroll_new_start + idx))"
            fview_draw_file_line "$((var_scroll_new_start + idx))" 0 0
        }
        for ((idx=0;idx<=var_scroll_len;idx++)); {

            if [[ -z ${FM_DIR_FILE_LIST[$((var_scroll_new_start + idx))]} ]]; then
                break
            fi

            fview_log_debug "fview_draw_file_line $((${FM_VIEW_WIDTH}/2)) 0 80 $((var_scroll_new_start + idx))"
            fview_draw_file_line "$((var_scroll_new_start + idx))" $((${FM_VIEW_WIDTH} / 2)) 0 $((${FM_VIEW_WIDTH} / 2))
        }

    else
        ################################################################
        for ((idx=0;idx<=var_scroll_len;idx++)); {
            # Don't print one too many newlines.
            # if ((idx > 0))
            #     # fout_print '\n'

            if [[ -z ${FM_DIR_FILE_LIST[$((var_scroll_new_start + idx))]} ]]; then
                break
            fi

            fview_draw_file_line "$((var_scroll_new_start + idx))"
        }
    fi

    # Move the cursor to its new position if it changed.
    # If the variable 'var_win_new_cursor' is empty, the cursor
    # is moved to line '0'.
    fout_print '\e[%sH' "$(($var_win_new_cursor+1+FM_VIEW_TAB_LINE_HEIGHT))"
    ((FM_DIR_CURSOR_ROW=var_win_new_cursor))
}

fview_draw_file_line() {
    # If the dir item doesn't exist, end here.
    if [[ ${#FM_DIR_FILE_LIST[@]} -eq 0 ]] || [[ -z ${FM_DIR_FILE_LIST[$1]} ]]; then
        return
    fi
    # Format the FM_DIR_FILE_LIST item and print it.
    local var_content_idx=$1

    # args max width
    if [[ ${#} -ge 3 ]]
    then
        local args_col_offset=${2}
        local args_line_offset=${3}
    else
        local args_col_offset=${FM_VIEW_MAINWIN_START_IDX[0]}
        local args_line_offset=${FM_VIEW_MAINWIN_START_IDX[1]}
        # local args_col_offset=0
        # local args_line_offset=0
    fi

    local var_file_name=${FM_DIR_FILE_LIST[$var_content_idx]##*/}
    # local var_file_name=${FM_DIR_FILE_LIST[$var_content_idx]}
    local var_file_ext=${var_file_name##*.}
    local var_format
    local var_postfix
    local var_prefix
    # local var_file_info="$(ls -al $PWD | grep ${var_file_name}\$ | sed 's/ [^ ]\+$//')"
    local var_file_info="${FM_DIR_FILE_INFO_LIST[$var_content_idx]}"

    # Directory.
    if [[ -d "${FM_DIR_FILE_LIST[$var_content_idx]}" ]]; then
        # Check if symbolic link
        if [[ -h ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
            var_format+=\\e[${ln:-01;36}m
        else
            var_format+=\\e[${di:-1;-32}m
        fi
        var_postfix+=/

    # Symbolic Link.
    elif [[ -h ${FM_DIR_FILE_LIST[$var_content_idx]} && ! -e ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${mi:-01;31;7}m

    # Block special file.
    elif [[ -b ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${bd:-40;33;01}m

    # Character special file.
    elif [[ -c ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${cd:-40;33;01}m

    # Executable file.
    elif [[ -x ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${ex:-01;32}m

    # Symbolic Link.
    elif [[ -h ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${ln:-01;36}m

    # Fifo file.
    elif [[ -p ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${pi:-40;33}m

    # Socket file.
    elif [[ -S ${FM_DIR_FILE_LIST[$var_content_idx]} ]]; then
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

    # If the FM_DIR_FILE_LIST item is under the cursor.
    (($var_content_idx == FM_DIR_SCROLL_IDX)) &&
        var_format+="\\e[${HSFM_COLOR_CURSOR}m"

    # If the FM_DIR_FILE_LIST item is marked for operation.
    if [[ ${FM_DIR_MARKED_LIST[$var_content_idx]} == "${FM_DIR_FILE_LIST[$var_content_idx]:-null}" ]];then
        var_format+=\\e[${HSFM_COLOR_SELECTION}m${FM_VIEW_MARK_PRE}
        var_prefix=${FM_VIEW_MARK_POST}
    else
        printf -v var_prefix "% ${#FM_VIEW_MARK_POST}s" ""
    fi

    # Escape the directory string.
    # Remove all non-printable characters.
    var_file_name=${var_file_name//[^[:print:]]/^[}
    tmp_line_offset=0

    # FIXME, Its a patch, after impl visual scroll, remove the following code.
    if ((var_content_idx - FM_DIR_SCROLL_START_IDX >= FM_VIEW_MAINWIN_HEIGHT))
    then
        # to next page
        ((FM_DIR_SCROLL_START_IDX=$var_content_idx-$FM_VIEW_MAINWIN_HEIGHT+1))
        # tmp_line_offset=$((${args_line_offset}))
        tmp_line_offset=$((${args_line_offset} + ${var_content_idx} - ${FM_DIR_SCROLL_START_IDX}))
    elif ((var_content_idx < FM_DIR_SCROLL_START_IDX))
    then
        # to previous page
        ((FM_DIR_SCROLL_START_IDX=var_content_idx))
        # tmp_line_offset=$((${args_line_offset}))
        tmp_line_offset=$((${args_line_offset} + ${var_content_idx} - ${FM_DIR_SCROLL_START_IDX}))
    else
        # within page
        tmp_line_offset=$((${args_line_offset} + ${var_content_idx} - ${FM_DIR_SCROLL_START_IDX}))
    fi

    fout_print '\e[%s;%sH' "${tmp_line_offset}" "${args_col_offset}"

    local tmp_content="${var_prefix}${var_file_info} ${FM_VIEW_FILE_PRE}${var_file_name}${FM_VIEW_FILE_POST}${var_postfix}"

    local var_content_width=${FM_VIEW_MAINWIN_WIDTH}
    # This is for marking with line length
    # if (( ${#tmp_content} > ${FM_VIEW_MAINWIN_WIDTH})); then
    #     local var_content_width=${FM_VIEW_MAINWIN_WIDTH}
    #     local var_content_width=${#tmp_content}

    fout_print "%b%- ${var_content_width}s\e[m" \
        "${var_format}" \
        "${tmp_content:0:${var_content_width}}"
}

fview_draw_tab_line() {
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

    if [ ${FM_PERF_DEBUG} = true ]
    then
        fview_log_debug "Enter fview_draw_tab_line, $((var_run_tab_cnt++))"
    fi
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # Escape the directory string.
    # Remove all non-printable characters.
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"

    # FIXME, when in /, PWD return empty, so default give it /.
    VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="${PWD:-/}"
    # VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(pwd)"

    for each_idx in "${!VAR_TERM_TAB_LINE_LIST_PATH[@]}"
    do
        if ! test -d "${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}"
        then
            fview_log "Empty idx found. ${each_idx}-${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}"
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

    var_left+=" ${FM_ENV_TITLE} "

    # update buffer
    var_left_cnt="$((${#var_left} + ${#var_tab_list_pre_buf}+ ${#var_tab_selected_buf} + ${#var_tab_list_post_buf}))"
    var_right_cnt="${#var_right}"
    ((var_content_cnt=FM_VIEW_WIDTH-var_left_cnt-var_right_cnt))
    [[ ${var_content_cnt} < 0 ]] && ((${var_content_cnt}=0))
    printf -v var_spacing "% ${var_content_cnt}s" ""


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
    # '\e[H\e[K':  Clear line below fview_draw_status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.

    fout_print "\e7\e[%sH\r\e[%sm%s\e[%sm%s\e[%sm%s\e[%sm%s\e[%sm%s\e[m\e8" \
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

    fview_draw_bookmark_line
}

fview_draw_bookmark_line() {
    # bookmark bar
    local def_bookmark_start_line=2
    local tmp_bookmark_buf=""
    local tmp_cnt=0
    if [ ${FM_PERF_DEBUG} = true ]
    then
        fview_log_debug "Enter fview_draw_bookmark_line, $((var_run_bk_cnt++))"
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

    fout_print '\e7\e[%sH\e[%sm%*s\r BM |%s \e[m\e8' \
           "${def_bookmark_start_line}" \
           "${HSFM_COLOR_TAB_BOOKMARK}" \
           "${FM_VIEW_WIDTH}" "" \
           "${tmp_bookmark_buf}"

           # "1 :${HSFM_FAV1##*/} | 2:${HSFM_FAV2##*/} | 3:${HSFM_FAV3##*/} | 4:${HSFM_FAV4##*/} | 5:${HSFM_FAV5##*/} | 6:${HSFM_FAV6##*/} | 7:${HSFM_FAV7##*/} | 8:${HSFM_FAV8##*/} | 9:${HSFM_FAV9##*/}"
}

fview_draw_status_line() {
    # Status_line to print when files are marked for operation.
    local var_mark_ui="[${#FM_DIR_MARKED_LIST[@]} selected]"
    local var_left=""
    local var_center=" "
    local var_left_cnt=""
    local var_right=" "
    local var_right_cnt=""
    local var_spacing=""
    local var_content_cnt=""
    local var_pwd_escaped=""
    local var_tmp=""

    # Escape the directory string.
    # Remove all non-printable characters.
    if test -n "${FM_CMD_OPEN_FILE}" && test -f "${FM_CMD_OPEN_FILE}"
    then
        var_pwd_escaped=${FM_CMD_OPEN_FILE//[^[:print:]]/^[}
    else
        var_pwd_escaped=${PWD//[^[:print:]]/^[}
    fi

    if [ ${FM_PERF_DEBUG} = true ]
    then
        fview_log_debug "Enter fview_draw_status_line, $((var_run_status_cnt++))"
    fi

    ## Update content
    var_left=" ${FM_INPUT_MODE} "
    var_left+="${FM_DIR_MARKED_LIST[*]:+${var_mark_ui}}"
    var_center+="${1:-${var_pwd_escaped:-/}}"

    # only shows printable chars.
    if [[ ${#FM_INPUT_KEY} -ne 0 ]] && [[ "${FM_INPUT_KEY}" =~ [a-zA-Z0-9!-~] ]]; then
        printf -v var_tmp "Key %- 5s" "${FM_INPUT_KEY}"
        var_right+="${var_tmp}"
    fi

    if [[ ${#FM_CMD_SELECTION_LIST[@]} -ne 0 ]]
    then
        # var_right+="Sel: ${#FM_CMD_SELECTION_LIST[@]} "
        printf -v var_tmp "Sel %s" "${#FM_CMD_SELECTION_LIST[@]}"
        var_right+="${var_tmp}"
    fi
    # var_right+="($((FM_DIR_SCROLL_IDX + 1))/$((FM_DIR_LIST_CNT + 1))) "
    printf -v var_tmp "% 4s/%- 4s" "$((FM_DIR_SCROLL_IDX + 1))" "$((FM_DIR_LIST_CNT + 1))"
    var_right+="${var_tmp}"
    # var_right+="$(date '+%Y/%m/%d')"

    ## calc spacing
    var_left_cnt="${#var_left}"
    var_right_cnt="${#var_right}"
    var_center_cnt="${#var_center}"
    ((var_content_cnt=FM_VIEW_WIDTH-var_left_cnt-var_right_cnt))
    [[ ${var_content_cnt} < 0 ]] && var_content_cnt=0

    if ((var_content_cnt < ${var_center_cnt})); then
        var_center=${var_center:var_center_cnt-var_content_cnt:var_content_cnt}
        var_center=" ${var_center#*/}"
        var_center_cnt="${#var_center}"
    fi
    printf -v var_spacing "% $((var_content_cnt - ${var_center_cnt}))s" ""

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
    # '\e[H\e[K':  Clear line below fview_draw_status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.

    fout_print "\e7\e[%sH\r\e[%sm%s\e[%sm%s\e[%sm%s\e[m\e8" \
           "$((FM_VIEW_HEIGHT-1))" \
           "${HSFM_COLOR_STATUS_LABEL}" \
           "${var_left}" \
           "${HSFM_COLOR_STATUS}" \
           "${var_center}${var_spacing}" \
           "${HSFM_COLOR_STATUS_LABEL}" \
           "${var_right}"
}

fview_draw_command_line() {

    if [[ "${FM_ED_ACTIVE}" = "1" ]] ||
        [ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_COMMAND}" ] ||
        [ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_SEARCH}" ] ||
        [ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_FIND}" ]
    then
        fout_print '\e[?25l\e[%sH' "$FM_VIEW_HEIGHT"
        fout_print $'\r%s\e[K%s\e[?25h' "$(fedit_line)" "$(printf "\e[%dD" "$(fedit_cursor_offset)")"
    else
        fout_print '\e7\e[%sH\e[K\e[?25l\e8' "$FM_VIEW_HEIGHT"
    fi
}

# FIXME, need impl a way to acept win type, for input purpose.
fview_draw_miniwin()
{
    fview_draw_actionwin "Action WIN" "$@"
}

# its an exp miniwin.
# A message window centred on the screen.
fview_draw_actionwin()
{
    local var_win_title=$1
    shift
    local var_start_line=$((${FM_VIEW_HEIGHT}/4))
    local var_start_col=$((${FM_VIEW_WIDTH}/4))
    local var_width=$((${FM_VIEW_WIDTH}/2))
    local var_height=$((${FM_VIEW_HEIGHT}/2))

    fout_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "Action ongoing" "$@"
}

fview_draw_checkwin()
{
    fview_draw_actionwin "Check WIN" "$@"
    fview_redraw full
}

# The bottom window: one geometry, the title and buffer differ.
fview_draw_bottomwin()
{
    local var_win_title=$1
    shift
    local var_start_line=$((${FM_VIEW_MAINWIN_START_IDX[1]} + ${FM_VIEW_MAINWIN_HEIGHT}))
    local var_start_col=0
    local var_width=${FM_VIEW_WIDTH}
    local var_height=${FM_VIEW_SUBWIN_BOTTOM_SIZE}

    fout_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "$@"
}

fview_draw_msgwin()
{
    fview_draw_bottomwin "Message WIN" "${FM_VIEW_MSGWIN_BUFFER[@]}"
}

fview_draw_taskwin()
{
    fview_draw_bottomwin "Task WIN" "${FM_VIEW_TASKWIN_BUFFER[@]}"
}

fview_log_debug()
{
    # if [ ${FM_DEBUG} = true ]
    #     printf "%s\n" "$*" >> ${FM_FILE_MESSAGE}
    # printf -v FM_VIEW_MSGWIN_BUFFER "%s\n" "$*" >> ${FM_FILE_MESSAGE}
    #
    local var_max_msg_cnt=20
    if [[ ${#FM_VIEW_MSGWIN_BUFFER[@]} -gt $((var_max_msg_cnt * 2)) ]]
    then

        FM_VIEW_MSGWIN_BUFFER=("${FM_VIEW_MSGWIN_BUFFER[@]: -$var_max_msg_cnt}")
        FM_VIEW_MSGWIN_BUFFER=("${FM_VIEW_MSGWIN_BUFFER[@]}" "Drop message. Current cnt: ${#FM_VIEW_MSGWIN_BUFFER[@]}")
    else
        FM_VIEW_MSGWIN_BUFFER=("${FM_VIEW_MSGWIN_BUFFER[@]}")
    fi
    FM_VIEW_MSGWIN_BUFFER=("${FM_VIEW_MSGWIN_BUFFER[@]}" "$@")
    if [ ${FM_VIEW_BOTTOMWIN_SHOW} = ${DEF_TERM_WIN_TYPE_MSG} ]
    then
        fview_draw_msgwin
    fi
}

fview_log()
{
    fout_print '\e7\e[%sH\e[?25h' "$FM_VIEW_HEIGHT"
    fout_print '\r\e[%sH\e[?25h\e[2K%s' "$FM_VIEW_HEIGHT" "$*"
    fout_print '\e[?25l\e8'
}

###########################################################
## L2 Workspace
## directory list, tabs, marks, cursor and scroll numbers, file getters.
###########################################################

fdir_mark_toggle() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$FM_DIR_MARK_DIR" ]] &&
        FM_DIR_MARKED_LIST=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${FM_DIR_FILE_LIST[0]} == empty && -z ${FM_DIR_FILE_LIST[1]} ]] &&
        return

    if [[ $1 == all ]]; then
        if ((${#FM_DIR_MARKED_LIST[@]} != ${#FM_DIR_FILE_LIST[@]})); then
            FM_DIR_MARKED_LIST=("${FM_DIR_FILE_LIST[@]}")
            FM_DIR_MARK_DIR=$PWD
        else
            FM_DIR_MARKED_LIST=()
        fi

        fview_redraw
    else
        if [[ ${FM_DIR_MARKED_LIST[$1]} == "${FM_DIR_FILE_LIST[$1]}" ]]; then
            unset 'FM_DIR_MARKED_LIST[FM_DIR_SCROLL_IDX]'

        else
            FM_DIR_MARKED_LIST[$1]="${FM_DIR_FILE_LIST[$1]}"
            FM_DIR_MARK_DIR=$PWD
        fi

        # Clear line before changing it.
        fout_print '\e[K'
        fview_draw_file_line "$1"
    fi

    # Find the program to use.
    # case "$2" in
    #     ${HSFM_KEY_YANK:=y}|${HSFM_KEY_YANK_ALL:=Y}) FM_CMD_FILE_PROGRAM=(fselect_copy) ;;
    #     ${HSFM_KEY_CUT:=m}|${HSFM_KEY_MOVE_ALL:=M}) FM_CMD_FILE_PROGRAM=(mv -i)  ;;
    #     ${HSFM_KEY_LINK:=s}|${HSFM_KEY_LINK_ALL:=S}) FM_CMD_FILE_PROGRAM=(ln -s)  ;;
    #
    #     # These are 'hsfm' functions.
    #     ${HSFM_KEY_TRASH:=d}|${HSFM_KEY_TRASH_ALL:=D})
    #         FM_CMD_FILE_PROGRAM=(fselect_remove)
    #     ;;
    #
    #     ${HSFM_KEY_BULK_RENAME:=b}|${HSFM_KEY_BULK_RENAME_ALL:=B})
    #         FM_CMD_FILE_PROGRAM=(fselect_rename)
    #     ;;

}

fdir_mark_reset() {
    FM_DIR_MARKED_LIST=()
}

fdir_mark_add() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$FM_DIR_MARK_DIR" ]] &&
        FM_DIR_MARKED_LIST=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${FM_DIR_FILE_LIST[0]} == empty && -z ${FM_DIR_FILE_LIST[1]} ]] &&
        return

    {
        if [[ ${FM_DIR_MARKED_LIST[$1]} != "${FM_DIR_FILE_LIST[$1]}" ]]; then
            FM_DIR_MARKED_LIST[$1]="${FM_DIR_FILE_LIST[$1]}"
            FM_DIR_MARK_DIR=$PWD
        fi

        # Clear line before changing it.
        fout_print '\e[K'
        fview_draw_file_line "$1"
    }

}

fdir_mark_remove() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$FM_DIR_MARK_DIR" ]] &&
        FM_DIR_MARKED_LIST=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${FM_DIR_FILE_LIST[0]} == empty && -z ${FM_DIR_FILE_LIST[1]} ]] &&
        return

    {
        if [[ ${FM_DIR_MARKED_LIST[$1]} == "${FM_DIR_FILE_LIST[$1]}" ]]; then
            unset 'FM_DIR_MARKED_LIST[FM_DIR_SCROLL_IDX]'
        fi

        # Clear line before changing it.
        fout_print '\e[K'
        fview_draw_file_line "$1"
    }

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

# Print a listing fdir_ingest can parse. $2 sorts by the first column.
fdirsrc_ls()
{
    local var_pattern=$1
    local var_sort=$2
    local var_ls_args=(${FM_ENV_DIR_LS_ARGS[@]})

    if test -n "${HSFM_LS_SORTING}"
    then
        var_ls_args+=("${HSFM_LS_SORTING}")
    fi

    if [[ ${var_sort:-0} -eq 1 ]]
    then
        ls ${var_ls_args[@]} "${PWD}"/${var_pattern} | sort -rk1,1 2>&1
    else
        ls ${var_ls_args[@]} "${PWD}"/${var_pattern} 2>&1
    fi
}

fdirsrc_ls_sort()
{
    fdirsrc_ls "${1}" 1
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

            fview_log_debug "${var_item}"
            continue
        else
            var_line="${var_line%% ->*}"

            var_info="${var_line%% /*}"
            var_item=${var_line/#*[0-9]? \//\/}
        fi

        if [[ -d ${var_item} ]]
        then
            FM_DIR_FILE_LIST+=("${var_item}")
            FM_DIR_FILE_INFO_LIST+=("${var_info}")

            # Find the position of the child directory in the
            # parent directory list.
            [[ ${var_item} == "${OLDPWD}" ]] &&
                ((FM_DIR_PREV_IDX=var_item_index))
        else
            FM_DIR_FILE_LIST+=("${var_item}")
            FM_DIR_FILE_INFO_LIST+=("${var_info}")
        fi
        ((var_item_index++))
    done

    if [[ ${#var_denied_item_list[@]} -ge 1 ]]
    then
        FM_DIR_FILE_LIST+=("${var_denied_item_list[@]}")
        FM_DIR_FILE_INFO_LIST+=("${var_denied_info_list[@]}")
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

    var_index=$(printf '%s\n' "${FM_DIR_FILE_LIST[@]}" |
        grep -n -F -x -- "${OLDPWD}" 2>/dev/null | head -n 1 | cut -d: -f1)

    if test -z "${var_index}"
    then
        FM_DIR_PREV_IDX=0
    else
        FM_DIR_PREV_IDX=$((var_index - 1))
    fi
}

fdir_read() {
    # Read a directory to an array and sort it directories first.
    local var_pattern="*"
    local var_dirs
    local var_files
    local var_item_index=0

    local item

    FM_DIR_FILE_LIST=()
    FM_DIR_FILE_INFO_LIST=()
    # NOTE. Clear FM_DIR_FILE_LIST & use it directly to avoid FM_DIR_FILE_LIST index issue on BSD

    if [[ "${#}" -eq "1" ]]
    then
        var_pattern="*$1*"
    fi

    # Set window name.
    fout_print '\e]2;hsfm: %s\e'\\ "$PWD"

    # If '$PWD' is '/', unset it to avoid '//'.
    [[ $PWD == / ]] && PWD=

    # set flags.
    shopt_flags=(s u)
    shopt -"${shopt_flags[$HSFM_ENABLE_HIDDEN]}" dotglob

    # tmp_start=$(date +%N)
    if [[ ${HSFM_READ_DIR_MODE} == ${DEF_TERM_READ_DIR_MODE_NONE} ]]
    then
        FM_DIR_FILE_LIST=("$PWD"/${var_pattern})

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
                FM_DIR_FILE_LIST+=("$item")

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
                FM_DIR_FILE_LIST+=("$item")
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
        local var_ls_args=(${FM_ENV_DIR_LS_ARGS[@]})
        if test -n "${HSFM_LS_SORTING}"
        then
            var_ls_args+=("${HSFM_LS_SORTING}")
        fi
        # var_ls_args+=("--time-style=+%Y-%m-%d-%H:%M,")
        var_ls_args+=("--time-style=+%Y-%m-%d-%H:%M")
        var_ls_args+=("--quote-name")

        # local tmp_ls_output="$(ls ${var_ls_args[*]} ${PWD}/${var_pattern})"
        local tmp_ls_output=$(ls ${var_ls_args[*]} "${PWD}"/${var_pattern})


        # mapfile -t tmp_ls_info < <(echo "$tmp_ls_output" | cut -d ',' -f 1)
        # mapfile -t tmp_ls_file < <(echo "$tmp_ls_output" | cut -d ',' -f 2)

        # mapfile -t tmp_ls_info < <(echo "$tmp_ls_output" | cut -d ',' -f 1)
        # mapfile -t tmp_ls_file < <(echo "$tmp_ls_output" | cut -d ',' -f 2- | sed "s/^ //g" | sed "s/ -> .*$//g")

        mapfile -t tmp_ls_info < <(echo "$tmp_ls_output" | cut -d '"' -f 1 | sed "s/ $//g")
        mapfile -t tmp_ls_file < <(echo "$tmp_ls_output" | cut -d '"' -f 2 | sed "s/ -> .*$//g")

        # Debug
        # for each_item in "${tmp_ls_info[@]}";do
        #
        # for each_item in "${tmp_ls_file[@]}";do

        # if [[ "${#tmp_ls_file[@]}" -eq "1" ]]
        if ! ([[ "${#tmp_ls_file[@]}" -eq "1" ]] && [ "${tmp_ls_file[0]}" = "." ])
        then
            FM_DIR_FILE_LIST=("${tmp_ls_file[@]}")
            FM_DIR_FILE_INFO_LIST=("${tmp_ls_info[@]}")

            # Update previous index.
            fdir_prev_index
        fi

    fi
    # tmp_end=$(date +%N)

    # sort for dir first
    # FM_DIR_FILE_LIST=("${var_dirs[@]}" "${var_files[@]}")

    # Indicate that the directory is empty.
    [[ -z ${FM_DIR_FILE_LIST[0]} ]] &&
        FM_DIR_FILE_LIST[0]=empty

    ((FM_DIR_LIST_CNT=${#FM_DIR_FILE_LIST[@]}-1))

    # Save the original dir in a second FM_DIR_FILE_LIST as a backup.
    FM_DIR_BACKUP=("${FM_DIR_FILE_LIST[@]}")
}

fdir_tab_reset() {
    local var_tab_id=$1

    FM_DIR_SCROLL_START_IDX=0
    FM_DIR_SCROLL_IDX=0
    FM_DIR_CURSOR_ROW=$((FM_DIR_SCROLL_START_IDX - FM_DIR_SCROLL_IDX))
}

fdir_tab_save() {
    local var_tab_id=${1}

    VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]="${PWD}"
    FM_DIR_TAB_START_IDX[var_tab_id]="${FM_DIR_SCROLL_START_IDX}"
    FM_DIR_TAB_CURSOR_IDX[var_tab_id]="${FM_DIR_SCROLL_IDX}"
}

fdir_tab_load() {
    local var_tab_id=${1}

        # echo "${FM_DIR_FILE_INFO_LIST[@]}"
    if test -d "${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"
    then
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"

        # Read the directory again. A cached list is stale, and serializing one
        # needs a separator that a file name may contain.
        fdir_read

        FM_DIR_SCROLL_START_IDX=${FM_DIR_TAB_START_IDX[var_tab_id]}
        FM_DIR_SCROLL_IDX=${FM_DIR_TAB_CURSOR_IDX[var_tab_id]}
        FM_DIR_CURSOR_ROW=$((FM_DIR_SCROLL_START_IDX - FM_DIR_SCROLL_IDX))
    else
        cd "${HOME}"

        FM_DIR_SCROLL_START_IDX=0
        FM_DIR_SCROLL_IDX=0
        FM_DIR_CURSOR_ROW=$((FM_DIR_SCROLL_START_IDX - FM_DIR_SCROLL_IDX))
        fview_log "Folder not found. back to HOME folder. '${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}'"
    fi
}

fdir_tab_remove() {
    local var_tab_start_idx=${1}
    local each_idx

    each_idx=${var_tab_start_idx}
    while ((${each_idx} < ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}))
    do
        if ((${each_idx} + 1 <  ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}))
        then
            VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]="${VAR_TERM_TAB_LINE_LIST_PATH[$((${each_idx} + 1))]}"
            FM_DIR_TAB_START_IDX[${each_idx}]="${FM_DIR_TAB_START_IDX[$((${each_idx} + 1))]}"
            FM_DIR_TAB_CURSOR_IDX[${each_idx}]="${FM_DIR_TAB_CURSOR_IDX[$((${each_idx} + 1))]}"
        elif ((${each_idx} + 1 == ${#VAR_TERM_TAB_LINE_LIST_PATH[@]}))
        then
            tmp_remove_pattern="hsfm_removed"
            VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]=${tmp_remove_pattern}
            VAR_TERM_TAB_LINE_LIST_PATH=(${VAR_TERM_TAB_LINE_LIST_PATH[@]/${tmp_remove_pattern}})

            FM_DIR_TAB_START_IDX[${each_idx}]=${tmp_remove_pattern}
            FM_DIR_TAB_START_IDX=(${FM_DIR_TAB_START_IDX[@]/${tmp_remove_pattern}})

            FM_DIR_TAB_CURSOR_IDX[${each_idx}]=${tmp_remove_pattern}
            FM_DIR_TAB_CURSOR_IDX=(${FM_DIR_TAB_CURSOR_IDX[@]/${tmp_remove_pattern}})
            break
        fi
        ((each_idx+=1))
    done

}

fdir_tab_swap() {
    local var_tab_id_a=${1}
    local var_tab_id_b=${2}
    local tmp_path
    local tmp_start_idx
    local tmp_idx

    tmp_path=${VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_a}]}
    tmp_start_idx=${FM_DIR_TAB_START_IDX[${var_tab_id_a}]}
    tmp_idx=${FM_DIR_TAB_CURSOR_IDX[${var_tab_id_a}]}

    VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_a}]=${VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_b}]}
    FM_DIR_TAB_START_IDX[${var_tab_id_a}]=${FM_DIR_TAB_START_IDX[${var_tab_id_b}]}
    FM_DIR_TAB_CURSOR_IDX[${var_tab_id_a}]=${FM_DIR_TAB_CURSOR_IDX[${var_tab_id_b}]}

    VAR_TERM_TAB_LINE_LIST_PATH[${var_tab_id_b}]=${tmp_path}
    FM_DIR_TAB_START_IDX[${var_tab_id_b}]=${tmp_start_idx}
    FM_DIR_TAB_CURSOR_IDX[${var_tab_id_b}]=${tmp_idx}
}

fdir_mime_type() {
    # Get a file's mime_type.
    # mime_type=$(file "-${FM_ENV_FILE_ARGS:-biL}" "$1" 2>/dev/null)
    echo $(file "-${FM_ENV_FILE_ARGS:-biL}" "$*" 2>/dev/null)
}

fdir_cursor_file() {
    # echo ${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}
    printf "%s\n" "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
}

fdir_selection_file() {
    echo ${FM_CMD_SELECTION_LIST[@]}
}

###########################################################
## L3 Commands
## cmd_*, vcmd_*, file operations, fsys_open, scroll and tab actions.
## May call only fprompt_wait and fprompt_confirm in L4.
###########################################################

###########################################################
## Env Functions
###########################################################
fcmd_left_hand_mode() {
    local args_value="$1"

    if [ "${args_value}" = "on" ]
    then
        FM_LEFT_HAND_MODE=1

        # to left hande
        HSFM_KEY_CHILD1="g"
        HSFM_KEY_PARENT1="s"
        HSFM_KEY_SCROLL_DOWN1="f"
        HSFM_KEY_SCROLL_UP1="d"
    elif [ "${args_value}" = "off" ]
    then
        FM_LEFT_HAND_MODE=0

        # restore to right hand
        HSFM_KEY_CHILD1="l"
        HSFM_KEY_PARENT1="h"
        HSFM_KEY_SCROLL_DOWN1="j"
        HSFM_KEY_SCROLL_UP1="k"
    else
        fview_log "Unknown value: ${args_value}"
        return -1
    fi
    return 0
}

###########################################################
## GUI Functions
###########################################################

fnav_scroll_up() {
    # '\e[1L': Insert a line above the cursor.
    # '\e[A':  Move cursor up a line.
    if ((FM_DIR_SCROLL_IDX > 0))
    then
        FM_VIEW_PRINT_BUFFER_ENABLE=true
        ((FM_DIR_SCROLL_IDX--))

        fview_draw_file_line "$((FM_DIR_SCROLL_IDX+1))"

        if ((FM_DIR_CURSOR_ROW < 1)); then
            # Same at the top edge: repaint in place, do not clear.
            fview_draw_dir
            fview_draw_status_line
            fout_flush
            return 0
        else
            fout_print '\e[A'
            ((FM_DIR_CURSOR_ROW--))
        fi
        fview_draw_file_line $FM_DIR_SCROLL_IDX

        fout_flush
    fi
}

fnav_scroll_down() {
    if ((FM_DIR_SCROLL_IDX < FM_DIR_LIST_CNT))
    then
        FM_VIEW_PRINT_BUFFER_ENABLE=true

        ((FM_DIR_SCROLL_IDX++))

        if ((FM_DIR_CURSOR_ROW + 1 < FM_VIEW_MAINWIN_HEIGHT))
        then
            fview_draw_file_line $((FM_DIR_SCROLL_IDX-1))
            ((FM_DIR_CURSOR_ROW++))
        else
            # At the window edge: shift one row and repaint the visible rows in
            # place. A full redraw clears the screen, which flashes.
            fview_draw_dir
            fview_draw_status_line
            fout_flush
            return 0
        fi
        fview_draw_file_line $((FM_DIR_SCROLL_IDX))

        fout_flush
    fi
}

# FIXME, i dont want to seperate two simlar function for different mode
fnav_scroll_up_visual() {
    # '\e[1L': Insert a line above the cursor.
    # '\e[A':  Move cursor up a line.
    if ((FM_DIR_SCROLL_IDX > 0))
    then
        FM_VIEW_PRINT_BUFFER_ENABLE=true
        if [ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ ${FM_DIR_SCROLL_IDX} -gt ${FM_INPUT_VISUAL_START} ]]
        then
            fdir_mark_remove "$FM_DIR_SCROLL_IDX"
        fi
        ((FM_DIR_SCROLL_IDX--))

        fview_draw_file_line "$((FM_DIR_SCROLL_IDX+1))"

        if ((FM_DIR_CURSOR_ROW < 1)); then
            fout_print '\e[L'
        else
            fout_print '\e[A'
            ((FM_DIR_CURSOR_ROW--))
        fi
        fview_draw_file_line $FM_DIR_SCROLL_IDX
        if [ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ $FM_DIR_SCROLL_IDX -lt $FM_INPUT_VISUAL_START ]]
        then
            fdir_mark_add "$FM_DIR_SCROLL_IDX"
        fi
        fout_flush
    fi
}

fnav_scroll_down_visual() {
    if ((FM_DIR_SCROLL_IDX < FM_DIR_LIST_CNT))
    then
        FM_VIEW_PRINT_BUFFER_ENABLE=true

        # We need to mark on visula mode
        if [ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ ${FM_DIR_SCROLL_IDX} -lt ${FM_INPUT_VISUAL_START} ]]
        then
            fdir_mark_remove "$FM_DIR_SCROLL_IDX"
        fi
        ((FM_DIR_SCROLL_IDX++))

        fview_draw_file_line $((FM_DIR_SCROLL_IDX-1))
        fout_print "\n"

        if ((FM_DIR_CURSOR_ROW + 1 < FM_VIEW_MAINWIN_HEIGHT))
        then
            ((FM_DIR_CURSOR_ROW++))
        else
            # FIXME, it's a patch to avoid glitch
            # clear the first content line
            fview_draw_tab_line
            fout_print "\e[$((FM_VIEW_MAINWIN_HEIGHT + FM_VIEW_TAB_LINE_HEIGHT))H"
        fi

        if [ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ $FM_DIR_SCROLL_IDX -gt $FM_INPUT_VISUAL_START ]]
        then
            fdir_mark_add "$FM_DIR_SCROLL_IDX"
        else
            fview_draw_file_line $((FM_DIR_SCROLL_IDX))
        fi
        fout_flush
    fi
}

# Extend the visual selection from its anchor to $1.
fnav_scroll_edge_visual()
{
    local var_target=$1
    local var_start_idx
    local var_end_idx
    local var_tmp
    local var_idx

    if ((FM_DIR_SCROLL_IDX == var_target)); then
        return
    fi
    FM_VIEW_PRINT_BUFFER_ENABLE=true

    FM_DIR_SCROLL_IDX=${var_target}
    fdir_mark_reset

    var_start_idx=${FM_INPUT_VISUAL_START}
    var_end_idx=${FM_DIR_SCROLL_IDX}

    if ((var_start_idx > var_end_idx)); then
        var_tmp=${var_start_idx}
        var_start_idx=${var_end_idx}
        var_end_idx=${var_tmp}
    fi

    for ((var_idx=var_start_idx; var_idx<=var_end_idx; var_idx++)); do
        fdir_mark_add "$var_idx"
    done

    # Redraw to drop the marks outside the new range.
    fview_redraw
}

fnav_scroll_top_visual()
{
    fnav_scroll_edge_visual 0
}

fnav_scroll_bottom_visual()
{
    fnav_scroll_edge_visual "${FM_DIR_LIST_CNT}"
}

ftab_go_previous()
{
    local var_target=$((VAR_TERM_TAB_LINE_IDX - 1))

    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        [[ ${VAR_TERM_TAB_LINE_IDX} -eq 0 ]]
    then
        fview_log "PREVIOUS_TAB ignored."
        return
    fi

    ftab_switch "${var_target}"
    fview_log "Go PREVIOUS_TAB."
}

# Switch to tab $1, which the caller has already validated.
ftab_switch()
{
    fdir_tab_save "${VAR_TERM_TAB_LINE_IDX}"
    VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
    VAR_TERM_TAB_LINE_IDX=$1
    cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
    fdir_tab_load "${VAR_TERM_TAB_LINE_IDX}"
    fview_redraw
}

ftab_go_next()
{
    local var_target=$((VAR_TERM_TAB_LINE_IDX + 1))

    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        ((var_target == ${#VAR_TERM_TAB_LINE_LIST_PATH[@]})) ||
        ! test -d "${VAR_TERM_TAB_LINE_LIST_PATH[${var_target}]}"
    then
        fview_log "NEXT_TAB ignored."
        return
    fi

    ftab_switch "${var_target}"
    fview_log "Go NEXT_TAB"
}

ftab_move_previous()
{
    local var_target=$((VAR_TERM_TAB_LINE_IDX - 1))

    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        [[ ${VAR_TERM_TAB_LINE_IDX} -eq 0 ]]
    then
        fview_log "MOVE_PREVIOUS_TAB ignored."
        return
    fi

    ftab_swap "${var_target}"
    fview_log "Move to PREVIOUS_TAB."
}

# Swap tab $1 with the current one and follow it.
ftab_swap()
{
    fdir_tab_save "${VAR_TERM_TAB_LINE_IDX}"
    fdir_tab_swap "${VAR_TERM_TAB_LINE_IDX}" "$1"
    VAR_TERM_TAB_LINE_IDX=$1
    fview_redraw
}

ftab_move_next()
{
    local var_target=$((VAR_TERM_TAB_LINE_IDX + 1))

    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        ((var_target == ${#VAR_TERM_TAB_LINE_LIST_PATH[@]})) ||
        ! test -d "${VAR_TERM_TAB_LINE_LIST_PATH[${var_target}]}"
    then
        fview_log "MOVE_NEXT_TAB ignored."
        return
    fi

    ftab_swap "${var_target}"
    fview_log "Move to NEXT_TAB"
}

# Insert a tab after the current one. $1: 1 to also enter the selected
# directory, 0 to stay.
ftab_insert()
{
    local var_open_selected=$1
    local each_idx

    VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"

    # Shift the tabs after the current one to make room.
    ((each_idx=${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
    while ((${each_idx} > ${VAR_TERM_TAB_LINE_IDX})) && ((each_idx != VAR_TERM_TAB_LINE_IDX))
    do
        VAR_TERM_TAB_LINE_LIST_PATH[$((each_idx + 1))]="${VAR_TERM_TAB_LINE_LIST_PATH[$((each_idx))]}"
        ((each_idx-=1))
    done

    fdir_tab_save ${VAR_TERM_TAB_LINE_IDX}
    ((VAR_TERM_TAB_LINE_IDX++))

    if [[ ${var_open_selected} -eq 1 ]] &&
        test -d "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
    then
        cd "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
    fi

    fdir_tab_reset ${VAR_TERM_TAB_LINE_IDX}
    fview_redraw full
}

ftab_open()
{
    ftab_insert 1
}

ftab_duplicate()
{
    ftab_insert 0
}

ftab_close()
{
    local var_action=${1:- }
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]]
    then
        exit 0
    elif [ "${var_action}" = "right" ];then
        tmp_current_idx=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
        if (( ${VAR_TERM_TAB_LINE_IDX} + 1 >= ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} ));then
            fview_log "Ignore CLOSE_TAB_RIGHT."
            return 0
        fi

        while ((tmp_current_idx > VAR_TERM_TAB_LINE_IDX));do
            fdir_tab_remove ${tmp_current_idx}
            ((tmp_current_idx = tmp_current_idx - 1))
        done

        VAR_TERM_TAB_LINE_IDX=${tmp_current_idx}

    elif [ "${var_action}" = "left" ];then
        tmp_current_idx=$((${VAR_TERM_TAB_LINE_IDX} - 1))
        if (( VAR_TERM_TAB_LINE_IDX <= 0));then
            fview_log "Ignore CLOSE_TAB_LEFT."
            return 0
        fi
        while ((tmp_current_idx >= 0));do
            fview_log_debug "${tmp_current_idx}: ${VAR_TERM_TAB_LINE_LIST_PATH[tmp_current_idx]}"

            fdir_tab_remove ${tmp_current_idx}
            ((tmp_current_idx = tmp_current_idx - 1))
        done

        VAR_TERM_TAB_LINE_IDX=0
        # cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
        #
    elif [ "${var_action}" = "others" ];then
        tmp_current_idx=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))

        while ((tmp_current_idx >= 0));do
            if (( tmp_current_idx != VAR_TERM_TAB_LINE_IDX ));then
                fdir_tab_remove ${tmp_current_idx}
            fi
            ((tmp_current_idx = tmp_current_idx - 1))
        done

        VAR_TERM_TAB_LINE_IDX=0
        # cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
        #
    elif [ "${var_action}" = "duplicate" ];then
        tmp_current_idx=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))

        while ((tmp_current_idx >= 1));do
            local var_current_path=${VAR_TERM_TAB_LINE_LIST_PATH[${tmp_current_idx}]}
            local found_duplicate=false

            for each_idx in $(seq 0 $((tmp_current_idx - 1))); do
                local tmp_path=${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}
                if [ "${tmp_path}" = "${var_current_path}" ] ; then
                    fdir_tab_remove ${tmp_current_idx}
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

        fdir_tab_load ${VAR_TERM_TAB_LINE_IDX}
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"
    else
        fdir_tab_remove ${VAR_TERM_TAB_LINE_IDX}

        if [[ ${VAR_TERM_TAB_LINE_IDX} -ne 0 ]]
        then
            VAR_TERM_TAB_LINE_IDX=$((VAR_TERM_TAB_LINE_IDX - 1 ))
        fi

        fdir_tab_load ${VAR_TERM_TAB_LINE_IDX}
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"

    fi

    # cd "${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}"

    fview_redraw full
    fview_log "Tab closed."
}

cmd_newsearch()
{
    local var_pattern="$*"

    fdir_read "*${var_pattern}*"

    # Draw the search results on screen.
    FM_DIR_SCROLL_IDX=0
    fview_redraw

}

cmd_find()
{
    local var_pattern="$*"

    local var_read_mode=${HSFM_READ_DIR_MODE}
    # find
    HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_FIND}
    fdir_read "*${var_pattern}*"
    HSFM_READ_DIR_MODE=${var_read_mode}

    # Draw the search results on screen.
    FM_DIR_SCROLL_IDX=0
    fview_redraw
}

cmd_search()
{
    local var_pattern="$*"
    # Search on keypress if search passed as an argument.
    # '\e[?25l': Hide the cursor.
    fout_print '\e[?25l'

    fdir_read "*${var_pattern}*"
    # if [[ $HSFM_READ_DIR_MODE == 0 ]]
    #     # Use a greedy glob to search.
    #     FM_DIR_FILE_LIST=("$PWD"/*"$var_pattern"*)
    #     FM_DIR_FILE_INFO_LIST=()
    #     FM_DIR_FILE_LIST=("$PWD"/*"$var_pattern"*)
    #     FM_DIR_FILE_INFO_LIST=()

    # Draw the search results on screen.
    FM_DIR_SCROLL_IDX=0
    fview_redraw

    # '\e[%sH':  Move cursor back to cmd-line.
    # '\e[?25h': Unhide the cursor.
    fout_print '\e[%sH\e[?25h' "$FM_VIEW_HEIGHT"
}

cmd_rename()
{
    local var_new_name="$@"
    if [[ -e $var_new_name ]]; then
        fview_log "warn: '$var_new_name' already exists."

    elif [[ -w ${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]} ]]; then
        mv "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}" "${PWD}/${var_new_name}"
        fview_redraw full
    else
        fview_log "warn: no write access to file."
    fi
}

cmd_backfile()
{
    local var_original_file="${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
    local var_original_name="$(basename ${var_original_file})"
    local var_original_path="$(dirname ${var_original_file})"
    local var_timestamp=$(date +%Y%m%d_%H%M%S)
    local var_new_file="$var_original_path/backup_${var_timestamp}_${var_original_name}"

    if [[ -e $var_new_file ]]; then
        fview_log "warn: '$var_new_file' already exists."
    elif [[ -w ${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]} ]]; then
        cp "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}" "${var_new_file}"
        fview_redraw full
    else
        fview_log "warn: no write access to file."
    fi
}

# Create a directory ($1=dir) or an empty file ($1=file) named by the rest.
fcmd_create()
{
    local var_kind=$1
    shift
    local var_name="$*"

    if [[ -e "${PWD}/${var_name}" ]]
    then
        fview_log "warn: '${var_name}' already exists."
    elif [[ -w "${PWD}" ]]
    then
        case ${var_kind} in
            dir)
                mkdir -p "${PWD}/${var_name}"
                ;;
            file)
                : > "${PWD}/${var_name}"
                ;;
        esac
        fview_redraw full
    else
        fview_log "warn: no write access to dir."
    fi
}

cmd_mkdir()
{
    fcmd_create dir "$@"
}

cmd_touch()
{
    fcmd_create file "$@"
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
        fdir_cursor_file
    fi
}

cmd_editor()
{
    local var_file=$(fcmd_file_get "$*")

    if [[ -f "${var_file}" ]]; then
        fout_reset

        if command -v "${HSFM_TEXT_EDITOR%% *}" 2>&1 > /dev/null;then
            # NOTE. VIDE_SH_TITLE use on the title of xim/vim projects.
            VIDE_SH_TITLE="${FM_ENV_TITLE}" ${HSFM_TEXT_EDITOR} "${var_file}"
        else
            fview_log "warn: command '$HSFM_TEXT_EDITOR' not found"
        fi

        fout_setup
        fview_redraw
    else
        fview_log "warn: '$var_file' not opened"
    fi
}

cmd_hex()
{
    local var_file=$(fcmd_file_get "$*")

    if ! command -v xxd 2>&1 > /dev/null; then
        fview_log "warn: 'xxd' not found."
        return 1
    fi

    if [[ -f "${var_file}" ]]; then
        fout_reset

        xxd "${var_file}" |less

        fout_setup
        fview_redraw
    else
        fview_log "warn: '$var_file' not opened"
    fi
}

cmd_media()
{
    fcmd_spawn_viewer "${HSFM_MEDIA_PLAYER}" "$@"
}

# Open a file with an external viewer, detached.
fcmd_spawn_viewer()
{
    local var_viewer=$1
    shift
    local var_file=$(fcmd_file_get "$*")

    if [[ -f "${var_file}" ]]
    then
        nohup "${var_viewer}" "${var_file}" &>/dev/null &
        disown
    else
        fview_log "warn: '${var_file}' not opened"
    fi
}

cmd_image()
{
    fcmd_spawn_viewer "${HSFM_PICTURE_VIEWER}" "$@"
}

cmd_preview()
{
    local var_file=$(fcmd_file_get "$*")

    FM_VIEW_PRINT_BUFFER_ENABLE=true
    fout_clear

    fview_draw_tab_line
    fview_draw_status_line
    fout_flush

    fout_print '\e[%sH\r' "$((FM_VIEW_TAB_LINE_HEIGHT + 1))"
    if command -v "catimg" 2>&1 > /dev/null; then
        local tmp_padding=1
        local tmp_height=$((${FM_VIEW_HEIGHT} - ${tmp_padding} - ${FM_VIEW_TAB_LINE_HEIGHT} - ${FM_VIEW_STATUS_LINE_CNT}))
        local tmp_args=("")

        # FIXME, disable true color, only for preview.
        tmp_args+=("-t")

        printf "$(catimg ${tmp_args[@]} -c -H ${tmp_height} ${var_file})"
    else
        printf "catimg not found. Please install catimg.\n"
    fi

    fprompt_wait "Press Enter Key To Continue..."
    fview_redraw
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
        var_file="$(fdir_cursor_file)"
    fi

    if [ -f "${var_file}" ] ; then
        var_extrace_name=($(echo "${var_file##*/}"| fout_sanitize_name))
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
        fview_log "'${var_file}' is not a valid file!"
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
            fview_log "Unknown file type, use 7z to extract it"
            var_cmd="7z x '${var_file}'"
            ;;
    esac


    fview_draw_miniwin "Start extract files."

    fview_log "Starting extract file ${var_file}."
    fview_log_debug "Eval: ${var_cmd}"

    pushd "${tmp_extrace_path}" > /dev/null
    if ! eval "${var_cmd}" > /dev/null; then
        rm -rf "${tmp_extrace_path}"
    fi
    popd > /dev/null

    # for redraw miniwin, we must redraw.
    fview_redraw full
    if [[ -e "${tmp_extrace_path}" ]]; then
        fview_log "Extract file to '${tmp_extrace_path}'"
    else
        fview_log "Extract file fail '${tmp_extrace_path}'"
    fi
}

cmd_shell()
{
    local var_file="$@"

    fout_clear
    fout_reset

    # Add hsfm on ps1
    bash --init-file <(echo ". \"$HOME/.bashrc\"; export FM_RUNNING=1; export PS1=\"[HSFM]\$PS1\"; cd ${PWD}")

    fout_setup
    fview_redraw
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
            fview_log "Sorting Options: none/size/time/version/extension, default use none."
            return 0
            ;;
    esac
    fview_redraw full
    fview_log "Sorting: ${var_name}"
}

# Resolve a directory alias ("home", "log") to a path.
fcmd_alias_get()
{
    local var_key=$1
    local var_idx

    for var_idx in "${!FM_DIR_ALIAS_KEY[@]}"; do
        if [ "${FM_DIR_ALIAS_KEY[${var_idx}]}" = "${var_key}" ]
        then
            printf '%s\n' "${FM_DIR_ALIAS_PATH[${var_idx}]}"
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
        # NOTE. It's a patch for storing cursor position, cuse fin_handler will restore it.
        fout_print '\e7'

        fview_log "Change dir to: ${var_dir_path}"
    else
        local var_dir_alias
        if var_dir_alias=$(fcmd_alias_get "${var_dir_path}") && test -d "${var_dir_alias}"
        then
            fsys_open "${var_dir_alias}"

            # backup cursor
            # NOTE. It's a patch for storing cursor position, cuse fin_handler will restore it.
            fout_print '\e7'

            fview_log "Change dir to: '${var_dir_path}' -> '${var_dir_alias}'"
            return 0
        fi

        fview_log "${var_dir_path} not found."
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
        # NOTE. It's a patch for storing cursor position, cuse fin_handler will restore it.
        fout_print '\e7'

        fview_log "Change dir to: ${var_dir_path}"
    else
        fview_log "No dir found. ${var_dir_path}"
    fi
    return 0
}

cmd_select()
{
    fout_clear
    fview_draw_tab_line
    fout_print '\e[%sH' "$((FM_VIEW_TAB_LINE_HEIGHT + 1))"
    {
        fout_print 'Program: %s\n' "${FM_CMD_FILE_PROGRAM}"
        fout_print 'File list: %s files slected.\n' ${#FM_CMD_SELECTION_LIST[@]}
        for each_file in "${FM_CMD_SELECTION_LIST[@]}"; do
            if test -e "${each_file}"; then
                fout_print '    %s\n' "${each_file}"
            else
                fout_print '    %s => Not found.\n' "${each_file}"
            fi
        done
    }
    fview_draw_tab_line
    fview_draw_status_line
    # read -ern 1
    fprompt_wait "Press Enter Key To Continue..."
    fview_redraw
}

cmd_stat()
{
    fcmd_page "" 1 stat "$(fdir_cursor_file)"
}

# Run a command full screen and wait for Enter. $1 is the status label; $2 is 1
# to repaint the frame over the output, 0 to leave the output alone.
fcmd_page()
{
    local var_title=$1
    local var_repaint=$2
    shift 2

    fout_clear
    fview_draw_tab_line
    fview_draw_status_line "${var_title}"
    fout_print '\e[%sH' "$((FM_VIEW_TAB_LINE_HEIGHT + 1))"

    "$@"

    if [[ ${var_repaint} -eq 1 ]]
    then
        fview_draw_tab_line
        fview_draw_status_line
    fi

    fprompt_wait "Press Enter Key To Continue..."
    fview_redraw
}

cmd_disk()
{
    fcmd_page "" 1 df -h
}

cmd_dump()
{
    fout_clear
    fview_draw_tab_line
    local var_print_cnt=0
    fout_print '\e[%sH' "$((FM_VIEW_TAB_LINE_HEIGHT + 1 + var_print_cnt++))"
    ################################################################
    fout_print '\e[%sH\r## %s' "$((FM_VIEW_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_PATH"
    for each_var in ${!HSFM_PATH_@}
    do
        if [[ ${var_print_cnt} -gt ${FM_VIEW_MAINWIN_HEIGHT} ]]
        then
            break
        fi
        fout_print '\e[%sH\r    %- 24s: %s' "$((FM_VIEW_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done

    fout_print '\e[%sH\r## %s' "$((FM_VIEW_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_FILE"
    for each_var in ${!HSFM_FILE_@}
    do
        if [[ ${var_print_cnt} -gt ${FM_VIEW_MAINWIN_HEIGHT} ]]
        then
            break
        fi
        fout_print '\e[%sH\r    %- 24s: %s' "$((FM_VIEW_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done

    fout_print '\e[%sH\r## %s' "$((FM_VIEW_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_FAV"
    for each_var in ${!HSFM_FAV@}
    do
        if [[ ${var_print_cnt} -gt ${FM_VIEW_MAINWIN_HEIGHT} ]]
        then
            break
        fi
        fout_print '\e[%sH\r    %- 24s: %s' "$((FM_VIEW_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done
    ################################################################
    fview_draw_tab_line
    fview_draw_status_line
    fprompt_wait "Press Enter Key To Continue..."
    fview_redraw
}

cmd_help()
{
    fcmd_page "Help info" 0 fapp_help "$@"
}

# Show the requested bottom window, or hide it when it is already showing.
fcmd_bottomwin_toggle()
{
    if [ ${FM_VIEW_BOTTOMWIN_SHOW} != ${1} ]
    then
        FM_VIEW_BOTTOMWIN_SHOW=${1}
    else
        FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
    fi

    fview_redraw
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
        FM_DEBUG=true
    else
        FM_DEBUG=false
    fi
}

cmd_eval()
{
    local var_cmd=""
    if [[ "${#}" -eq "0" ]]
    then
        fview_log "No command specify."
        return 0
    elif ! command -v $1 2>&1 > /dev/null
    then
        fview_log "No command ${1} found."
        return 0
    fi

    fout_clear
    fview_draw_tab_line
    fout_print '\e[%sH' "$((FM_VIEW_TAB_LINE_HEIGHT + 1))"
    printf "Excute: '%s'\n" "${*}"
    printf "%s\n" "################################################################################"
    eval ${@}

    fview_draw_tab_line
    fview_draw_status_line
    fprompt_wait "Press Enter Key To Continue..."
    fview_redraw
}

cmd_title()
{
    if [[ "${#}" -ge "1" ]]
    then
        FM_ENV_TITLE="$@"
        fview_draw_tab_line
    else
        fview_log "${FM_ENV_TITLE}"
    fi
}

cmd_set()
{
    if [[ "${#}" -lt "2" ]]
    then
        fview_log "No enough args number."
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
                fview_log "Unknown value: ${args_value}"
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
                fview_log "Unknown value: ${args_value}"
                return -1
            fi
            ;;
        left)
            if ! fcmd_left_hand_mode "${args_value}"; then
                return -1
            fi
            ;;
        *)
            fview_log "Unknown variable name: ${args_variable}"
            return -1
            ;;
    esac
    fview_redraw full
    fview_log "Set ${args_variable} ${args_value}"
}

cmd_colorscheme()
{
    fapp_setup_theme $1
    fview_redraw full
}

cmd_test()
{
    # local tmp_cmd="sleep 5"
    # {
    #     eval "${tmp_cmd}"
    # } &
    fview_draw_checkwin
}

cmd_tabclose()
{
    ftab_close
}

cmd_tabcloseright()
{
    ftab_close right
}

cmd_tabcloseleft()
{
    ftab_close left
}

cmd_tabcloseothers()
{
    ftab_close others
}

cmd_tabcloseduplicate()
{
    ftab_close duplicate
}

cmd_quitngo()
{
    : "${FM_FILE_CD_LASTPATH}"

    [[ -w $FM_FILE_CD_LASTPATH ]] &&
        rm "$FM_FILE_CD_LASTPATH"

    [[ ${HSFM_CD_ON_EXIT:=1} == 1 ]] &&
        fout_print '%s\n' "$PWD" > "$FM_FILE_CD_LASTPATH"

    exit 0
}

cmd_config()
{
    local var_file="${HSFM_FILE_CONFIG}"
    fout_reset

    if command -v "${HSFM_TEXT_EDITOR%% *}" 2>&1 > /dev/null;then
        ${HSFM_TEXT_EDITOR} "${var_file}"
    elif command -v "vim" 2>&1 > /dev/null;then
        vim "${var_file}"
    elif command -v "vi" 2>&1 > /dev/null;then
        vi "${var_file}"
    elif command -v "nano" 2>&1 > /dev/null;then
        nano "${var_file}"
    else
        fview_log "warn: no editor found. editor: '$HSFM_TEXT_EDITOR'"
    fi

    fout_setup
    fview_redraw
}

cmd_exit()
{
    exit 0
}

fsys_open() {
    local var_file=""
    fview_log_debug "Open '$*'"
    if test -e "$*"; then
        var_file="${*}"
    else
        var_file="$(fdir_cursor_file)"
    fi

    # Open directories and files.
    if [[ -d "${var_file}/" ]]; then
        FM_DIR_SEARCH_ACTIVE=
        FM_DIR_SEARCH_END_EARLY=
        if test -r "${var_file:-/}"; then
            cd "${var_file:-/}" || :
            fview_log_debug "Enter $var_file"
            fview_redraw full
        else
            fview_log "Access fail on: ${var_file:-/}"
        fi

    elif [[ -f "${var_file}" ]]; then
        FM_CMD_OPEN_FILE=""
        while test -z "${FM_CMD_OPEN_FILE}"; do
            FM_CMD_OPEN_FILE="${var_file}"
            local tmp_file_type=($(fdir_mime_type "$var_file"))
            tmp_file_type=${tmp_file_type[@]}

            # cli preview
            case "${tmp_file_type}" in
                # image/*)
                #     break
                #     ;;
                text/* | *x-empty* | *json*)
                    cmd_editor "$var_file"
                    break
                    ;;
                application/zip*)
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

                # 'nohup':  Make the process immune to hangups.
                # '&':      Send it to the background.
                # 'disown': Detach it from the shell.
                if test -n "${HSFM_OPENER}" && command -v ${HSFM_OPENER%% *} >/dev/null; then
                    fview_log_debug "Open file via ${HSFM_OPENER}"
                    nohup "${HSFM_OPENER}" "$var_file" &>/dev/null &
                    disown
                    break
                fi
            fi

            fview_log "Unknown file type: '${tmp_file_type}'"
        done
    fi
    FM_CMD_OPEN_FILE=""
}

## Visual CMD Function
###########################################################
# IMPL, it's an template command function for both vcmd/cmd
vcmd_compress()
{
    # currently only take one args.
    local arg_file_name="${1:-}"
    local var_compress_cmd=""
    local var_file_ext=""
    local var_base_name=""
    local var_stem=""
    if command -v zip >/dev/null 2>&1
    then
        var_compress_cmd="zip -j"
        var_file_ext="zip"
    elif command -v "tar"
    then
        var_compress_cmd="tar -C ${PWD} -cvJf "
        var_file_ext="txz"
    else
        fview_log "No zip or tar/xz found."
        return -1
    fi

    [[ ${FM_CMD_SELECTION_LIST[*]} ]] && {
        [[ ! -w $PWD ]] && {
        fview_log "warn: no write access to dir."
            return -1
        }
        if test -z "${arg_file_name}"
        then
            if [[ ${#FM_CMD_SELECTION_LIST[@]} -eq 1 ]]
            then
                var_base_name="${FM_CMD_SELECTION_LIST[0]##*/}"
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
            fview_log "${arg_file_name} exist, skip compression."
            return 0
        fi

        local tmp_cmd="${var_compress_cmd} '${arg_file_name}' "
        for each_file in "${FM_CMD_SELECTION_LIST[@]}"
        do
            tmp_cmd+="'${each_file}' "
        done
        # tmp_cmd+="./"
        fview_log "Compress started."
        fview_log_debug "excute: ${tmp_cmd}"
        fview_draw_miniwin "Start Compress files."
        eval "${tmp_cmd}"
        if [ $? != 0 ]
        then
            fview_redraw full
            fview_log "File compression fail."
            return -1
        fi

        fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
        fview_redraw full
        fview_log "Compress finished."
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
    [[ ${FM_CMD_SELECTION_LIST[*]} ]] && {
        [[ ! -w $PWD ]] && {
            fview_log "warn: no write access to dir."
            return
        }

        local tmp_cmd="${FM_CMD_FILE_PROGRAM[@]} "
        for each_file in "${FM_CMD_SELECTION_LIST[@]}"
        do
            tmp_cmd+="'${each_file}' "
        done
        tmp_cmd+="./"

        #==========================
        {
            fview_log_debug "${FM_CMD_FILE_PROGRAM} started."
            eval "${tmp_cmd}"
            fview_log_debug "${FM_CMD_FILE_PROGRAM} finished."
        } &
        #==========================

        FM_CMD_SELECTION_LIST=()
        fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
        fout_setup
        fview_redraw full
    }
}

fselect_execute_block()
{
    [[ ${FM_CMD_SELECTION_LIST[*]} ]] && {
        [[ ! -w $PWD ]] && {
            fview_log "warn: no write access to dir."
            return
        }

        # Clear the screen to make room for a prompt if needed.

        stty echo
        local tmp_cmd="${FM_CMD_FILE_PROGRAM[@]} "
        for each_file in "${FM_CMD_SELECTION_LIST[@]}"
        do
            tmp_cmd+="'${each_file}' "
        done
        tmp_cmd+="./"
        fview_log "${FM_CMD_FILE_PROGRAM} started."
        fview_draw_miniwin "Start ${FM_CMD_FILE_PROGRAM}"
        eval "${tmp_cmd}"
        # "${FM_CMD_FILE_PROGRAM[@]}" "${FM_CMD_SELECTION_LIST[@]}" .
        stty -echo

        # FM_CMD_SELECTION_LIST=()
        fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
        fout_setup
        fview_redraw full
        fview_log "${FM_CMD_FILE_PROGRAM} finished."
    }
}

fselect_copy() {
    local flag_overwrite=false
    local flag_duplicate=false
    local var_target_folder=${@:$#}

    # FIXME, don't trash on different device/big file size
    for ((i=1;i<${#};i++)); {
        local tmp_file="${@:i:1}"
        if test -e "${tmp_file##*/}"
        then

            if [ ${flag_overwrite} = false ] && [ ${flag_duplicate} = false ]
            then
                fprompt_confirm "${tmp_file##*/} exist. Overwrite(a.all/y.yes/d.duplicate/n.no/c.cancel/s.skip)? "

                case $FM_ED_COMMIT in
                    'y'|'Y')
                        cp -R -f "${tmp_file}" "${var_target_folder}"
                        ;;
                    'c'|'C')
                        fview_log_debug "Copy Abort."
                        break
                        ;;
                    's'|'S')
                        fview_log_debug "Skip copy ${tmp_file} to $(realpath ${var_target_folder})"
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
            cp -iR "${tmp_file}" "${var_target_folder}"
        fi
        fview_log_debug "Copy: ${tmp_file} to $(realpath ${var_target_folder})"
    }
}

fselect_remove() {
    # Trash a file.
    fprompt_confirm "trash [$(($#-1))] items? [y/n]: "

    [[ $FM_ED_COMMIT != y ]] &&
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
        # cd "$HSFM_PATH_TRASH" || fview_log "error: Can't cd to trash directory."
        #
        # if cp -alf "$@" &>/dev/null; then
        #     rm -r "${@:1:$#-1}"
        #     mv -f "$@"
        #
        # # Go back to where we were.
        # cd "$OLDPWD" ||:
    fi
}

fselect_rename() {
    # Bulk rename files using '$HSFM_TEXT_EDITOR'.
    rename_file=${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/fselect_rename
    FM_DIR_MARKED_LIST=("${@:1:$#-1}")

    # Save marked files to a file and open them for editing.
    fout_print '%s\n' "${FM_DIR_MARKED_LIST[@]##*/}" > "$rename_file"
    "${HSFM_TEXT_EDITOR:-vi}" "$rename_file"

    # Read the renamed files to an array.
    IFS=$'\n' read -d "" -ra changed_files < "$rename_file"

    # If the user deleted a line, stop here.
    ((${#FM_DIR_MARKED_LIST[@]} != ${#changed_files[@]})) && {
        rm "$rename_file"
        fview_log "error: Line mismatch in rename file. Doing nothing."
        return
    }

    fout_print '%s\n%s\n' \
        "# This file will be executed when the editor is closed." \
        "# Clear the file to abort." > "$rename_file"

    # Construct the rename commands.
    for ((i=0;i<${#FM_DIR_MARKED_LIST[@]};i++)); {
        [[ ${FM_DIR_MARKED_LIST[i]} != "${PWD}/${changed_files[i]}" ]] && {
            fout_print 'mv -i -- %q %q\n' \
                "${FM_DIR_MARKED_LIST[i]}" "${PWD}/${changed_files[i]}"
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
    fout_setup
}

###########################################################
## L4 Input and modes
## key decoding, mode state machine, line editor.
###########################################################

fin_read_key() {
    # local REPLY
    read "${FM_INPUT_READ_ARGS[@]}" -srn 1
    local ret_value=$?
    if [ "${FM_INPUT_KEY_BUFFER}" != "" ]
    then
        REPLY="${FM_INPUT_KEY_BUFFER}${REPLY}"
        FM_INPUT_KEY_BUFFER=""
    fi
    if [[ ${REPLY} == $'\e' ]]
    then
        local tmp_buffer="${REPLY}"
        read "${FM_INPUT_READ_ARGS[@]}" -rsn 1

        if [[ ${tmp_buffer}${REPLY} == $'\e\e' ]]; then
            # fast esc
            REPLY=${REPLY}
            FM_INPUT_KEY="^"
            return ${ret_value}
        elif [[ ${tmp_buffer}${REPLY} == $'\e[' ]]; then
            tmp_buffer="${tmp_buffer}${REPLY}"
            read "${FM_INPUT_READ_ARGS[@]}" -rsn 1
        fi

        if [[ "${REPLY}" =~ ^-?[0-9]+$ ]]; then
            # Handle F5~F12/Home/Ins/Del/PgD/PgU.
            tmp_buffer="${tmp_buffer}${REPLY}"
            read "${FM_INPUT_READ_ARGS[@]}" -rsn 1

            if [[ "${REPLY}" = "~" ]]; then
                # tmp_buffer="${tmp_buffer}${REPLY}"
                REPLY=${tmp_buffer}${REPLY}
            else
                tmp_buffer="${tmp_buffer}${REPLY}"
                read "${FM_INPUT_READ_ARGS[@]}" -rsn 1

                REPLY=${tmp_buffer}${REPLY}
            fi

        elif [[ "${REPLY}" = 'O' ]]; then
            # Handle F1~F4
            tmp_buffer="${tmp_buffer}${REPLY}"
            read "${FM_INPUT_READ_ARGS[@]}" -rsn 1
            REPLY=${tmp_buffer}${REPLY}
        else
            REPLY=${tmp_buffer}${REPLY}
        fi

        # REPLY=${tmp_buffer}${REPLY}
        FM_INPUT_KEY="^"${REPLY:1}
    elif [[ ${ret_value} ]]
    then
        FM_INPUT_KEY="${REPLY}"
    else
        FM_INPUT_KEY=""
    fi

    # if test -n "${REPLY}"

    return ${ret_value}
}

fin_read_key_timeout() {
    local var_input_timeout=${1:-1}

    read -t ${var_input_timeout} -srn 1
    local ret_value=$?

    if [[ ${ret_value} ]]
    then
        FM_INPUT_KEY+="+${REPLY}"
    fi
    # if test -n "${REPLY}"
    return ${ret_value}
}

fin_mode_setup()
{

    case ${1} in
        "${DEF_TERM_MODE_VISUAL}")
            FM_INPUT_MODE="${DEF_TERM_MODE_VISUAL}"
            # setup visual mode
            FM_INPUT_VISUAL_START=$FM_DIR_SCROLL_IDX
            fdir_mark_add "$FM_DIR_SCROLL_IDX"
            FM_CMD_SELECTION_LIST=()
            fview_draw_command_line
            ;;
        "${DEF_TERM_MODE_SELECT}")
            FM_INPUT_MODE="${DEF_TERM_MODE_SELECT}"
            # setup selection mode
            fdir_mark_add "$FM_DIR_SCROLL_IDX"
            FM_CMD_SELECTION_LIST=()
            fview_draw_command_line
            ;;
        "${DEF_TERM_MODE_COMMAND}")
            FM_INPUT_MODE="${DEF_TERM_MODE_COMMAND}"
            fedit_begin ":" "${DEF_TERM_MODE_COMMAND}" "${DEF_ED_DRIVER_MODE}"
            fview_draw_command_line
            ;;
        "${DEF_TERM_MODE_SEARCH}")
            FM_INPUT_MODE="${DEF_TERM_MODE_SEARCH}"
            fedit_begin "/" "${DEF_TERM_MODE_SEARCH}" "${DEF_ED_DRIVER_MODE}"
            fview_draw_command_line
            ;;
        "${DEF_TERM_MODE_FIND}")
            FM_INPUT_MODE="${DEF_TERM_MODE_FIND}"
            fedit_begin "?" "${DEF_TERM_MODE_FIND}" "${DEF_ED_DRIVER_MODE}"
            fview_draw_command_line
            ;;
        *|"${DEF_TERM_MODE_NORMAL}")
            FM_INPUT_MODE="${DEF_TERM_MODE_NORMAL}"
            fdir_mark_reset
            # we don't flush command on enter normal mode, it will erase message.
            ;;
    esac
    fview_draw_status_line
}

fin_mode_normal() {

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fsys_open "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
            ;;
        # Open FM_DIR_FILE_LIST item.
        # 'C' is what bash sees when the right arrow is pressed
        # ('\e[C' or '\eOC').
        ${HSFM_KEY_CHILD1:=l} | \
            ${HSFM_KEY_CHILD2:=$'\e[C'} | \
            ${HSFM_KEY_CHILD4:=$'\eOC'})
            # only check if it's directory.
            if test -d "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"; then
                FM_DIR_FLAG_RESET_IDX=true
                fsys_open "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
            elif test -f "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"; then
                local tmp_mine=$(fdir_mime_type "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}")
                local tmp_info=$(file "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}")
                fview_log "File info(${tmp_mine%%;*}):${tmp_info##*:}"
            else
                fview_log "File access failed."
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
            if ((FM_DIR_SEARCH_ACTIVE == 1 && FM_DIR_SEARCH_END_EARLY != 1)); then
                fsys_open "$PWD"

            # If '$PWD' is '/', do nothing.
            elif [[ $PWD && $PWD != / ]]; then
                FM_DIR_FLAG_FIND_PREVIOUS=1
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
            fnav_scroll_down
            ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k} | \
            ${HSFM_KEY_SCROLL_UP2:=$'\e[A'} | \
            ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            fnav_scroll_up
            ;;

        # Go to top.
        ${HSFM_KEY_TO_TOP:=g})
            ((FM_DIR_SCROLL_IDX != 0)) && {
                FM_DIR_SCROLL_IDX=0
                fview_redraw
            }
            ;;

        # Go to bottom.
        ${HSFM_KEY_TO_BOTTOM:=G})
            ((FM_DIR_SCROLL_IDX != FM_DIR_LIST_CNT)) && {
                ((FM_DIR_SCROLL_IDX = FM_DIR_LIST_CNT))
                fview_redraw
            }
            ;;

        # Tab selcet
        ${HSFM_KEY_GO_PREVIOUS_TAB})
            ftab_go_previous
            ;;

        ${HSFM_KEY_GO_NEXT_TAB})
            ftab_go_next
            ;;
        ${HSFM_KEY_MOVE_TAB_PREVIOUS})
            ftab_move_previous
            ;;

        ${HSFM_KEY_MOVE_TAB_NEXT})
            ftab_move_next
            ;;
        ${HSFM_KEY_OPEN_TAB})
            ftab_open
            ;;
        ${HSFM_KEY_CLOSE_TAB})
            ftab_close
            ;;

        ${HSFM_KEY_VISUAL_SELECT:="V"})
            fin_mode_setup "${DEF_TERM_MODE_VISUAL}"
            ;;
        ${HSFM_KEY_SELECTION})
            fin_mode_setup "${DEF_TERM_MODE_SELECT}"
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
            fview_redraw full
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
            fview_redraw full
            fview_log "Sorting: ${var_name}.${HSFM_LS_SORTING}"
            ;;

        # Spawn a shell.
        ${HSFM_KEY_SHELL:=!})
            cmd_shell
            ;;

        # Search.
        ${HSFM_KEY_SEARCH:=/})
            fin_mode_setup "${DEF_TERM_MODE_SEARCH}"
            ;;
        "${HSFM_KEY_FIND:=?}")
            fin_mode_setup "${DEF_TERM_MODE_FIND}"
            ;;

        # FIXME, remove this fake command.
        F)
            fin_handler "${DEF_TERM_MODE_SEARCH}"

            # If the search came up empty, fview_redraw the current dir.
            if [[ -z ${FM_DIR_FILE_LIST[*]} ]]; then
                FM_DIR_FILE_LIST=("${FM_DIR_BACKUP[@]}")
                ((FM_DIR_LIST_CNT = ${#FM_DIR_FILE_LIST[@]} - 1))
                fview_redraw
                FM_DIR_SEARCH_ACTIVE=
            else
                FM_DIR_SEARCH_ACTIVE=1
            fi
            ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            fin_mode_setup "${DEF_TERM_MODE_COMMAND}"
            ;;
        # FIXME, remove this fake command.
        C)
            # FIXME, if command change cursor pos, it will be resotre to wier position
            fin_handler "${DEF_TERM_MODE_COMMAND}"
            ;;

        # Show file attributes.
        ${HSFM_KEY_ATTRIBUTES:=x})
            [[ -e "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}" ]] && {
                cmd_stat "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
            }
            ;;

        # Show help info.
        ${HSFM_KEY_HELP:=H})
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
            fview_redraw full
            fview_log "Window Refreshed."
            ;;
        ${HSFM_KEY_TOGGLE_MSGWIN})
            if [ ${FM_VIEW_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_MSG} ]
            then
                FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_MSG}
            else
                FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
            fi
            fview_redraw
            ;;
        ${HSFM_KEY_TOGGLE_TASKWIN})
            if [ ${FM_VIEW_BOTTOMWIN_SHOW} != ${DEF_TERM_WIN_TYPE_TASK} ]
            then
                FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_TASK}
            else
                FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
            fi
            fview_redraw
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
            if [[ -e "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}" ]]; then
                cmd_editor "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}"
            fi
            ;;
        ${HSFM_KEY_YANK:=y})
            FM_CMD_FILE_PROGRAM=(fselect_copy)
            FM_CMD_SELECTION_LIST=("${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}")
            fview_redraw
            fview_log "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]} yanked."
            ;;
        ${HSFM_KEY_CUT:=m})
            FM_CMD_FILE_PROGRAM=(mv -i)
            FM_CMD_SELECTION_LIST=("${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}")
            fview_redraw
            fview_log "${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]} cuted."
            ;;
        ${HSFM_KEY_TRASH:=d})
            FM_CMD_FILE_PROGRAM=(fselect_remove)
            FM_CMD_SELECTION_LIST=("${FM_DIR_FILE_LIST[FM_DIR_SCROLL_IDX]}")
            fselect_execute
            ;;
        ${HSFM_KEY_PASTE})
            fselect_execute
            ;;

        ## Second level list
        '\')
            fin_read_key_timeout 1
            case ${REPLY} in
                a)
                    fdir_mark_toggle "all"
                    fin_mode_setup "${DEF_TERM_MODE_SELECT}"
                    ;;
                d)
                    ftab_duplicate
                    ;;
            esac
            ;;
        q)
            fin_read_key_timeout 1
            case ${REPLY} in
                q)
                    ftab_close
                    ;;
                g)
                    # quit & go
                    cmd_quitngo
                    ;;
                a)
                    cmd_exit
                    ;;
            esac
            ;;
    esac
    fout_flush
}

# File-operation arm shared by the visual and selection handlers.
fin_file_op()
{
    case ${1} in
        yank)
            FM_CMD_FILE_PROGRAM=(fselect_copy)
            FM_CMD_SELECTION_LIST=("${FM_DIR_MARKED_LIST[@]}")

            FM_DIR_MARKED_LIST=()
            fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
            fview_redraw
            fview_log "${#FM_CMD_SELECTION_LIST[@]} files yanked."
            ;;
        cut)
            FM_CMD_FILE_PROGRAM=(mv -i)
            FM_CMD_SELECTION_LIST=("${FM_DIR_MARKED_LIST[@]}")

            FM_DIR_MARKED_LIST=()
            fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
            fview_redraw
            fview_log "${#FM_CMD_SELECTION_LIST[@]} files cuted."
            ;;
        trash)
            FM_CMD_FILE_PROGRAM=(fselect_remove)
            FM_CMD_SELECTION_LIST=("${FM_DIR_MARKED_LIST[@]}")

            FM_DIR_MARKED_LIST=()
            fselect_execute
            ;;
    esac
}

fin_quit()
{
    fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
    fview_redraw
}

fin_mode_visual() {

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
            ;;
        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j} | \
            ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'} | \
            ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            fnav_scroll_down_visual
            ;;
        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k} | \
            ${HSFM_KEY_SCROLL_UP2:=$'\e[A'} | \
            ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            fnav_scroll_up_visual
            ;;
        # Go to top.
        ${HSFM_KEY_TO_TOP:=g})
            fnav_scroll_top_visual
            ;;

        # Go to bottom.
        ${HSFM_KEY_TO_BOTTOM:=G})
            fnav_scroll_bottom_visual
            ;;
        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # FIXME, if command change cursor pos, it will be resotre to wier position
            FM_CMD_SELECTION_LIST=("${FM_DIR_MARKED_LIST[@]}")
            fin_handler "${DEF_TERM_MODE_COMMAND}"
            ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            fin_file_op "yank"
            ;;
        ${HSFM_KEY_CUT:=m})
            fin_file_op "cut"
            ;;
        ${HSFM_KEY_TRASH:=d})
            fin_file_op "trash"
            ;;
        q | $'\e')
            fin_quit
            ;;
    esac
}

fin_mode_select() {

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
            ;;
        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j} | \
            ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'} | \
            ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            fnav_scroll_down
            ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k} | \
            ${HSFM_KEY_SCROLL_UP2:=$'\e[A'} | \
            ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            fnav_scroll_up
            ;;
        # Go to top.
        ${HSFM_KEY_TO_TOP:=g})
            ((FM_DIR_SCROLL_IDX != 0)) && {
                FM_DIR_SCROLL_IDX=0
                fview_redraw
            }
            ;;

        # Go to bottom.
        ${HSFM_KEY_TO_BOTTOM:=G})
            ((FM_DIR_SCROLL_IDX != FM_DIR_LIST_CNT)) && {
                ((FM_DIR_SCROLL_IDX = FM_DIR_LIST_CNT))
                fview_redraw
            }
            ;;

        ${HSFM_KEY_SELECTION})
            fdir_mark_toggle "$FM_DIR_SCROLL_IDX" "$1"
            ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # FIXME, if command change cursor pos, it will be resotre to wier position
            fin_handler "${DEF_TERM_MODE_COMMAND}"
            ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            fin_file_op "yank"
            ;;
        ${HSFM_KEY_CUT:=m})
            fin_file_op "cut"
            ;;
        ${HSFM_KEY_TRASH:=d})
            fin_file_op "trash"
            ;;
        q | $'\e')
            fin_quit
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

    FM_ED_COMMIT=""
}

fedit_end()
{
    case "${FM_ED_DRIVER}" in
        "${DEF_ED_DRIVER_MODE}")
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_COMMAND}" && -z "${FM_ED_COMMIT}" ]]
            then
                fout_print '\r\e[K\e[?25l'
            fi
            fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
            ;;
        "${DEF_ED_DRIVER_PROMPT}")
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_COMMAND}" && -z "${FM_ED_COMMIT}" ]]
            then
                fout_print '\r\e[K\e[?25l\e8'
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
    if [[ ${var_count} -ge ${FM_ED_HISTORY_MAX} ]]
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

        if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" && "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_COMMAND}" ]]
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
                IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${FM_ED_CMD_LIST[*]}" ${FM_ED_BUF})
            fi
        elif [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
        then
            IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${FM_ED_VCMD_LIST[*]}" ${FM_ED_BUF})
        elif [[ "${FM_INPUT_MODE}" = "${DEF_TERM_MODE_NORMAL}" ]]
        then
            IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${FM_ED_CMD_LIST[*]}" ${FM_ED_BUF})
        else
            IFS=$'\n' read -d "" -ra var_wordlist < <(compgen -W "${FM_ED_VCMD_LIST[*]}" ${FM_ED_BUF})
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
        # Delete: drop the character under the cursor.
        $'\e[3~')
            FM_ED_POSTBUF=${FM_ED_POSTBUF:1}
            fedit_comp_reset
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
            FM_ED_COMMIT="${FM_ED_BUF}${FM_ED_POSTBUF}"
            return 1
            ;;
        $'\e')
            FM_ED_COMMIT=""
            return 2
            ;;
        $'\e'*)
            # A sequence the key decoder already handled.
            ;;
        $'\x12')
            # Ctrl-R inserts the selection, mode driver only.
            if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
            then
                fin_read_key_timeout 1
                case ${REPLY} in
                    \")
                        FM_ED_BUF+=$(fdir_selection_file)
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
    FM_ED_COMMIT="${FM_ED_BUF}${FM_ED_POSTBUF}"

    case "${FM_ED_FUNC}" in
        "${DEF_TERM_MODE_SEARCH}")
            [[ -n "${FM_ED_COMMIT}" ]] &&
                fhist_append "VAR_TERM_SEARCH_HISTORY" "${FM_ED_COMMIT}"
            fedit_end
            return 0
            ;;
        "${DEF_TERM_MODE_FIND}")
            cmd_find "${FM_ED_COMMIT}"
            [[ -n "${FM_ED_COMMIT}" ]] &&
                fhist_append "VAR_TERM_FIND_HISTORY" "${FM_ED_COMMIT}"
            fedit_end
            return 0
            ;;
    esac

    if [[ "${FM_ED_FUNC}" != "${DEF_TERM_MODE_COMMAND}" ]]
    then
        fedit_end
        return 0
    fi

    if [[ -z "${FM_ED_COMMIT}" ]]
    then
        fedit_end
        return 0
    fi

    fhist_append "VAR_TERM_CMD_HISTORY" "${FM_ED_COMMIT}"
    fedit_dispatch
    fedit_end
}

fedit_cancel()
{
    fedit_escape_drain
    FM_ED_COMMIT=""

    case "${FM_ED_DRIVER}" in
        "${DEF_ED_DRIVER_MODE}")
            fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_SEARCH}" ]]
            then
                fview_redraw full
            else
                fout_print '\r\e[K\e[?25l'
            fi
            ;;
        "${DEF_ED_DRIVER_PROMPT}")
            if [[ "${FM_ED_FUNC}" = "${DEF_TERM_MODE_SEARCH}" ]]
            then
                fview_redraw full
            else
                fout_print '\r\e[K\e[?25l\e8'
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

    if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_PROMPT}" && "${FM_INPUT_MODE}" != "${DEF_TERM_MODE_COMMAND}" ]]
    then
        var_family="vcmd_"
    fi

    FM_ED_CMD=$(echo ${FM_ED_COMMIT} | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 1)
    # The trailing space is a workaround for an argument-less command.
    FM_ED_ARGS=$(echo "${FM_ED_COMMIT} " | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 2-)

    case ${FM_ED_CMD} in
        !*)
            # '!command' runs the shell, mode driver only.
            if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
            then
                cmd_eval "${FM_ED_COMMIT#!}"
            else
                fout_print '\r\e[K Command "'${FM_ED_CMD}'" not found.\e[?25l\e8'
            fi
            ;;
        "redraw")
            fview_redraw full
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
            fview_log "${FM_ED_ARGS}"
            ;;
        *)
            if command -v ${var_family}${FM_ED_CMD} >/dev/null
            then
                ${var_family}${FM_ED_CMD} ${FM_ED_ARGS}
                # We should not clear msg, after running.
                if [[ "${FM_ED_DRIVER}" = "${DEF_ED_DRIVER_MODE}" ]]
                then
                    fout_print '\e[?25l'
                else
                    fout_print '\e[?25l\e8'
                fi
            else
                fout_print '\r\e[K Command "'${FM_ED_CMD}'" not found.\e[?25l\e8'
            fi
            ;;
    esac
}

# Driver A: one key per call, driven by fapp_core.
fin_mode_command()
{
    local var_key=$*

    fout_print '\e[?25l\e[%sH' "$FM_VIEW_HEIGHT"

    fedit_key "${var_key}"
    case $? in
        0)
            fout_print $'\r%s\e[K%s\e[?25h' "$(fedit_line)" "$(printf "\e[%dD" "$(fedit_cursor_offset)")"
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

fin_handler()
{
    ## Pre settings.
    ################################################################
    # new functon for handle all commands

    ## Main handler
    ################################################################
    case ${1} in
        "${DEF_TERM_MODE_COMMAND}")
            fin_prompt "${HSFM_KEY_OPEN_CMD}" "${DEF_TERM_MODE_COMMAND}"
            ;;
        "${DEF_TERM_MODE_SEARCH}")
            fin_prompt "${HSFM_KEY_SEARCH}" "${DEF_TERM_MODE_SEARCH}"
            fview_redraw
            ;;
    esac

    ## Post settings.
    ################################################################
    # Unset tab completion variables since we're done.
    # unset comp c

    # '\e[2K':   Clear the entire command line on finish.
    # '\e[?25l': Hide the cursor.
    # '\e8':     Restore cursor position.

    # we don't need fview_redraw after commands running
    # this will be clear after fview_redraw

}

# Driver B: owns the read loop, the prompt rendering and the input flush.
fin_prompt()
{
    local var_prompt
    local var_read_reply=""

    fedit_begin "${1}" "${2:-}" "${DEF_ED_DRIVER_PROMPT}"

    fout_print '\e7\e[%sH\e[?25h' "$FM_VIEW_HEIGHT"

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

    fin_prompt "${var_prefix}" "${var_func}"

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
## config, persistence, traps, help, fapp_core, fapp_main.
###########################################################

fapp_resize_win()
{
    fview_get_size
    fview_redraw
    # print size to prevent buffering
}

fapp_exit()
{
    FM_RUNNING=0
    fapp_save_settings
    fout_clear
    fout_reset
    fout_print "FM finished.\n"
    # exit 0
}

###########################################################
## Load/Save session
###########################################################
fapp_save_env() {
    if test -f ${FM_FILE_RUNTIME_ENV}
    then
        rm ${FM_FILE_RUNTIME_ENV}
    fi
    ## Save history
    if [[ "${#VAR_TERM_CMD_HISTORY[@]}" -ge "1" ]]
    then
        echo "#!/bin/bash" >> ${FM_FILE_RUNTIME_ENV}
        echo "export VAR_TERM_CMD_HISTORY" >> ${FM_FILE_RUNTIME_ENV}
        for each_history in "${VAR_TERM_CMD_HISTORY[@]}"
        do
            echo "VAR_TERM_CMD_HISTORY+=(\"${each_history}\")" >> ${FM_FILE_RUNTIME_ENV}
        done
    fi

    ## Save history
    if [[ "${#VAR_TERM_SEARCH_HISTORY[@]}" -ge "1" ]]
    then
        echo "export VAR_TERM_SEARCH_HISTORY" >> ${FM_FILE_RUNTIME_ENV}
        for each_history in "${VAR_TERM_SEARCH_HISTORY[@]}"
        do
            echo "VAR_TERM_SEARCH_HISTORY+=(\"${each_history}\")" >> ${FM_FILE_RUNTIME_ENV}
        done
    fi
    if [[ "${#VAR_TERM_FIND_HISTORY[@]}" -ge "1" ]]
    then
        echo "export VAR_TERM_FIND_HISTORY" >> ${FM_FILE_RUNTIME_ENV}
        for each_history in "${VAR_TERM_FIND_HISTORY[@]}"
        do
            echo "VAR_TERM_FIND_HISTORY+=(\"${each_history}\")" >> ${FM_FILE_RUNTIME_ENV}
        done
    fi

    # Save runtime env
    echo "export HSFM_COLOR_THEME=${HSFM_COLOR_THEME}" >> ${FM_FILE_RUNTIME_ENV}
    echo "export HSFM_READ_DIR_MODE=${HSFM_READ_DIR_MODE}" >> ${FM_FILE_RUNTIME_ENV}
    echo "export HSFM_LS_SORTING=${HSFM_LS_SORTING}" >> ${FM_FILE_RUNTIME_ENV}
}

fapp_save_session() {
    ## Save tab 
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]]
    then
        return 0
    fi

    if test -f ${FM_FILE_SESSION}
    then
        rm ${FM_FILE_SESSION}
    fi

    echo "#!/bin/bash" >> ${FM_FILE_SESSION}

    echo "export VAR_TERM_TAB_LINE_IDX=${VAR_TERM_TAB_LINE_IDX}" >> ${FM_FILE_SESSION}
    echo "export VAR_TERM_TAB_LINE_LIST_PATH" >> ${FM_FILE_SESSION}
    for each_tab in "${VAR_TERM_TAB_LINE_LIST_PATH[@]}"
    do
        echo "VAR_TERM_TAB_LINE_LIST_PATH+=(\"${each_tab}\")" >> ${FM_FILE_SESSION}
    done

    # The directory lists are read from disk again on restore.
    echo "cd '${PWD}'" >> ${FM_FILE_SESSION}
}

fapp_load_session() {
    if test -f ${FM_FILE_SESSION}
    then
        source ${FM_FILE_SESSION}
        fview_log_debug "Load Session Tab: ${VAR_TERM_TAB_LINE_IDX}-${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]##*/}"
    else
        # load sessio fail, start a new one.
        VAR_TERM_TAB_LINE_IDX=0
        VAR_TERM_TAB_LINE_LIST_PATH=("${PWD}")
    fi
}

fapp_load_env() {
    if test -f ${FM_FILE_RUNTIME_ENV}
    then
        source ${FM_FILE_RUNTIME_ENV}
    fi
}

fapp_save_settings() {
    fapp_save_env
    fapp_save_session
}

###########################################################
## Others
###########################################################
fapp_setup_env_cache() {
    # Setup patch env
    export FM_FILE_RUNTIME_ENV=${HSFM_PATH_CACHE}/hsfm_runtimeenv.sh
    export FM_FILE_SESSION=${HSFM_PATH_CACHE}/hsfm_session.sh
    export FM_FILE_CD_LASTPATH=${HSFM_PATH_CACHE}/hsfm_last.sh
    export FM_FILE_MESSAGE=${HSFM_PATH_CACHE}/hsfm_message.log
    export FM_FILE_LOGS=${HSFM_PATH_CACHE}/hsfm_logs.sh
}

fapp_setup_env() {
    # Figure out the current operating system to set some specific variables.
    # '$OSTYPE' typically stores the name of the OS kernel.
    case $OSTYPE in
        # Mac OS X / macOS.
        darwin*)
            HSFM_OPENER=""
            FM_ENV_FILE_ARGS=bIL

            FM_ENV_DIR_LS_ARGS=("--color=none")
            FM_ENV_DIR_LS_ARGS+=("-h -ld ")

            # FIXME, not tested.
            # FM_ENV_DIR_LS_ARGS+=("--time-style=long-iso")
            # FM_ENV_DIR_LS_ARGS+=("-quote-name")

            # Patch
            # HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_LS}
            HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_LS_SORT}

        ;;

        linux*|*)
            # HSFM_OPENER=
            FM_ENV_FILE_ARGS=biL

            FM_ENV_DIR_LS_ARGS=("--color=none")
            FM_ENV_DIR_LS_ARGS+=("--group-directories-first")
            FM_ENV_DIR_LS_ARGS+=("-h -ld ")

            # FM_ENV_DIR_LS_ARGS+=("--time-style=long-iso")
            # FM_ENV_DIR_LS_ARGS+=("--time-style=+%Y-%m-%d-%H:%M,")

            #other args
            # FM_ENV_DIR_LS_ARGS+=("-quote-name")
            # FM_ENV_DIR_LS_ARGS+=("--tabsize=8")
            # FM_ENV_DIR_LS_ARGS+=("-1")
        ;;
    esac
    fapp_setup_env_cache
}

fapp_setup_options() {

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
        FM_VIEW_FILE_PRE=${HSFM_FILE_FORMAT/'%f'*}
        FM_VIEW_FILE_POST=${HSFM_FILE_FORMAT/*'%f'}
    }

    # Format for marked files.
    # Use affixes provided by the user or use defaults, if necessary.
    if [[ $HSFM_MARK_FORMAT == *%f* ]]; then
        FM_VIEW_MARK_PRE=${HSFM_MARK_FORMAT/'%f'*}
        FM_VIEW_MARK_POST=${HSFM_MARK_FORMAT/*'%f'}
    else
        FM_VIEW_MARK_PRE=""
        FM_VIEW_MARK_POST="*"
    fi

    # Find supported 'file' arguments.
    # file -I &>/dev/null || : "${FM_ENV_FILE_ARGS:=biL}"

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

fapp_setup_shell()
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
    # causes the window to not fview_redraw on resize until the user has pressed
    # a key (causing the read to finish). This sets a read timeout on the
    # affected versions of bash.
    # NOTE: This shouldn't affect idle performance as the loop doesn't do
    # anything until a key is pressed.
    # SEE: https://github.com/dylanaraps/hsfm/issues/48
    ((BASH_VERSINFO[0] > 3)) &&
        FM_INPUT_READ_ARGS=(-t 0.05)

    ((${HSFM_LS_COLORS:=1} == 1)) &&
        fapp_export_ls_colors

    # Move to read dir to set opt.
    # ((${HSFM_ENABLE_HIDDEN:=0} == 1)) &&
    #     shopt -s dotglob

    # Create the trash and cache directory if they don't exist.
    mkdir -p "${HSFM_PATH_CACHE}"

    # 'nocaseglob': Glob case insensitively (Used for case insensitive search).
    # 'nullglob':   Don't expand non-matching globs to themselves.
    shopt -s nocaseglob nullglob

    # Trap the exit signal (we need to reset the terminal to a useable state.)
    # trap 'fout_reset' EXIT
    # trap "trap - SIGTERM && fapp_exit &&kill -- -$$" SIGINT SIGTERM EXIT
    trap "fapp_exit" SIGINT SIGTERM EXIT

    # Trap the window resize signal (handle window resize events).
    trap 'fapp_resize_win' WINCH
}

fapp_export_ls_colors() {
    # Parse the LS_COLORS variable and declare each file type
    # as a separate variable.
    # Format: ':.ext=0;0:*.jpg=0;0;0:*png=0;0;0;0:'
    [[ -z $LS_COLORS ]] && {
        HSFM_LS_COLORS=0
        fview_log_debug "LS_COLORS is empty. use default one."
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

fapp_setup_theme() {
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
        fview_log "Theme ${var_colorscheme} not found."
        return -1
    fi
    HSFM_COLOR_THEME=${var_colorscheme}
}

fapp_help_keymap() {
    fout_print "[KeyMap]\n"
    fout_print "\n%s\n" "## Movement."
    fout_print "    % -32s: %s\n"  "Go to child directory"          "${HSFM_KEY_CHILD1}, ${HSFM_KEY_CHILD2}, ${HSFM_KEY_CHILD3}"
    fout_print "    % -32s: %s\n"  "Go to parent directory"         "${HSFM_KEY_PARENT1}, ${HSFM_KEY_PARENT2}, ${HSFM_KEY_PARENT3}, ${HSFM_KEY_PARENT4}"
    fout_print "    % -32s: %s\n"  "Scroll down"                    "${HSFM_KEY_SCROLL_DOWN1}, ${HSFM_KEY_SCROLL_DOWN2}"
    fout_print "    % -32s: %s\n"  "Scroll up"                      "${HSFM_KEY_SCROLL_UP1}, ${HSFM_KEY_SCROLL_UP2}"
    fout_print "    % -32s: %s\n"  "Go to top"                      "${HSFM_KEY_TO_TOP}"
    fout_print "    % -32s: %s\n"  "Go to bottom"                   "${HSFM_KEY_TO_BOTTOM}"
    fout_print "    % -32s: %s\n"  "Go to previous directory"       "${HSFM_KEY_PREVIOUS}"
    fout_print "    % -32s: %s\n"  "Go to home"                     "${HSFM_KEY_GO_HOME}"
    fout_print "    % -32s: %s\n"  "Go to trash"                    "${HSFM_KEY_GO_TRASH}"

    fout_print "\n%s\n" "## Tab operations."
    fout_print "    % -32s: %s\n"  "Go to previous tab"             "${HSFM_KEY_GO_PREVIOUS_TAB}"
    fout_print "    % -32s: %s\n"  "Go to next tab"                 "${HSFM_KEY_GO_NEXT_TAB}"
    fout_print "    % -32s: %s\n"  "Open new tab"                   "${HSFM_KEY_OPEN_TAB}"
    fout_print "    % -32s: %s\n"  "Close current tab"              "${HSFM_KEY_CLOSE_TAB}"
    fout_print "    % -32s: %s\n"  "Move tab previous"              "${HSFM_KEY_MOVE_TAB_PREVIOUS}"
    fout_print "    % -32s: %s\n"  "Move tab next"                  "${HSFM_KEY_MOVE_TAB_NEXT}"

    fout_print "\n%s\n" "## Mode switches."
    fout_print "    % -32s: %s\n"  "Visual select mode"             "${HSFM_KEY_VISUAL_SELECT}"
    fout_print "    % -32s: %s\n"  "Selection mode"                 "${HSFM_KEY_SELECTION}"
    fout_print "    % -32s: %s\n"  "Command mode"                   "${HSFM_KEY_OPEN_CMD}"
    fout_print "    % -32s: %s\n"  "Search mode"                    "${HSFM_KEY_SEARCH}"
    fout_print "    % -32s: %s\n"  "Find mode"                      "${HSFM_KEY_FIND}"

    fout_print "\n%s\n" "## File operations."
    fout_print "    % -32s: %s\n"  "Yank (copy)"                    "${HSFM_KEY_YANK}"
    fout_print "    % -32s: %s\n"  "Cut (move)"                     "${HSFM_KEY_CUT}"
    fout_print "    % -32s: %s\n"  "Trash (delete)"                 "${HSFM_KEY_TRASH}"
    fout_print "    % -32s: %s\n"  "Paste"                          "${HSFM_KEY_PASTE}"

    fout_print "\n%s\n" "## Miscellaneous."
    fout_print "    % -32s: %s\n"  "Show file attributes"           "${HSFM_KEY_ATTRIBUTES}"
    fout_print "    % -32s: %s\n"  "Toggle hidden files"            "${HSFM_KEY_HIDDEN}"
    fout_print "    % -32s: %s\n"  "Toggle sorting"                 "${HSFM_KEY_SORTING}"
    fout_print "    % -32s: %s\n"  "Spawn a shell"                  "${HSFM_KEY_SHELL}"
    fout_print "    % -32s: %s\n"  "Show help info"                 "${HSFM_KEY_HELP}"
    fout_print "    % -32s: %s\n"  "Refresh window"                 "${HSFM_KEY_REFRESH}"
    fout_print "    % -32s: %s\n"  "Toggle message window"          "${HSFM_KEY_TOGGLE_MSGWIN}"
    fout_print "    % -32s: %s\n"  "Toggle task window"             "${HSFM_KEY_TOGGLE_TASKWIN}"
}

fapp_help_commands() {
    echo "FileManager"
    fout_print "[Options]\n"
    fout_print "    %- 16s\t%s\n" "-s|-setup   " "Copy hsfm config file."
    fout_print "    %- 16s\t%s\n" "-d|--debug  " "Enable debug flag."
    fout_print "    %- 16s\t%s\n" "--cache-path" "Specify cache path."
    fout_print "    %- 16s\t%s\n" "-n|--new" "Open new session session."
    fout_print "    %- 16s\t%s\n" "-l|--last   " "Print last path & remove the last path file."
    fout_print "    %- 16s\t%s\n" "--history   " "Store history."
    fout_print "[Commands]\n"
    fout_print "    % -16s: %s\n"  "redraw" "Redraws the current window."
    fout_print "    % -16s: %s\n"  "help" "Shows help information. Accepts 'key' or 'map' for keybindings."
    fout_print "    % -16s: %s\n"  "exit" "Exits the file manager."
    fout_print "    % -16s: %s\n"  "shell" "Spawns a new shell."
    fout_print "    % -16s: %s\n"  "cd" "Changes the current directory."
    fout_print "    % -16s: %s\n"  "reenter" "Re-enters the current directory."
    fout_print "    % -16s: %s\n"  "colorscheme" "Changes the color scheme (e.g., 'black', 'color')."
    fout_print "    % -16s: %s\n"  "set" "Sets various options (e.g., 'set read fast', 'set hidden on')."
    fout_print "    % -16s: %s\n"  "title" "Sets the window title."
    fout_print "    % -16s: %s\n"  "config" "Opens the configuration file in the default editor."
    fout_print "    % -16s: %s\n"  "debug" "Toggles debug mode ('on'/'off')."
    fout_print "    % -16s: %s\n"  "select" "Shows selected files."
    fout_print "    % -16s: %s\n"  "stat" "Displays file attributes for the current file."
    fout_print "    % -16s: %s\n"  "eval" "Evaluates a shell command."
    fout_print "    % -16s: %s\n"  "dump" "Dumps HSFM environment variables."
    fout_print "    % -16s: %s\n"  "test" "Runs a test function."
    fout_print "    % -16s: %s\n"  "task" "Toggles the task window."
    fout_print "    % -16s: %s\n"  "msg" "Toggles the message window."
    fout_print "    % -16s: %s\n"  "mkdir" "Creates a new directory."
    fout_print "    % -16s: %s\n"  "touch" "Creates a new empty file."
    fout_print "    % -16s: %s\n"  "rename" "Renames the current file."
    fout_print "    % -16s: %s\n"  "search" "Searches for files in the current directory."
    fout_print "    % -16s: %s\n"  "find" "Finds files recursively from the current directory."
    fout_print "    % -16s: %s\n"  "sort" "Sorts files by 'none', 'size', 'time', 'version', or 'extension'."
    fout_print "    % -16s: %s\n"  "backfile" "Creates a backup of the current file."
    fout_print "    % -16s: %s\n"  "quitngo" "Quits and changes to the current directory in the parent shell."
    fout_print "    % -16s: %s\n"  "tabclose" "Closes the current tab."
    fout_print "    % -16s: %s\n"  "tabcloseright" "Closes tabs to the right of the current tab."
    fout_print "    % -16s: %s\n"  "tabcloseleft" "Closes tabs to the left of the current tab."
    fout_print "    % -16s: %s\n"  "tabcloseothers" "Closes all other tabs except the current one."
    fout_print "    % -16s: %s\n"  "tabcloseduplicate" "Closes duplicate tabs."
    fout_print "    % -16s: %s\n"  "open" "Opens the current file with the default opener."
    fout_print "    % -16s: %s\n"  "editor" "Opens the current file in the default text editor."
    fout_print "    % -16s: %s\n"  "vim" "Opens the current file in Vim."
    fout_print "    % -16s: %s\n"  "hex" "Opens the current file in a hex viewer (xxd)."
    fout_print "    % -16s: %s\n"  "media" "Opens the current file in the default media player."
    fout_print "    % -16s: %s\n"  "play" "Opens the current file in the default media player."
    fout_print "    % -16s: %s\n"  "image" "Opens the current file in the default image viewer."
    fout_print "    % -16s: %s\n"  "preview" "Previews the current file (requires catimg for images)."
    fout_print "    % -16s: %s\n"  "unzip" "Extracts a zip archive."
    fout_print "    % -16s: %s\n"  "extract" "Extracts various archive types."
    fout_print "    % -16s: %s\n"  "disk" "Displays disk usage information."

    fout_print "\n%s\n" "## Selection Commands."
    fout_print "    % -16s: %s\n"  "compress" "Compresses selected files."

    fout_print "\n%s\n" "## TODO Function."
    fout_print "    %s\n"  "The following functions are under construction."
    fout_print "    %s\n"  "#. Background task & task manager."
}

fapp_help() {
    local help_type=$1
    if [ "${help_type}" = "key" ] || [ "${help_type}" = "map" ]
    then
        fapp_help_keymap $@
    else
        fapp_help_commands $@
    fi
}

# '--verbose' diagnostics. fapp_main calls them before the UI exists, so they write
# to stderr.
fapp_info()
{
    printf '%s\n' "hsfm: verbose mode" >&2
}

fapp_err_control()
{
    printf '%s\n' "hsfm: ${1:-?}:${2:-?}" >&2
}

## Core Function
###########################################################
function fapp_core() {
    # restore runtime env.
    fapp_load_env

    fapp_setup_env
    fapp_setup_options
    fapp_setup_shell
    fapp_setup_theme "${HSFM_COLOR_THEME}"

    fview_get_size
    fout_setup
    fview_redraw full

    fview_log_debug "HSFM initialized."

    FM_RUNNING=1
    # Vintage infinite loop.
    for ((;FM_RUNNING;)); {
        # read "${FM_INPUT_READ_ARGS[@]}" -srn 1 && {
        fin_read_key && {
            case ${FM_INPUT_MODE} in
                "${DEF_TERM_MODE_VISUAL}")
                    fin_mode_visual "$REPLY"
                    ;;
                "${DEF_TERM_MODE_SELECT}")
                    fin_mode_select "$REPLY"
                    ;;
                "${DEF_TERM_MODE_COMMAND}"|"${DEF_TERM_MODE_SEARCH}"|"${DEF_TERM_MODE_FIND}")
                    fin_mode_command "$REPLY"
                    ;;
                *|"${DEF_TERM_MODE_NORMAL}")
                    fin_mode_normal "$REPLY"
                    ;;
                esac
                # FIXME, temporailly disable draw status line during keytyping.
                # Discard following input
                # read -t 0 -rsn 10000 _
            }

        # Exit if there is no longer a terminal attached.
        [[ -t 1 ]] || exit 1
    }
}

## Main Functions
###########################################################
function fapp_main()
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
                    if test -f "${FM_FILE_CD_LASTPATH}"
                    then
                        cat ${FM_FILE_CD_LASTPATH}

                        if [[ "$2" = "flush" ]]
                        then
                            rm ${FM_FILE_CD_LASTPATH}
                        fi
                    else
                        exit 1
                    fi
                else
                    # Don't print to stdio, some will use it for cd.
                    if cat ${FM_FILE_CD_LASTPATH} 2> /dev/null
                    then
                        exit 0
                    else
                        exit 1
                    fi
                fi
                exit 0

                ;;
            -d|--debug)
                FM_DEBUG=true
                ;;
            --history)
                # Store file name in a file on open instead of using 'HSFM_OPENER'.
                # Used in 'hsfm.vim'.
                FM_FILE_PICKER=1
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
                    fapp_setup_env_cache
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
                fapp_help
                exit 0
                ;;
            *)
                if test -d "$*"; then
                    var_new_path="$(realpath ${*})"
                else
                    echo "Unknown Options: ${1}"
                    fapp_help
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
        fapp_info; fapp_err_control ${FUNCNAME[0]} ${LINENO}
    fi

    if [[ $FM_RUNNING = 1 ]]
    then
        echo "HSFM is running. Status: $FM_RUNNING"
        exit 1
    fi

    if [ "${flag_load_session}" = "true" ]
    then
        fapp_load_session
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
            fview_log_debug "${each_idx}: ${tmp_path}, ${new_abs_path}"
            if [ "${tmp_path}" = "${new_abs_path}" ] ; then
                VAR_TERM_TAB_LINE_IDX=${each_idx}
                flash_found_tab=true
                # break
            fi
        done

        if [ ${flash_found_tab} = false ]
        then
            fview_log_debug "Open$(pwd), ${var_new_path}"
            # cd ${var_new_path}
            # TODO, use api for create new page?
            VAR_TERM_TAB_LINE_LIST_PATH+=("${var_new_path}")
            # 0 base idx.
            VAR_TERM_TAB_LINE_IDX=$((${#VAR_TERM_TAB_LINE_LIST_PATH[@]} - 1))
            cd ${var_new_path}
        fi
    fi


    if [[ $FM_DEBUG = true ]]
    then
        # Record stderr
        fapp_core 2> >(tee ${FM_FILE_LOGS} >&2)
    else
        fapp_core
    fi
}

# Sourceable: only run when executed, not when sourced by the test harness.
[[ "${BASH_SOURCE[0]}" == "$0" ]] && fapp_main "$@"
