#!/usr/bin/env bash
###########################################################
## Varis
###########################################################

## FM Vars Options
###########################################################
export VAR_TERM_SCROLL_CURSOR=0
export VAR_TERM_TAB_LINE_CNT=1
export VAR_TERM_STATUS_LINE_CNT=2
export VAR_TERM_LINE_CNT=0
export VAR_TERM_COLUMN_CNT=0

export VAR_TERM_STATUS_DEBUG=""
export VAR_TERM_CONTENT_MAX_CNT=0
export VAR_TERM_CONTENT_SCROLL=0

export VAR_DIR_LIST_CNT=0

## Default Options
###########################################################
# Use LS_COLORS to color hsfm.
# (On by default if available)
# (Ignores HSFM_COL1)
export HSFM_LS_COLORS=1

# Show/Hide hidden files on open.
# (On by default)
export HSFM_HIDDEN=0

## Themes & colors
###########################################################
# Directory color [0\-9]
export HSFM_COLOR_DIR=32

# Selection color [0\-9] (copied/moved files)
export HSFM_COLOR_SELECTION=34

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
export HSFM_CD_FILE=~/.hsfm_d

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
export HSFM_FAV4=/etc
export HSFM_FAV5=~/workspace
export HSFM_FAV6=
export HSFM_FAV7=~/downloads
export HSFM_FAV8=~/media
export HSFM_FAV9=

# File format.
# Customize the item string.
# Format ('%f' is the current file): "str%fstr"
# Example (Add a tab before files): HSFM_FILE_FORMAT="\t%f"
export HSFM_FILE_FORMAT="%f"

# Mark format.
# Customize the marked item string.
# Format ('%f' is the current file): "str%fstr"
# Example (Add a ' >' before files): HSFM_MARK_FORMAT="> %f"
export HSFM_MARK_FORMAT=" %f*"

## Keybindings
###########################################################

### Moving around.

# Show help info
export HSFM_KEY_HELP="H"

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
export HSFM_KEY_GO_DIR="t"
export HSFM_KEY_OPEN_CMD=":"
export HSFM_KEY_GO_HOME="~"
export HSFM_KEY_GO_TRASH="z"

### File operations.

export HSFM_KEY_YANK="y"
export HSFM_KEY_MOVE="m"
export HSFM_KEY_TRASH="d"
export HSFM_KEY_LINK="s"
export HSFM_KEY_BULK_RENAME="b"

export HSFM_KEY_YANK_ALL="Y"
export HSFM_KEY_MOVE_ALL="M"
export HSFM_KEY_TRASH_ALL="D"
export HSFM_KEY_LINK_ALL="S"
export HSFM_KEY_BULK_RENAME_ALL="B"

export HSFM_KEY_PASTE="p"
export HSFM_KEY_CLEAR="c"

export HSFM_KEY_RENAME="r"
export HSFM_KEY_MKDIR="n"
export HSFM_KEY_MKFILE="f"

### Miscellaneous

# Show file attributes.
export HSFM_KEY_ATTRIBUTES="x"

# Toggle executable flag.
export HSFM_KEY_EXECUTABLE="X"

# Toggle hidden files.
export HSFM_KEY_HIDDEN="."

###########################################################
## Terminal Functions
###########################################################

setup_terminal() {
    # Setup the terminal for the TUI.
    # '\e[?1049h': Use alternative screen buffer.
    # '\e[?7l':    Disable line wrapping.
    # '\e[?25l':   Hide the cursor.
    # '\e[2J':     Clear the screen.
    # '\e[1;Nr':   Limit scrolling to scrolling area.
    #              Also sets cursor to (0,0).
    printf '\e[?1049h\e[?7l\e[?25l\e[2J\e[1;%sr' "$VAR_TERM_CONTENT_MAX_CNT"

    # Hide echoing of user input
    stty -echo
}

reset_terminal() {
    # Reset the terminal to a useable state (undo all changes).
    # '\e[?7h':   Re-enable line wrapping.
    # '\e[?25h':  Unhide the cursor.
    # '\e[2J':    Clear the terminal.
    # '\e[;r':    Set the VAR_TERM_CONTENT_SCROLL region to its default value.
    #             Also sets cursor to (0,0).
    # '\e[?1049l: Restore main screen buffer.
    printf '\e[?7h\e[?25h\e[2J\e[;r\e[?1049l'

    # Show user input.
    stty echo
}

clear_screen() {
    # Only clear the scrolling window (dir item list).
    # '\e[%sH':    Move cursor to bottom of VAR_TERM_CONTENT_SCROLL area.
    # '\e[9999C':  Move cursor to right edge of the terminal.
    # '\e[1J':     Clear screen to top left corner (from cursor up).
    # '\e[2J':     Clear screen fully (if using tmux) (fixes clear issues).
    # '\e[1;%sr':  Clearing the screen resets the VAR_TERM_CONTENT_SCROLL region(?). Re-set it.
    #              Also sets cursor to (0,0).
    # printf '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
    #        "$((VAR_TERM_LINE_CNT-2))" "${TMUX:+\e[2J}" "$VAR_TERM_CONTENT_MAX_CNT"
    printf '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
        "$((VAR_TERM_LINE_CNT))" "${TMUX:+\e[2J}" "$(($VAR_TERM_CONTENT_MAX_CNT+$VAR_TERM_TAB_LINE_CNT))"
}

get_term_size() {
    # Get terminal size ('stty' is POSIX and always available).
    # This can't be done reliably across all bash versions in pure bash.
    read -r VAR_TERM_LINE_CNT VAR_TERM_COLUMN_CNT < <(stty size)

    # Max list items that fit in the VAR_TERM_CONTENT_SCROLL area.
    # ((VAR_TERM_CONTENT_MAX_CNT=VAR_TERM_LINE_CNT-3))
    ((VAR_TERM_CONTENT_MAX_CNT=VAR_TERM_LINE_CNT-VAR_TERM_TAB_LINE_CNT-VAR_TERM_STATUS_LINE_CNT))
}
resize_term_win()
{
    get_term_size
    redraw
    # print size to prevent buffering
    cmd_handler "log" "Window resized"
}
exit_term()
{
    reset_terminal
}

###########################################################
## Drawing Functions
###########################################################
redraw() {
    # Redraw the current window.
    # If 'full' is passed, re-fetch the directory list.
    [[ $1 == full ]] && {
        read_dir
        VAR_TERM_CONTENT_SCROLL=0
    }

    clear_screen
    draw_dir
    tab_line
    status_line
}
draw_dir() {
    # Print the max directory items that fit in the VAR_TERM_CONTENT_SCROLL area.
    local scroll_start=$VAR_TERM_CONTENT_SCROLL
    local scroll_new_pos
    local scroll_end
    local scroll_len=$(($VAR_TERM_CONTENT_MAX_CNT - 1))

    # When going up the directory tree, place the cursor on the position
    # of the previous directory.
    ((find_previous == 1)) && {
        ((scroll_start=previous_index))
        ((VAR_TERM_CONTENT_SCROLL=scroll_start))

        # Clear the directory history. We're here now.
        find_previous=
    }

    # If current dir is near the top of the list, keep VAR_TERM_CONTENT_SCROLL position.
    if ((VAR_DIR_LIST_CNT < VAR_TERM_CONTENT_MAX_CNT || VAR_TERM_CONTENT_SCROLL < VAR_TERM_CONTENT_MAX_CNT/2)); then
        ((scroll_start=0))
        ((scroll_new_pos=VAR_TERM_CONTENT_SCROLL))
        # ((scroll_end=VAR_TERM_CONTENT_MAX_CNT-VAR_TERM_TAB_LINE_CNT))

    # If current dir is near the end of the list, keep VAR_TERM_CONTENT_SCROLL position.
    elif ((VAR_DIR_LIST_CNT - VAR_TERM_CONTENT_SCROLL < VAR_TERM_CONTENT_MAX_CNT/2)); then
        ((scroll_start=VAR_DIR_LIST_CNT-VAR_TERM_CONTENT_MAX_CNT + 1))
        ((scroll_new_pos=VAR_TERM_CONTENT_MAX_CNT - 1))
        # ((scroll_end=VAR_DIR_LIST_CNT+1))

    # If current dir is somewhere in the middle, center VAR_TERM_CONTENT_SCROLL position.
    else
        ((scroll_start=VAR_TERM_CONTENT_SCROLL-VAR_TERM_CONTENT_MAX_CNT/2 + 1))
        ((scroll_new_pos=VAR_TERM_CONTENT_MAX_CNT/2 - 1))
        # ((scroll_end=scroll_start+VAR_TERM_CONTENT_MAX_CNT))
    fi

    # Reset cursor position.
    # printf '\e[H'
    printf '\e[%sH' "$((1 + ${VAR_TERM_TAB_LINE_CNT}))"

    for ((i=0;i<=scroll_len;i++)); {
        # Don't print one too many newlines.
        ((i > 0)) &&
            printf '\n'

        print_line "$((scroll_start + i))"
        # printf "$i"
    }

    # Move the cursor to its new position if it changed.
    # If the variable 'scroll_new_pos' is empty, the cursor
    # is moved to line '0'.
    printf '\e[%sH' "$(($scroll_new_pos+1+VAR_TERM_TAB_LINE_CNT))"
    # printf '\e[%sH' "$((${scroll_new_pos} + ${VAR_TERM_TAB_LINE_CNT}))"
    ((VAR_TERM_SCROLL_CURSOR=scroll_new_pos))
}
tab_line() {
    # Status_line to print when files are marked for operation.
    local mark_ui="[${#marked_files[@]}] selected (${file_program[*]}) [p] ->"

    # Escape the directory string.
    # Remove all non-printable characters.
    # PWD_escaped=${PWD//[^[:print:]]/^[}
    PWD_escaped=$(basename $(realpath .))

    # '\e7':       Save cursor position.
    #              This is more widely supported than '\e[s'.
    # '\e[%sH':    Move cursor to bottom of the terminal.
    # '\e[30;41m': Set foreground and background colors.
    # '%*s':       Insert enough spaces to fill the screen width.
    #              This sets the background color to the whole line
    #              and fixes issues in 'screen' where '\e[K' doesn't work.
    # '\r':        Move cursor back to column 0 (was at EOL due to above).
    # '\e[m':      Reset text formatting.
    # '\e[H\e[K':  Clear line below status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.
    # printf '\e7\e[%sH\e[%s;%sm%*s\r%s %s%s\e[m\e[%sH\e[K\e8' \
    printf '\e7\e[%sH\e[%s;%sm%*s\r%s %s\e[m\e8' \
           "$((0))" \
           "${HSFM_COLOR_STATUS_FG:-30}" \
           "${HSFM_COLOR_STATUS_BG:-41}" \
           "$VAR_TERM_COLUMN_CNT" "" \
           "FM" \
           "|${1:-${PWD_escaped:-/}}|"
}
status_line() {
    # Status_line to print when files are marked for operation.
    local mark_ui="[${#marked_files[@]}] selected (${file_program[*]}) [p] ->"
    local var_left=""
    local var_left_cnt=""
    local var_right=""
    local var_right_cnt=""
    local var_spacing=""
    local var_content_cnt=""

    # Escape the directory string.
    # Remove all non-printable characters.
    PWD_escaped=${PWD//[^[:print:]]/^[}

    ## Update content
    var_left="($((VAR_TERM_CONTENT_SCROLL + 1))/$((VAR_DIR_LIST_CNT + 1))) "
    var_left+="${marked_files[*]:+${mark_ui}}"
    var_left+="${1:-${PWD_escaped:-/}}"

    # var_right="$(date '+%Y/%m/%d %H:%M:%S')"
    var_right="$(date '+%Y/%m/%d')"

    ## calc spacing
    var_left_cnt="${#var_left}"
    var_right_cnt="${#var_right}"
    ((var_content_cnt=VAR_TERM_COLUMN_CNT-var_left_cnt-var_right_cnt))
    [[ ${var_content_cnt} < 0 ]] && ((${var_content_cnt}=0))
    # cmd_handler "log" "test-> ${var_content_cnt}/$VAR_TERM_COLUMN_CNT"
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
    # '\e[H\e[K':  Clear line below status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.

    # printf '\e7\e[%sH\e[%s;%sm%*s\r%s %s%s\e[m\e[%sH\e[K\e8' \
    #        "$((VAR_TERM_LINE_CNT-1))" \
    #        "${HSFM_COLOR_STATUS_FG:-30}" \
    #        "${HSFM_COLOR_STATUS_BG:-41}" \
    #        "$VAR_TERM_COLUMN_CNT" "" \
    #        "($((VAR_TERM_CONTENT_SCROLL + 1))/$((VAR_DIR_LIST_CNT + 1)))" \
    #        "${marked_files[*]:+${mark_ui}}" \
    #        "${1:-${PWD_escaped:-/}}" \
    #        "$VAR_TERM_LINE_CNT"

    printf "\e7\e[%sH\e[%s;%sm%*s\r%s%s%s\e[m\e[%sH\e[K\e8" \
           "$((VAR_TERM_LINE_CNT-1))" \
           "${HSFM_COLOR_STATUS_FG:-30}" \
           "${HSFM_COLOR_STATUS_BG:-41}" \
           "$VAR_TERM_COLUMN_CNT" "" \
           "${var_left}" \
           "${var_spacing}" \
           "${var_right}" \
           "$VAR_TERM_LINE_CNT"
}

print_line() {
    # Format the list item and print it.
    local file_name=${list[$1]##*/}
    local file_ext=${file_name##*.}
    local format
    local suffix

    # If the dir item doesn't exist, end here.
    if [[ -z ${list[$1]} ]]; then
        return

    # Directory.
    elif [[ -d ${list[$1]} ]]; then
        format+=\\e[${di:-1;${HSFM_COLOR_DIR:-32}}m
        suffix+=/

    # Block special file.
    elif [[ -b ${list[$1]} ]]; then
        format+=\\e[${bd:-40;33;01}m

    # Character special file.
    elif [[ -c ${list[$1]} ]]; then
        format+=\\e[${cd:-40;33;01}m

    # Executable file.
    elif [[ -x ${list[$1]} ]]; then
        format+=\\e[${ex:-01;32}m

    # Symbolic Link (broken).
    elif [[ -h ${list[$1]} && ! -e ${list[$1]} ]]; then
        format+=\\e[${mi:-01;31;7}m

    # Symbolic Link.
    elif [[ -h ${list[$1]} ]]; then
        format+=\\e[${ln:-01;36}m

    # Fifo file.
    elif [[ -p ${list[$1]} ]]; then
        format+=\\e[${pi:-40;33}m

    # Socket file.
    elif [[ -S ${list[$1]} ]]; then
        format+=\\e[${so:-01;35}m

    # Color files that end in a pattern as defined in LS_COLORS.
    # 'BASH_REMATCH' is an array that stores each REGEX match.
    elif [[ $HSFM_LS_COLORS == 1 &&
            $ls_patterns &&
            $file_name =~ ($ls_patterns)$ ]]; then
        match=${BASH_REMATCH[0]}
        file_ext=ls_${match//[^a-zA-Z0-9=\\;]/_}
        format+=\\e[${!file_ext:-${fi:-37}}m

    # Color files based on file extension and LS_COLORS.
    # Check if file extension adheres to POSIX naming
    # standard before checking if its a variable.
    elif [[ $HSFM_LS_COLORS == 1 &&
            $file_ext != "$file_name" &&
            $file_ext =~ ^[a-zA-Z0-9_]*$ ]]; then
        file_ext=ls_${file_ext}
        format+=\\e[${!file_ext:-${fi:-37}}m

    else
        format+=\\e[${fi:-37}m
    fi

    # If the list item is under the cursor.
    (($1 == VAR_TERM_CONTENT_SCROLL)) &&
        format+="\\e[1;${HSFM_COLOR_CURSOR:-36};7m"

    # If the list item is marked for operation.
    [[ ${marked_files[$1]} == "${list[$1]:-null}" ]] && {
        format+=\\e[${HSFM_COLOR_SELECTION:-31}m${mark_pre}
        suffix+=${mark_post}
    }

    # Escape the directory string.
    # Remove all non-printable characters.
    file_name=${file_name//[^[:print:]]/^[}

    # printf '\r%b%s\e[m\e[K\r' \
    #     "$1: ${file_pre}${format}" \
    #     "${file_name}${suffix}${file_post}"
    printf '\r%b%s\e[m\e[K\r' \
        " ${file_pre}${format}" \
        "${file_name}${suffix}${file_post}"
}

mark() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$mark_dir" ]] &&
        marked_files=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${list[0]} == empty && -z ${list[1]} ]] &&
        return

    if [[ $1 == all ]]; then
        if ((${#marked_files[@]} != ${#list[@]})); then
            marked_files=("${list[@]}")
            mark_dir=$PWD
        else
            marked_files=()
        fi

        redraw
    else
        if [[ ${marked_files[$1]} == "${list[$1]}" ]]; then
            unset 'marked_files[VAR_TERM_CONTENT_SCROLL]'

        else
            marked_files[$1]="${list[$1]}"
            mark_dir=$PWD
        fi

        # Clear line before changing it.
        printf '\e[K'
        print_line "$1"
    fi

    # Find the program to use.
    case "$2" in
        ${HSFM_KEY_YANK:=y}|${HSFM_KEY_YANK_ALL:=Y}) file_program=(cp -iR) ;;
        ${HSFM_KEY_MOVE:=m}|${HSFM_KEY_MOVE_ALL:=M}) file_program=(mv -i)  ;;
        ${HSFM_KEY_LINK:=s}|${HSFM_KEY_LINK_ALL:=S}) file_program=(ln -s)  ;;

        # These are 'hsfm' functions.
        ${HSFM_KEY_TRASH:=d}|${HSFM_KEY_TRASH_ALL:=D})
            file_program=(trash)
        ;;

        ${HSFM_KEY_BULK_RENAME:=b}|${HSFM_KEY_BULK_RENAME_ALL:=B})
            file_program=(bulk_rename)
        ;;
    esac

    status_line
}
read_dir() {
    # Read a directory to an array and sort it directories first.
    local dirs
    local files
    local item_index
    list=()
    # NOTE. Clear list & use it directly to avoid list index issue on BSD

    # Set window name.
    printf '\e]2;hsfm: %s\e'\\ "$PWD"

    # If '$PWD' is '/', unset it to avoid '//'.
    [[ $PWD == / ]] && PWD=

    for item in "$PWD"/*; do
        if [[ -d $item ]]; then
            dirs+=("$item")
            list+=("$item")

            # Find the position of the child directory in the
            # parent directory list.
            [[ $item == "$OLDPWD" ]] &&
                ((previous_index=item_index))
            ((item_index++))
        elif [[ -f $item ]]; then
            files+=("$item")
            list+=("$item")
        fi
    done

    # list=("${dirs[@]}" "${files[@]}")

    # Indicate that the directory is empty.
    [[ -z ${list[0]} ]] &&
        list[0]=empty

    ((VAR_DIR_LIST_CNT=${#list[@]}-1))

    # Save the original dir in a second list as a backup.
    cur_list=("${list[@]}")
}

###########################################################
## GUI Functions
###########################################################

fKeyHandler() {
    # Handle special key presses.
    [[ $1 == $'\e' ]] && {
        read "${read_flags[@]}" -rsn 2

        # Handle a normal escape key press.
        [[ ${1}${REPLY} == $'\e\e['* ]] &&
            read "${read_flags[@]}" -rsn 1 _

        local special_key=${1}${REPLY}
    }

    case ${special_key:-$1} in
        # Open list item.
        # 'C' is what bash sees when the right arrow is pressed
        # ('\e[C' or '\eOC').
        # '' is what bash sees when the enter/return key is pressed.
        ${HSFM_KEY_CHILD1:=l}|\
        ${HSFM_KEY_CHILD2:=$'\e[C'}|\
        ${HSFM_KEY_CHILD3:=""}|\
        ${HSFM_KEY_CHILD4:=$'\eOC'})
            open "${list[VAR_TERM_CONTENT_SCROLL]}"
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
            if ((search == 1 && search_end_early != 1)); then
                open "$PWD"

            # If '$PWD' is '/', do nothing.
            elif [[ $PWD && $PWD != / ]]; then
                find_previous=1
                open "${PWD%/*}"
            fi
        ;;

        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${HSFM_KEY_SCROLL_DOWN1:=j}|\
        ${HSFM_KEY_SCROLL_DOWN2:=$'\e[B'}|\
        ${HSFM_KEY_SCROLL_DOWN3:=$'\eOB'})
            ((VAR_TERM_CONTENT_SCROLL < VAR_DIR_LIST_CNT)) && {
                ((VAR_TERM_CONTENT_SCROLL++))

                if ((VAR_TERM_SCROLL_CURSOR + 1 < VAR_TERM_CONTENT_MAX_CNT)); then
                    ((VAR_TERM_SCROLL_CURSOR++))
                else
                # elif ((VAR_TERM_SCROLL_CURSOR + 1 == VAR_TERM_CONTENT_MAX_CNT)); then
                    printf '\e7\e[2H\e[K\e8'
                    # read x
                fi

                print_line "$((VAR_TERM_CONTENT_SCROLL-1))"
                printf '\n'
                print_line "$VAR_TERM_CONTENT_SCROLL"
                tab_line
                status_line
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
            ((VAR_TERM_CONTENT_SCROLL > 0)) && {
                ((VAR_TERM_CONTENT_SCROLL--))

                print_line "$((VAR_TERM_CONTENT_SCROLL+1))"

                if ((VAR_TERM_SCROLL_CURSOR < 1)); then
                    printf '\e[L'
                else
                    printf '\e[A'
                    ((VAR_TERM_SCROLL_CURSOR--))
                fi

                print_line "$VAR_TERM_CONTENT_SCROLL"
                tab_line
                status_line
            }
        ;;

        # Go to top.
        ${HSFM_KEY_TO_TOP:=g})
            ((VAR_TERM_CONTENT_SCROLL != 0)) && {
                VAR_TERM_CONTENT_SCROLL=0
                redraw
            }
        ;;

        # Go to bottom.
        ${HSFM_KEY_TO_BOTTOM:=G})
            ((VAR_TERM_CONTENT_SCROLL != VAR_DIR_LIST_CNT)) && {
                ((VAR_TERM_CONTENT_SCROLL=VAR_DIR_LIST_CNT))
                redraw
            }
        ;;

        # Show hidden files.
        ${HSFM_KEY_HIDDEN:=.})
            # 'a=a>0?0:++a': Toggle between both values of 'shopt_flags'.
            #                This also works for '3' or more values with
            #                some modification.
            shopt_flags=(u s)
            shopt -"${shopt_flags[((a=${a:=$HSFM_HIDDEN}>0?0:++a))]}" dotglob
            redraw full
        ;;

        # Search.
        ${HSFM_KEY_SEARCH:=/})
            # cmd_line "/" "search"
            cmd_handler "search" "${list[VAR_TERM_CONTENT_SCROLL]##*/}"

            # If the search came up empty, redraw the current dir.
            if [[ -z ${list[*]} ]]; then
                list=("${cur_list[@]}")
                ((VAR_DIR_LIST_CNT=${#list[@]}-1))
                redraw
                search=
            else
                search=1
            fi
        ;;

        # Spawn a shell.
        ${HSFM_KEY_SHELL:=!})
            reset_terminal

            # Make hsfm aware of how many times it is nested.
            export HSFM_LEVEL
            ((HSFM_LEVEL++))

            cd "$PWD" && "$SHELL"
            setup_terminal
            redraw full
        ;;

        # Mark files for operation.
        ${HSFM_KEY_YANK:=y}|\
        ${HSFM_KEY_MOVE:=m}|\
        ${HSFM_KEY_TRASH:=d}|\
        ${HSFM_KEY_LINK:=s}|\
        ${HSFM_KEY_BULK_RENAME:=b})
            mark "$VAR_TERM_CONTENT_SCROLL" "$1"
        ;;

        # Mark all files for operation.
        ${HSFM_KEY_YANK_ALL:=Y}|\
        ${HSFM_KEY_MOVE_ALL:=M}|\
        ${HSFM_KEY_TRASH_ALL:=D}|\
        ${HSFM_KEY_LINK_ALL:=S}|\
        ${HSFM_KEY_BULK_RENAME_ALL:=B})
            mark all "$1"
        ;;

        # Do the file operation.
        ${HSFM_KEY_PASTE:=p})
            [[ ${marked_files[*]} ]] && {
                [[ ! -w $PWD ]] && {
                    # cmd_line "warn: no write access to dir."
                    cmd_handler "log" "warn: no write access to dir."
                    return
                }

                # Clear the screen to make room for a prompt if needed.
                # clear_screen
                # reset_terminal

                stty echo
                # printf '\e[1mhsfm\e[m: %s\n' "Running ${file_program[0]}"
                "${file_program[@]}" "${marked_files[@]}" .
                stty -echo

                marked_files=()
                setup_terminal
                redraw full
            }
        ;;

        # Clear all marked files.
        ${HSFM_KEY_CLEAR:=c})
            [[ ${marked_files[*]} ]] && {
                marked_files=()
                redraw
            }
        ;;

        # open file with command
        ${HSFM_KEY_OPEN_CMD:=:})
            # cmd_line ":" "${list[VAR_TERM_CONTENT_SCROLL]##*/}"
            cmd_handler "shell" "${list[VAR_TERM_CONTENT_SCROLL]##*/}"
        ;;

        # Show file attributes.
        ${HSFM_KEY_ATTRIBUTES:=x})
            [[ -e "${list[VAR_TERM_CONTENT_SCROLL]}" ]] && {
                clear_screen
                # tab_line
                status_line "${list[VAR_TERM_CONTENT_SCROLL]}"
                "${HSFM_STAT_CMD:-stat}" "${list[VAR_TERM_CONTENT_SCROLL]}"
                read -ern 1
                redraw
            }
        ;;

        # Show help info.
        ${HSFM_KEY_HELP:=H})
            clear_screen
            status_line "Help info"
            fHelp
            read -ern 1
            redraw
        ;;

        # Go to dir.
        ${HSFM_KEY_GO_DIR:=g})
            cmd_line "go to dir: " "dirs"

            # Let 'cd' know about the current directory.
            cd "$PWD" &>/dev/null ||:

            [[ $cmd_reply ]] &&
                cd "${cmd_reply/\~/$HOME}" &>/dev/null &&
                    open "$PWD"
        ;;

        # Go to '$HOME'.
        ${HSFM_KEY_GO_HOME:='~'})
            open ~
        ;;

        # Go to trash.
        ${HSFM_KEY_GO_TRASH:=t})
            get_os
            open "$HSFM_TRASH"
        ;;

        # Go to previous dir.
        ${HSFM_KEY_PREVIOUS:=-})
            open "$OLDPWD"
        ;;

        # Refresh current dir.
        ${HSFM_KEY_REFRESH:=e})
            open "$PWD"
        ;;

        # Directory favourites.
        [1-9])
            favourite="HSFM_FAV${1}"
            favourite="${!favourite}"

            [[ $favourite ]] &&
                open "$favourite"
        ;;

        # Quit and store current directory in a file for CD on exit.
        # Don't allow user to redefine 'q' so a bad keybinding doesn't
        # remove the option to quit.
        q)
        cmd_handler "exit"
            # : "${HSFM_CD_FILE:=${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/.hsfm_d}"
            #
            # [[ -w $HSFM_CD_FILE ]] &&
            #     rm "$HSFM_CD_FILE"
            #
            # [[ ${HSFM_CD_ON_EXIT:=1} == 1 ]] &&
            #     printf '%s\n' "$PWD" > "$HSFM_CD_FILE"
            #
            # exit
        ;;
    esac
}

get_mime_type() {
    # Get a file's mime_type.
    mime_type=$(file "-${file_flags:-biL}" "$1" 2>/dev/null)
}

###########################################################
## Open Functions
###########################################################
cmd_handler()
{
    ## Pre settings.
    ################################################################
    # new functon for handle all commands
    printf '\e7\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"

    ## Main handler
    ################################################################
    case ${1} in
        "log")
            shift 1
            cmd_log "$@"
            ;;
        "shell")
            cmd_line_interact "${HSFM_KEY_OPEN_CMD}" "shell" "${list[VAR_TERM_CONTENT_SCROLL]##*/}"
            ;;
        "search")
            cmd_line_interact "${HSFM_KEY_SEARCH}" "search"
            ;;
        "exit")
            cmd_exit
            ;;
    esac

    ## Post settings.
    ################################################################
    # Unset tab completion variables since we're done.
    # unset comp c

    # '\e[2K':   Clear the entire cmd_line on finish.
    # '\e[?25l': Hide the cursor.
    # '\e8':     Restore cursor position.
    # printf '\e[2K\e[?25l\e8'
    printf '\e[?25l\e8'

    # we don't need redraw after commands running
    # this will be clear after redraw
    # redraw

}
cmd_line_interact() {
    # Write to the command_line (under status_line).
    cmd_list=("redraw" "search" "mkdir" "mkfile" "touch" "open" "exit" "rename" "more" "help")
    cmd_prefix=${1}
    cmd_function=${2:""}
    cmd_file=${3:""}
    cmd_reply=""

    # '\r\e[K': Redraw the read prompt on every keypress.
    #           This is mimicking what happens normally.
    while IFS= read -rsn 1 -p $'\r\e[K'"${cmd_prefix}${cmd_reply}" read_reply; do
        case $read_reply in
            # Backspace.
            $'\177'|$'\b')
                cmd_reply=${cmd_reply%?}

                # Clear tab-completion.
                unset comp c
            ;;

            # Tab.
            $'\t')
                comp_glob="$cmd_reply*"

                # Pass the argument dirs to limit completion to directories.
                # [[ $2 == dirs ]] &&
                #     comp_glob="$cmd_reply*/"

                # Generate a completion list once.
                # [[ -z ${comp[0]} ]] &&
                #     IFS=$'\n' read -d "" -ra comp < <(compgen -G "$comp_glob")
                    # IFS=$'\n' read -d "" -ra comp < <(compgen -G -W "redraw search" "$comp_glob")
                if [[ -z ${comp[0]} ]]
                then
                    # IFS=$'\n' read -d "" -ra globpat < <(compgen -G "$comp_glob")
                    IFS=$'\n' read -d "" -ra wordlist < <(compgen -W "${cmd_list[*]}" ${cmd_reply})
                    # comp=$globpat
                    comp+=$wordlist
                fi

                # On each tab press, cycle through the completion list.
                [[ -n ${comp[c]} ]] && {
                    cmd_reply=${comp[c]}
                    ((c=c >= ${#comp[@]}-1 ? 0 : ++c))
                }
            ;;

            # Escape / Custom 'no' value (used as a replacement for '-n 1').
            $'\e'|${3:-null})
                read "${read_flags[@]}" -rsn 2
                cmd_reply=
                cmd_log ${cmd_reply}
                break
            ;;

            # Enter/Return.
            "")
                [[ ${cmd_function} != shell ]] && {
                    # # Unset tab completion variables since we're done.
                    # unset comp c
                    # return
                    break
                }

                tmp_command=$(echo ${cmd_reply} | tr -s ' ' |sed 's/^ //g' | cut -d ' ' -f 1)
                tmp_args=$(echo ${cmd_reply} | tr -s ' ' |sed 's/^ //g' | cut -d ' ' -f 2-)
                # printf "\r\e[2K%s" ${tmp_command}
                case ${tmp_command} in
                    "echo")
                        # printf "\r\e[2K%s"
                        cmd_log "${tmp_args}"
                        ;;
                    "search")
                        cmd_search "${tmp_args}"
                        # search_end_early=1
                        ;;
                    "rename")
                        cmd_rename "${tmp_args}"
                        ;;
                    "mkdir")
                        cmd_mkdir "${tmp_args}"
                        ;;
                    "mkfile"|"touch")
                        cmd_mkfile "${tmp_args}"
                        ;;
                    "vim")
                        cmd_vim "${cmd_file}"
                        ;;
                    "exit")
                        cmd_exit
                        ;;
                    "open")
                        open "${tmp_args}"
                        ;;
                    "help")
                        cmd_help
                        ;;
                    *)
                    # cmd_handler "log"
                    # printf '\r\e[%sH\e[?25h%s' "$VAR_TERM_LINE_CNT" "Unknown commands.${tmp_command}: ${tmp_args}"
                    cmd_log "Unknown commands: ${tmp_command} ${tmp_args}"
                    ;;
                esac

                # [[ $1 == :  ]] && {
                #     nohup "${cmd_reply}" "$2" &>/dev/null &
                # }

                break
            ;;

            # Custom 'yes' value (used as a replacement for '-n 1').
            ${2:-null})
                cmd_reply=$read_reply
                break
            ;;

            # Replace '~' with '$HOME'.
            "~")
                cmd_reply+=$HOME
            ;;

            # Anything else, add it to read reply.
            *)
                cmd_reply+=$read_reply

                # Clear tab-completion.
                unset comp c
            ;;
        esac

        [[ ${cmd_function} == "search" ]] && {
            cmd_search "${cmd_reply}"
        }

    done

    # Unset tab completion variables since we're done.
    unset comp c
}
cmd_log()
{
    printf '\r\e[%sH\e[?25h\e[2K%s' "$VAR_TERM_LINE_CNT" "$@"
}
cmd_search()
{
    var_pattern="$*"
    # Search on keypress if search passed as an argument.
    # '\e[?25l': Hide the cursor.
    printf '\e[?25l'

    # Use a greedy glob to search.
    list=("$PWD"/*"$var_pattern"*)
    ((VAR_DIR_LIST_CNT=${#list[@]}-1))

    # Draw the search results on screen.
    VAR_TERM_CONTENT_SCROLL=0
    redraw

    # '\e[%sH':  Move cursor back to cmd-line.
    # '\e[?25h': Unhide the cursor.
    printf '\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"
}
cmd_rename()
{
    local var_new_name="$@"
    if [[ -e $var_new_name ]]; then
        cmd_handler "log" "warn: '$var_new_name' already exists."

    elif [[ -w ${list[VAR_TERM_CONTENT_SCROLL]} ]]; then
        mv "${list[VAR_TERM_CONTENT_SCROLL]}" "${PWD}/${var_new_name}"
        redraw full
    else
        cmd_handler "log" "warn: no write access to file."
    fi
}
cmd_mkdir()
{
    local var_dir_name="$@"
    if [[ -e $var_dir_name ]]; then
        cmd_log "warn: '$var_dir_name' already exists."

    elif [[ -w $PWD ]]; then
        mkdir -p "${PWD}/${var_dir_name}"
        redraw full

    else
        cmd_log "warn: no write access to dir."
    fi
}
cmd_mkfile()
{
    local var_dir_name="$@"
    if [[ -e $var_dir_name ]]; then
        cmd_log "warn: '$var_dir_name' already exists."

    elif [[ -w $PWD ]]; then
        : > "$var_dir_name"
        redraw full

    else
        cmd_log "warn: no write access to dir."
    fi
}
cmd_vim()
{
    local var_file="$@"
    if [[ -f $var_file ]]; then
        clear_screen
        reset_terminal

        vim ${var_file}

        setup_terminal
        redraw
    else
        cmd_log "warn: '$var_file' not opened"
    fi
}
cmd_help()
{
    clear_screen
    reset_terminal
    fHelp
    read p
    setup_terminal
    redraw
}
cmd_exit()
{
    : "${HSFM_CD_FILE:=${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/.hsfm_d}"

    [[ -w $HSFM_CD_FILE ]] &&
        rm "$HSFM_CD_FILE"

    [[ ${HSFM_CD_ON_EXIT:=1} == 1 ]] &&
        printf '%s\n' "$PWD" > "$HSFM_CD_FILE"

    exit 0
}

cmd_line() {
    # Write to the command_line (under status_line).
    cmd_reply=

    # '\e7':     Save cursor position.
    # '\e[?25h': Unhide the cursor.
    # '\e[%sH':  Move cursor to bottom (cmd_line).
    printf '\e7\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"

    # '\r\e[K': Redraw the read prompt on every keypress.
    #           This is mimicking what happens normally.
    while IFS= read -rsn 1 -p $'\r\e[K'"${1}${cmd_reply}" read_reply; do
        case $read_reply in
            # Backspace.
            $'\177'|$'\b')
                cmd_reply=${cmd_reply%?}

                # Clear tab-completion.
                unset comp c
            ;;

            # Tab.
            $'\t')
                comp_glob="$cmd_reply*"

                # Pass the argument dirs to limit completion to directories.
                [[ $2 == dirs ]] &&
                    comp_glob="$cmd_reply*/"

                # Generate a completion list once.
                [[ -z ${comp[0]} ]] &&
                    IFS=$'\n' read -d "" -ra comp < <(compgen -G "$comp_glob")

                # On each tab press, cycle through the completion list.
                [[ -n ${comp[c]} ]] && {
                    cmd_reply=${comp[c]}
                    ((c=c >= ${#comp[@]}-1 ? 0 : ++c))
                }
            ;;

            # Escape / Custom 'no' value (used as a replacement for '-n 1').
            $'\e'|${3:-null})
                read "${read_flags[@]}" -rsn 2
                cmd_reply=
                break
            ;;

            # Enter/Return.
            "")
                # If there's only one search result and its a directory,
                # enter it on one enter keypress.
                [[ $2 == search && -d ${list[0]} ]] && ((VAR_DIR_LIST_CNT == 0)) && {
                    # '\e[?25l': Hide the cursor.
                    printf '\e[?25l'

                    open "${list[0]}"
                    search_end_early=1

                    # Unset tab completion variables since we're done.
                    unset comp c
                    return
                }

                [[ $1 == :  ]] && {
                    nohup "${cmd_reply}" "$2" &>/dev/null &
                }

                break
            ;;

            # Custom 'yes' value (used as a replacement for '-n 1').
            ${2:-null})
                cmd_reply=$read_reply
                break
            ;;

            # Replace '~' with '$HOME'.
            "~")
                cmd_reply+=$HOME
            ;;

            # Anything else, add it to read reply.
            *)
                cmd_reply+=$read_reply

                # Clear tab-completion.
                unset comp c
            ;;
        esac

        # Search on keypress if search passed as an argument.
        [[ $2 == search ]] && {
            # '\e[?25l': Hide the cursor.
            printf '\e[?25l'

            # Use a greedy glob to search.
            list=("$PWD"/*"$cmd_reply"*)
            ((VAR_DIR_LIST_CNT=${#list[@]}-1))

            # Draw the search results on screen.
            VAR_TERM_CONTENT_SCROLL=0
            redraw

            # '\e[%sH':  Move cursor back to cmd-line.
            # '\e[?25h': Unhide the cursor.
            printf '\e[%sH\e[?25h' "$VAR_TERM_LINE_CNT"
        }
    done

    # Unset tab completion variables since we're done.
    unset comp c

    # '\e[2K':   Clear the entire cmd_line on finish.
    # '\e[?25l': Hide the cursor.
    # '\e8':     Restore cursor position.
    printf '\e[2K\e[?25l\e8'
    redraw
}
open() {
    # Open directories and files.
    if [[ -d $1/ ]]; then
        search=
        search_end_early=
        cd "${1:-/}" ||:
        redraw full

    elif [[ -f $1 ]]; then
        # Figure out what kind of file we're working with.
        get_mime_type "$1"

        # Open all text-based files in '$EDITOR'.
        # Everything else goes through 'xdg-open'/'open'.
        case "$mime_type" in
            audio/*|video/*)
                nohup "${HSFM_MEDIA_PLAYER}" "$1" &>/dev/null &
            ;;
            image/*|video/*)
                nohup "${HSFM_PICTURE_VIEWER}" "$1" &>/dev/null &
            ;;
            text/*|*x-empty*|*json*)
                # If 'hsfm' was opened as a file picker, save the opened
                # file in a file called 'opened_file'.
                ((file_picker == 1)) && {
                    printf '%s\n' "$1" > \
                        "${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/opened_file"
                    exit
                }

                clear_screen
                reset_terminal
                # "${VISUAL:-${EDITOR:-vi}}" "$1"
                fopen_editor "$1"
                setup_terminal
                redraw
            ;;

            *)
                # 'nohup':  Make the process immune to hangups.
                # '&':      Send it to the background.
                # 'disown': Detach it from the shell.
                nohup "${HSFM_OPENER:-${opener:-xdg-open}}" "$1" &>/dev/null &
                disown
            ;;
        esac
    fi
}
function fopen_editor() {
    "${VISUAL:-${EDITOR:-vi}}" "$1"
}

## File Operation Function
###########################################################
trash() {
    # Trash a file.
    cmd_line "trash [${#marked_files[@]}] items? [y/n]: " y n

    [[ $cmd_reply != y ]] &&
        return

    if [[ $HSFM_TRASH_CMD ]]; then
        # Pass all but the last argument to the user's
        # custom script. command is used to prevent this function
        # from conflicting with commands named "trash".
        command "$HSFM_TRASH_CMD" "${@:1:$#-1}"

    else
        cd "$HSFM_TRASH" || cmd_line "error: Can't cd to trash directory."

        if cp -alf "$@" &>/dev/null; then
            rm -r "${@:1:$#-1}"
        else
            mv -f "$@"
        fi

        # Go back to where we were.
        cd "$OLDPWD" ||:
    fi
}

bulk_rename() {
    # Bulk rename files using '$EDITOR'.
    rename_file=${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm/bulk_rename
    marked_files=("${@:1:$#-1}")

    # Save marked files to a file and open them for editing.
    printf '%s\n' "${marked_files[@]##*/}" > "$rename_file"
    "${EDITOR:-vi}" "$rename_file"

    # Read the renamed files to an array.
    IFS=$'\n' read -d "" -ra changed_files < "$rename_file"

    # If the user deleted a line, stop here.
    ((${#marked_files[@]} != ${#changed_files[@]})) && {
        rm "$rename_file"
        cmd_line "error: Line mismatch in rename file. Doing nothing."
        return
    }

    printf '%s\n%s\n' \
        "# This file will be executed when the editor is closed." \
        "# Clear the file to abort." > "$rename_file"

    # Construct the rename commands.
    for ((i=0;i<${#marked_files[@]};i++)); {
        [[ ${marked_files[i]} != "${PWD}/${changed_files[i]}" ]] && {
            printf 'mv -i -- %q %q\n' \
                "${marked_files[i]}" "${PWD}/${changed_files[i]}"
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
    setup_terminal
}


###########################################################
## Others
###########################################################
get_os() {
    # Figure out the current operating system to set some specific variables.
    # '$OSTYPE' typically stores the name of the OS kernel.
    case $OSTYPE in
        # Mac OS X / macOS.
        darwin*)
            opener=open
            file_flags=bIL
        ;;

        haiku)
            opener=open

            [[ -z $HSFM_TRASH_CMD ]] &&
                HSFM_TRASH_CMD=trash

            [[ $HSFM_TRASH_CMD == trash ]] && {
                HSFM_TRASH=$(finddir -v "$PWD" B_TRASH_DIRECTORY)
                mkdir -p "$HSFM_TRASH"
            }
        ;;
    esac
}

setup_options() {
    # Some options require some setup.
    # This function is called once on open to parse
    # select options so the operation isn't repeated
    # multiple times in the code.

    # Format for normal files.
    [[ $HSFM_FILE_FORMAT == *%f* ]] && {
        file_pre=${HSFM_FILE_FORMAT/'%f'*}
        file_post=${HSFM_FILE_FORMAT/*'%f'}
    }

    # Format for marked files.
    # Use affixes provided by the user or use defaults, if necessary.
    if [[ $HSFM_MARK_FORMAT == *%f* ]]; then
        mark_pre=${HSFM_MARK_FORMAT/'%f'*}
        mark_post=${HSFM_MARK_FORMAT/*'%f'}
    else
        mark_pre=" "
        mark_post="*"
    fi

    # Find supported 'file' arguments.
    file -I &>/dev/null || : "${file_flags:=biL}"
}

get_ls_colors() {
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

fHelp() {
    echo "Help Info\n"
    printf "\n%s\n" "## Help operations."
    printf "% -32s: %s\n"  "HSFM_KEY_HELP"                  ${HSFM_KEY_HELP}
    printf "% -32s: %s\n"  "HSFM_KEY_CHILD1"                ${HSFM_KEY_CHILD1}
    printf "% -32s: %s\n"  "HSFM_KEY_CHILD2"                ${HSFM_KEY_CHILD2}
    printf "% -32s: %s\n"  "HSFM_KEY_CHILD3"                ${HSFM_KEY_CHILD3}
    printf "% -32s: %s\n"  "HSFM_KEY_PARENT1"               ${HSFM_KEY_PARENT1}
    printf "% -32s: %s\n"  "HSFM_KEY_PARENT2"               ${HSFM_KEY_PARENT2}
    printf "% -32s: %s\n"  "HSFM_KEY_PARENT3"               ${HSFM_KEY_PARENT3}
    printf "% -32s: %s\n"  "HSFM_KEY_PARENT4"               ${HSFM_KEY_PARENT4}
    printf "% -32s: %s\n"  "HSFM_KEY_PREVIOUS"              ${HSFM_KEY_PREVIOUS}
    printf "% -32s: %s\n"  "HSFM_KEY_SEARCH"                ${HSFM_KEY_SEARCH}
    printf "% -32s: %s\n"  "HSFM_KEY_SHELL"                 ${HSFM_KEY_SHELL}
    printf "% -32s: %s\n"  "HSFM_KEY_SCROLL_DOWN1"          ${HSFM_KEY_SCROLL_DOWN1}
    printf "% -32s: %s\n"  "HSFM_KEY_SCROLL_DOWN2"          ${HSFM_KEY_SCROLL_DOWN2}
    printf "% -32s: %s\n"  "HSFM_KEY_SCROLL_UP1"            ${HSFM_KEY_SCROLL_UP1}
    printf "% -32s: %s\n"  "HSFM_KEY_SCROLL_UP2"            ${HSFM_KEY_SCROLL_UP2}
    printf "% -32s: %s\n"  "HSFM_KEY_TO_TOP"                ${HSFM_KEY_TO_TOP}
    printf "% -32s: %s\n"  "HSFM_KEY_TO_BOTTOM"             ${HSFM_KEY_TO_BOTTOM}
    printf "% -32s: %s\n"  "HSFM_KEY_GO_DIR"                ${HSFM_KEY_GO_DIR}
    printf "% -32s: %s\n"  "HSFM_KEY_GO_HOME"               ${HSFM_KEY_GO_HOME}
    printf "% -32s: %s\n"  "HSFM_KEY_GO_TRASH"              ${HSFM_KEY_GO_TRASH}
    printf "% -32s: %s\n"  "HSFM_KEY_OPEN_CMD"              ${HSFM_KEY_OPEN_CMD}

    printf "\n%s\n" "## File operations."
    printf "% -32s: %s\n"  "HSFM_KEY_YANK"                  ${HSFM_KEY_YANK}
    printf "% -32s: %s\n"  "HSFM_KEY_MOVE"                  ${HSFM_KEY_MOVE}
    printf "% -32s: %s\n"  "HSFM_KEY_TRASH"                 ${HSFM_KEY_TRASH}
    printf "% -32s: %s\n"  "HSFM_KEY_LINK"                  ${HSFM_KEY_LINK}
    printf "% -32s: %s\n"  "HSFM_KEY_BULK_RENAME"           ${HSFM_KEY_BULK_RENAME}
    printf "% -32s: %s\n"  "HSFM_KEY_YANK_ALL"              ${HSFM_KEY_YANK_ALL}
    printf "% -32s: %s\n"  "HSFM_KEY_MOVE_ALL"              ${HSFM_KEY_MOVE_ALL}
    printf "% -32s: %s\n"  "HSFM_KEY_TRASH_ALL"             ${HSFM_KEY_TRASH_ALL}
    printf "% -32s: %s\n"  "HSFM_KEY_LINK_ALL"              ${HSFM_KEY_LINK_ALL}
    printf "% -32s: %s\n"  "HSFM_KEY_BULK_RENAME_ALL"       ${HSFM_KEY_BULK_RENAME_ALL}
    printf "% -32s: %s\n"  "HSFM_KEY_PASTE"                 ${HSFM_KEY_PASTE}
    printf "% -32s: %s\n"  "HSFM_KEY_CLEAR"                 ${HSFM_KEY_CLEAR}
    printf "% -32s: %s\n"  "HSFM_KEY_RENAME"                ${HSFM_KEY_RENAME}
    printf "% -32s: %s\n"  "HSFM_KEY_MKDIR"                 ${HSFM_KEY_MKDIR}
    printf "% -32s: %s\n"  "HSFM_KEY_MKFILE"                ${HSFM_KEY_MKFILE}

    printf "\n%s\n" "## Miscellaneous"
    printf "% -32s: %s\n"  "HSFM_KEY_ATTRIBUTES"            ${HSFM_KEY_ATTRIBUTES}
    printf "% -32s: %s\n"  "HSFM_KEY_EXECUTABLE"            ${HSFM_KEY_EXECUTABLE}
    printf "% -32s: %s\n"  "HSFM_KEY_HIDDEN"                ${HSFM_KEY_HIDDEN}
}

## Main Function
###########################################################
function fmain() {
    # Handle a directory as the first argument.
    # 'cd' is a cheap way of finding the full path to a directory.
    # It updates the '$PWD' variable on successful execution.
    # It handles relative paths as well as '../../../'.
    #
    # '||:': Do nothing if 'cd' fails. We don't care.
    cd "${2:-$1}" &>/dev/null ||:

    [[ $1 == -v ]] && {
        printf '%s\n' "hsfm 2.2"
        exit
    }

    [[ $1 == -h ]] && {
        man hsfm
        exit
    }

    # Store file name in a file on open instead of using 'HSFM_OPENER'.
    # Used in 'hsfm.vim'.
    [[ $1 == -p ]] &&
        file_picker=1

    # bash 5 and some versions of bash 4 don't allow SIGWINCH to interrupt
    # a 'read' command and instead wait for it to complete. In this case it
    # causes the window to not redraw on resize until the user has pressed
    # a key (causing the read to finish). This sets a read timeout on the
    # affected versions of bash.
    # NOTE: This shouldn't affect idle performance as the loop doesn't do
    # anything until a key is pressed.
    # SEE: https://github.com/dylanaraps/hsfm/issues/48
    ((BASH_VERSINFO[0] > 3)) &&
        read_flags=(-t 0.05)

    ((${HSFM_LS_COLORS:=1} == 1)) &&
        get_ls_colors

    ((${HSFM_HIDDEN:=0} == 1)) &&
        shopt -s dotglob

    # Create the trash and cache directory if they don't exist.
    mkdir -p "${XDG_CACHE_HOME:=${HOME}/.cache}/hsfm" \
             "${HSFM_TRASH:=${XDG_DATA_HOME:=${HOME}/.local/share}/hsfm/trash}"

    # 'nocaseglob': Glob case insensitively (Used for case insensitive search).
    # 'nullglob':   Don't expand non-matching globs to themselves.
    shopt -s nocaseglob nullglob

    # Trap the exit signal (we need to reset the terminal to a useable state.)
    # trap 'reset_terminal' EXIT
    trap "trap - SIGTERM && reset_terminal &&kill -- -$$" SIGINT SIGTERM EXIT

    # Trap the window resize signal (handle window resize events).
    trap 'resize_term_win' WINCH


    get_os
    get_term_size
    setup_options
    setup_terminal
    redraw full

    # Vintage infinite loop.
    for ((;;)); {
        read "${read_flags[@]}" -srn 1 && fKeyHandler "$REPLY"

        # Exit if there is no longer a terminal attached.
        [[ -t 1 ]] || exit 1
    }
}

fmain "$@"
