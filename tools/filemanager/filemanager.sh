#!/usr/bin/env bash
###########################################################
## Flags
###########################################################
export HSFM_RUNNING=1
export HSFM_DEBUG=true

# Use LS_COLORS to color hsfm.
# (On by default if available)
# (Ignores HSFM_COL1)
export HSFM_LS_COLORS=1

# Show/Hide hidden files on open.
# (On by default)
export HSFM_ENABLE_HIDDEN=0

export HSFM_FILE_PICKER=0

export HSFM_READ_WITH_LS=1

## TERMINAL Vars Options
###########################################################
# Terminal Atrib
export VAR_TERM_READ_FLAGS=()

## Terminal UI control
export VAR_TERM_SCROLL_CURSOR=0
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

# Buffer
export VAR_TERM_PRINT_BUFFER_ENABLE=false
export VAR_TERM_PRINT_BUFFER=""
export VAR_TERM_KEY_CURRENT_INPUT=""

# Marks
export VAR_TERM_FILE_PRE=""
export VAR_TERM_FILE_POST=""
export VAR_TERM_MARK_PRE=""
export VAR_TERM_MARK_POST=""

## Tab Line
export VAR_TERM_TAB_LINE_IDX=0
export VAR_TERM_TAB_LINE_LIST
export VAR_TERM_TAB_LINE_BUFFER=""

## Status Line
export VAR_TERM_FIND_PREVIOUS
export VAR_TERM_MARKED_FILE_LIST=()
export VAR_TERM_MARK_DIR=""
export VAR_TERM_SELECTION_FILE_LIST=()
export VAR_TERM_FILE_PROGRAM=()

# Cmd line
export VAR_TERM_CMD_INPUT_BUFFER=""
export VAR_TERM_CMD_LIST=( "redraw" "fullredraw" "help" "info" "exit" "select" "shell" )
VAR_TERM_CMD_LIST+=( "mkdir" "mkfile" "touch" "rename" "search" )
VAR_TERM_CMD_LIST+=( "open" "editor" "vim" "media" "play" "image" "preview" )

# Mode
export VAR_TERM_VISUAL_START_IDX=0
export VAR_TERM_OPS_MODE='n'

## Others
export VAR_TERM_SEARCH_END_EARLY=0

## Themes & colors
###########################################################
# Directory color [0\-9]
export HSFM_COLOR_DIR=32

# Selection color [0\-9] (copied/moved files)
export HSFM_COLOR_SELECTION=100

export HSFM_COLOR_TAB_SELECTION_FG=97
export HSFM_COLOR_TAB_SELECTION_BG=100

export HSFM_COLOR_TAB_BOOKMARK_FG=97
export HSFM_COLOR_TAB_BOOKMARK_BG=100

# Cursor color [0\-9]
# export HSFM_COL4=1
export HSFM_COLOR_CURSOR=37

# Status color
export HSFM_COLOR_STATUS_FG=30
export HSFM_COLOR_STATUS_BG=43

## Others
###########################################################
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

# CD on exit helper file
# Default: '${XDG_CACHE_HOME}/hsfm/hsfm.d'
#          If not using XDG, '${HOME}/.cache/hsfm/hsfm.d' is used.
export HSFM_STORE_PATH="${HOME}/.cache/hsfm"
export HSFM_SESSION_FILE=${HSFM_STORE_PATH}/hsfm_session.sh
export HSFM_CD_FILE=${HSFM_STORE_PATH}/hsfm_history.log
export HSFM_MESSAGE_FILE=${HSFM_STORE_PATH}/hsfm_message.log

# Trash Directory
# Default: '${XDG_DATA_HOME}/hsfm/trash'
#          If not using XDG, '${XDG_DATA_HOME}/hsfm/trash' is used.
export HSFM_TRASH="${HOME}/.trash"

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
export HSFM_FAV9=${HSFM_STORE_PATH}

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

# Search.
export HSFM_KEY_SEARCH="/"

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

### Miscellaneous
# Show file attributes.
export HSFM_KEY_ATTRIBUTES="i"

# Toggle hidden files.
export HSFM_KEY_HIDDEN="."

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
    printf "${VAR_TERM_PRINT_BUFFER}"
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
    fterminal_print '\e[?7h\e[?25h\e[2J\e[;r\e[?1049l'

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
    flog_msg "Window resized"
}
fHSFM_exit()
{
    HSFM_RUNNING=0
    fsave_settings
    fterminal_reset
    fterminal_print "FM finished.\n"
    exit 0
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
        VAR_TERM_CONTENT_SCROLL_IDX=0
        VAR_TERM_SCROLL_CURSOR=0
    }
    # order is important, don't change it.
    # clear before redraw, avoid glict/search result incorrect.
    VAR_TERM_PRINT_BUFFER_ENABLE=true

    fterminal_clear
    fterminal_draw_dir
    fterminal_draw_tab_line
    fterminal_draw_status_line

    fterminal_flush
}
fterminal_draw_dir() {
    # Print the max directory items that fit in the VAR_TERM_CONTENT_SCROLL_IDX area.
    local var_scroll_start=$VAR_TERM_CONTENT_SCROLL_IDX
    local var_scroll_new_cursor
    local var_scroll_end
    local var_scroll_len=$(($VAR_TERM_CONTENT_MAX_CNT - 1))

    # When going up the directory tree, place the cursor on the position
    # of the previous directory.
    ((VAR_TERM_FIND_PREVIOUS == 1)) && {
        ((VAR_TERM_CONTENT_SCROLL_IDX=previous_index))

        # Clear the directory history. We're here now.
        VAR_TERM_FIND_PREVIOUS=
    }

    # If the list in shorter then window, or the scroll idx == 0
    if ((VAR_TERM_DIR_LIST_CNT < VAR_TERM_CONTENT_MAX_CNT || VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_CONTENT_MAX_CNT)); then
        ((var_scroll_start=0))
        ((var_scroll_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX))
        # flog_msg "1/$var_scroll_start/$var_scroll_new_cursor"
    elif ((VAR_TERM_CONTENT_SCROLL_IDX + VAR_TERM_CONTENT_MAX_CNT > VAR_TERM_DIR_LIST_CNT)); then
        # If the list is greater then win size, and in the last page
        ((var_scroll_start=VAR_TERM_DIR_LIST_CNT-VAR_TERM_CONTENT_MAX_CNT + 1))
        ((var_scroll_new_cursor=VAR_TERM_CONTENT_SCROLL_IDX - var_scroll_start))
        # flog_msg "2/$var_scroll_start/$var_scroll_new_cursor"
    else
        # If in the midddle of the dir list.
        ((var_scroll_start=VAR_TERM_CONTENT_SCROLL_IDX-VAR_TERM_SCROLL_CURSOR))
        ((var_scroll_new_cursor=VAR_TERM_SCROLL_CURSOR))
        # flog_msg "else/$var_scroll_start/$var_scroll_new_cursor"
    fi

    # Update Scroll index
    ((VAR_TERM_CONTENT_SCROLL_IDX=var_scroll_new_cursor+var_scroll_start))
    ((VAR_TERM_CONTENT_SCROLL_START_IDX=var_scroll_start))

    # local var_col_offset=15
    # Reset cursor position.
    # fterminal_print '\e[H'
    # fterminal_print '\e[%s;%sH' "$((1 + ${VAR_TERM_TAB_LINE_HEIGHT}))" "${var_col_offset}"

    for ((idx=0;idx<=var_scroll_len;idx++)); {
        # Don't print one too many newlines.
        # if ((idx > 0))
        # then
        #     fterminal_print '\e[%s;%sH' "$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + idx))" "${var_col_offset}"
        #     # fterminal_print '\n'
        # fi

        if [[ -z ${VAR_TERM_DIR_FILE_LIST[$((var_scroll_start + idx))]} ]]; then
            break
        fi

        fterminal_draw_file_line "$((var_scroll_start + idx))"
    }

    # Move the cursor to its new position if it changed.
    # If the variable 'var_scroll_new_cursor' is empty, the cursor
    # is moved to line '0'.
    fterminal_print '\e[%sH' "$(($var_scroll_new_cursor+1+VAR_TERM_TAB_LINE_HEIGHT))"
    # fterminal_print '\e[%sH' "$((${var_scroll_new_cursor} + ${VAR_TERM_TAB_LINE_HEIGHT}))"
    ((VAR_TERM_SCROLL_CURSOR=var_scroll_new_cursor))
}
fterminal_draw_tab_line() {
    # Status_line to print when files are marked for operation.
    local var_tab_list_buf=""
    local var_tab_list_pre_buf=""
    local var_tab_list_post_buf=""
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    # Escape the directory string.
    # Remove all non-printable characters.
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"

    for each_idx in "${!VAR_TERM_TAB_LINE_LIST[@]}"
    do
        if ! test -d "${VAR_TERM_TAB_LINE_LIST[${each_idx}]}"
        then
            continue
        fi
        if [ "${VAR_TERM_TAB_LINE_IDX}" = "${each_idx}" ]
        then
            var_tab_list_buf=${var_tab_list_buf}"${each_idx}: ${VAR_TERM_TAB_LINE_LIST[${each_idx}]##*/}"
        elif [[ "${VAR_TERM_TAB_LINE_IDX}" -gt "${each_idx}" ]]
        then
            var_tab_list_pre_buf=${var_tab_list_pre_buf}"${each_idx}: ${VAR_TERM_TAB_LINE_LIST[${each_idx}]##*/}|"
        else
            var_tab_list_post_buf=${var_tab_list_post_buf}"${each_idx}: ${VAR_TERM_TAB_LINE_LIST[${each_idx}]##*/}|"
        fi
    done

    # Escape the directory string.
    # Remove all non-printable characters.
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    local var_pwd_escaped=${PWD//[^[:print:]]/^[}

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

    fterminal_print '\e7\e[%sH\e[%s;%sm%*s\rFM %s\e[%s;%sm%s\e[%s;%sm%s\e[m\e8' \
           "$((1))" \
           "${HSFM_COLOR_STATUS_FG}" \
           "${HSFM_COLOR_STATUS_BG}" \
           "$VAR_TERM_COLUMN_CNT" "" \
           "|${var_tab_list_pre_buf}" \
           "${HSFM_COLOR_TAB_SELECTION_FG}" \
           "${HSFM_COLOR_TAB_SELECTION_BG}" \
           "${var_tab_list_buf}" \
           "${HSFM_COLOR_STATUS_FG}" \
           "${HSFM_COLOR_STATUS_BG}" \
           "|${var_tab_list_post_buf}"
           # "|${1:-${var_pwd_escaped:-/}}|${var_tab_list_buf[@]}"


    # bookmark bar
    fterminal_print '\e7\e[%sH\e[%s;%sm%*s\rBM | %s |\e[m\e8' \
           "$((2))" \
           "${HSFM_COLOR_TAB_BOOKMARK_FG}" \
           "${HSFM_COLOR_TAB_BOOKMARK_BG}" \
           "$VAR_TERM_COLUMN_CNT" "" \
           "1 :${HSFM_FAV1##*/} | 2:${HSFM_FAV2##*/} | 3:${HSFM_FAV3##*/} | 4:${HSFM_FAV4##*/} | 5:${HSFM_FAV5##*/} | 6:${HSFM_FAV6##*/} | 7:${HSFM_FAV7##*/} | 8:${HSFM_FAV8##*/} | 9:${HSFM_FAV9##*/}"
}
fterminal_draw_status_line() {
    # Status_line to print when files are marked for operation.
    local var_mark_ui="[${#VAR_TERM_MARKED_FILE_LIST[@]} selected]"
    local var_left=""
    local var_left_cnt=""
    local var_right=""
    local var_right_cnt=""
    local var_spacing=""
    local var_content_cnt=""

    # Escape the directory string.
    # Remove all non-printable characters.
    local var_pwd_escaped=${PWD//[^[:print:]]/^[}

    ## Update content
    var_left=[${VAR_TERM_OPS_MODE}]
    var_left+="${VAR_TERM_MARKED_FILE_LIST[*]:+${var_mark_ui}}"
    var_left+="${1:-${var_pwd_escaped:-/}}"

    if [[ ${#VAR_TERM_KEY_CURRENT_INPUT} -ne 0 ]]
    then
        # var_right+="${VAR_TERM_KEY_CURRENT_INPUT} "
        var_right+=$(printf "Key %- 3s" "${VAR_TERM_KEY_CURRENT_INPUT}")
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

    # fterminal_print '\e7\e[%sH\e[%s;%sm%*s\r%s %s%s\e[m\e[%sH\e[K\e8' \
    #        "$((VAR_TERM_LINE_CNT-1))" \
    #        "${HSFM_COLOR_STATUS_FG:-30}" \
    #        "${HSFM_COLOR_STATUS_BG:-41}" \
    #        "$VAR_TERM_COLUMN_CNT" "" \
    #        "($((VAR_TERM_CONTENT_SCROLL_IDX + 1))/$((VAR_TERM_DIR_LIST_CNT + 1)))" \
    #        "${VAR_TERM_MARKED_FILE_LIST[*]:+${var_mark_ui}}" \
    #        "${1:-${var_pwd_escaped:-/}}" \
    #        "$VAR_TERM_LINE_CNT"

    fterminal_print "\e7\e[%sH\e[%s;%sm%*s\r%s%s%s\e[m\e[%sH\e[K\e8" \
           "$((VAR_TERM_LINE_CNT-1))" \
           "${HSFM_COLOR_STATUS_FG:-30}" \
           "${HSFM_COLOR_STATUS_BG:-41}" \
           "$VAR_TERM_COLUMN_CNT" "" \
           "${var_left}" \
           "${var_spacing}" \
           "${var_right}" \
           "$VAR_TERM_LINE_CNT"
}

fterminal_draw_file_line() {

    # If the dir item doesn't exist, end here.
    if [[ -z ${VAR_TERM_DIR_FILE_LIST[$1]} ]]; then
        return
    fi

    # Format the VAR_TERM_DIR_FILE_LIST item and print it.
    local var_content_idx=$1
    local var_file_name=${VAR_TERM_DIR_FILE_LIST[$var_content_idx]##*/}
    # local var_file_name=${VAR_TERM_DIR_FILE_LIST[$var_content_idx]}
    local var_file_ext=${var_file_name##*.}
    local var_format
    local var_postfix
    local var_prefix
    # local file_info="$(ls -al $PWD | grep ${var_file_name}\$ | sed 's/ [^ ]\+$//')"
    local file_info="${VAR_TERM_DIR_FILE_INFO_LIST[$var_content_idx]}"

    # Directory.
    if [[ -d "${VAR_TERM_DIR_FILE_LIST[$var_content_idx]}" ]]; then
        var_format+=\\e[${di:-1;${HSFM_COLOR_DIR:-32}}m
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

    local var_col_offset=0
    local var_line_offset=0
    if ((var_content_idx - VAR_TERM_CONTENT_SCROLL_START_IDX >= VAR_TERM_CONTENT_MAX_CNT))
    then
        ((VAR_TERM_CONTENT_SCROLL_START_IDX=$var_content_idx-$VAR_TERM_CONTENT_MAX_CNT+1))
        var_line_offset=$((${VAR_TERM_TAB_LINE_HEIGHT} + ${VAR_TERM_CONTENT_MAX_CNT}))
    elif ((var_content_idx < VAR_TERM_CONTENT_SCROLL_START_IDX))
    then
        ((VAR_TERM_CONTENT_SCROLL_START_IDX=var_content_idx))
        var_line_offset=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT}))
    else
        var_line_offset=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + ${var_content_idx} - ${VAR_TERM_CONTENT_SCROLL_START_IDX}))
    fi

    fterminal_print '\e[%s;%sH' "${var_line_offset}" "${var_col_offset}"

    fterminal_print '%b%s\e[m\e[K\r' \
        " ${VAR_TERM_FILE_PRE}${var_format}" \
        "${file_info} ${var_prefix}${var_file_name}${var_postfix}${VAR_TERM_FILE_POST}"
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
    #     ${HSFM_KEY_YANK:=y}|${HSFM_KEY_YANK_ALL:=Y}) VAR_TERM_FILE_PROGRAM=(cp -iR) ;;
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

    fterminal_draw_status_line
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

    fterminal_draw_status_line
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

    fterminal_draw_status_line
}
fterminal_read_dir() {
    # Read a directory to an array and sort it directories first.
    local var_pattern="*"
    local var_dirs
    local var_files
    local var_item_index
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

    if [[ $HSFM_READ_WITH_LS == 0 ]]
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
    else
        local var_ls_args=(${VAR_TERM_DIR_LS_ARGS[@]})
        if [[ ${HSFM_ENABLE_HIDDEN} -eq 0 ]]
        then
            var_ls_args+=("-A")
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

            each_line="${each_line%% ->*}"

            info="${each_line%% /*}"
            # item="${each_line/* \'/}"
            # item="${each_line/* /}"

            item=${each_line/#*[0-9]? \//\/}

            if [[ -d $item ]]; then
                # var_dirs+=("$item")
                VAR_TERM_DIR_FILE_LIST+=("$item")
                VAR_TERM_DIR_FILE_INFO_LIST+=("$info")

                # Find the position of the child directory in the
                # parent directory list.
                [[ $item == "$OLDPWD" ]] &&
                    ((previous_index=var_item_index))
                                ((var_item_index++))
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
        done << EOF
$(ls ${var_ls_args[@]} "${PWD}"/${var_pattern})
EOF
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
    read "${VAR_TERM_READ_FLAGS[@]}" -srn 1
    local ret_value=$?
    if [[ ${REPLY} == $'\e' ]]
    then
        local tmp_buffer="${REPLY}"
        read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2

        # Handle a normal escape key press.
        [[ ${tmp_buffer}${REPLY} == $'\e\e['* ]] &&
            read "${VAR_TERM_READ_FLAGS[@]}" -rsn 1 _

        REPLY=${tmp_buffer}${REPLY}
        # VAR_TERM_KEY_CURRENT_INPUT="ESC"${REPLY:1:2}
        VAR_TERM_KEY_CURRENT_INPUT="ESC"${REPLY:1}
    elif [[ ${ret_value} ]]
    then
        VAR_TERM_KEY_CURRENT_INPUT="${REPLY}"
    else
        VAR_TERM_KEY_CURRENT_INPUT=""
    fi
    return ${ret_value}
}


###########################################################
## GUI Functions
###########################################################

fmode_setup()
{
    case ${1} in
        'V'|'v')
            VAR_TERM_OPS_MODE='v'
            # setup visual mode
            VAR_TERM_VISUAL_START_IDX=$VAR_TERM_CONTENT_SCROLL_IDX
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
            VAR_TERM_SELECTION_FILE_LIST=()
            ;;
        'S'|'s')
            VAR_TERM_OPS_MODE='s'
            # setup selection mode
            fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
            VAR_TERM_SELECTION_FILE_LIST=()
            ;;
        *|'N'|'n')
            VAR_TERM_OPS_MODE='n'
            fterminal_mark_reset
            ;;
    esac
}
fnormal_mode_handler() {
    # Handle special key presses.
    # [[ $1 == $'\e' ]] && {
    #     read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2
    #
    #     # Handle a normal escape key press.
    #     [[ ${1}${REPLY} == $'\e\e['* ]] &&
    #         read "${VAR_TERM_READ_FLAGS[@]}" -rsn 1 _
    #
    #     local var_special_key=${1}${REPLY}
    # }

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fsys_open "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
        ;;
        ${HSFM_KEY_VISUAL_SELECT:="V"})
            fmode_setup "v"
            # fterminal_redraw
        ;;
        ${HSFM_KEY_SELECTION})
            fmode_setup "s"
            # fterminal_redraw
        ;;
        # Open VAR_TERM_DIR_FILE_LIST item.
        # 'C' is what bash sees when the right arrow is pressed
        # ('\e[C' or '\eOC').
        ${HSFM_KEY_CHILD1:=l}|\
        ${HSFM_KEY_CHILD2:=$'\e[C'}|\
        ${HSFM_KEY_CHILD4:=$'\eOC'})
            # only check if it's directory.
            if test -d "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
            then
                fsys_open "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            else
                # flog_msg $(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" | tail -n 1)
                flog_msg "File type: $(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" | tail -n 1 | cut -d ':' -f2)"
            fi
        ;;

        # Go to the parent directory.
        # 'D' is what bash sees when the left arrow is pressed
        # ('\e[D' or '\eOD').
        # '\177' and '\b' are what bash sometimes sees when the backspace
        # key is pressed.
        ${HSFM_KEY_PARENT1:=h}|\
        ${HSFM_KEY_PARENT2:=$'\e[D'}|\
        ${HSFM_KEY_PARENT3:=$'\177'}|\
        ${HSFM_KEY_PARENT4:=$'\b'}|\
        ${HSFM_KEY_PARENT5:=$'\eOD'})
            # If a search was done, clear the results and open the current dir.
            if ((VAR_SEARCH_MODE == 1 && VAR_TERM_SEARCH_END_EARLY != 1)); then
                fsys_open "$PWD"

            # If '$PWD' is '/', do nothing.
            elif [[ $PWD && $PWD != / ]]; then
                VAR_TERM_FIND_PREVIOUS=1
                fsys_open "${PWD%/*}"
            fi
        ;;

        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j}|\
        ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'}|\
        ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
                ((VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_DIR_LIST_CNT)) && {
                    VAR_TERM_PRINT_BUFFER_ENABLE=true
                    ((VAR_TERM_CONTENT_SCROLL_IDX++))

                fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX-1))
                fterminal_print "\n"

                if ((VAR_TERM_SCROLL_CURSOR + 1 < VAR_TERM_CONTENT_MAX_CNT))
                then
                    ((VAR_TERM_SCROLL_CURSOR++))
                else
                    # FIXME, it's a patch to avoid glitch
                    # clear the first content line
                    # fterminal_print '\e7\e[2H\e[K\e8'
                    fterminal_draw_tab_line
                    fterminal_print "\e[$((VAR_TERM_CONTENT_MAX_CNT + VAR_TERM_TAB_LINE_HEIGHT))H"
                fi
                fterminal_draw_file_line $((VAR_TERM_CONTENT_SCROLL_IDX))
                fterminal_draw_status_line
                fterminal_flush
                }
        ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k}|\
        ${HSFM_KEY_SCROLL_UP2:=$'\e[A'}|\
        ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            # '\e[1L': Insert a line above the cursor.
            # '\e[A':  Move cursor up a line.
            ((VAR_TERM_CONTENT_SCROLL_IDX > 0)) && {
                VAR_TERM_PRINT_BUFFER_ENABLE=true
                ((VAR_TERM_CONTENT_SCROLL_IDX--))

                fterminal_draw_file_line "$((VAR_TERM_CONTENT_SCROLL_IDX+1))"

                if ((VAR_TERM_SCROLL_CURSOR < 1)); then
                    fterminal_print '\e[L'
                else
                    fterminal_print '\e[A'
                    ((VAR_TERM_SCROLL_CURSOR--))
                fi
                fterminal_draw_file_line $VAR_TERM_CONTENT_SCROLL_IDX
                fterminal_draw_tab_line
                fterminal_draw_status_line
                fterminal_flush
            }
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
                ((VAR_TERM_CONTENT_SCROLL_IDX=VAR_TERM_DIR_LIST_CNT))
                fterminal_redraw
            }
        ;;

        # Tab selcet
        ${HSFM_KEY_GO_PREVIOUS_TAB})
            if [[ ${#VAR_TERM_TAB_LINE_LIST[@]} -eq 1 ]] ||
                [[ ${VAR_TERM_TAB_LINE_IDX} -eq 0 ]]
            then
                flog_msg "PREVIOUS_TAB ignored."
                return
            else
                VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
                VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX - 1))
                cd ${VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]}
                fterminal_redraw full
                flog_msg "Go PREVIOUS_TAB."
            fi
        ;;

        ${HSFM_KEY_GO_NEXT_TAB})
            if [[ ${#VAR_TERM_TAB_LINE_LIST[@]} -eq 1 ]] ||
                (( ${VAR_TERM_TAB_LINE_IDX} + 1 == ${#VAR_TERM_TAB_LINE_LIST[@]} )) ||
                ! test -d ${VAR_TERM_TAB_LINE_LIST[(( ${VAR_TERM_TAB_LINE_IDX} + 1))]}

            then
                flog_msg "NEXT_TAB ignored."
                return
            else
                VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
                VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX + 1))
                cd ${VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]}
                fterminal_redraw full
                flog_msg "Go NEXT_TAB"
            fi
        ;;
        ${HSFM_KEY_MOVE_TAB_PREVIOUS})
            if [[ ${#VAR_TERM_TAB_LINE_LIST[@]} -eq 1 ]] ||
                [[ ${VAR_TERM_TAB_LINE_IDX} -eq 0 ]]
            then
                flog_msg "MOVE_PREVIOUS_TAB ignored."
                return
            else
                tmp_preserved_path=${VAR_TERM_TAB_LINE_LIST[$((${VAR_TERM_TAB_LINE_IDX}-1))]}
                VAR_TERM_TAB_LINE_LIST[$((${VAR_TERM_TAB_LINE_IDX} - 1))]="$(realpath .)"
                VAR_TERM_TAB_LINE_LIST[$((${VAR_TERM_TAB_LINE_IDX}))]="${tmp_preserved_path}"
                VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX - 1))

                fterminal_redraw
                flog_msg "Move to PREVIOUS_TAB."
            fi
        ;;

        ${HSFM_KEY_MOVE_TAB_NEXT})
            if [[ ${#VAR_TERM_TAB_LINE_LIST[@]} -eq 1 ]] ||
                (( ${VAR_TERM_TAB_LINE_IDX} + 1 == ${#VAR_TERM_TAB_LINE_LIST[@]} )) ||
                ! test -d ${VAR_TERM_TAB_LINE_LIST[(( ${VAR_TERM_TAB_LINE_IDX} + 1))]}

            then
                flog_msg "MOVE_NEXT_TAB ignored."
                return
            else
                tmp_preserved_path=${VAR_TERM_TAB_LINE_LIST[$((${VAR_TERM_TAB_LINE_IDX}+1))]}
                VAR_TERM_TAB_LINE_LIST[$((${VAR_TERM_TAB_LINE_IDX}+1))]="$(realpath .)"
                VAR_TERM_TAB_LINE_LIST[$((${VAR_TERM_TAB_LINE_IDX}))]="${tmp_preserved_path}"
                VAR_TERM_TAB_LINE_IDX=$(($VAR_TERM_TAB_LINE_IDX + 1))

                fterminal_redraw
                flog_msg "Move to NEXT_TAB"
            fi
        ;;
        ${HSFM_KEY_OPEN_TAB})
            VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"

            # move tab to insert a new tab.
            ((each_idx=${#VAR_TERM_TAB_LINE_LIST[@]} - 1))
            while ((${each_idx} > ${VAR_TERM_TAB_LINE_IDX})) &&  ((each_idx != VAR_TERM_TAB_LINE_IDX))
            do
                VAR_TERM_TAB_LINE_LIST[$((${each_idx} + 1))]="${VAR_TERM_TAB_LINE_LIST[$((${each_idx}))]}"
                ((each_idx-=1))
            done

            VAR_TERM_TAB_LINE_IDX=$((${VAR_TERM_TAB_LINE_IDX} + 1))
            if test -d "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            then
                cd "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            fi
            VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]="$(realpath .)"
            fterminal_redraw full
            # flog_msg "HSFM_KEY_OPEN_TAB.${VAR_TERM_TAB_LINE_IDX}"$(fget_selection)
        ;;
        ${HSFM_KEY_CLOSE_TAB})
            if [[ ${#VAR_TERM_TAB_LINE_LIST[@]} -eq 1 ]]
            then
                flog_msg "CLOSE_TAB ignored."
                return
            else
                each_idx=${VAR_TERM_TAB_LINE_IDX}
                while ((${each_idx} < ${#VAR_TERM_TAB_LINE_LIST[@]}))
                do
                    if ((${each_idx} + 1 <  ${#VAR_TERM_TAB_LINE_LIST[@]}))
                    then
                        VAR_TERM_TAB_LINE_LIST[${each_idx}]="${VAR_TERM_TAB_LINE_LIST[$((${each_idx} + 1))]}"
                    elif ((${each_idx} + 1 == ${#VAR_TERM_TAB_LINE_LIST[@]}))
                    then
                        tmp_remove_pattern="hsfm_removed"
                        VAR_TERM_TAB_LINE_LIST[${each_idx}]=${tmp_remove_pattern}
                        VAR_TERM_TAB_LINE_LIST=(${VAR_TERM_TAB_LINE_LIST[@]/${tmp_remove_pattern}})
                        break
                    fi
                    ((each_idx+=1))
                done

                if [[ ${VAR_TERM_TAB_LINE_IDX} -ne 0 ]]
                then
                    VAR_TERM_TAB_LINE_IDX=$((VAR_TERM_TAB_LINE_IDX - 1 ))
                fi

                cd ${VAR_TERM_TAB_LINE_LIST[${VAR_TERM_TAB_LINE_IDX}]}
                fterminal_redraw full
                flog_msg "Tab closed."
            fi
        ;;

        # Show hidden files.
        ${HSFM_KEY_HIDDEN:=.})
            # 'a=a>0?0:++a': Toggle between both values of 'shopt_flags'.
            #                This also works for '3' or more values with
            #                some modification.
            if [[ ${HSFM_ENABLE_HIDDEN} == 0 ]]
            then
                HSFM_ENABLE_HIDDEN=1
            else
                HSFM_ENABLE_HIDDEN=0
            fi
            shopt_flags=(u s)
            shopt -"${shopt_flags[$HSFM_ENABLE_HIDDEN]}" dotglob
            fterminal_redraw full
            # flog_msg "Hidden: $HSFM_ENABLE_HIDDEN/${shopt_flags[$HSFM_ENABLE_HIDDEN]}"
        ;;

        # Search.
        ${HSFM_KEY_SEARCH:=/})
            fcommand_handler "search" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"

            # If the search came up empty, fterminal_redraw the current dir.
            if [[ -z ${VAR_TERM_DIR_FILE_LIST[*]} ]]; then
                VAR_TERM_DIR_FILE_LIST=("${cur_list[@]}")
                ((VAR_TERM_DIR_LIST_CNT=${#VAR_TERM_DIR_FILE_LIST[@]}-1))
                fterminal_redraw
                VAR_SEARCH_MODE=
            else
                VAR_SEARCH_MODE=1
            fi
        ;;

        # Spawn a shell.
        ${HSFM_KEY_SHELL:=!})
            cmd_shell
        ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # FIXME, if command change cursor pos, it will be resotre to wier position
            fcommand_handler "command" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
        ;;

        # Show file attributes.
        ${HSFM_KEY_ATTRIBUTES:=x})
            [[ -e "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" ]] && {
                cmd_stat "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
                # fterminal_clear
                # # fterminal_draw_tab_line
                # fterminal_draw_status_line "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
                # "${HSFM_STAT_CMD:-stat}" "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
                # read -ern 1
                # fterminal_redraw
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
            fsys_open "$HSFM_TRASH"
        ;;

        # Go to previous dir.
        ${HSFM_KEY_PREVIOUS:=-})
            fsys_open "$OLDPWD"
        ;;

        # # Refresh current dir.
        ${HSFM_KEY_REFRESH:=r})
            fterminal_redraw
            flog_msg "window refreshed."
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
            VAR_TERM_FILE_PROGRAM=(cp -iR)
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

        # Quit and store current directory in a file for CD on exit.
        # Don't allow user to redefine 'q' so a bad keybinding doesn't
        # remove the option to quit.
        q)
            cmd_exit
            # : "${HSFM_CD_FILE:=${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/.hsfm_d}"
            #
            # [[ -w $HSFM_CD_FILE ]] &&
            #     rm "$HSFM_CD_FILE"
            #
            # [[ ${HSFM_CD_ON_EXIT:=1} == 1 ]] &&
            #     fterminal_print '%s\n' "$PWD" > "$HSFM_CD_FILE"
            #
            # exit
        ;;
    esac
    fterminal_flush
}
fvisual_mode_handler() {
    # Handle special key presses.
    # [[ $1 == $'\e' ]] && {
    #     read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2
    #
    #     # Handle a normal escape key press.
    #     [[ ${1}${REPLY} == $'\e\e['* ]] &&
    #         read "${VAR_TERM_READ_FLAGS[@]}" -rsn 1 _
    #
    #     local var_special_key=${1}${REPLY}
    # }

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fmode_setup "n"
        ;;
        # Open VAR_TERM_DIR_FILE_LIST item.
        # 'C' is what bash sees when the right arrow is pressed
        # ('\e[C' or '\eOC').
        ${HSFM_KEY_CHILD1:=l}|\
        ${HSFM_KEY_CHILD2:=$'\e[C'}|\
        ${HSFM_KEY_CHILD4:=$'\eOC'})
            # only check if it's directory.
            if test -d "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
            then
                fsys_open "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            else
                # flog_msg $(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" | tail -n 1)
                flog_msg "File type: $(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" | tail -n 1 | cut -d ':' -f2)"
            fi
        ;;

        # Go to the parent directory.
        # 'D' is what bash sees when the left arrow is pressed
        # ('\e[D' or '\eOD').
        # '\177' and '\b' are what bash sometimes sees when the backspace
        # key is pressed.
        ${HSFM_KEY_PARENT1:=h}|\
        ${HSFM_KEY_PARENT2:=$'\e[D'}|\
        ${HSFM_KEY_PARENT3:=$'\177'}|\
        ${HSFM_KEY_PARENT4:=$'\b'}|\
        ${HSFM_KEY_PARENT5:=$'\eOD'})
            # If a search was done, clear the results and open the current dir.
            if ((VAR_SEARCH_MODE == 1 && VAR_TERM_SEARCH_END_EARLY != 1)); then
                fsys_open "$PWD"

            # If '$PWD' is '/', do nothing.
            elif [[ $PWD && $PWD != / ]]; then
                VAR_TERM_FIND_PREVIOUS=1
                fsys_open "${PWD%/*}"
            fi
        ;;

        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j}|\
        ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'}|\
        ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            ((VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_DIR_LIST_CNT)) && {
                if [[ $VAR_TERM_CONTENT_SCROLL_IDX -lt $VAR_TERM_VISUAL_START_IDX ]]
                then
                    fterminal_mark_remove "$VAR_TERM_CONTENT_SCROLL_IDX"
                fi

                ((VAR_TERM_CONTENT_SCROLL_IDX++))

                if ((VAR_TERM_SCROLL_CURSOR + 1 < VAR_TERM_CONTENT_MAX_CNT))
                then
                    ((VAR_TERM_SCROLL_CURSOR++))
                else
                # elif ((VAR_TERM_SCROLL_CURSOR + 1 == VAR_TERM_CONTENT_MAX_CNT)); then
                    fterminal_print '\e7\e[2H\e[K\e8'
                    # read x
                fi

                fterminal_draw_file_line "$((VAR_TERM_CONTENT_SCROLL_IDX-1))"
                fterminal_print '\n'
                fterminal_draw_file_line "${VAR_TERM_CONTENT_SCROLL_IDX}"

                if [[ $VAR_TERM_CONTENT_SCROLL_IDX -gt $VAR_TERM_VISUAL_START_IDX ]]
                then
                    fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
                fi

                fterminal_draw_tab_line
                fterminal_draw_status_line
            }
        ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k}|\
        ${HSFM_KEY_SCROLL_UP2:=$'\e[A'}|\
        ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            # '\e[1L': Insert a line above the cursor.
            # '\e[A':  Move cursor up a line.
            ((VAR_TERM_CONTENT_SCROLL_IDX > 0)) && {
                if [[ $VAR_TERM_CONTENT_SCROLL_IDX -gt $VAR_TERM_VISUAL_START_IDX ]]
                then
                    fterminal_mark_remove "$VAR_TERM_CONTENT_SCROLL_IDX"
                fi
                ((VAR_TERM_CONTENT_SCROLL_IDX--))

                fterminal_draw_file_line "$((VAR_TERM_CONTENT_SCROLL_IDX+1))"

                if ((VAR_TERM_SCROLL_CURSOR < 1)); then
                    fterminal_print '\e[L'
                else
                    fterminal_print '\e[A'
                    ((VAR_TERM_SCROLL_CURSOR--))
                fi

                fterminal_draw_file_line "$VAR_TERM_CONTENT_SCROLL_IDX"
                if [[ $VAR_TERM_CONTENT_SCROLL_IDX -lt $VAR_TERM_VISUAL_START_IDX ]]
                then
                    fterminal_mark_add "$VAR_TERM_CONTENT_SCROLL_IDX"
                fi

                fterminal_draw_tab_line
                fterminal_draw_status_line
            }
        ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            VAR_TERM_FILE_PROGRAM=(cp -iR)
            VAR_TERM_SELECTION_FILE_LIST=(${VAR_TERM_MARKED_FILE_LIST[@]})

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "n"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files yanked."
            ;;
        ${HSFM_KEY_CUT:=m})
            VAR_TERM_FILE_PROGRAM=(mv -i)
            VAR_TERM_SELECTION_FILE_LIST=(${VAR_TERM_MARKED_FILE_LIST[@]})

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "n"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files cuted."
            ;;
        ${HSFM_KEY_TRASH:=d})
            VAR_TERM_FILE_PROGRAM=(fselect_remove)
            VAR_TERM_SELECTION_FILE_LIST=(${VAR_TERM_MARKED_FILE_LIST[@]})

            VAR_TERM_MARKED_FILE_LIST=()
            fselect_execute
            ;;
        q)
            fmode_setup "n"
            fterminal_redraw
        ;;
    esac
}
fselection_mode_handler() {
    # Handle special key presses.
    # [[ $1 == $'\e' ]] && {
    #     read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2
    #
    #     # Handle a normal escape key press.
    #     [[ ${1}${REPLY} == $'\e\e['* ]] &&
    #         read "${VAR_TERM_READ_FLAGS[@]}" -rsn 1 _
    #
    #     local var_special_key=${1}${REPLY}
    # }

    case ${var_special_key:-$1} in
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD3:=""})
            fmode_setup "n"
        ;;
        # Open VAR_TERM_DIR_FILE_LIST item.
        # 'C' is what bash sees when the right arrow is pressed
        # ('\e[C' or '\eOC').
        ${HSFM_KEY_CHILD1:=l}|\
        ${HSFM_KEY_CHILD2:=$'\e[C'}|\
        ${HSFM_KEY_CHILD4:=$'\eOC'})
            # only check if it's directory.
            if test -d "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]##*/}"
            then
                fsys_open "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}"
            else
                # flog_msg $(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" | tail -n 1)
                local tmp_file_info=($(file "${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}" | tail -n 1 | cut -d ':' -f2))
                flog_msg "File type: ${tmp_file_info[@]}"
            fi
        ;;

        # Go to the parent directory.
        # 'D' is what bash sees when the left arrow is pressed
        # ('\e[D' or '\eOD').
        # '\177' and '\b' are what bash sometimes sees when the backspace
        # key is pressed.
        ${HSFM_KEY_PARENT1:=h}|\
        ${HSFM_KEY_PARENT2:=$'\e[D'}|\
        ${HSFM_KEY_PARENT3:=$'\177'}|\
        ${HSFM_KEY_PARENT4:=$'\b'}|\
        ${HSFM_KEY_PARENT5:=$'\eOD'})
            # If a search was done, clear the results and open the current dir.
            if ((VAR_SEARCH_MODE == 1 && VAR_TERM_SEARCH_END_EARLY != 1)); then
                fsys_open "$PWD"

            # If '$PWD' is '/', do nothing.
            elif [[ $PWD && $PWD != / ]]; then
                VAR_TERM_FIND_PREVIOUS=1
                fsys_open "${PWD%/*}"
            fi
        ;;

        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j}|\
        ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'}|\
        ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            ((VAR_TERM_CONTENT_SCROLL_IDX < VAR_TERM_DIR_LIST_CNT)) && {

                ((VAR_TERM_CONTENT_SCROLL_IDX++))

                if ((VAR_TERM_SCROLL_CURSOR + 1 < VAR_TERM_CONTENT_MAX_CNT))
                then
                    ((VAR_TERM_SCROLL_CURSOR++))
                else
                # elif ((VAR_TERM_SCROLL_CURSOR + 1 == VAR_TERM_CONTENT_MAX_CNT)); then
                    fterminal_print '\e7\e[2H\e[K\e8'
                    # read x
                fi

                fterminal_draw_file_line "$((VAR_TERM_CONTENT_SCROLL_IDX-1))"
                fterminal_print '\n'
                fterminal_draw_file_line "${VAR_TERM_CONTENT_SCROLL_IDX}"

                fterminal_draw_tab_line
                fterminal_draw_status_line
            }
        ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${HSFM_KEY_SCROLL_UP1:=k}|\
        ${HSFM_KEY_SCROLL_UP2:=$'\e[A'}|\
        ${HSFM_KEY_SCROLL_UP3:=$'\eOA'})
            # '\e[1L': Insert a line above the cursor.
            # '\e[A':  Move cursor up a line.
            ((VAR_TERM_CONTENT_SCROLL_IDX > 0)) && {
                ((VAR_TERM_CONTENT_SCROLL_IDX--))

                fterminal_draw_file_line "$((VAR_TERM_CONTENT_SCROLL_IDX+1))"

                if ((VAR_TERM_SCROLL_CURSOR < 1)); then
                    fterminal_print '\e[L'
                else
                    fterminal_print '\e[A'
                    ((VAR_TERM_SCROLL_CURSOR--))
                fi

                fterminal_draw_file_line "$VAR_TERM_CONTENT_SCROLL_IDX"

                fterminal_draw_tab_line
                fterminal_draw_status_line
            }
        ;;

        ${HSFM_KEY_SELECTION})
            fterminal_mark_toggle "$VAR_TERM_CONTENT_SCROLL_IDX" "$1"
        ;;

        # File operstions
        ${HSFM_KEY_YANK:=y})
            VAR_TERM_FILE_PROGRAM=(cp -iR)
            VAR_TERM_SELECTION_FILE_LIST=(${VAR_TERM_MARKED_FILE_LIST[@]})

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "n"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files yanked."
            ;;
        ${HSFM_KEY_CUT:=m})
            VAR_TERM_FILE_PROGRAM=(mv -i)
            VAR_TERM_SELECTION_FILE_LIST=(${VAR_TERM_MARKED_FILE_LIST[@]})

            VAR_TERM_MARKED_FILE_LIST=()
            fmode_setup "n"
            fterminal_redraw
            flog_msg "${#VAR_TERM_SELECTION_FILE_LIST[@]} files cuted."
            ;;
        ${HSFM_KEY_TRASH:=d})
            VAR_TERM_FILE_PROGRAM=(fselect_remove)
            VAR_TERM_SELECTION_FILE_LIST=(${VAR_TERM_MARKED_FILE_LIST[@]})

            VAR_TERM_MARKED_FILE_LIST=()
            fselect_execute
            ;;
        q)
            fmode_setup "n"
            fterminal_redraw
        ;;
    esac
}

fget_mime_type() {
    # Get a file's mime_type.
    # mime_type=$(file "-${file_flags:-biL}" "$1" 2>/dev/null)
    echo $(file "-${file_flags:-biL}" "$*" 2>/dev/null)
}
fget_selection() {

    # VAR_TERM_DIR_FILE_LIST+=("$item")
    echo ${VAR_TERM_DIR_FILE_LIST[VAR_TERM_CONTENT_SCROLL_IDX]}
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
    # Write to the command_line (under fterminal_draw_status_line).
    local var_cmd_prefix=${1}
    local var_cmd_function=${2:=""}
    # local var_cmd_file=${3:=""}

    if [[ "${#}" -eq "3" ]]
    then
        local var_cmd_file=${3:=""}
    else
        local var_cmd_file=""
    fi

    VAR_TERM_CMD_INPUT_BUFFER=""

    fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"
    # '\r\e[K': Redraw the read prompt on every keypress.
    #           This is mimicking what happens normally.
    while IFS= read -rsn 1 -p $'\r\e[K'"${var_cmd_prefix}${VAR_TERM_CMD_INPUT_BUFFER}" read_reply; do
        case $read_reply in
            # Backspace.
            $'\177'|$'\b')
                VAR_TERM_CMD_INPUT_BUFFER=${VAR_TERM_CMD_INPUT_BUFFER%?}

                # Clear tab-completion.
                unset comp c
            ;;

            # Tab.
            $'\t')
                comp_glob="$VAR_TERM_CMD_INPUT_BUFFER*"

                # Pass the argument dirs to limit completion to directories.
                # [[ $2 == dirs ]] &&
                #     comp_glob="$VAR_TERM_CMD_INPUT_BUFFER*/"

                # Generate a completion list once.
                # [[ -z ${comp[0]} ]] &&
                #     IFS=$'\n' read -d "" -ra comp < <(compgen -G "$comp_glob")
                    # IFS=$'\n' read -d "" -ra comp < <(compgen -G -W "fterminal_redraw search" "$comp_glob")
                if [[ -z ${comp[0]} ]]
                then
                    # IFS=$'\n' read -d "" -ra globpat < <(compgen -G "$comp_glob")
                    IFS=$'\n' read -d "" -ra wordlist < <(compgen -W "${VAR_TERM_CMD_LIST[*]}" ${VAR_TERM_CMD_INPUT_BUFFER})
                    # comp=$globpat
                    comp+=$wordlist
                fi

                # On each tab press, cycle through the completion list.
                [[ -n ${comp[c]} ]] && {
                    VAR_TERM_CMD_INPUT_BUFFER=${comp[c]}
                    ((c=c >= ${#comp[@]}-1 ? 0 : ++c))
                }
            ;;

            # Enter/Return.
            "")
                [[ ${var_cmd_function} != command ]] && {
                    # # Unset tab completion variables since we're done.
                    # unset comp c
                    # return
                    break
                }

                tmp_command=$(echo ${VAR_TERM_CMD_INPUT_BUFFER} | tr -s ' ' |sed 's/^ //g' | cut -d ' ' -f 1)
                tmp_args=$(echo ${VAR_TERM_CMD_INPUT_BUFFER} | tr -s ' ' |sed 's/^ //g' | cut -d ' ' -f 2-)
                # fterminal_print "\r\e[2K%s" ${tmp_command}
                case ${tmp_command} in
                    "fullredraw")
                        fterminal_redraw full
                        ;;
                    "redraw")
                        fterminal_redraw full
                        ;;
                    "open")
                        fsys_open ${tmp_args}
                        ;;
                    "cd")
                        cmd_cd ${tmp_args}
                        ;;
                    "file"|"info")
                        cmd_stat "${var_cmd_file}"
                        ;;

                    "vim"|"edit")
                        cmd_editor "${var_cmd_file}"
                        ;;
                    "media"|"play")
                        cmd_media "${var_cmd_file}"
                        ;;
                    "image"|"preview")
                        cmd_media "${var_cmd_file}"
                        ;;
                    "mkfile"|"touch")
                        cmd_mkfile "${tmp_args}"
                        ;;
                    "echo")
                        flog_msg "${tmp_args}"
                        ;;
                    *)
                        # flog_msg "Unknown commands: ${tmp_command} ${tmp_args}"
                        cmd_${tmp_command} ${tmp_args}
                        fterminal_print '\e[?25l\e8'
                        ;;
                esac

                # [[ $1 == :  ]] && {
                #     nohup "${VAR_TERM_CMD_INPUT_BUFFER}" "$2" &>/dev/null &
                # }

                break
            ;;

            # Custom 'yes' value (used as a replacement for '-n 1').
            ${2:-null})
                VAR_TERM_CMD_INPUT_BUFFER=$read_reply
                break
            ;;

            # Escape / Custom 'no' value (used as a replacement for '-n 1').
            $'\e'|${3:-null})
                read "${VAR_TERM_READ_FLAGS[@]}" -rsn 2
                VAR_TERM_CMD_INPUT_BUFFER=

                fterminal_print '\e[?25l\e8'
                break
            ;;

            # Replace '~' with '$HOME'.
            "~")
                VAR_TERM_CMD_INPUT_BUFFER+=$HOME
            ;;

            # Anything else, add it to read reply.
            *)
                VAR_TERM_CMD_INPUT_BUFFER+=$read_reply

                # Clear tab-completion.
                unset comp c
            ;;
        esac

        [[ ${var_cmd_function} == "search" ]] && {
            cmd_search "${VAR_TERM_CMD_INPUT_BUFFER}"
        }

    done

    # Unset tab completion variables since we're done.
    unset comp c
}
flog_msg_debug()
{
    if [ ${HSFM_DEBUG} = true ]
    then
        printf "%s\n" "$*" >> ${HSFM_MESSAGE_FILE}
    fi
}
flog_msg()
{
    fterminal_print '\e7\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"
    fterminal_print '\r\e[%sH\e[?25h\e[2K%s' "$VAR_TERM_LINE_CNT" "$*"
    fterminal_print '\e[?25l\e8'
}
cmd_search()
{
    local var_pattern="$*"
    # Search on keypress if search passed as an argument.
    # '\e[?25l': Hide the cursor.
    fterminal_print '\e[?25l'

    fterminal_read_dir "*${var_pattern}*"
    # if [[ $HSFM_READ_WITH_LS == 0 ]]
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
cmd_mkfile()
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
    local var_file="$@"
    if [[ -f "${var_file}" ]]; then
        fterminal_clear
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
    local var_file="$@"
    if [[ -f "${var_file}" ]]; then
        nohup "${HSFM_MEDIA_PLAYER}" "${var_file}" &>/dev/null &
    else
        flog_msg "warn: '${var_file}' not opened"
    fi
}
cmd_image()
{
    local var_file="$@"
    if [[ -f "${var_file}" ]]; then
        nohup "${HSFM_PICTURE_VIEWER}" "${var_file}" &>/dev/null &
    else
        flog_msg "warn: '${var_file}' not opened"
    fi
}
cmd_shell()
{
    local var_file="$@"

    fterminal_clear
    fterminal_reset

    bash

    fterminal_setup
    fterminal_redraw
}
cmd_cd()
{
    if test -d $@
    then
        # fterminal_clear
        fterminal_draw_status_line "Change dir to: $@"
        # cd $@
        fsys_open "$@"
        # fterminal_redraw full
        # backup cursor
        # NOTE. It's a patch for storing cursor position, cuse fcommand_handler will restore it.
        fterminal_print '\e7'
    fi
}
cmd_select()
{
    fterminal_clear
    fterminal_draw_tab_line
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    {
        fterminal_print 'Program: %s\n' "${VAR_TERM_FILE_PROGRAM}"
        fterminal_print 'File list: %s files slected.\n' ${VAR_TERM_SELECTION_FILE_LIST[@]}
        for each_file in "${VAR_TERM_SELECTION_FILE_LIST[@]}"
        do
            if test -e ${each_file}
            then
                # fterminal_print '%s\n' "$(ls -ld ${each_file})"
                fterminal_print '    %s\n' "${each_file}"
            fi
        done
    }
    fterminal_draw_tab_line
    fterminal_draw_status_line
    # read -ern 1
    fcommand_line_interact "Enter Any Key To Continue..." "wait"
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
    stat "$*"
    fterminal_draw_tab_line
    fterminal_draw_status_line
    fcommand_line_interact "Enter Any Key To Continue..." "wait"
    fterminal_redraw
}
cmd_help()
{
    fterminal_clear
    fterminal_draw_tab_line
    fterminal_draw_status_line "Help info"
    fterminal_print '\e[%sH' "$((VAR_TERM_TAB_LINE_HEIGHT + 1))"
    fHelp $@
    fcommand_line_interact "Enter Any Key To Continue..." "wait"
    fterminal_redraw
}
cmd_exit()
{
    : "${HSFM_CD_FILE}"

    [[ -w $HSFM_CD_FILE ]] &&
        rm "$HSFM_CD_FILE"

    [[ ${HSFM_CD_ON_EXIT:=1} == 1 ]] &&
        fterminal_print '%s\n' "$PWD" > "$HSFM_CD_FILE"

    fHSFM_exit
}

fsys_open() {
    # Open directories and files.
    if [[ -d $1/ ]]; then
        VAR_SEARCH_MODE=
        VAR_TERM_SEARCH_END_EARLY=
        if test -r "${1:-/}"
        then
            cd "${1:-/}" ||:
            fterminal_redraw full
        else
            flog_msg "Access fail on: ${1:-/}"
        fi

    elif [[ -f $1 ]]; then
        # Figure out what kind of file we're working with.
        # fget_mime_type "$1"

        # Open all text-based files in '$EDITOR'.
        # Everything else goes through 'xdg-open'/'open'.
        # case "$mime_type" in
        case "$(fget_mime_type $1)" in
            audio/*)
                # nohup "${HSFM_MEDIA_PLAYER}" "$1" &>/dev/null &
                cmd_media "$1"
            ;;
            video/*)
                # nohup "${HSFM_MEDIA_PLAYER}" "$1" &>/dev/null &
                cmd_media "$1"
            ;;
            image/*)
                # nohup "${HSFM_PICTURE_VIEWER}" "$1" &>/dev/null &
                cmd_image "$1"
            ;;
            text/*|*x-empty*|*json*)
                cmd_editor "$1"
                # # If 'hsfm' was opened as a file picker, save the opened
                # # file in a file called 'opened_file'.
                # ((HSFM_FILE_PICKER == 1)) && {
                #     fterminal_print '%s\n' "$1" > \
                #         "${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/opened_file"
                #     exit
                # }
                #
                # # fterminal_clear
                # fterminal_reset
                # # "${VISUAL:-${EDITOR:-vi}}" "$1"
                # fopen_editor "$1"
                # fterminal_setup
                # fterminal_redraw
            ;;

            *)
                # 'nohup':  Make the process immune to hangups.
                # '&':      Send it to the background.
                # 'disown': Detach it from the shell.
                if command -v ${HSFM_OPENER} > /dev/null
                then
                    nohup "${HSFM_OPENER}" "$1" &>/dev/null &
                    disown
                else
                    flog_msg "Unknown file type: $1"
                fi
            ;;
        esac
    fi
}
function fopen_editor() {
    "${VISUAL:-${EDITOR:-vi}}" "$1"
}

## File Operation Function
###########################################################
fselect_execute()
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
        "${VAR_TERM_FILE_PROGRAM[@]}" "${VAR_TERM_SELECTION_FILE_LIST[@]}" .
        stty -echo

        # VAR_TERM_SELECTION_FILE_LIST=()
        fmode_setup "n"
        fterminal_setup
        fterminal_redraw full
    }
}
fselect_remove() {
    # Trash a file.
    if [[ ${#VAR_TERM_SELECTION_FILE_LIST[@]} == 1 ]] 
    then
        fcommand_line_interact "trash [${VAR_TERM_SELECTION_FILE_LIST[@]}] items? [y/n]: " y n
    else
        fcommand_line_interact "trash [${#VAR_TERM_SELECTION_FILE_LIST[@]}] items? [y/n]: " y n
    fi

    [[ $VAR_TERM_CMD_INPUT_BUFFER != y ]] &&
        return

    if [[ $HSFM_TRASH_CMD ]]; then
        # Pass all but the last argument to the user's
        # custom script. command is used to prevent this function
        # from conflicting with commands named "fselect_remove".
        command "$HSFM_TRASH_CMD" "${@:1:$#-1}"

    else
        cd "$HSFM_TRASH" || flog_msg "error: Can't cd to trash directory."

        if cp -alf "$@" &>/dev/null; then
            rm -r "${@:1:$#-1}"
        else
            mv -f "$@"
        fi

        # Go back to where we were.
        cd "$OLDPWD" ||:
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
## Others
###########################################################
fsetup_osenv() {
    # Figure out the current operating system to set some specific variables.
    # '$OSTYPE' typically stores the name of the OS kernel.
    case $OSTYPE in
        # Mac OS X / macOS.
        darwin*)
            HSFM_OPENER=fsys_open
            file_flags=bIL
            VAR_TERM_DIR_LS_ARGS=("--color=none")
            VAR_TERM_DIR_LS_ARGS+=("-h -ld ")
            break
        ;;

        linux*|*)
            HSFM_OPENER=fsys_open
            file_flags=bIL

            [[ -z $HSFM_TRASH_CMD ]] &&
                HSFM_TRASH_CMD=fselect_remove

            [[ $HSFM_TRASH_CMD == fselect_remove ]] && {
                HSFM_TRASH=$(finddir -v "$PWD" B_TRASH_DIRECTORY)
                mkdir -p "$HSFM_TRASH"
            }

            VAR_TERM_DIR_LS_ARGS=("--color=none")
            VAR_TERM_DIR_LS_ARGS+=("--group-directories-first")
            VAR_TERM_DIR_LS_ARGS+=("-h -ld ")
            break
        ;;
    esac
}

fsetup_options() {
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
    file -I &>/dev/null || : "${file_flags:=biL}"
}

fsave_settings() {
    if [[ ${#VAR_TERM_TAB_LINE_LIST[@]} -eq 1 ]]
    then
        return 0
    fi

    if test -f ${HSFM_SESSION_FILE}
    then
        rm ${HSFM_SESSION_FILE}
    fi

    echo "export VAR_TERM_TAB_LINE_IDX=(${VAR_TERM_TAB_LINE_IDX})" >> ${HSFM_SESSION_FILE}
    echo "export VAR_TERM_TAB_LINE_LIST=(${VAR_TERM_TAB_LINE_LIST[@]})" >> ${HSFM_SESSION_FILE}
    echo "cd ${PWD}" >> ${HSFM_SESSION_FILE}
}
fload_settings() {
    if test -f ${HSFM_SESSION_FILE}
    then
        source ${HSFM_SESSION_FILE}
    fi
}

fget_ls_colors() {
    # Parse the LS_COLORS variable and declare each file type
    # as a separate variable.
    # Format: ':.ext=0;0:*.jpg=0;0;0:*png=0;0;0;0:'
    [[ -z $LS_COLORS ]] && {
        HSFM_LS_COLORS=0
        return
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
    fterminal_print "    %- 16s\t%s\n" "-d|--debug  " "Enable debug flag."
    fterminal_print "    %- 16s\t%s\n" "-r|--restore" "restore previous session."
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
    fterminal_print "    % -16s: %s\n"  "${VAR_TERM_CMD_LIST[@]}"
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
    # Handle a directory as the first argument.
    # 'cd' is a cheap way of finding the full path to a directory.
    # It updates the '$PWD' variable on successful execution.
    # It handles relative paths as well as '../../../'.
    #
    # '||:': Do nothing if 'cd' fails. We don't care.
    cd "${2:-$1}" &>/dev/null ||:

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
        fget_ls_colors

    ((${HSFM_ENABLE_HIDDEN:=0} == 1)) &&
        shopt -s dotglob

    # Create the trash and cache directory if they don't exist.
    mkdir -p "${HSFM_STORE_PATH}"

    # 'nocaseglob': Glob case insensitively (Used for case insensitive search).
    # 'nullglob':   Don't expand non-matching globs to themselves.
    shopt -s nocaseglob nullglob

    # Trap the exit signal (we need to reset the terminal to a useable state.)
    # trap 'fterminal_reset' EXIT
    # trap "trap - SIGTERM && fHSFM_exit &&kill -- -$$" SIGINT SIGTERM EXIT
    trap "fHSFM_exit" SIGINT SIGTERM EXIT

    # Trap the window resize signal (handle window resize events).
    trap 'fterminal_resize_win' WINCH

    fsetup_osenv
    fsetup_options

    fterminal_get_size
    fterminal_setup
    fterminal_redraw full

    # Vintage infinite loop.
    for ((;HSFM_RUNNING;)); {
        # read "${VAR_TERM_READ_FLAGS[@]}" -srn 1 && {
        fterminal_read_key && {
            case ${VAR_TERM_OPS_MODE} in
                'v')
                    fvisual_mode_handler "$REPLY"
                    ;;
                's')
                    fselection_mode_handler "$REPLY"
                    ;;
                *|'n')
                    fnormal_mode_handler "$REPLY"
                    ;;
                esac
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
            -d|--debug)
                HSFM_DEBUG=true
                ;;
            --history)
                # Store file name in a file on open instead of using 'HSFM_OPENER'.
                # Used in 'hsfm.vim'.
                HSFM_FILE_PICKER=1
                ;;
            -r|-restore)
                fload_settings
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

    fCore
}

fMain $@
