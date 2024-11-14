#!/usr/bin/env bash
export PATH_SCRIPT_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"
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

# 0: system mode.
# 1: ls mode.
# 3: find mode.
export HSFM_READ_DIR_MODE=1

## Env
# this is only work on run time.
export HSFM_ENV_LEFT_HAND_MODE=0

## TERMINAL Vars Options
###########################################################
# Terminal Atrib
export VAR_TERM_READ_FLAGS=()

## Terminal UI control
export VAR_TERM_WIN_CURRENT_CURSOR=0
export VAR_TERM_STATUS_LINE_CNT=2
export VAR_TERM_TAB_LINE_HEIGHT=2
export VAR_TERM_LINE_CNT=0
export VAR_TERM_COLUMN_CNT=0

export VAR_TERM_CONTENT_MAX_CNT=0
export VAR_TERM_CONTENT_SCROLL_IDX=0
export VAR_TERM_CONTENT_SCROLL_START_IDX=0

export VAR_TERM_DIR_LIST_CNT=0
export VAR_TERM_DIR_FILE_LIST=()
export VAR_TERM_DIR_FILE_INFO_LIST=()

export VAR_TERM_DIR_LS_ARGS=()
export VAR_TERM_FILE_ARGS=""

# Buffer
export VAR_TERM_PRINT_BUFFER_ENABLE=false
export VAR_TERM_PRINT_BUFFER=""
export VAR_TERM_KEY_CURRENT_INPUT=""
# export VAR_TERM_KEY_PREVIOUS_INPUT=""
# export VAR_TERM_KEY_SECOND_LEVE_KEY_LIST=("q")

# Marks
export VAR_TERM_FILE_PRE=""
export VAR_TERM_FILE_POST=""
export VAR_TERM_MARK_PRE=""
export VAR_TERM_MARK_POST=""

## Tab Line
export VAR_TERM_TAB_LINE_IDX=0
export VAR_TERM_TAB_LINE_BUFFER=""
export VAR_TERM_TAB_LINE_LIST_PATH
export VAR_TERM_TAB_LINE_LIST_START_IDX
export VAR_TERM_TAB_LINE_LIST_IDX

## Flags
export VAR_TERM_FLAG_FIND_PREVIOUS=0
export VAR_TERM_FLAG_RESET_IDX=false

## Status Line
export VAR_TERM_MARKED_FILE_LIST=()
export VAR_TERM_MARK_DIR=""
export VAR_TERM_SELECTION_FILE_LIST=()
export VAR_TERM_FILE_PROGRAM=()

## Windows
# log win
export VAR_TERM_MSGWIN_SHOW=false
export VAR_TERM_MSGWIN_BUFFER=()
export VAR_TERM_MSGWIN_SCROLL_IDX=""
export VAR_TERM_MSGWIN_HEIGHT="12"

# log win
export VAR_TERM_TASKWIN_SHOW=false
export VAR_TERM_TASKWIN_BUFFER=("Main task running.")
export VAR_TERM_TASKWIN_SCROLL_IDX=""
export VAR_TERM_TASKWIN_HEIGHT="12"

# Cmd line
export VAR_TERM_CMD_HISTORY_MAX=100
export VAR_TERM_CMD_HISTORY
export VAR_TERM_SEARCH_HISTORY
export VAR_TERM_FIND_HISTORY

export VAR_TERM_CMD_INPUT_BUFFER=""
export VAR_TERM_CMD_LIST=( "redraw" "help" "exit" "shell" "cd" )
VAR_TERM_CMD_LIST+=( "set" "title" )
VAR_TERM_CMD_LIST+=( "debug" "select" "stat" "eval" "dump" "test")
VAR_TERM_CMD_LIST+=( "mkdir" "touch" "rename" "search" "find" "sort" )
VAR_TERM_CMD_LIST+=( "quit" "tab" "quitngo")
VAR_TERM_CMD_LIST+=( "open" "editor" "vim" "media" "play" "image" "preview" "unzip" "extract")

export VAR_TERM_SELECT_CMD_LIST=( "compress" )
# VAR_TERM_SELECT_CMD_LIST+=( "copy" "remove" "paste" )

# Mode
export DEF_TERM_MODE_NORMAL='normal'
export DEF_TERM_MODE_VISUAL='visual'
export DEF_TERM_MODE_SELECT='select'
export DEF_TERM_MODE_SEARCH='search'
export DEF_TERM_MODE_FIND='find'
export DEF_TERM_MODE_COMMAND='command'

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
# Cursor color [0\-9]
export HSFM_COLOR_CURSOR=37

# Selection color [0\-9] (copied/moved files)
export HSFM_COLOR_SELECTION=100

# Title
export HSFM_COLOR_TITLE_FG=30
export HSFM_COLOR_TITLE_BG=104

# tab bar
export HSFM_COLOR_TAB_FG=97
export HSFM_COLOR_TAB_BG=100
export HSFM_COLOR_TAB_SELECTION_FG=30
export HSFM_COLOR_TAB_SELECTION_BG=43
export HSFM_COLOR_TAB_LEBEL_FG=30
export HSFM_COLOR_TAB_LEBEL_BG=43

# bookmark bar
export HSFM_COLOR_TAB_BOOKMARK_FG=97
export HSFM_COLOR_TAB_BOOKMARK_BG=40

# Status bar
export HSFM_COLOR_STATUS_FG=97
export HSFM_COLOR_STATUS_BG=100
export HSFM_COLOR_STATUS_LABEL_FG=30
export HSFM_COLOR_STATUS_LABEL_BG=43

## HSFM ENV
###########################################################
export HSFM_ENV_TITLE="HSFM"

# Text Editor
export EDITOR="vim"
export HSFM_MEDIA_PLAYER="vlc"
export HSFM_PICTURE_VIEWER="firefox"

# File Opener
export HSFM_OPENER="xdg\-open"

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
export HSFM_FAV1=~
export HSFM_FAV2=~/tools
export HSFM_FAV3=~/lab
export HSFM_FAV4=~/projects
export HSFM_FAV5=~/workspace
export HSFM_FAV6=~/documents
export HSFM_FAV7=~/downloads
export HSFM_FAV8=~/media
export HSFM_FAV9=${HSFM_PATH_CACHE}

# Dir alias
# FIXME, only work on command cd
declare -A HSFM_DIR_ALIAS
HSFM_DIR_ALIAS["home"]="${HOME}"
HSFM_DIR_ALIAS["log"]="/var/log"

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
# a: alph, t:time
export HSFM_LS_SORTING=""
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
export HSFM_KEY_YANK="y"
export HSFM_KEY_CUT="x"
export HSFM_KEY_TRASH="d"
export HSFM_KEY_PASTE="p"

# Mode switch
export HSFM_KEY_VISUAL_SELECT="V"
export HSFM_KEY_SELECTION="s"

###########################################################
## Source file
###########################################################
# source ${PATH_SCRIPT_ROOT}/winmgr.sh

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
    fterminal_print '\e[?1049h\e[?7l\e[?25l\e[2J\e[1;%sr' "$VAR_TERM_CONTENT_MAX_CNT"

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
    #        "$((VAR_TERM_LINE_CNT-2))" "${TMUX:+\e[2J}" "$VAR_TERM_CONTENT_MAX_CNT"
    fterminal_print '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
        "$((VAR_TERM_LINE_CNT))" "${TMUX:+\e[2J}" "$(($VAR_TERM_CONTENT_MAX_CNT+$VAR_TERM_TAB_LINE_HEIGHT))"
}

fterminal_get_size() {
    # Get terminal size ('stty' is POSIX and always available).
    # This can't be done reliably across all bash versions in pure bash.
    read -r VAR_TERM_LINE_CNT VAR_TERM_COLUMN_CNT < <(stty size)

    # Max list items that fit in the VAR_TERM_CONTENT_SCROLL_IDX area.
    # ((VAR_TERM_CONTENT_MAX_CNT=VAR_TERM_LINE_CNT-3))
    ((VAR_TERM_CONTENT_MAX_CNT=VAR_TERM_LINE_CNT-VAR_TERM_TAB_LINE_HEIGHT-VAR_TERM_STATUS_LINE_CNT))
}
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
## raw draw Functions
###########################################################
fterminal_draw_window() {
    #  6 Args with order
    local var_start_line=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + ${VAR_TERM_CONTENT_MAX_CNT}))
    local var_start_col=0
    local var_width=${VAR_TERM_COLUMN_CNT}
    local var_height=${VAR_TERM_MSGWIN_HEIGHT}
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
    # var_width=$((${VAR_TERM_COLUMN_CNT}/2))
    # var_height=$((${VAR_TERM_LINE_CNT}/2))
    # var_start_line=$((${VAR_TERM_LINE_CNT}/4))
    # var_start_col=$((${VAR_TERM_COLUMN_CNT}/4))
    # flog_msg "ORI WH: ${VAR_TERM_LINE_CNT}/${VAR_TERM_COLUMN_CNT}, WH: ${var_width}/${var_height}, POS: ${var_start_line}/${var_start_col}"
    ############################################################################

    # Update length, only print the latest lines. 
    if [[ ${#var_buffer[@]} -gt $((var_height - 1)) ]]
    then
        var_buffer=("${var_buffer[@]: -$((var_height - 1))}")
    else
        var_buffer=("${var_buffer[@]}")
    fi

    fterminal_print '\e7'

    fterminal_print '\e[%sH\e[%sm%*s\e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
           "${var_width}"
    fterminal_print '\e[%sH\e[%sm %s \e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
           "${var_win_title}"

    local var_content_max=$((var_height - 1))
    local var_cnt=0
    while read each_line || ((var_cnt < var_height - 1));
    do
        local var_line_buf=""
        # clean lines
        fterminal_print '\e[%sH\e[%sm%*s\e[m' \
            "$((var_start_line + 1 + var_cnt));${var_start_col}" \
            "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
            "${var_width}"

        # Draw lines
        if test -n "${each_line}"
        then
            fterminal_print '\e[%sH\e[%sm%s\e[m' \
                "$((var_start_line + 1 + var_cnt));${var_start_col}" \
                "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
                " ${each_line:0:$((var_width - 2))} "
        fi
        ((var_cnt++))
    done << EOF
$(for each_line in "${var_buffer[@]}"; do printf "${each_line}\n"; done)
EOF

    fterminal_print '\e8'
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
    if [ ${VAR_TERM_MSGWIN_SHOW} = true ]
    then
        VAR_TERM_STATUS_LINE_CNT=$((${VAR_TERM_MSGWIN_HEIGHT} + 2))
    elif [ ${VAR_TERM_TASKWIN_SHOW} = true ]
    then
        VAR_TERM_STATUS_LINE_CNT=$((${VAR_TERM_TASKWIN_HEIGHT} + 2))
    else
        VAR_TERM_STATUS_LINE_CNT=2
    fi
    fterminal_get_size

    ## Do redraw
    fterminal_clear
    fterminal_draw_dir
    fterminal_draw_tab_line
    fterminal_draw_status_line
    fterminal_draw_command_line
    if [ ${VAR_TERM_MSGWIN_SHOW} = true ]
    then
        fterminal_draw_msgwin
    elif [ ${VAR_TERM_TASKWIN_SHOW} = true ]
    then
        fterminal_draw_taskwin
    fi

    fterminal_flush
}
fterminal_draw_dir() {
    # Print the max directory items that fit in the VAR_TERM_CONTENT_SCROLL_IDX area.
    local var_scroll_new_start
    local var_win_new_cursor
    local var_scroll_len=$(($VAR_TERM_CONTENT_MAX_CNT - 1))
    local var_scroll_distance=$(($VAR_TERM_CONTENT_MAX_CNT - 3))

    # When going up the directory tree, place the cursor on the position
    # of the previous directory.
    if ((VAR_TERM_FLAG_FIND_PREVIOUS == 1))
    then
        ((VAR_TERM_CONTENT_SCROLL_IDX=previous_index))
        # ((VAR_TERM_CONTENT_SCROLL_START_IDX=previous_index))

        # Clear the directory history. We're here now.
        VAR_TERM_FLAG_FIND_PREVIOUS=0
    fi

    # Update idx for previous store.
    if [[ ${VAR_TERM_CONTENT_SCROLL_IDX} -ge ${#VAR_TERM_DIR_FILE_LIST[@]} ]]
    then
        if [[ ${VAR_TERM_CONTENT_MAX_CNT} -gt ${#VAR_TERM_DIR_FILE_LIST[@]} ]]
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
    # local dbg_case="0"

    # Update scroll idx
    # FIXME, i assume this is for turning page
    if ((VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX < VAR_TERM_CONTENT_MAX_CNT)) && 
        ((VAR_TERM_CONTENT_SCROLL_IDX >= VAR_TERM_CONTENT_SCROLL_START_IDX)); then
        # No need to update page, sine it could shows all content.
        # also check if if we are going to the previous page
        ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_START_IDX))
        ((var_win_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX))
        # dbg_case="0"
    elif ((VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX == VAR_TERM_CONTENT_MAX_CNT)); then
        # Go to next page, add one for conveint
        ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_START_IDX + var_scroll_distance + 1))
        ((var_win_new_cursor=VAR_TERM_WIN_CURRENT_CURSOR-var_scroll_distance))
        # dbg_case="1"
    # elif ((VAR_TERM_CONTENT_SCROLL_IDX - VAR_TERM_CONTENT_SCROLL_START_IDX >= VAR_TERM_CONTENT_MAX_CNT)); then
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
        # dbg_case="2"
    # This will handle other case.
    elif ((VAR_TERM_DIR_LIST_CNT < VAR_TERM_CONTENT_MAX_CNT || VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_CONTENT_MAX_CNT)); then
        # If the list in shorter then window, or the scroll idx == 0
        ((var_scroll_new_start=0))
        ((var_win_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX))
        # flog_msg "1/$var_scroll_new_start/$var_win_new_cursor"
        # dbg_case="3"
    elif ((VAR_TERM_CONTENT_SCROLL_IDX + VAR_TERM_CONTENT_MAX_CNT > VAR_TERM_DIR_LIST_CNT)); then
        # If the list is greater then win size, and in the last page
        ((var_scroll_new_start=VAR_TERM_DIR_LIST_CNT-VAR_TERM_CONTENT_MAX_CNT + 1))
        ((var_win_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX - var_scroll_new_start))
        # flog_msg "2/$var_scroll_new_start/$var_win_new_cursor"
        # dbg_case="4"
    else
        # If in the midddle of the dir list.
        ((var_scroll_new_start=VAR_TERM_CONTENT_SCROLL_IDX-VAR_TERM_WIN_CURRENT_CURSOR))
        ((var_win_new_cursor=VAR_TERM_WIN_CURRENT_CURSOR))
        # flog_msg "else/$var_scroll_new_start/$var_win_new_cursor"
        # dbg_case="5"
    fi

    # Update Scroll index
    ((VAR_TERM_CONTENT_SCROLL_IDX=var_win_new_cursor+var_scroll_new_start))
    ((VAR_TERM_CONTENT_SCROLL_START_IDX=var_scroll_new_start))
    # flog_msg_debug "dbg case ${dbg_case}: ${VAR_TERM_CONTENT_SCROLL_IDX}/${VAR_TERM_CONTENT_SCROLL_START_IDX}/${previous_index}"

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

            flog_msg_debug "fterminal_draw_file_line $((${VAR_TERM_COLUMN_CNT}/2)) 0 80 $((var_scroll_new_start + idx))"
            # fterminal_draw_file_line "$((${VAR_TERM_COLUMN_CNT}/2))" 0 80 "$((var_scroll_new_start + idx))"
            # fterminal_draw_file_line 80 0 80 "$((var_scroll_new_start + idx))"
            fterminal_draw_file_line "$((var_scroll_new_start + idx))" 0 0 $((${VAR_TERM_COLUMN_CNT} / 2))
        }
        for ((idx=0;idx<=var_scroll_len;idx++)); {

            if [[ -z ${VAR_TERM_DIR_FILE_LIST[$((var_scroll_new_start + idx))]} ]]; then
                break
            fi

            flog_msg_debug "fterminal_draw_file_line $((${VAR_TERM_COLUMN_CNT}/2)) 0 80 $((var_scroll_new_start + idx))"
            # fterminal_draw_file_line "$((${VAR_TERM_COLUMN_CNT}/2))" 0 80 "$((var_scroll_new_start + idx))"
            # fterminal_draw_file_line 80 0 80 "$((var_scroll_new_start + idx))"
            fterminal_draw_file_line "$((var_scroll_new_start + idx))" $((${VAR_TERM_COLUMN_CNT} / 2)) 0 $((${VAR_TERM_COLUMN_CNT} / 2))
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
    if [[ -z ${VAR_TERM_DIR_FILE_LIST[$1]} ]]; then
        return
    fi
    # Format the VAR_TERM_DIR_FILE_LIST item and print it.
    local var_content_idx=$1

    # args max width
    if [[ ${#} -ge 4 ]]
    then
        local args_col_offset=${2}
        local args_line_offset=${3}
        local args_content_width=${4}
    else
        local args_col_offset=0
        local args_line_offset=0
        local args_content_width=${VAR_TERM_COLUMN_CNT}
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
        var_format+=\\e[${di:-1;-32}m
        var_postfix+=/

    # Block special file.
    elif [[ -b ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${bd:-40;33;01}m

    # Character special file.
    elif [[ -c ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${cd:-40;33;01}m

    # Executable file.
    elif [[ -x ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${ex:-01;32}m

    # Symbolic Link (broken).
    elif [[ -h ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} && ! -e ${VAR_TERM_DIR_FILE_LIST[$var_content_idx]} ]]; then
        var_format+=\\e[${mi:-01;31;7}m

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
        var_format+="\\e[1;${HSFM_COLOR_CURSOR:-36};7m"

    # If the VAR_TERM_DIR_FILE_LIST item is marked for operation.
    [[ ${VAR_TERM_MARKED_FILE_LIST[$var_content_idx]} == "${VAR_TERM_DIR_FILE_LIST[$var_content_idx]:-null}" ]] && {
        var_format+=\\e[${HSFM_COLOR_SELECTION}m${VAR_TERM_MARK_PRE}
        var_prefix+=${VAR_TERM_MARK_POST}
    }

    # Escape the directory string.
    # Remove all non-printable characters.
    var_file_name=${var_file_name//[^[:print:]]/^[}

    if ((var_content_idx - VAR_TERM_CONTENT_SCROLL_START_IDX >= VAR_TERM_CONTENT_MAX_CNT))
    then
        ((VAR_TERM_CONTENT_SCROLL_START_IDX=$var_content_idx-$VAR_TERM_CONTENT_MAX_CNT+1))
        args_line_offset=$((${VAR_TERM_TAB_LINE_HEIGHT} + ${VAR_TERM_CONTENT_MAX_CNT}))
    elif ((var_content_idx < VAR_TERM_CONTENT_SCROLL_START_IDX))
    then
        ((VAR_TERM_CONTENT_SCROLL_START_IDX=var_content_idx))
        args_line_offset=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT}))
    else
        args_line_offset=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + ${var_content_idx} - ${VAR_TERM_CONTENT_SCROLL_START_IDX}))
    fi

    fterminal_print '\e[%s;%sH' "${args_line_offset}" "${args_col_offset}"

    # fterminal_print '%b%s\e[m\e[K\r' \
    #     " ${VAR_TERM_FILE_PRE}${var_format}" \
    #     "${var_file_info} ${var_prefix}${var_file_name}${var_postfix}${VAR_TERM_FILE_POST}"

    local tmp_content="${VAR_TERM_FILE_PRE}${var_file_info} ${var_prefix}${var_file_name}${var_postfix}${VAR_TERM_FILE_POST}"
    fterminal_print "%b%- ${args_content_width}s\e[m" \
        "${var_format}" \
        "${tmp_content:0:${args_content_width}}"
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
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # Escape the directory string.
    # Remove all non-printable characters.
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
    VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="${PWD}"

    for each_idx in "${!VAR_TERM_TAB_LINE_LIST_PATH[@]}"
    do
        if ! test -d "${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]}"
        then
            continue
        fi
        if [ "${VAR_TERM_TAB_LINE_IDX}" = "${each_idx}" ]
        then
            var_tab_selected_buf=" ${each_idx} ${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]##*/} "
            var_right=" $((${each_idx} + 1))/${#VAR_TERM_TAB_LINE_LIST_PATH[@]} "
        elif [[ "${VAR_TERM_TAB_LINE_IDX}" -gt "${each_idx}" ]]
        then
            var_tab_list_pre_buf=${var_tab_list_pre_buf}" ${each_idx} ${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]##*/} ${var_tab_seperator}"
        else
            var_tab_list_post_buf=${var_tab_list_post_buf}"${var_tab_seperator} ${each_idx} ${VAR_TERM_TAB_LINE_LIST_PATH[${each_idx}]##*/} "
        fi
    done

    var_left+=" ${HSFM_ENV_TITLE} "

    # update buffer
    var_left_cnt="$((${#var_left} + ${#var_tab_list_pre_buf}+ ${#var_tab_selected_buf} + ${#var_tab_list_post_buf}))"
    var_right_cnt="${#var_right}"
    ((var_content_cnt=VAR_TERM_COLUMN_CNT-var_left_cnt-var_right_cnt))
    [[ ${var_content_cnt} < 0 ]] && ((${var_content_cnt}=0))
    # flog_msg "test-> ${var_content_cnt}/$VAR_TERM_COLUMN_CNT"
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
           "${HSFM_COLOR_TITLE_FG:-30};${HSFM_COLOR_TITLE_BG:-41}" \
           "${var_left}" \
           "${HSFM_COLOR_TAB_FG:-30};${HSFM_COLOR_TAB_BG:-41}" \
           "${var_tab_list_pre_buf}" \
           "${HSFM_COLOR_TAB_SELECTION_FG:-30};${HSFM_COLOR_TAB_SELECTION_BG:-41}" \
           "${var_tab_selected_buf}" \
           "${HSFM_COLOR_TAB_FG:-30};${HSFM_COLOR_TAB_BG:-41}" \
           "${var_tab_list_post_buf}${var_spacing}" \
           "${HSFM_COLOR_TAB_LEBEL_FG:-30};${HSFM_COLOR_TAB_LEBEL_BG:-41}" \
           "${var_right}"

    fterminal_draw_bookmark_line
}
fterminal_draw_bookmark_line() {
    # bookmark bar
    local def_bookmark_start_line=2
    local tmp_bookmark_buf=""
    local tmp_cnt=1
    if [ ${HSFM_PERFORMANCE_DEBUG} = true ]
    then
        flog_msg_debug "Enter fterminal_draw_bookmark_line, $((var_run_bk_cnt++))"
    fi
    for each_fav in "${!HSFM_FAV@}"
    do
        if test -n "${!each_fav}"
        then
            tmp_bookmark_buf+=" ${tmp_cnt}: ${!each_fav##*/} |"
        fi
        ((tmp_cnt++))
    done

    fterminal_print '\e7\e[%sH\e[%s;%sm%*s\rBM |%s \e[m\e8' \
           "${def_bookmark_start_line}" \
           "${HSFM_COLOR_TAB_BOOKMARK_FG}" \
           "${HSFM_COLOR_TAB_BOOKMARK_BG}" \
           "${VAR_TERM_COLUMN_CNT}" "" \
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

    # Escape the directory string.
    # Remove all non-printable characters.
    local var_pwd_escaped=${PWD//[^[:print:]]/^[}
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
    var_left_cnt="$((${#var_left} + ${#var_center}))"
    var_right_cnt="${#var_right}"
    ((var_content_cnt=VAR_TERM_COLUMN_CNT-var_left_cnt-var_right_cnt))
    [[ ${var_content_cnt} < 0 ]] && ((${var_content_cnt}=0))
    # flog_msg "test-> ${var_content_cnt}/$VAR_TERM_COLUMN_CNT"
    var_spacing=$(printf "% ${var_content_cnt}s" "")

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

    # fterminal_print "\e7\e[%sH\e[%s;%sm%*s\r%s%s%s\e[m\e[%sH\e[K\e8" \
    #        "$((VAR_TERM_LINE_CNT-1))" \
    #        "${HSFM_COLOR_STATUS_FG:-30}" \
    #        "${HSFM_COLOR_STATUS_BG:-41}" \
    #        "$VAR_TERM_COLUMN_CNT" "" \
    #        "${var_left}" \
    #        "${var_spacing}" \
    #        "${var_right}" \
    #        "$VAR_TERM_LINE_CNT"

    # fterminal_print "\e7\e[%sH\e[%s;%sm%*s\r%s%s%s\e[m\e8" \
    #        "$((VAR_TERM_LINE_CNT-1))" \
    #        "${HSFM_COLOR_STATUS_FG:-30}" \
    #        "${HSFM_COLOR_STATUS_BG:-41}" \
    #        "$VAR_TERM_COLUMN_CNT" "" \
    #        "${var_left}" \
    #        "${var_spacing}" \
    #        "${var_right}"

    fterminal_print "\e7\e[%sH\r\e[%sm%s\e[%sm%s\e[%sm%s\e[m\e8" \
           "$((VAR_TERM_LINE_CNT-1))" \
           "${HSFM_COLOR_STATUS_LABEL_FG:-30};${HSFM_COLOR_STATUS_LABEL_BG:-41}" \
           "${var_left}" \
           "${HSFM_COLOR_STATUS_FG:-30};${HSFM_COLOR_STATUS_BG:-41}" \
           "${var_center}${var_spacing}" \
           "${HSFM_COLOR_STATUS_LABEL_FG:-30};${HSFM_COLOR_STATUS_LABEL_BG:-41}" \
           "${var_right}"
}

fterminal_draw_command_line() {

    if [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_COMMAND}" ] ||
        [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_SEARCH}" ] ||
        [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_FIND}" ]
    then
        fterminal_print '\e[?25l\e[%sH' "$VAR_TERM_LINE_CNT"

        # fterminal_print $'\r\e[K'"${var_cmd_prefix}${var_input_buffer}${var_post_input_buffer} $(printf "\e[%dD" $((${#var_post_input_buffer} + 1)))"
        fterminal_print $'\r'"${var_cmd_prefix}${var_input_buffer}${var_post_input_buffer} "$'\e[K'"$(printf "\e[%dD" $((${#var_post_input_buffer} + 1)))"$'\e[?25h'
    else
        fterminal_print '\e7\e[%sH\e[K\e[?25l\e8' "$VAR_TERM_LINE_CNT"
    fi
}

# FIXME, need impl a way to acept win type, for input purpose.
fterminal_draw_miniwin()
{
    local var_start_line=$((${VAR_TERM_LINE_CNT}/4))
    local var_start_col=$((${VAR_TERM_COLUMN_CNT}/4))
    local var_width=$((${VAR_TERM_COLUMN_CNT}/2))
    local var_height=$((${VAR_TERM_LINE_CNT}/2))
    local var_win_title="Action WIN"
    local var_buffer=()
    var_buffer+=("Action ongoing")
    var_buffer+=("$@")

    fterminal_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "${var_buffer[@]}"
}
# its an exp miniwin.
fterminal_draw_checkwin() {

    local var_start_line=$((${VAR_TERM_LINE_CNT}/4))
    local var_start_col=$((${VAR_TERM_COLUMN_CNT}/4))
    local var_width=$((${VAR_TERM_COLUMN_CNT}/2))
    local var_height=$((${VAR_TERM_LINE_CNT}/2))
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
    local var_start_line=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + ${VAR_TERM_CONTENT_MAX_CNT}))
    local var_start_col=0
    local var_width=${VAR_TERM_COLUMN_CNT}
    local var_height=${VAR_TERM_MSGWIN_HEIGHT}
    local var_win_title="Message WIN"
    local var_buffer=("${VAR_TERM_MSGWIN_BUFFER[@]}")

    fterminal_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "${var_buffer[@]}"
}
fterminal_draw_taskwin()
{
    local var_start_line=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + ${VAR_TERM_CONTENT_MAX_CNT}))
    local var_start_col=0
    local var_width=${VAR_TERM_COLUMN_CNT}
    local var_height=${VAR_TERM_MSGWIN_HEIGHT}
    local var_win_title="Task WIN"
    local var_buffer=("${VAR_TERM_TASKWIN_BUFFER[@]}")

    fterminal_draw_window ${var_start_line} ${var_start_col} ${var_width} ${var_height} "${var_win_title}" "${var_buffer[@]}"
}

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
fterminal_read_dir() {
    # Read a directory to an array and sort it directories first.
    local var_pattern="*"
    local var_dirs
    local var_files
    local var_item_index=0

    local tmp_file_list=()
    local tmp_file_info_list=()

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

    if [[ $HSFM_READ_DIR_MODE == 0 ]]
    then
        # for some reason, we should sort in seperate loop.
        # sort for dir first
        for item in "$PWD"/*; do
            if [[ -d $item ]]; then
                var_dirs+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")

            # Find the position of the child directory in the
            # parent directory list.
            [[ $item == "$OLDPWD" ]] &&
                ((previous_index=var_item_index))
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
    elif [[ $HSFM_READ_DIR_MODE == 3 ]]
    then
        local var_find_args=("")

        # for each_line in "$(ls -al ${PWD}/)";
        while read each_line;
        do
            local item
            local info

            if ! [[ "${each_line}" =~ / ]]
            then
                continue
            fi
            if [[ ${each_line} =~ ^ls:* ]]
            then
                # Access fail
                each_line="${each_line/: Permission denied/}"
                each_line="${each_line/cannot access /}"

                info="Permission denied"
                # item=${each_line/#*[0-9]? \//\/}
                item=${each_line/*: /}
                item=${item//\'/}

                tmp_file_list+=("$item")
                tmp_file_info_list+=("$info")

                flog_msg_debug "${item}"
                continue
            else
                each_line="${each_line%% ->*}"

                info="${each_line%% /*}"
                item=${each_line/#*[0-9]? \//\/}
            fi


            if [[ -d $item ]]; then
                # var_dirs+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
                VAR_TERM_DIR_FILE_INFO_LIST+=("$info")

                # Find the position of the child directory in the
                # parent directory list.
                [[ $item == "$OLDPWD" ]] &&
                    ((previous_index=var_item_index))
            elif [[ -f $item ]]; then
                # var_files+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
                VAR_TERM_DIR_FILE_INFO_LIST+=("$info")
            else
                # debug
                # var_files+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
                VAR_TERM_DIR_FILE_INFO_LIST+=("$info")
            fi
            ((var_item_index++))
        done << EOF
$(timeout 10 find "${PWD}" ${var_find_args[@]} -name "${var_pattern}" 2>&1)
EOF
    else
        local var_ls_args=(${VAR_TERM_DIR_LS_ARGS[@]})
        if test -n "${HSFM_LS_SORTING}"
        then
            var_ls_args+=("${HSFM_LS_SORTING}")
        fi

        # for each_line in "$(ls -al ${PWD}/)";
        while read each_line;
        do
            local item
            local info

            if ! [[ "${each_line}" =~ / ]]
            then
                continue
            fi
            if [[ ${each_line} =~ ^ls:* ]]
            then
                # Access fail
                each_line="${each_line/: Permission denied/}"
                each_line="${each_line/cannot access /}"

                info="Permission denied"
                # item=${each_line/#*[0-9]? \//\/}
                item=${each_line/*: /}
                item=${item//\'/}

                tmp_file_list+=("$item")
                tmp_file_info_list+=("$info")

                flog_msg_debug "${item}"
                continue
            else
                each_line="${each_line%% ->*}"

                info="${each_line%% /*}"
                item=${each_line/#*[0-9]? \//\/}
            fi


            if [[ -d $item ]]; then
                # var_dirs+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
                VAR_TERM_DIR_FILE_INFO_LIST+=("$info")

                # Find the position of the child directory in the
                # parent directory list.
                [[ $item == "$OLDPWD" ]] &&
                    ((previous_index=var_item_index))
            elif [[ -f $item ]]; then
                # var_files+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
                VAR_TERM_DIR_FILE_INFO_LIST+=("$info")
            else
                # debug
                # var_files+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
                VAR_TERM_DIR_FILE_INFO_LIST+=("$info")
            fi
            ((var_item_index++))
        done << EOF
$(ls ${var_ls_args[@]} "${PWD}"/${var_pattern} 2>&1)
EOF
    fi

    if [[ ${#tmp_file_list[@]} -ge 1 ]]
    then
        VAR_TERM_DIR_FILE_LIST+=("${tmp_file_list[@]}")
        VAR_TERM_DIR_FILE_INFO_LIST+=("${tmp_file_info_list[@]}")
    fi

    # sort for dir first
    # VAR_TERM_DIR_FILE_LIST=("${var_dirs[@]}" "${var_files[@]}")

    # Indicate that the directory is empty.
    [[ -z ${VAR_TERM_DIR_FILE_LIST[0]} ]] &&
        VAR_TERM_DIR_FILE_LIST[0]=empty

    ((VAR_TERM_DIR_LIST_CNT=${#VAR_TERM_DIR_FILE_LIST[@]}-1))

    # Save the original dir in a second VAR_TERM_DIR_FILE_LIST as a backup.
    cur_list=("${VAR_TERM_DIR_FILE_LIST[@]}")
}

fterminal_read_key() {
    # local REPLY
    read "${VAR_TERM_READ_FLAGS[@]}" -srn 1
    local ret_value=$?
    if [[ ${REPLY} == $'\e' ]]
    then
        local tmp_buffer="${REPLY}"
        read "${VAR_TERM_READ_FLAGS[@]}" -rsn 1

        if [[ ${tmp_buffer}${REPLY} == $'\e\e' ]]; then
            # fast esc
            REPLY=${REPLY}
            VAR_TERM_KEY_CURRENT_INPUT="^"
            return ${ret_value}
        elif [[ ${tmp_buffer}${REPLY} == $'\e[' ]]; then
            tmp_buffer="${tmp_buffer}${REPLY}"
            read "${VAR_TERM_READ_FLAGS[@]}" -rsn 3
        fi

        # read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2

        # Handle a normal escape key press.
        # [[ ${tmp_buffer}${REPLY} == $'\e\e['* ]] &&
        #     read "${VAR_TERM_READ_FLAGS[@]}" -rsn 1 _

        REPLY=${tmp_buffer}${REPLY}
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

    if test -d "${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"
    then
        cd "${VAR_TERM_TAB_LINE_LIST_PATH[var_tab_id]}"

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

###########################################################
## Env Functions
###########################################################
fenv_left_hande_mode() {
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

        if ((VAR_TERM_WIN_CURRENT_CURSOR + 1 < VAR_TERM_CONTENT_MAX_CNT))
        then
            fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX-1))
            ((VAR_TERM_WIN_CURRENT_CURSOR++))
        else
            # FIXME, it's a patch to avoid glitch
            # clear the first content line
            # fterminal_draw_tab_line
            # fterminal_print "\e[$((VAR_TERM_CONTENT_MAX_CNT + VAR_TERM_TAB_LINE_HEIGHT))H"
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

        if ((VAR_TERM_WIN_CURRENT_CURSOR + 1 < VAR_TERM_CONTENT_MAX_CNT))
        then
            ((VAR_TERM_WIN_CURRENT_CURSOR++))
        else
            # FIXME, it's a patch to avoid glitch
            # clear the first content line
            fterminal_draw_tab_line
            fterminal_print "\e[$((VAR_TERM_CONTENT_MAX_CNT + VAR_TERM_TAB_LINE_HEIGHT))H"
        fi
        fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX))

        if [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_VISUAL}" ] && [[ $VAR_TERM_CONTENT_SCROLL_IDX -gt $VAR_TERM_VISUAL_START_IDX ]]
        then
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
        fi
        # fterminal_draw_status_line
        fterminal_flush
    fi
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
            cd ${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}
            fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
            fterminal_redraw full
            flog_msg "Go PREVIOUS_TAB."
    fi
}
fgui_tab_go_next()
{
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]] ||
        (( ${VAR_TERM_TAB_LINE_IDX} + 1 == ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} )) ||
        ! test -d ${VAR_TERM_TAB_LINE_LIST_PATH[(( ${VAR_TERM_TAB_LINE_IDX} + 1))]}
    then
        flog_msg "NEXT_TAB ignored."
        return
    else
        fterminal_tab_save_contex ${VAR_TERM_TAB_LINE_IDX}
        VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
        VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX + 1))
        cd ${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}
        fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}
        fterminal_redraw full
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
    if [[ ${#VAR_TERM_TAB_LINE_LIST_PATH[@]} -eq 1 ]]
    then
        # flog_msg "CLOSE_TAB ignored."
        exit 0
    else
        fterminal_tab_remove ${VAR_TERM_TAB_LINE_IDX}

        if [[ ${VAR_TERM_TAB_LINE_IDX} -ne 0 ]]
        then
            VAR_TERM_TAB_LINE_IDX=$((VAR_TERM_TAB_LINE_IDX - 1 ))
        fi
        fterminal_tab_load_contex ${VAR_TERM_TAB_LINE_IDX}

        cd ${VAR_TERM_TAB_LINE_LIST_PATH[${VAR_TERM_TAB_LINE_IDX}]}
        fterminal_redraw full
        flog_msg "Tab closed."
    fi
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
            ;;
        "${DEF_TERM_MODE_SELECT}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_SELECT}"
            # setup selection mode
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
            VAR_TERM_SELECTION_FILE_LIST=()
            ;;
        "${DEF_TERM_MODE_COMMAND}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_COMMAND}"
            # setup selection mode
            # fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
            # VAR_TERM_SELECTION_FILE_LIST=()

            var_cmd_history_idx=0
            var_cmd_backup_buffer=""

            # Write to the command_line (under fterminal_draw_status_line).
            var_cmd_prefix=":"
            var_cmd_function="command"

            var_input_buffer=""
            var_post_input_buffer=""

            VAR_TERM_CMD_INPUT_BUFFER=""

            # FIXME, it's just a workaround.
            # flog_msg ":"
            fterminal_draw_command_line
            ;;
        "${DEF_TERM_MODE_SEARCH}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_SEARCH}"

            var_cmd_history_idx=0
            var_cmd_backup_buffer=""

            # Write to the command_line (under fterminal_draw_status_line).
            var_cmd_prefix="/"
            var_cmd_function="search"

            var_input_buffer=""
            var_post_input_buffer=""

            VAR_TERM_CMD_INPUT_BUFFER=""

            fterminal_draw_command_line
            ;;
        "${DEF_TERM_MODE_FIND}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_FIND}"

            var_cmd_history_idx=0
            var_cmd_backup_buffer=""

            # Write to the command_line (under fterminal_draw_status_line).
            var_cmd_prefix="?"
            var_cmd_function="find"

            var_input_buffer=""
            var_post_input_buffer=""

            VAR_TERM_CMD_INPUT_BUFFER=""

            fterminal_draw_command_line
            ;;
        *|"${DEF_TERM_MODE_NORMAL}")
            VAR_TERM_MODE_CURRENT="${DEF_TERM_MODE_NORMAL}"
            fterminal_mark_reset
            ;;
    esac
    # fterminal_draw_status_line
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
            if ((VAR_SEARCH_MODE == 1 && VAR_TERM_SEARCH_END_EARLY != 1)); then
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
            else
                HSFM_LS_SORTING=""
            fi
            fterminal_redraw full
            flog_msg "Sorting: ${HSFM_LS_SORTING}"
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
            fcommand_handler "search" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"

            # If the search came up empty, fterminal_redraw the current dir.
            if [[ -z ${VAR_TERM_DIR_FILE_LIST[*]} ]]; then
                VAR_TERM_DIR_FILE_LIST=("${cur_list[@]}")
                ((VAR_TERM_DIR_LIST_CNT = ${#VAR_TERM_DIR_FILE_LIST[@]} - 1))
                fterminal_redraw
                VAR_SEARCH_MODE=
            else
                VAR_SEARCH_MODE=1
            fi
            ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            fmode_setup "${DEF_TERM_MODE_COMMAND}"
            ;;
        # FIXME, remove this fake command.
        C)
            # FIXME, if command change cursor pos, it will be resotre to wier position
            fcommand_handler "command" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
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
            if [ ${VAR_TERM_MSGWIN_SHOW} = true ]; then
                VAR_TERM_MSGWIN_SHOW=false
            else
                VAR_TERM_MSGWIN_SHOW=true
            fi
            fterminal_redraw
            ;;
        ${HSFM_KEY_TOGGLE_TASKWIN})
            if [ ${VAR_TERM_TASKWIN_SHOW} = true ]; then
                VAR_TERM_TASKWIN_SHOW=false
            else
                VAR_TERM_TASKWIN_SHOW=true
            fi
            fterminal_redraw
            ;;

        # Directory favourites.
        [1-9])
            tmp_favorite_name="HSFM_FAV${1}"
            tmp_favorite="${!tmp_favorite_name}"

            [[ $tmp_favorite ]] &&
                fsys_open "$tmp_favorite"
            ;;

        # File operation
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
        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # FIXME, if command change cursor pos, it will be resotre to wier position
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")
            fcommand_handler "command" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
            ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            VAR_TERM_FILE_PROGRAM=(fselect_copy)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files yanked."
            ;;
        ${HSFM_KEY_CUT:=m})
            VAR_TERM_FILE_PROGRAM=(mv -i)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files cuted."
            ;;
        ${HSFM_KEY_TRASH:=d})
            VAR_TERM_FILE_PROGRAM=(fselect_remove)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fselect_execute
            ;;
        q | $'\e')
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
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

        ${HSFM_KEY_SELECTION})
            fterminal_mark_toggle "$VAR_TERM_CONTENT_SCROLL_IDX" "$1"
            ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # FIXME, if command change cursor pos, it will be resotre to wier position
            fcommand_handler "command" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
            ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            VAR_TERM_FILE_PROGRAM=(fselect_copy)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files yanked."
            ;;
        ${HSFM_KEY_CUT:=m})
            VAR_TERM_FILE_PROGRAM=(mv -i)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files cuted."
            ;;
        ${HSFM_KEY_TRASH:=d})
            VAR_TERM_FILE_PROGRAM=(fselect_remove)
            VAR_TERM_SELECTION_FILE_LIST=("${VAR_TERM_MARKED_FILE_LIST[@]}")

            VAR_TERM_MARKED_FILE_LIST=()
            fselect_execute
            ;;
        q | $'\e')
            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            fterminal_redraw
            ;;
    esac
}

fcommand_mode_handler() {
    local var_key_press="$@"

    # static_var_comp_list=()
    # static_var_comp_idx=0
    # static_var_comp_path_cmd=""

    fterminal_print '\e[?25l\e[%sH' "$VAR_TERM_LINE_CNT"

    case ${var_key_press} in
        # Control UI
        # Move backward
        $'\e[C')
            local tmp_post_buf_cnt=${#var_post_input_buffer}

            if [[ "${tmp_post_buf_cnt}" -ne "0" ]]; then
                var_input_buffer+="${var_post_input_buffer:0:1}"
                var_post_input_buffer=${var_post_input_buffer:1:$tmp_post_buf_cnt-1}
            fi
            ;;
        # Move forward
        $'\e[D')
            local tmp_buf_cnt=${#var_input_buffer}

            if [[ "${tmp_buf_cnt}" -ne "0" ]]; then
                # var_post_input_buffer="${var_input_buffer:1:#}${var_post_input_buffer}"
                var_post_input_buffer="${var_input_buffer:$tmp_buf_cnt-1:1}${var_post_input_buffer}"
                var_input_buffer=${var_input_buffer:0:$tmp_buf_cnt-1}
            fi

            ;;
        # Scroll down
        $'\e[B')
            if [[ "${var_cmd_history_idx}" = "1" ]]; then
                var_input_buffer=${var_cmd_backup_buffer}
                var_post_input_buffer=""
                ((var_cmd_history_idx--))
            elif [[ "${var_cmd_history_idx}" != "0" ]]; then
                if [[ ${var_cmd_function} = "search" ]]; then
                    if [[ $((${var_cmd_history_idx} - 1)) -le ${#VAR_TERM_SEARCH_HISTORY[@]} ]]; then
                        ((var_cmd_history_idx--))
                        local tmp_history_idx=$((${#VAR_TERM_SEARCH_HISTORY[@]} - ${var_cmd_history_idx}))
                        var_input_buffer=${VAR_TERM_SEARCH_HISTORY[${tmp_history_idx}]}
                        var_post_input_buffer=""
                    fi
                elif [[ ${var_cmd_function} = "find" ]]; then
                    if [[ $((${var_cmd_history_idx} - 1)) -le ${#VAR_TERM_FIND_HISTORY[@]} ]]; then
                        ((var_cmd_history_idx--))
                        local tmp_history_idx=$((${#VAR_TERM_FIND_HISTORY[@]} - ${var_cmd_history_idx}))
                        var_input_buffer=${VAR_TERM_FIND_HISTORY[${tmp_history_idx}]}
                        var_post_input_buffer=""
                    fi
                else
                    if [[ $((${var_cmd_history_idx} - 1)) -le ${#VAR_TERM_CMD_HISTORY[@]} ]]; then
                        ((var_cmd_history_idx--))
                        local tmp_history_idx=$((${#VAR_TERM_CMD_HISTORY[@]} - ${var_cmd_history_idx}))
                        var_input_buffer=${VAR_TERM_CMD_HISTORY[${tmp_history_idx}]}
                        var_post_input_buffer=""
                    fi
                fi
            fi
            ;;

        # Scroll up.
        $'\e[A')

            if [[ "${var_cmd_history_idx}" = "0" ]]; then
                var_cmd_backup_buffer="${var_input_buffer}${var_post_input_buffer}"
            fi
            if [[ ${var_cmd_function} = "search" ]]; then
                if [[ $((${var_cmd_history_idx} + 1)) -le ${#VAR_TERM_SEARCH_HISTORY[@]} ]]; then
                    ((var_cmd_history_idx++))
                    local tmp_history_idx=$((${#VAR_TERM_SEARCH_HISTORY[@]} - ${var_cmd_history_idx}))
                    var_input_buffer=${VAR_TERM_SEARCH_HISTORY[${tmp_history_idx}]}
                    var_post_input_buffer=""
                fi
            elif [[ ${var_cmd_function} = "find" ]]; then
                if [[ $((${var_cmd_history_idx} + 1)) -le ${#VAR_TERM_FIND_HISTORY[@]} ]]; then
                    ((var_cmd_history_idx++))
                    local tmp_history_idx=$((${#VAR_TERM_FIND_HISTORY[@]} - ${var_cmd_history_idx}))
                    var_input_buffer=${VAR_TERM_FIND_HISTORY[${tmp_history_idx}]}
                    var_post_input_buffer=""
                fi
            else
                if [[ $((${var_cmd_history_idx} + 1)) -le ${#VAR_TERM_CMD_HISTORY[@]} ]]; then
                    ((var_cmd_history_idx++))
                    local tmp_history_idx=$((${#VAR_TERM_CMD_HISTORY[@]} - ${var_cmd_history_idx}))
                    var_input_buffer=${VAR_TERM_CMD_HISTORY[${tmp_history_idx}]}
                    var_post_input_buffer=""
                fi
            fi
            ;;

        # : to clear buffer
        ":")
            if [[ ${var_cmd_function} = "command" ]]; then
                var_input_buffer=""
            fi
            ;;
        # Backspace.
        $'\177' | $'\b')
            var_input_buffer=${var_input_buffer%?}

            # Clear tab-completion.
            unset static_var_comp_list static_var_comp_idx
            ;;

        # Tab.
        $'\t')
            comp_glob="$var_input_buffer*"

            # Pass the argument dirs to limit completion to directories.
            # [[ $2 == dirs ]] &&
            #     comp_glob="$var_input_buffer*/"

            # Generate a completion list once.
            # [[ -z ${static_var_comp_list[0]} ]] &&
            #     IFS=$'\n' read -d "" -ra static_var_comp_list < <(compgen -G "$comp_glob")
            # IFS=$'\n' read -d "" -ra static_var_comp_list < <(compgen -G -W "fterminal_redraw search" "$comp_glob")
            #

            # flog_msg_debug "Redo comp list.'[ "${#static_var_comp_list[@]}" = "0" ]'"
            if [[ "${#static_var_comp_list[@]}" -eq "0" ]]; then
                static_var_comp_list=()
                static_var_comp_idx=0
                static_var_comp_path_cmd=""

                # FIXME, only firs args can be completion with path.
                if [ "${VAR_TERM_MODE_CURRENT}" = "${DEF_TERM_MODE_COMMAND}" ]; then
                    local tmp_cmd="${var_input_buffer%% *}"
                    local tmp_args="${var_input_buffer##${tmp_cmd}}"
                    # flog_msg_debug "Command comp list.'${var_input_buffer}'/'${tmp_cmd}'/'${tmp_args}'"

                    # local tmp_cmd="${var_input_buffer%% *}"
                    if test -n "${tmp_cmd}" && test -n "${tmp_args}"; then
                        # flog_msg_debug "Path comp list.'${tmp_args}'"
                        local tmp_path=${var_input_buffer#* }
                        if test -n "${tmp_path}" && test -e ${tmp_path%/*}; then
                            # IFS=$'\n' read -d "" -ra globpat < <(compgen -G "$comp_glob")
                            IFS=$'\n' read -d "" -ra wordlist < <(compgen -f ${tmp_path})
                            # static_var_comp_list=$globpat
                            static_var_comp_list+=("${wordlist[@]}" "${tmp_path}" )

                            static_var_comp_path_cmd="${tmp_cmd}"
                        fi

                    else
                        # flog_msg_debug "Command comp list.'${var_input_buffer}'"
                        # IFS=$'\n' read -d "" -ra globpat < <(compgen -G "$comp_glob")
                        IFS=$'\n' read -d "" -ra wordlist < <(compgen -W "${VAR_TERM_CMD_LIST[*]}" ${var_input_buffer})
                        # static_var_comp_list=$globpat
                        static_var_comp_list+=("${wordlist[@]}" "${var_input_buffer}")
                    fi

                else
                    # flog_msg_debug "Select comp list.'${var_input_buffer}'"
                    # IFS=$'\n' read -d "" -ra globpat < <(compgen -G "$comp_glob")
                    IFS=$'\n' read -d "" -ra wordlist < <(compgen -W "${VAR_TERM_SELECT_CMD_LIST[*]}" ${var_input_buffer})
                    # static_var_comp_list=$globpat
                    static_var_comp_list+=("${wordlist[@]}" "${var_input_buffer}")
                fi
            fi

            # flog_msg_debug "Completion: ${static_var_comp_idx}-> '${static_var_comp_list[static_var_comp_idx]}'"
            # On each tab press, cycle through the completion list.
            [[ -n ${static_var_comp_list[static_var_comp_idx]} ]] && {

                if test -n "${static_var_comp_path_cmd}"
                then
                    var_input_buffer="${static_var_comp_path_cmd} "${static_var_comp_list[static_var_comp_idx]}
                    ((static_var_comp_idx = static_var_comp_idx >= ${#static_var_comp_list[@]} - 1 ? 0 : ++static_var_comp_idx))
                else
                    var_input_buffer=${static_var_comp_list[static_var_comp_idx]}
                    ((static_var_comp_idx = static_var_comp_idx >= ${#static_var_comp_list[@]} - 1 ? 0 : ++static_var_comp_idx))
                fi
            }
            ;;

        # Enter/Return.
        "")
            VAR_TERM_CMD_INPUT_BUFFER="${var_input_buffer}${var_post_input_buffer}"
            if [[ ${var_cmd_function} = "search" ]]; then

                if test -z "${VAR_TERM_CMD_INPUT_BUFFER}"; then
                    fmode_setup "${DEF_TERM_MODE_NORMAL}"
                    return 0
                elif [[ ${#VAR_TERM_SEARCH_HISTORY[@]} -gt ${VAR_TERM_CMD_HISTORY_MAX} ]]; then
                    local tmp_start_idx=$((${#VAR_TERM_SEARCH_HISTORY[@]} - ${VAR_TERM_CMD_HISTORY_MAX}))
                    VAR_TERM_SEARCH_HISTORY=("${VAR_TERM_SEARCH_HISTORY[@]:${tmp_start_idx}:${VAR_TERM_CMD_HISTORY_MAX}}")

                else
                    VAR_TERM_SEARCH_HISTORY+=("${VAR_TERM_CMD_INPUT_BUFFER}")
                fi
                # # Unset tab completion variables since we're done.
                # unset static_var_comp_list static_var_comp_idx
                fmode_setup "${DEF_TERM_MODE_NORMAL}"
                return 0
            elif [[ ${var_cmd_function} = "find" ]]; then

                cmd_find "${VAR_TERM_CMD_INPUT_BUFFER}"

                if test -z "${VAR_TERM_CMD_INPUT_BUFFER}"; then
                    fmode_setup "${DEF_TERM_MODE_NORMAL}"
                    return 0
                elif [[ ${#VAR_TERM_FIND_HISTORY[@]} -gt ${VAR_TERM_CMD_HISTORY_MAX} ]]; then
                    local tmp_start_idx=$((${#VAR_TERM_FIND_HISTORY[@]} - ${VAR_TERM_CMD_HISTORY_MAX}))
                    VAR_TERM_FIND_HISTORY=("${VAR_TERM_FIND_HISTORY[@]:${tmp_start_idx}:${VAR_TERM_CMD_HISTORY_MAX}}")

                else
                    VAR_TERM_FIND_HISTORY+=("${VAR_TERM_CMD_INPUT_BUFFER}")
                fi

                # # Unset tab completion variables since we're done.
                # unset static_var_comp_list static_var_comp_idx
                fmode_setup "${DEF_TERM_MODE_NORMAL}"
                return 0
            elif [[ ${var_cmd_function} != "command" ]]; then
                # # Unset tab completion variables since we're done.
                # unset static_var_comp_list static_var_comp_idx
                fmode_setup "${DEF_TERM_MODE_NORMAL}"
                return 0
            fi

            if test -z "${VAR_TERM_CMD_INPUT_BUFFER}"; then
                fterminal_print '\r\e[K\e[?25l'
                fmode_setup "${DEF_TERM_MODE_NORMAL}"
                return 0
            elif [[ ${#VAR_TERM_CMD_HISTORY[@]} -gt ${VAR_TERM_CMD_HISTORY_MAX} ]]; then
                local tmp_start_idx=$((${#VAR_TERM_CMD_HISTORY[@]} - ${VAR_TERM_CMD_HISTORY_MAX}))
                VAR_TERM_CMD_HISTORY=("${VAR_TERM_CMD_HISTORY[@]:${tmp_start_idx}:${VAR_TERM_CMD_HISTORY_MAX}}")
            else
                VAR_TERM_CMD_HISTORY+=("${VAR_TERM_CMD_INPUT_BUFFER}")
            fi

            tmp_command=$(echo ${VAR_TERM_CMD_INPUT_BUFFER} | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 1)
            # space is for workaround.
            tmp_args=$(echo "${VAR_TERM_CMD_INPUT_BUFFER} " | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 2-)
            # flog_msg_debug "${tmp_args}/$VAR_TERM_CMD_INPUT_BUFFER"
            # fterminal_print "\r\e[2K%s" ${tmp_command}
            if [ "$VAR_TERM_MODE_CURRENT" = "${DEF_TERM_MODE_COMMAND}" ] ; then
                case ${tmp_command} in
                    # NOTE. only build-in commands can list here.
                    "redraw")
                        fterminal_redraw full
                        ;;
                    "open")
                        fsys_open ${tmp_args}
                        ;;
                    "vim" | "edit")
                        cmd_editor "${tmp_args}"
                        ;;
                    "media" | "play")
                        cmd_media "${tmp_args}"
                        ;;
                    "image" | "preview")
                        cmd_media "${tmp_args}"
                        ;;

                    "echo")
                        flog_msg "${tmp_args}"
                        ;;
                    *)
                        # This if for build in commands.
                        # flog_msg "Unknown commands: ${tmp_command} ${tmp_args}"
                        if command -v cmd_${tmp_command} >/dev/null; then
                            cmd_${tmp_command} ${tmp_args}
                            # We should not clear msg, after running.
                            fterminal_print '\e[?25l'
                        else
                            fterminal_print '\r\e[K Command "'${tmp_command}'" not found.\e[?25l\e8'
                        fi
                        ;;
                esac
            else
                case ${tmp_command} in
                    *)
                        # flog_msg "Unknown commands: ${tmp_command} ${tmp_args}"
                        if command -v vcmd_${tmp_command} >/dev/null; then
                            vcmd_${tmp_command} ${tmp_args}
                            # We should not clear msg, after running.
                            fterminal_print '\e[?25l'
                        else
                            fterminal_print '\r\e[K Command "'${tmp_command}'" not found.\e[?25l'
                        fi
                        ;;
                esac

            fi

            # [[ $1 == :  ]] && {
            #     nohup "${VAR_TERM_CMD_INPUT_BUFFER}" "$2" &>/dev/null &
            # }

            fmode_setup "${DEF_TERM_MODE_NORMAL}"
            return 0
            ;;

        # Escape / Custom 'no' value (used as a replacement for '-n 1').
        # $'\e'|${3:-null})
        $'\e')
            read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2
            VAR_TERM_CMD_INPUT_BUFFER=
            fmode_setup "${DEF_TERM_MODE_NORMAL}"

            if [[ ${var_cmd_function} == "search" ]]; then
                fterminal_redraw full
            else
                # clear cli line, and exit.
                fterminal_print '\r\e[K\e[?25l'
            fi
            return 0
            ;;
        $'\e'*)
            # ignore
            ;;

        # Replace '~' with '$HOME'.
        "~")
            var_input_buffer+=$HOME
            ;;

        # Anything else, add it to read reply.
        *)
            var_input_buffer+=${var_key_press}

            # Clear tab-completion.
            unset static_var_comp_list static_var_comp_idx
            ;;
    esac
    # flog_msg_debug "${var_input_buffer}/${var_post_input_buffer}"
    # fterminal_print $'\r\e[K'"${var_cmd_prefix}${var_input_buffer}${var_post_input_buffer} $(printf "\e[%dD" $((${#var_post_input_buffer} + 1)))"
    fterminal_print $'\r'"${var_cmd_prefix}${var_input_buffer}${var_post_input_buffer} "$'\e[K'"$(printf "\e[%dD" $((${#var_post_input_buffer} + 1)))"$'\e[?25h'

    [[ ${var_cmd_function} == "search" ]] && {
        VAR_TERM_CMD_INPUT_BUFFER="${var_input_buffer}${var_post_input_buffer}"
        # cmd_search "${VAR_TERM_CMD_INPUT_BUFFER}"
        cmd_newsearch "${VAR_TERM_CMD_INPUT_BUFFER}"
    }
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================
    #==========================================================================


    return 0
    # Unset tab completion variables since we're done.
    # unset static_var_comp_list static_var_comp_idx
}

fprase_mime_type() {
    # Get a file's mime_type.
    # mime_type=$(file "-${VAR_TERM_FILE_ARGS:-biL}" "$1" 2>/dev/null)
    echo $(file "-${VAR_TERM_FILE_ARGS:-biL}" "$*" 2>/dev/null)
}
fget_cursor_file() {
    echo ${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}
}
fget_selection_file() {
    echo ${VAR_TERM_SELECTION_FILE_LIST[@]}
}

###########################################################
## Open Functions
###########################################################
fcommand_handler()
{
    ## Pre settings.
    ################################################################
    # new functon for handle all commands
    # fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"

    ## Main handler
    ################################################################
    case ${1} in
        "command")
            fcommand_line_interact "${HSFM_KEY_OPEN_CMD}" "command" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
            # fterminal_print '\e[?25l\e8'
            ;;
        "search")
            fcommand_line_interact "${HSFM_KEY_SEARCH}" "search" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
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
fcommand_line_interact() {
    # cmd history
    local var_cmd_history_idx=0
    local var_cmd_backup_buffer=""

    # Write to the command_line (under fterminal_draw_status_line).
    local var_cmd_prefix=${1}
    local var_cmd_function=${2:=""}
    # local var_cmd_file=${3:=""}

    if [[ "${#}" -eq "3" ]]; then
        local var_cmd_file=${3:=""}
    else
        local var_cmd_file=""
    fi

    VAR_TERM_CMD_INPUT_BUFFER=""

    local var_input_buffer=""
    local var_post_input_buffer=""

    fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"
    # '\r\e[K': Redraw the read prompt on every keypress.
    #           This is mimicking what happens normally.
    while IFS= read -rsn 1 -p $'\r\e[K'"${var_cmd_prefix}${var_input_buffer}${var_post_input_buffer} $(printf "\e[%dD" $((${#var_post_input_buffer} + 1)))" read_reply 2>&1; do
        if [[ ${read_reply} == $'\e' ]]; then
            local tmp_buffer="${read_reply}"
            local var_read_flag=(-t 0.02)
            read "${var_read_flag[@]}" -rsn 2 read_reply

            # Handle a normal escape key press.
            [[ ${tmp_buffer}${read_reply} == $'\e\e['* ]] &&
                read "${var_read_flag[@]}" -rsn 2 _

            if [[ ${tmp_buffer}${read_reply} == $'\e['* ]]; then
                # read "${var_read_flag[@]}" -rsn 2 _
                tmp_buffer+="${read_reply}"
                read "${var_read_flag[@]}" -rsn 2 read_reply
            fi

            read_reply=${tmp_buffer}${read_reply}
            # Flush others
            # read "${var_read_flag[@]}" -rsn 5 _
        fi

        case $read_reply in
            # Control UI
            # Move backward
            $'\e[C')
                local tmp_post_buf_cnt=${#var_post_input_buffer}

                if [[ "${tmp_post_buf_cnt}" -ne "0" ]]; then
                    var_input_buffer+="${var_post_input_buffer:0:1}"
                    var_post_input_buffer=${var_post_input_buffer:1:$tmp_post_buf_cnt-1}
                fi
                ;;
            # Move forward
            $'\e[D')
                local tmp_buf_cnt=${#var_input_buffer}

                if [[ "${tmp_buf_cnt}" -ne "0" ]]; then
                    # var_post_input_buffer="${var_input_buffer:1:#}${var_post_input_buffer}"
                    var_post_input_buffer="${var_input_buffer:$tmp_buf_cnt-1:1}${var_post_input_buffer}"
                    var_input_buffer=${var_input_buffer:0:$tmp_buf_cnt-1}
                fi

                ;;
            # Scroll down
            $'\e[B')
                if [[ "${var_cmd_history_idx}" = "1" ]]; then
                    var_input_buffer=${var_cmd_backup_buffer}
                    var_post_input_buffer=""
                    ((var_cmd_history_idx--))
                elif [[ "${var_cmd_history_idx}" != "0" ]]; then
                    if [[ ${var_cmd_function} = "search" ]]; then
                        if [[ $((${var_cmd_history_idx} - 1)) -le ${#VAR_TERM_SEARCH_HISTORY[@]} ]]; then
                            ((var_cmd_history_idx--))
                            local tmp_history_idx=$((${#VAR_TERM_SEARCH_HISTORY[@]} - ${var_cmd_history_idx}))
                            var_input_buffer=${VAR_TERM_SEARCH_HISTORY[${tmp_history_idx}]}
                            var_post_input_buffer=""
                        fi
                    else
                        if [[ $((${var_cmd_history_idx} - 1)) -le ${#VAR_TERM_CMD_HISTORY[@]} ]]; then
                            ((var_cmd_history_idx--))
                            local tmp_history_idx=$((${#VAR_TERM_CMD_HISTORY[@]} - ${var_cmd_history_idx}))
                            var_input_buffer=${VAR_TERM_CMD_HISTORY[${tmp_history_idx}]}
                            var_post_input_buffer=""
                        fi
                    fi
                fi
                ;;

            # Scroll up.
            $'\e[A')

                if [[ "${var_cmd_history_idx}" = "0" ]]; then
                    var_cmd_backup_buffer="${var_input_buffer}${var_post_input_buffer}"
                fi
                if [[ ${var_cmd_function} = "search" ]]; then
                    if [[ $((${var_cmd_history_idx} + 1)) -le ${#VAR_TERM_SEARCH_HISTORY[@]} ]]; then
                        ((var_cmd_history_idx++))
                        local tmp_history_idx=$((${#VAR_TERM_SEARCH_HISTORY[@]} - ${var_cmd_history_idx}))
                        var_input_buffer=${VAR_TERM_SEARCH_HISTORY[${tmp_history_idx}]}
                        var_post_input_buffer=""
                    fi
                else
                    if [[ $((${var_cmd_history_idx} + 1)) -le ${#VAR_TERM_CMD_HISTORY[@]} ]]; then
                        ((var_cmd_history_idx++))
                        local tmp_history_idx=$((${#VAR_TERM_CMD_HISTORY[@]} - ${var_cmd_history_idx}))
                        var_input_buffer=${VAR_TERM_CMD_HISTORY[${tmp_history_idx}]}
                        var_post_input_buffer=""
                    fi
                fi
                ;;

            # : to clear buffer
            ":")
                if [[ ${var_cmd_function} = "command" ]]; then
                    var_input_buffer=""
                fi
                ;;
            # Backspace.
            $'\177' | $'\b')
                var_input_buffer=${var_input_buffer%?}

                # Clear tab-completion.
                unset comp c
                ;;

            # Tab.
            $'\t')
                comp_glob="$var_input_buffer*"

                # Pass the argument dirs to limit completion to directories.
                # [[ $2 == dirs ]] &&
                #     comp_glob="$var_input_buffer*/"

                # Generate a completion list once.
                # [[ -z ${comp[0]} ]] &&
                #     IFS=$'\n' read -d "" -ra comp < <(compgen -G "$comp_glob")
                # IFS=$'\n' read -d "" -ra comp < <(compgen -G -W "fterminal_redraw search" "$comp_glob")
                #

                if [ "$VAR_TERM_MODE_CURRENT" = "${DEF_TERM_MODE_NORMAL}" ]; then
                    if [[ -z ${comp[0]} ]]; then
                        # IFS=$'\n' read -d "" -ra globpat < <(compgen -G "$comp_glob")
                        IFS=$'\n' read -d "" -ra wordlist < <(compgen -W "${VAR_TERM_CMD_LIST[*]}" ${var_input_buffer})
                        # comp=$globpat
                        comp+=$wordlist
                    fi
                else
                    if [[ -z ${comp[0]} ]]; then
                        # IFS=$'\n' read -d "" -ra globpat < <(compgen -G "$comp_glob")
                        IFS=$'\n' read -d "" -ra wordlist < <(compgen -W "${VAR_TERM_SELECT_CMD_LIST[*]}" ${var_input_buffer})
                        # comp=$globpat
                        comp+=$wordlist
                    fi
                fi

                # On each tab press, cycle through the completion list.
                [[ -n ${comp[c]} ]] && {
                    var_input_buffer=${comp[c]}
                    ((c = c >= ${#comp[@]} - 1 ? 0 : ++c))
                }
                ;;

            # Enter/Return.
            "")
                VAR_TERM_CMD_INPUT_BUFFER="${var_input_buffer}${var_post_input_buffer}"
                if [[ ${var_cmd_function} = "search" ]]; then

                    if test -z "${VAR_TERM_CMD_INPUT_BUFFER}"; then
                        break
                    elif [[ ${#VAR_TERM_SEARCH_HISTORY[@]} -gt ${VAR_TERM_CMD_HISTORY_MAX} ]]; then
                        local tmp_start_idx=$((${#VAR_TERM_SEARCH_HISTORY[@]} - ${VAR_TERM_CMD_HISTORY_MAX}))
                        VAR_TERM_SEARCH_HISTORY=("${VAR_TERM_SEARCH_HISTORY[@]:${tmp_start_idx}:${VAR_TERM_CMD_HISTORY_MAX}}")

                    else
                        VAR_TERM_SEARCH_HISTORY+=("${VAR_TERM_CMD_INPUT_BUFFER}")
                    fi
                    # # Unset tab completion variables since we're done.
                    # unset comp c
                    # return
                    break
                elif [[ ${var_cmd_function} != "command" ]]; then
                    # # Unset tab completion variables since we're done.
                    # unset comp c
                    # return
                    break
                fi
                if test -z "${VAR_TERM_CMD_INPUT_BUFFER}"; then
                    fterminal_print '\r\e[K\e[?25l\e8'
                    break
                elif [[ ${#VAR_TERM_CMD_HISTORY[@]} -gt ${VAR_TERM_CMD_HISTORY_MAX} ]]; then
                    local tmp_start_idx=$((${#VAR_TERM_CMD_HISTORY[@]} - ${VAR_TERM_CMD_HISTORY_MAX}))
                    VAR_TERM_CMD_HISTORY=("${VAR_TERM_CMD_HISTORY[@]:${tmp_start_idx}:${VAR_TERM_CMD_HISTORY_MAX}}")

                else
                    VAR_TERM_CMD_HISTORY+=("${VAR_TERM_CMD_INPUT_BUFFER}")
                fi

                tmp_command=$(echo ${VAR_TERM_CMD_INPUT_BUFFER} | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 1)
                # space is for workaround.
                tmp_args=$(echo "${VAR_TERM_CMD_INPUT_BUFFER} " | tr -s ' ' | sed 's/^ //g' | cut -d ' ' -f 2-)
                # flog_msg_debug "${tmp_args}/$VAR_TERM_CMD_INPUT_BUFFER"
                # fterminal_print "\r\e[2K%s" ${tmp_command}
                if [ "$VAR_TERM_MODE_CURRENT" = "${DEF_TERM_MODE_NORMAL}" ] ; then
                    case ${tmp_command} in
                        # NOTE. only build-in commands can list here.
                        "redraw")
                            fterminal_redraw full
                            ;;
                        "open")
                            fsys_open ${tmp_args}
                            ;;
                        "vim" | "edit")
                            cmd_editor "${tmp_args}"
                            ;;
                        "media" | "play")
                            cmd_media "${tmp_args}"
                            ;;
                        "image" | "preview")
                            cmd_media "${tmp_args}"
                            ;;

                        "echo")
                            flog_msg "${tmp_args}"
                            ;;
                        *)
                            # This if for build in commands.
                            # flog_msg "Unknown commands: ${tmp_command} ${tmp_args}"
                            if command -v cmd_${tmp_command} >/dev/null; then
                                cmd_${tmp_command} ${tmp_args}
                                # We should not clear msg, after running.
                                fterminal_print '\e[?25l\e8'
                            else
                                fterminal_print '\r\e[K Command "'${tmp_command}'" not found.\e[?25l\e8'
                            fi
                            ;;
                    esac
                else
                    case ${tmp_command} in
                        *)
                            # flog_msg "Unknown commands: ${tmp_command} ${tmp_args}"
                            if command -v vcmd_${tmp_command} >/dev/null; then
                                vcmd_${tmp_command} ${tmp_args}
                                # We should not clear msg, after running.
                                fterminal_print '\e[?25l\e8'
                            else
                                fterminal_print '\r\e[K Command "'${tmp_command}'" not found.\e[?25l\e8'
                            fi
                            ;;
                    esac

                fi

                # [[ $1 == :  ]] && {
                #     nohup "${VAR_TERM_CMD_INPUT_BUFFER}" "$2" &>/dev/null &
                # }

                break
                ;;

            # Custom 'yes' value (used as a replacement for '-n 1').
            # ${2:-null})
            #     VAR_TERM_CMD_INPUT_BUFFER=$read_reply
            #     break
            # ;;

            # Escape / Custom 'no' value (used as a replacement for '-n 1').
            # $'\e'|${3:-null})
            $'\e')
                read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2
                VAR_TERM_CMD_INPUT_BUFFER=

                if [[ ${var_cmd_function} == "search" ]]; then
                    fterminal_redraw full
                else
                    # clear cli line, and exit.
                    fterminal_print '\r\e[K\e[?25l\e8'
                fi
                break
                ;;
            $'\e'*)
                # ignore
                ;;

            # Replace '~' with '$HOME'.
            "~")
                var_input_buffer+=$HOME
                ;;

            # Anything else, add it to read reply.
            *)
                var_input_buffer+=$read_reply

                # Clear tab-completion.
                unset comp c
                ;;
        esac

        [[ ${var_cmd_function} == "search" ]] && {
            VAR_TERM_CMD_INPUT_BUFFER="${var_input_buffer}${var_post_input_buffer}"
            cmd_search "${VAR_TERM_CMD_INPUT_BUFFER}"
        }

        # Flush others
        read -t 0 -rsn 100 _

    done

    # Unset tab completion variables since we're done.
    unset comp c
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
    if [ ${VAR_TERM_MSGWIN_SHOW} = true ]
    then
        fterminal_draw_msgwin
    fi
}
flog_msg()
{
    fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"
    fterminal_print '\r\e[%sH\e[?25h\e[2K%s' "$VAR_TERM_LINE_CNT" "$*"
    fterminal_print '\e[?25l\e8'
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
    HSFM_READ_DIR_MODE=3
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
    fterminal_print '\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"
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
cmd_editor()
{
    local var_file=""
    if test -f "$*"
    then
        var_file="${*}"
    else
        var_file="$(fget_cursor_file)"
    fi

    if [[ -f "${var_file}" ]]; then
        fterminal_reset

        vim "${var_file}"

        fterminal_setup
        fterminal_redraw
    else
        flog_msg "warn: '$var_file' not opened"
    fi
}
cmd_media()
{
    local var_file=""
    if test -f "$*"
    then
        var_file="${*}"
    else
        var_file="$(fget_cursor_file)"
    fi
    if [[ -f "${var_file}" ]]; then
        nohup "${HSFM_MEDIA_PLAYER}" "${var_file}" &>/dev/null &
        disown
    else
        flog_msg "warn: '${var_file}' not opened"
    fi
}
cmd_image()
{
    local var_file=""
    if test -f "$*"
    then
        var_file="${*}"
    else
        var_file="$(fget_cursor_file)"
    fi
    if [[ -f "${var_file}" ]]; then
        nohup "${HSFM_PICTURE_VIEWER}" "${var_file}" &>/dev/null &
        disown
    else
        flog_msg "warn: '${var_file}' not opened"
    fi
}
# cmd_unzip()
# {
#     local var_file="$@"
#     if [[ -f "${var_file}" ]]; then
#
#         if [[ -d "${var_file%%.zip}" ]]; then
#             fcommand_line_interact "${tmp_file##*/} exist. Overwrite(y.yes/n.no)? " y n
#             if [ "${VAR_TERM_CMD_INPUT_BUFFER}" = "y" ]
#             then
#                 unzip -f -d "${var_file%%.zip}" "${var_file}" > /dev/null
#             else
#                 flog_msg "skip unzip '$var_file'"
#                 return 0
#             fi
#         else
#             unzip -d "${var_file%%.zip}" "${var_file}" > /dev/null
#         fi
#
#         if [[ -d "${var_file%%.zip}" ]]; then
#             fterminal_redraw full
#         fi
#     else
#         flog_msg "warn: '$var_file' not opened"
#     fi
# }
cmd_extract()
{
    local var_file=""
    local var_file_type=""
    local var_cmd=""

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
        var_file="$(realpath ${var_file})"
    else
        flog_msg "'${var_file}' is not a valid file!"
        return 1
    fi
    case ${var_file_type} in
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
        *gz)
            var_cmd="gunzip '${var_file}'"
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
        *7z)
            var_cmd="7z x '${var_file}'"
            ;;
        *)
            flog_msg "Unknown file type, use 7z to extract it"
            var_cmd="7z x '${var_file}'"
            ;;
    esac

    local tmp_extrace_path="${var_file%.*}"
    flog_msg "Starting extract file ${var_file}."
    fterminal_draw_miniwin "Start extract files."
    if [[ -d "${var_file%.*}" ]]; then
        local tmp_time=$(date +%s)
        local tmp_extrace_path="${var_file%.*}_${tmp_time}"
        mkdir "${tmp_extrace_path}"
        pushd "${tmp_extrace_path}" > /dev/null
        if ! eval "${var_cmd}" > /dev/null; then
            rm -rf "${tmp_extrace_path}"
        fi
        popd > /dev/null
    else
        mkdir "${tmp_extrace_path}"
        pushd "${tmp_extrace_path}" > /dev/null
        if ! eval "${var_cmd}" > /dev/null; then
            rm -rf "${tmp_extrace_path}"
        fi
        popd > /dev/null
    fi

    # for redraw miniwin, we must redraw.
    fterminal_redraw full
    if [[ -d "${var_file%.*}" ]]; then
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
            flog_msg "Sorting Options: none/size/time/version/extension"
            return 0
            ;;
    esac
    fterminal_redraw full
    flog_msg "Sorting: ${var_name}"
}
cmd_cd()
{
    local var_dir_path="$*"
    if test -d "${var_dir_path}"
    then
        # cd $@
        fsys_open "${var_dir_path}"

        # backup cursor
        # NOTE. It's a patch for storing cursor position, cuse fcommand_handler will restore it.
        fterminal_print '\e7'

        flog_msg "Change dir to: ${var_dir_path}"
    else
        for each_key in  "${!HSFM_DIR_ALIAS[@]}"; do
            flog_msg_debug "Key: '${each_key}'/'${var_dir_path}'/'${HSFM_DIR_ALIAS[$each_key]}'"

            if [ "${each_key}" = "${var_dir_path}" ] && test -d "${HSFM_DIR_ALIAS[$each_key]}"
            then
                local tmp_dir_path="${HSFM_DIR_ALIAS[$each_key]}"

                fsys_open "${tmp_dir_path}"

                # backup cursor
                # NOTE. It's a patch for storing cursor position, cuse fcommand_handler will restore it.
                fterminal_print '\e7'

                flog_msg "Change dir to: '${each_key}' -> '${tmp_dir_path}'"
                return 0
            fi
        done

        flog_msg "${var_dir_path} not found."
        return 1
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
    fcommand_line_interact "Press Enter Key To Continue..." "wait" "q"
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
    fcommand_line_interact "Press Enter Key To Continue..." "wait" "q"
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
        if [[ ${var_print_cnt} -gt ${VAR_TERM_CONTENT_MAX_CNT} ]]
        then
            break
        fi
        fterminal_print '\e[%sH\r    %- 24s: %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done

    fterminal_print '\e[%sH\r## %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_FILE"
    for each_var in ${!HSFM_FILE_@}
    do
        if [[ ${var_print_cnt} -gt ${VAR_TERM_CONTENT_MAX_CNT} ]]
        then
            break
        fi
        fterminal_print '\e[%sH\r    %- 24s: %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done

    fterminal_print '\e[%sH\r## %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "HSFM_FAV"
    for each_var in ${!HSFM_FAV@}
    do
        if [[ ${var_print_cnt} -gt ${VAR_TERM_CONTENT_MAX_CNT} ]]
        then
            break
        fi
        fterminal_print '\e[%sH\r    %- 24s: %s' "$((VAR_TERM_TAB_LINE_HEIGHT + 1 + var_print_cnt++))" "${each_var}" "${!each_var}"
    done
    ################################################################
    fterminal_draw_tab_line
    fterminal_draw_status_line
    fcommand_line_interact "Press Enter Key To Continue..." "wait" "q"
    fterminal_redraw
}
cmd_help()
{
    fterminal_clear
    fterminal_draw_tab_line
    fterminal_draw_status_line "Help info"
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    fHelp $@
    fcommand_line_interact "Press Enter Key To Continue..." "wait" "q"
    fterminal_redraw
}
cmd_msg_debug()
{
    if [ ${VAR_TERM_MSGWIN_SHOW} = true ]
    then
        VAR_TERM_MSGWIN_SHOW=false
    else
        VAR_TERM_MSGWIN_SHOW=true
    fi

    shift 1
    # VAR_TERM_MSGWIN_BUFFER=$(stat $*)
    # VAR_TERM_MSGWIN_BUFFER="$(stat $*)"
    printf -v VAR_TERM_MSGWIN_BUFFER "%s\n" $(stat $*)
    fterminal_redraw
}
cmd_task_debug()
{
    if [ ${VAR_TERM_TASKWIN_SHOW} = true ]
    then
        VAR_TERM_TASKWIN_SHOW=false
    else
        VAR_TERM_TASKWIN_SHOW=true
    fi

    shift 1

    printf -v VAR_TERM_TASKWIN_BUFFER "%s\n" $(stat $*)
    fterminal_redraw
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
    if [[ "${#}" -ge "1" ]]
    then
        eval "$@"
    fi
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
        ls)
            if [ "${args_value}" = "on" ]
            then
                HSFM_READ_DIR_MODE=1
            elif [ "${args_value}" = "off" ]
            then
                HSFM_READ_DIR_MODE=0
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
            if fenv_left_hande_mode "${args_value}"; then
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
cmd_quit()
{
    fgui_tab_close
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
cmd_exit()
{
    exit 0
}
fsys_open() {
    local var_file=""
    # flog_msg_debug "Open '$*'"
    if test -e "$*"; then
        var_file="${*}"
    else
        var_file="$(fget_cursor_file)"
    fi

    # Open directories and files.
    if [[ -d $var_file/ ]]; then
        VAR_SEARCH_MODE=
        VAR_TERM_SEARCH_END_EARLY=
        if test -r "${var_file:-/}"
        then
            cd "${var_file:-/}" ||:
            flog_msg_debug "Enter $var_file"
            fterminal_redraw full
        else
            flog_msg "Access fail on: ${var_file:-/}"
        fi

    elif [[ -f $var_file ]]; then
        # Figure out what kind of file we're working with.
        # Open all text-based files in '$EDITOR'.
        # Everything else goes through 'xdg-open'/'open'.
        case "$(fprase_mime_type $var_file)" in
            audio/*)
                cmd_media "$var_file"
                return 0
            ;;
            video/*)
                cmd_media "$var_file"
                return 0
            ;;
            image/*)
                cmd_image "$var_file"
                return 0
            ;;
            text/*|*x-empty*|*json*)
                cmd_editor "$var_file"
                return 0
            ;;
            application/zip*)
                # cmd_unzip "$var_file"
                cmd_extract "zip" "$var_file"
                return 0
            ;;
            application/x-tar*|application/x-xz*)
                cmd_extract "tar" "$var_file"
                return 0
            ;;
        esac

        # Try with file extension.
        case "${var_file##*.}" in
            tar|Z|xz|zip|7z|gz|rar|tbz2|tgz)
                cmd_extract "$var_file"
                return 0
            ;;
        esac

        # 'nohup':  Make the process immune to hangups.
        # '&':      Send it to the background.
        # 'disown': Detach it from the shell.
        if command -v ${HSFM_OPENER} > /dev/null
        then
            flog_msg_debug "Open file via ${HSFM_OPENER}"
            nohup "${HSFM_OPENER}" "$var_file" &>/dev/null &
            disown
        else
            flog_msg "Unknown file type: '$(fprase_mime_type $var_file)'"
        fi
    fi
}
## Visual CMD Function
###########################################################
# IMPL, it's an template command function for both vcmd/cmd
vcmd_compress()
{
    # currently only take one args.
    local arg_file_name="${1: }"
    # flog_msg_debug "compress:$@"
    local var_compress_cmd=""
    local var_file_ext=""
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
            if [[ "${VAR_TERM_SELECTION_FILE_LIST[@]}" -eq "1" ]]
            then
                arg_file_name="${VAR_TERM_SELECTION_FILE_LIST%%.*}.${var_file_ext}"
            else
                arg_file_name="${PWD##*/}.${var_file_ext}"
            fi
        fi

        if test -e ${arg_file_name}
        then
            flog_msg "${arg_file_name} exist, skip compression."
            return 0
        fi

        local tmp_cmd="${var_compress_cmd} ${arg_file_name} "
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
                fcommand_line_interact "${tmp_file##*/} exist. Overwrite(a.all/y.yes/d.duplicate/n.no/c.cancel/s.skip)? " y n

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
                    *|'d'|'D')
                        cp -R "${tmp_file}" "${var_target_folder}/copy_$(date +%s)_${tmp_file##*/}"
                        flag_duplicate=true
                        ;;
                    *|'n'|'N')
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
    if [[ $(($#-1)) == 1 ]] 
    then
        fcommand_line_interact "trash [$(($#-1))] items? [y/n]: " y n
    else
        fcommand_line_interact "trash [$(($#-1))] items? [y/n]: " y n
    fi

    [[ $VAR_TERM_CMD_INPUT_BUFFER != y ]] &&
        return

    if [[ $HSFM_TRASH_CMD ]]; then
        # Pass all but the last argument to the user's
        # custom script. command is used to prevent this function
        # from conflicting with commands named "fselect_remove".
        command "$HSFM_TRASH_CMD" "${@:1:$#-1}"

    else
        # FIXME, don't trash on different device/big file size
        rm -r "${@:1:$#-1}"

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
    # Bulk rename files using '$EDITOR'.
    rename_file=${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/fselect_rename
    VAR_TERM_MARKED_FILE_LIST=("${@:1:$#-1}")

    # Save marked files to a file and open them for editing.
    fterminal_print '%s\n' "${VAR_TERM_MARKED_FILE_LIST[@]##*/}" > "$rename_file"
    "${EDITOR:-vi}" "$rename_file"

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
        "${EDITOR:-vi}" "$rename_file"

        source "$rename_file"
        rm "$rename_file"
    }

    # Fix terminal settings after '$EDITOR'.
    fterminal_setup
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
    echo "cd ${PWD}" >> ${HSFM_FILE_SESSION}
}
fload_session() {
    if test -f ${HSFM_FILE_SESSION}
    then
        source ${HSFM_FILE_SESSION}
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
fsetup_osenv() {
    # Figure out the current operating system to set some specific variables.
    # '$OSTYPE' typically stores the name of the OS kernel.
    case $OSTYPE in
        # Mac OS X / macOS.
        darwin*)
            HSFM_OPENER=""
            VAR_TERM_FILE_ARGS=bIL

            VAR_TERM_DIR_LS_ARGS=("--color=none")
            VAR_TERM_DIR_LS_ARGS+=("-h -ld ")
        ;;

        linux*|*)
            # HSFM_OPENER=
            VAR_TERM_FILE_ARGS=biL

            VAR_TERM_DIR_LS_ARGS=("--color=none")
            VAR_TERM_DIR_LS_ARGS+=("--group-directories-first")
            VAR_TERM_DIR_LS_ARGS+=("-h -ld ")
        ;;
    esac
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
        VAR_TERM_READ_FLAGS=(-t 0.05)

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

fHelp_keymap() {
    fterminal_print "[KeyMap]\n"
    if false
    then
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_CHILD1"                ${HSFM_KEY_CHILD1}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_CHILD2"                ${HSFM_KEY_CHILD2}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_CHILD3"                ${HSFM_KEY_CHILD3}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_PARENT1"               ${HSFM_KEY_PARENT1}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_PARENT2"               ${HSFM_KEY_PARENT2}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_PARENT3"               ${HSFM_KEY_PARENT3}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_PARENT4"               ${HSFM_KEY_PARENT4}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_SCROLL_DOWN1"          ${HSFM_KEY_SCROLL_DOWN1}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_SCROLL_DOWN2"          ${HSFM_KEY_SCROLL_DOWN2}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_SCROLL_UP1"            ${HSFM_KEY_SCROLL_UP1}
        fterminal_print "    % -32s: %s\n"  "HSFM_KEY_SCROLL_UP2"            ${HSFM_KEY_SCROLL_UP2}
    fi

    fterminal_print "\n%s\n" "## Shortcut operations."
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_TO_TOP"                ${HSFM_KEY_TO_TOP}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_TO_BOTTOM"             ${HSFM_KEY_TO_BOTTOM}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_GO_HOME"               ${HSFM_KEY_GO_HOME}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_GO_TRASH"              ${HSFM_KEY_GO_TRASH}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_PREVIOUS"              ${HSFM_KEY_PREVIOUS}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_SEARCH"                ${HSFM_KEY_SEARCH}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_SHELL"                 ${HSFM_KEY_SHELL}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_OPEN_CMD"              ${HSFM_KEY_OPEN_CMD}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_HELP"                  ${HSFM_KEY_HELP}

    fterminal_print "\n%s\n" "## File operations."
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_YANK"                  ${HSFM_KEY_YANK}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_CUT"                   ${HSFM_KEY_CUT}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_TRASH"                 ${HSFM_KEY_TRASH}
    # fterminal_print "    % -32s: %s\n"  "HSFM_KEY_LINK"                  ${HSFM_KEY_LINK}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_PASTE"                 ${HSFM_KEY_PASTE}
    # fterminal_print "    % -32s: %s\n"  "HSFM_KEY_MKDIR"                 ${HSFM_KEY_MKDIR}
    # fterminal_print "    % -32s: %s\n"  "HSFM_KEY_MKFILE"                ${HSFM_KEY_MKFILE}

    fterminal_print "\n%s\n" "## Miscellaneous"
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_ATTRIBUTES"            ${HSFM_KEY_ATTRIBUTES}
    # fterminal_print "    % -32s: %s\n"  "HSFM_KEY_EXECUTABLE"            ${HSFM_KEY_EXECUTABLE}
    fterminal_print "    % -32s: %s\n"  "HSFM_KEY_HIDDEN"                ${HSFM_KEY_HIDDEN}
}
fHelp_commands() {
    echo "FileManager"
    fterminal_print "[Options]\n"
    fterminal_print "    %- 16s\t%s\n" "-s|-setup   " "Copy hsfm config file."
    fterminal_print "    %- 16s\t%s\n" "-d|--debug  " "Enable debug flag."
    fterminal_print "    %- 16s\t%s\n" "-r|--restore" "restore previous session."
    fterminal_print "    %- 16s\t%s\n" "-l|--last   " "Print last path & remove the last path file."
    fterminal_print "    %- 16s\t%s\n" "--history   " "Store history."
    fterminal_print "[Commands]\n"
    fterminal_print "    % -16s: %s\n"  "redraw" "Commands."
    fterminal_print "    % -16s: %s\n"  "search" "Commands."
    fterminal_print "    % -16s: %s\n"  "mkdir " "Commands."
    fterminal_print "    % -16s: %s\n"  "mkfile" "Commands."
    fterminal_print "    % -16s: %s\n"  "touch " "Commands."
    fterminal_print "    % -16s: %s\n"  "open  " "Commands."
    fterminal_print "    % -16s: %s\n"  "exit  " "Commands."
    fterminal_print "    % -16s: %s\n"  "rename" "Commands."
    fterminal_print "    % -16s: %s\n"  "more  " "Commands."
    fterminal_print "    % -16s: %s\n"  "help  " "Commands. Accept option for key/map"
    fterminal_print "[Other commands]\n"
    # fterminal_print "    % -16s: %s\n" ""  "${VAR_TERM_CMD_LIST[@]}"
    fterminal_print "    % -16s: " "Normal Command"
    fterminal_print "%s, "   "${VAR_TERM_CMD_LIST[@]}"
    fterminal_print "\n"
    fterminal_print "    % -16s: " "Selction Command"
    fterminal_print "%s, "   "${VAR_TERM_SELECT_CMD_LIST[@]}"
    fterminal_print "\n"
    fterminal_print "[TODO Funcion]\n"
    fterminal_print "    %s\n"  "The following function is under constructure."
    fterminal_print "    %s\n"  "#. Add find function and Search/find list persistent."
    fterminal_print "    %s\n"  "#. Support 256 color and colorscheme."
    fterminal_print "    %s\n"  "#. Mini window, collecting various window. replace check in command line."
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

## Core Function
###########################################################
function fCore() {
    # restore runtime env.
    fload_env

    fsetup_osenv
    fsetup_options
    fsetup_shell

    fterminal_get_size
    fterminal_setup
    fterminal_redraw full

    flog_msg_debug "HSFM initialized."

    HSFM_RUNNING=1
    # Vintage infinite loop.
    for ((;HSFM_RUNNING;)); {
        # read "${VAR_TERM_READ_FLAGS[@]}" -srn 1 && {
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
                fterminal_draw_status_line
                # Discard following input
                read -t 0 -rsn 10000 _
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
            -r|-restore)
                fload_session
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

    if [[ $HSFM_RUNNING = 1 ]]
    then
        echo "HSFM is running. Status: $HSFM_RUNNING"
        exit 1
    elif [[ $HSFM_DEBUG = true ]]
    then
        # Record stderr
        fCore 2> >(tee ${HSFM_FILE_LOGS} >&2)
    else
        fCore
    fi
}

fMain $@
