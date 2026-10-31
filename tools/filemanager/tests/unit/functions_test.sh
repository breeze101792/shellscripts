#!/usr/bin/env bash
#
# One case per function: every function in the script is called at least once
# and its contract is pinned. The terminal layer and the interactive prompts are
# stubbed, external commands resolve to fakes in a private PATH, and every case
# runs inside a mktemp tree.
#
# Usage: tests/unit/functions_test.sh [script]

set -o pipefail

script=${1:-filemanager.sh}
case ${script} in
    /*) ;;
    *) script=$(realpath "${script}") ;;
esac
self=$(realpath "$0")

fixture=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-func.XXXXXX")
cleanup() { rm -rf "${fixture}"; }
trap cleanup EXIT

stub=${fixture}/stub
bin=${fixture}/bin
tree=${fixture}/tree
work=${fixture}/work
mkdir -p "${stub}" "${bin}" "${tree}" "${work}"

export HOME="${fixture}"
export HSFM_FILE_CONFIG="${HOME}/.hsfm.sh"
export HSFM_PATH_CACHE="${HOME}/.cache/hsfm"
export XDG_CACHE_HOME="${HOME}/.cache"
export STUB_LOG="${stub}"
export TERM=dumb
export LC_ALL=C
# fsys_open branches on DISPLAY; keep it unset so the unknown-type path is taken.
unset DISPLAY TMUX

mkdir -p "${HSFM_PATH_CACHE}"

# --- external command fakes ------------------------------------------------
# Nothing here may launch a real editor, pager, shell, file manager or
# background viewer. Each fake logs its arguments under "${stub}".

cat > "${bin}/stty" <<'EOF'
#!/bin/sh
if [ "$1" = size ]; then echo "24 80"; exit 0; fi
printf 'stty %s\n' "$*" >> "$STUB_LOG/stty"
exit 0
EOF

cat > "${bin}/vim" <<'EOF'
#!/bin/sh
printf 'vim %s\n' "$*" >> "$STUB_LOG/vim"
# One-shot rewrite, used by the bulk-rename test.
if [ -n "$STUB_VIM_REWRITE" ] && [ -f "$STUB_VIM_REWRITE" ]; then
    cat "$STUB_VIM_REWRITE" > "$1"
    rm -f "$STUB_VIM_REWRITE"
fi
exit 0
EOF

cat > "${bin}/nano" <<'EOF'
#!/bin/sh
printf 'nano %s\n' "$*" >> "$STUB_LOG/nano"
exit 0
EOF

cat > "${bin}/less" <<'EOF'
#!/bin/sh
cat > /dev/null
printf 'less %s\n' "$*" >> "$STUB_LOG/less"
exit 0
EOF

cat > "${bin}/xxd" <<'EOF'
#!/bin/sh
printf 'xxd %s\n' "$*" >> "$STUB_LOG/xxd"
printf '00000000: 0000\n'
exit 0
EOF

cat > "${bin}/xdg-open" <<'EOF'
#!/bin/sh
printf 'xdg-open %s\n' "$*" >> "$STUB_LOG/xdg-open"
exit 0
EOF

cat > "${bin}/open" <<'EOF'
#!/bin/sh
printf 'open %s\n' "$*" >> "$STUB_LOG/open"
exit 0
EOF

cat > "${bin}/tput" <<'EOF'
#!/bin/sh
printf 'tput %s\n' "$*" >> "$STUB_LOG/tput"
exit 0
EOF

cat > "${bin}/nohup" <<'EOF'
#!/bin/sh
printf 'nohup %s\n' "$*" >> "$STUB_LOG/nohup"
exit 0
EOF

cat > "${bin}/bash" <<'EOF'
#!/bin/sh
printf 'bash %s\n' "$*" >> "$STUB_LOG/bash"
exit 0
EOF

# An archiver fake creates an empty file named by its first non-option
# argument, which is how zip -j is called.
cat > "${bin}/zip" <<'EOF'
#!/bin/sh
printf 'zip %s\n' "$*" >> "$STUB_LOG/zip"
for arg in "$@"; do
    case $arg in
        -*) ;;
        *) : > "$arg"; break ;;
    esac
done
exit 0
EOF

# An extractor fake leaves a marker in the current directory and succeeds.
cat > "${bin}/tar" <<'EOF'
#!/bin/sh
printf 'tar %s\n' "$*" >> "$STUB_LOG/tar"
: > stub_tar_output
exit 0
EOF

for name in unzip 7z bunzip2 unrar uncompress; do
    cat > "${bin}/${name}" <<EOF
#!/bin/sh
printf '%s %s\n' "${name}" "\$*" >> "\$STUB_LOG/${name}"
: > stub_${name}_output
exit 0
EOF
done

cat > "${bin}/df" <<'EOF'
#!/bin/sh
printf 'df %s\n' "$*" >> "$STUB_LOG/df"
echo "Filesystem Size Used Avail Use% Mounted on"
echo "/dev/stub  100G  1G  99G   1% /"
exit 0
EOF

cat > "${bin}/stat" <<'EOF'
#!/bin/sh
printf 'stat %s\n' "$*" >> "$STUB_LOG/stat"
echo "  File: stub"
exit 0
EOF

# The harness drives programs through fake names; this one records its argv.
cat > "${bin}/fakeprog" <<'EOF'
#!/bin/sh
printf 'fakeprog %s\n' "$*" >> "$STUB_LOG/fakeprog"
exit 0
EOF

chmod +x "${bin}"/*

export PATH="${bin}:${PATH}"

# --- fixture tree ----------------------------------------------------------

mkdir -p "${tree}/gamma"
printf 'alpha\n' > "${tree}/alpha.txt"
printf 'beta\n' > "${tree}/beta.log"
printf 'inner\n' > "${tree}/gamma/inner.txt"
printf 'delta\n' > "${tree}/delta.txt"
printf 'hidden\n' > "${tree}/.hidden"
printf 'PK\n' > "${tree}/sample.zip"
printf '\000\001\002binary\n' > "${tree}/blob.bin"

cd "${tree}"

# The script relies on unset-as-empty; the harness keeps nounset off throughout.
set +u
# shellcheck disable=SC1090
source "${script}" >/dev/null 2>&1

# --- terminal layer --------------------------------------------------------
# Capture the terminal primitives instead of writing to a tty. The originals are
# kept under real_* so the L0 cases and the redirected-fout flows can run them.

save_real() {
    eval "real_$1() $(declare -f "$1" | tail -n +2)"
}

save_real fout_print
save_real fout_flush
save_real fout_setup
save_real fout_reset
save_real fout_clear
save_real fout_draw_window
save_real fview_redraw
save_real fprompt_wait
save_real fprompt_confirm
save_real fin_prompt

fout_calls=()
fout_last=""
n_print=0
n_flush=0
n_setup=0
n_reset=0
n_clear=0
n_window=0
redraw_n=0
prompt_n=0
prompt_last=""
prompt_reply=""

reset_fout() {
    fout_calls=()
    fout_last=""
    n_print=0
    n_flush=0
    n_setup=0
    n_reset=0
    n_clear=0
    n_window=0
}

fout_stub() {
    fout_print() { fout_last="$*"; fout_calls+=("$*"); n_print=$((n_print + 1)); }
    fout_flush() { n_flush=$((n_flush + 1)); }
    fout_setup() { n_setup=$((n_setup + 1)); }
    fout_reset() { n_reset=$((n_reset + 1)); }
    fout_clear() { n_clear=$((n_clear + 1)); }
    fout_draw_window() { fout_last="$*"; fout_calls+=("$*"); n_window=$((n_window + 1)); }
}

fout_real() {
    local name
    for name in fout_print fout_flush fout_setup fout_reset fout_clear fout_draw_window; do
        eval "${name}() $(declare -f "real_${name}" | tail -n +2)"
    done
}

fout_stub

# Count repaints without changing them.
fview_redraw() { redraw_n=$((redraw_n + 1)); real_fview_redraw "$@"; }

# Interactive prompts: count them, never wait for a key.
fprompt_wait() { prompt_n=$((prompt_n + 1)); prompt_last="wait:$1"; }
fprompt_confirm() { prompt_n=$((prompt_n + 1)); prompt_last="confirm:$1"; FM_ED_COMMIT="${prompt_reply}"; }
fin_prompt() { prompt_n=$((prompt_n + 1)); prompt_last="prompt:${1}|${2}"; }

# --- assertions ------------------------------------------------------------

fail=0
total=0

check() {
    local name=$1
    local got=$2
    local want=$3
    total=$((total + 1))
    if [ "${got}" = "${want}" ]; then
        printf 'ok   %s\n' "${name}"
    else
        printf 'FAIL %s\n     got:  %s\n     want: %s\n' "${name}" "${got}" "${want}"
        fail=$((fail + 1))
    fi
}

has() {
    case "$1" in
        *"$2"*) echo yes ;;
        *) echo no ;;
    esac
}

yes_no() {
    if "$@"; then echo yes; else echo no; fi
}

fresh_dir() {
    local dir="${work}/$1"
    rm -rf "${dir}"
    mkdir -p "${dir}"
    printf '%s\n' "${dir}"
}

# fdir_read needs the window and the lists in a known state.
load_tree() {
    cd "${tree}"
    HSFM_READ_DIR_MODE=${DEF_TERM_READ_DIR_MODE_FAST_LS}
    fdir_read >/dev/null 2>&1
}

# index_of <basename> prints the entry's index in the loaded list.
index_of() {
    local i
    for i in "${!FM_DIR_FILE_LIST[@]}"; do
        case ${FM_DIR_FILE_LIST[${i}]} in
            */"$1") printf '%s' "${i}"; return ;;
        esac
    done
    printf '0'
}

# cursor_on <basename> puts the directory cursor on that entry.
cursor_on() {
    FM_DIR_SCROLL_IDX=$(index_of "$1")
}

# wait_for_file polls for a detached process to leave its mark (200 ms max).
wait_for_file() {
    local tries=0
    while [ ! -s "$1" ] && [ "${tries}" -lt 20 ]; do
        sleep 0.01
        tries=$((tries + 1))
    done
    test -s "$1"
}

# ===========================================================================
# L0 Driver: fout_*
# ===========================================================================

# --- fout_sanitize_name ----------------------------------------------------
check "fout_sanitize_name: space and slash become underscore" \
    "$(printf 'a b/c' | fout_sanitize_name)" "a_b_c"
check "fout_sanitize_name: leading and trailing underscore stripped" \
    "$(printf '/x/' | fout_sanitize_name)" "x"
check "fout_sanitize_name: runs of underscore squeezed" \
    "$(printf 'a  b' | fout_sanitize_name)" "a_b"

# --- fout_print ------------------------------------------------------------
fout_real
FM_VIEW_PRINT_BUFFER=""
FM_VIEW_PRINT_BUFFER_ENABLE=true
fout_print 'hello %s' world > "${fixture}/print.out"
check "fout_print: appends to the buffer when it is on" \
    "${FM_VIEW_PRINT_BUFFER}" "hello world"
check "fout_print: emits nothing while buffering" \
    "$(cat "${fixture}/print.out")" ""

FM_VIEW_PRINT_BUFFER=""
FM_VIEW_PRINT_BUFFER_ENABLE=false
fout_print 'plain %s' text > "${fixture}/print.out"
check "fout_print: prints when buffering is off" \
    "$(cat "${fixture}/print.out")" "plain text"

# --- fout_flush ------------------------------------------------------------
FM_VIEW_PRINT_BUFFER="pending"
FM_VIEW_PRINT_BUFFER_ENABLE=true
real_fout_flush > "${fixture}/flush.out"
check "fout_flush: emits the buffer" "$(cat "${fixture}/flush.out")" "pending"
check "fout_flush: clears the buffer" "${FM_VIEW_PRINT_BUFFER}" ""
check "fout_flush: turns buffering off" "${FM_VIEW_PRINT_BUFFER_ENABLE}" "false"

# --- fout_setup ------------------------------------------------------------
: > "${stub}/stty"
FM_VIEW_MAINWIN_HEIGHT=20
real_fout_setup > "${fixture}/setup.out"
check "fout_setup: enters the alternate screen" \
    "$(has "$(cat "${fixture}/setup.out")" '1049h')" "yes"
check "fout_setup: sets the scroll region from the main window height" \
    "$(has "$(cat "${fixture}/setup.out")" '1;20r')" "yes"
check "fout_setup: hides input echo" \
    "$(has "$(cat "${stub}/stty")" '-echo')" "yes"

# --- fout_reset ------------------------------------------------------------
: > "${stub}/stty"
real_fout_reset > "${fixture}/reset.out"
check "fout_reset: restores the main screen buffer" \
    "$(has "$(cat "${fixture}/reset.out")" '1049l')" "yes"
check "fout_reset: shows the cursor again" \
    "$(has "$(cat "${fixture}/reset.out")" '?25h')" "yes"
check "fout_reset: restores input echo" \
    "$(cat "${stub}/stty")" "stty echo"

# --- fout_clear ------------------------------------------------------------
FM_VIEW_HEIGHT=24
FM_VIEW_MAINWIN_HEIGHT=20
FM_VIEW_TAB_LINE_HEIGHT=2
real_fout_clear > "${fixture}/clear.out"
check "fout_clear: moves to the last line" \
    "$(has "$(cat "${fixture}/clear.out")" '24H')" "yes"
check "fout_clear: re-sets the scroll region below the tab line" \
    "$(has "$(cat "${fixture}/clear.out")" '1;22r')" "yes"

# Back to the capture stubs for everything above the driver.
fout_stub
reset_fout

# --- fout_draw_window ------------------------------------------------------
HSFM_COLOR_FLOAT_WIN=97
HSFM_COLOR_FLOAT_WIN_LABEL=30
reset_fout
real_fout_draw_window 5 0 80 6 "T" "one" "two"
check "fout_draw_window: brackets the title" \
    "$(has "${fout_calls[*]}" '[T]')" "yes"
check "fout_draw_window: places the first line below the title" \
    "$(has "${fout_calls[*]}" '6;0')" "yes"
check "fout_draw_window: draws each buffer line" \
    "$(has "${fout_calls[*]}" ' one ')" "yes"
check "fout_draw_window: draws the last buffer line" \
    "$(has "${fout_calls[*]}" ' two ')" "yes"

reset_fout
real_fout_draw_window 5 0 80 3 "T" "one" "two" "three"
check "fout_draw_window: keeps the newest lines when the buffer overflows" \
    "$(has "${fout_calls[*]}" ' three ')" "yes"
check "fout_draw_window: drops the oldest line when the buffer overflows" \
    "$(has "${fout_calls[*]}" ' one ')" "no"

# ===========================================================================
# L1 View: fview_*
# ===========================================================================

FM_VIEW_UPPERWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
FM_VIEW_LEFTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
FM_VIEW_RIGHTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}

# --- fview_get_size --------------------------------------------------------
fview_get_size
check "fview_get_size: reads the terminal size" "${FM_VIEW_HEIGHT}x${FM_VIEW_WIDTH}" "24x80"
check "fview_get_size: main window height is 24-2-2" "${FM_VIEW_MAINWIN_HEIGHT}" "20"
check "fview_get_size: main window starts below the tab line" \
    "${FM_VIEW_MAINWIN_START_IDX[*]}" "1 3"

FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_MSG}
fview_get_size
check "fview_get_size: a shown bottom window shrinks the main window" \
    "${FM_VIEW_MAINWIN_HEIGHT}" "8"
FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}

FM_VIEW_LEFTWIN_SHOW=${DEF_TERM_WIN_TYPE_MSG}
FM_VIEW_RIGHTWIN_SHOW=${DEF_TERM_WIN_TYPE_MSG}
fview_get_size
check "fview_get_size: shown side windows narrow the main window" \
    "${FM_VIEW_MAINWIN_WIDTH}" "40"
check "fview_get_size: a shown left window shifts the start column" \
    "${FM_VIEW_MAINWIN_START_IDX[0]}" "21"
FM_VIEW_LEFTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
FM_VIEW_RIGHTWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
fview_get_size

# --- fview_redraw ----------------------------------------------------------
load_tree
FM_DIR_SCROLL_IDX=0
FM_DIR_CURSOR_ROW=0
reset_fout
redraw_n=0
real_fview_redraw full
check "fview_redraw: full reloads the directory" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'alpha.txt')" "yes"
check "fview_redraw: flushes the print buffer" "${n_flush}" "1"
check "fview_redraw: clears and redraws the frame" \
    "$(yes_no test "${n_clear}" -ge 1)" "yes"

# --- fview_draw_dir --------------------------------------------------------
load_tree
FM_VIEW_MAINWIN_HEIGHT=20
FM_DIR_SCROLL_IDX=2
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=0
reset_fout
fview_draw_dir
check "fview_draw_dir: keeps the page when the cursor is inside it" \
    "${FM_DIR_SCROLL_START_IDX}" "0"
check "fview_draw_dir: stores the cursor row" "${FM_DIR_CURSOR_ROW}" "2"
check "fview_draw_dir: prints one line per visible entry" \
    "$(yes_no test "${n_print}" -ge 3)" "yes"

# --- fview_draw_file_line --------------------------------------------------
load_tree
FM_DIR_SCROLL_IDX=0
FM_DIR_SCROLL_START_IDX=0
FM_VIEW_MAINWIN_HEIGHT=20
FM_VIEW_MAINWIN_WIDTH=80
entry_idx=$(index_of alpha.txt)
reset_fout
fview_draw_file_line "${entry_idx}"
check "fview_draw_file_line: prints the entry name" \
    "$(has "${fout_calls[*]}" 'alpha.txt')" "yes"
HSFM_COLOR_CURSOR="1;37;7"
FM_DIR_SCROLL_IDX=${entry_idx}
reset_fout
fview_draw_file_line "${entry_idx}"
check "fview_draw_file_line: colours the entry under the cursor" \
    "$(has "${fout_calls[*]}" '1;37;7')" "yes"
reset_fout
fview_draw_file_line 999
check "fview_draw_file_line: an out-of-range index prints nothing" "${n_print}" "0"

# --- fview_draw_tab_line ---------------------------------------------------
load_tree
VAR_TERM_TAB_LINE_LIST_PATH=("${tree}" "${tree}/gamma")
VAR_TERM_TAB_LINE_IDX=0
FM_ENV_TITLE="HSFM"
reset_fout
fview_draw_tab_line
check "fview_draw_tab_line: shows the tab title" \
    "$(has "${fout_calls[*]}" 'HSFM')" "yes"
check "fview_draw_tab_line: shows the selected tab name" \
    "$(has "${fout_calls[*]}" 'tree')" "yes"
check "fview_draw_tab_line: also draws the bookmark bar" \
    "$(has "${fout_calls[*]}" 'BM |')" "yes"

# --- fview_draw_bookmark_line ----------------------------------------------
HSFM_FAV1="${tree}"
HSFM_FAV2=""
reset_fout
fview_draw_bookmark_line
check "fview_draw_bookmark_line: numbers the bookmarks" \
    "$(has "${fout_calls[*]}" '1:')" "yes"
check "fview_draw_bookmark_line: shows the bookmark basename" \
    "$(has "${fout_calls[*]}" 'tree')" "yes"

# --- fview_draw_status_line ------------------------------------------------
FM_INPUT_MODE=${DEF_TERM_MODE_NORMAL}
FM_DIR_MARKED_LIST=("${tree}/alpha.txt" "${tree}/delta.txt")
FM_DIR_SCROLL_IDX=1
FM_DIR_LIST_CNT=5
FM_INPUT_KEY=""
FM_CMD_SELECTION_LIST=()
reset_fout
fview_draw_status_line
check "fview_draw_status_line: shows the mode" \
    "$(has "${fout_calls[*]}" 'normal')" "yes"
check "fview_draw_status_line: shows the marked count" \
    "$(has "${fout_calls[*]}" '2 selected')" "yes"
check "fview_draw_status_line: shows the cursor position" \
    "$(has "${fout_calls[*]}" '2/6')" "yes"

# --- fview_draw_command_line -----------------------------------------------
FM_INPUT_MODE=${DEF_TERM_MODE_COMMAND}
FM_ED_ACTIVE=1
FM_ED_PREFIX=">"
FM_ED_BUF="abc"
FM_ED_POSTBUF=""
reset_fout
fview_draw_command_line
check "fview_draw_command_line: draws the live editor line" \
    "$(has "${fout_calls[*]}" '>abc')" "yes"
FM_INPUT_MODE=${DEF_TERM_MODE_NORMAL}
FM_ED_ACTIVE=0
reset_fout
fview_draw_command_line
check "fview_draw_command_line: clears the line when idle" \
    "$(has "${fout_calls[*]}" '?25l')" "yes"

# --- the window drawers ----------------------------------------------------
FM_VIEW_HEIGHT=24
FM_VIEW_WIDTH=80
FM_VIEW_MAINWIN_START_IDX=(1 3)
FM_VIEW_MAINWIN_HEIGHT=20
FM_VIEW_SUBWIN_BOTTOM_SIZE=12

reset_fout
fview_draw_actionwin "T" "body"
check "fview_draw_actionwin: centres a quarter-screen window" \
    "$(has "${fout_last}" '6 20 40 12 T')" "yes"
check "fview_draw_actionwin: prefixes the action line" \
    "$(has "${fout_last}" 'Action ongoing body')" "yes"

reset_fout
fview_draw_miniwin "body"
check "fview_draw_miniwin: uses the action window title" \
    "$(has "${fout_last}" 'Action WIN Action ongoing body')" "yes"

reset_fout
redraw_n=0
fview_draw_checkwin "working"
check "fview_draw_checkwin: titles the window Check WIN" \
    "$(has "${fout_calls[*]}" 'Check WIN')" "yes"
check "fview_draw_checkwin: repaints the frame afterwards" "${redraw_n}" "1"

reset_fout
fview_draw_bottomwin "T" "line"
check "fview_draw_bottomwin: sits under the main window" \
    "$(has "${fout_last}" '23 0 80 12 T line')" "yes"

FM_VIEW_MSGWIN_BUFFER=("msg one")
reset_fout
fview_draw_msgwin
check "fview_draw_msgwin: carries the message buffer" \
    "$(has "${fout_last}" '23 0 80 12 Message WIN msg one')" "yes"

FM_VIEW_TASKWIN_BUFFER=("task one" "task two")
reset_fout
fview_draw_taskwin
check "fview_draw_taskwin: carries the task buffer" \
    "$(has "${fout_last}" '23 0 80 12 Task WIN task one task two')" "yes"

# --- fview_log_debug -------------------------------------------------------
FM_VIEW_MSGWIN_BUFFER=()
FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
fview_log_debug "first"
check "fview_log_debug: appends the message" \
    "${FM_VIEW_MSGWIN_BUFFER[0]}" "first"

FM_VIEW_MSGWIN_BUFFER=()
local_idx=0
while [ "${local_idx}" -lt 45 ]; do
    fview_log_debug "m${local_idx}"
    local_idx=$((local_idx + 1))
done
check "fview_log_debug: caps the buffer" \
    "$(yes_no test "${#FM_VIEW_MSGWIN_BUFFER[@]}" -lt 45)" "yes"
check "fview_log_debug: notes the drop" \
    "$(has "${FM_VIEW_MSGWIN_BUFFER[*]}" 'Drop message')" "yes"

# --- fview_log -------------------------------------------------------------
reset_fout
fview_log "a message"
check "fview_log: writes the message to the last line" \
    "$(has "${fout_calls[*]}" 'a message')" "yes"
check "fview_log: hides the cursor again" \
    "$(has "${fout_calls[*]}" '?25l')" "yes"

# ===========================================================================
# L2 Workspace: fdir_* and fdirsrc_*
# ===========================================================================

# --- fdir_mark_toggle ------------------------------------------------------
load_tree
cd "${tree}"
FM_DIR_MARKED_LIST=()
FM_DIR_MARK_DIR="${PWD}"
idx=$(index_of alpha.txt)
FM_DIR_SCROLL_IDX=${idx}
fdir_mark_toggle "${idx}"
check "fdir_mark_toggle: marks the cursor entry" \
    "${FM_DIR_MARKED_LIST[${idx}]}" "${tree}/alpha.txt"
fdir_mark_toggle "${idx}"
check "fdir_mark_toggle: a second toggle clears it" \
    "$(yes_no test -z "${FM_DIR_MARKED_LIST[${idx}]}")" "yes"
FM_DIR_MARKED_LIST=()
redraw_n=0
fdir_mark_toggle all
check "fdir_mark_toggle: all marks every entry" \
    "${#FM_DIR_MARKED_LIST[@]}" "${#FM_DIR_FILE_LIST[@]}"
check "fdir_mark_toggle: all repaints" "${redraw_n}" "1"
fdir_mark_toggle all
check "fdir_mark_toggle: all twice clears the marks" \
    "${#FM_DIR_MARKED_LIST[@]}" "0"

# --- fdir_mark_reset -------------------------------------------------------
FM_DIR_MARKED_LIST=("a" "b")
fdir_mark_reset
check "fdir_mark_reset: empties the mark list" "${#FM_DIR_MARKED_LIST[@]}" "0"

# --- fdir_mark_add ---------------------------------------------------------
load_tree
cd "${tree}"
FM_DIR_MARKED_LIST=()
FM_DIR_MARK_DIR="${PWD}"
idx=$(index_of delta.txt)
FM_DIR_SCROLL_IDX=${idx}
fdir_mark_add "${idx}"
check "fdir_mark_add: adds the entry" \
    "${FM_DIR_MARKED_LIST[${idx}]}" "${tree}/delta.txt"
check "fdir_mark_add: records the mark directory" "${FM_DIR_MARK_DIR}" "${PWD}"

# --- fdir_mark_remove ------------------------------------------------------
fdir_mark_remove "${idx}"
check "fdir_mark_remove: removes the entry" \
    "$(yes_no test -z "${FM_DIR_MARKED_LIST[${idx}]}")" "yes"

# --- fdirsrc_find ----------------------------------------------------------
cd "${tree}"
check "fdirsrc_find: finds a match below the current directory" \
    "$(has "$(fdirsrc_find 'al*.txt')" 'alpha.txt')" "yes"
check "fdirsrc_find: an unmatched pattern prints nothing" \
    "$(fdirsrc_find 'no-such-file-xyz')" ""

# --- fdirsrc_ls ------------------------------------------------------------
cd "${tree}"
check "fdirsrc_ls: lists the matching entries" \
    "$(has "$(fdirsrc_ls '*.txt')" 'alpha.txt')" "yes"
check "fdirsrc_ls: prints one line per entry" \
    "$(fdirsrc_ls '*.txt' | wc -l | tr -d ' ')" "2"

# --- fdirsrc_ls_sort -------------------------------------------------------
check "fdirsrc_ls_sort: lists the matching entries" \
    "$(has "$(fdirsrc_ls_sort '*.txt')" 'delta.txt')" "yes"

# --- fdir_ingest -----------------------------------------------------------
cd "${tree}"
FM_DIR_FILE_LIST=()
FM_DIR_FILE_INFO_LIST=()
fdir_ingest <<EOF
$(fdirsrc_ls '*')
EOF
check "fdir_ingest: fills the file list" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'alpha.txt')" "yes"
check "fdir_ingest: keeps the lists the same length" \
    "${#FM_DIR_FILE_INFO_LIST[@]}" "${#FM_DIR_FILE_LIST[@]}"

FM_DIR_FILE_LIST=()
FM_DIR_FILE_INFO_LIST=()
fdir_ingest <<'EOF'
ls: cannot access '/nope': Permission denied
EOF
check "fdir_ingest: keeps an unreadable entry" \
    "${FM_DIR_FILE_LIST[0]}" "/nope"
check "fdir_ingest: records the denial as the info" \
    "${FM_DIR_FILE_INFO_LIST[0]}" "Permission denied"

# --- fdir_prev_index -------------------------------------------------------
load_tree
OLDPWD="${tree}/gamma"
fdir_prev_index
check "fdir_prev_index: finds the previous directory" \
    "${FM_DIR_FILE_LIST[${FM_DIR_PREV_IDX}]}" "${tree}/gamma"
OLDPWD=""
fdir_prev_index
check "fdir_prev_index: no previous directory means zero" "${FM_DIR_PREV_IDX}" "0"

# --- fdir_read -------------------------------------------------------------
load_tree
check "fdir_read: publishes the directory entries" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'alpha.txt')" "yes"
check "fdir_read: keeps a backup copy" \
    "${#FM_DIR_BACKUP[@]}" "${#FM_DIR_FILE_LIST[@]}"
empty_dir=$(fresh_dir empty)
cd "${empty_dir}"
FM_DIR_FILE_LIST=()
fdir_read 2>/dev/null
check "fdir_read: marks an empty directory" "${FM_DIR_FILE_LIST[0]}" "empty"

# --- fdir_tab_reset --------------------------------------------------------
FM_DIR_SCROLL_START_IDX=7
FM_DIR_SCROLL_IDX=9
FM_DIR_CURSOR_ROW=4
fdir_tab_reset 0
check "fdir_tab_reset: zeros the scroll start" "${FM_DIR_SCROLL_START_IDX}" "0"
check "fdir_tab_reset: zeros the scroll index" "${FM_DIR_SCROLL_IDX}" "0"
check "fdir_tab_reset: zeros the cursor row" "${FM_DIR_CURSOR_ROW}" "0"

# --- fdir_tab_save ---------------------------------------------------------
cd "${tree}"
FM_DIR_SCROLL_START_IDX=2
FM_DIR_SCROLL_IDX=5
fdir_tab_save 1
check "fdir_tab_save: stores the path" \
    "${VAR_TERM_TAB_LINE_LIST_PATH[1]}" "${tree}"
check "fdir_tab_save: stores the scroll start" "${FM_DIR_TAB_START_IDX[1]}" "2"
check "fdir_tab_save: stores the cursor index" "${FM_DIR_TAB_CURSOR_IDX[1]}" "5"

# --- fdir_tab_load ---------------------------------------------------------
VAR_TERM_TAB_LINE_LIST_PATH[0]="${tree}/gamma"
FM_DIR_TAB_START_IDX[0]=0
FM_DIR_TAB_CURSOR_IDX[0]=1
fdir_tab_load 0
check "fdir_tab_load: enters the stored directory" "${PWD}" "${tree}/gamma"
check "fdir_tab_load: restores the cursor index" "${FM_DIR_SCROLL_IDX}" "1"
check "fdir_tab_load: restores the directory list" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'inner.txt')" "yes"

VAR_TERM_TAB_LINE_LIST_PATH[0]="${fixture}/no-such-tab-dir"
FM_DIR_TAB_START_IDX[0]=3
FM_DIR_TAB_CURSOR_IDX[0]=3
reset_fout
fdir_tab_load 0
check "fdir_tab_load: a missing directory falls back to HOME" "${PWD}" "${HOME}"
check "fdir_tab_load: reports the fallback" \
    "$(has "${fout_calls[*]}" 'Folder not found')" "yes"

# --- fdir_tab_remove -------------------------------------------------------
cd "${tree}"
VAR_TERM_TAB_LINE_LIST_PATH=("${tree}" "${tree}/gamma" "${HOME}")
FM_DIR_TAB_START_IDX=(0 1 2)
FM_DIR_TAB_CURSOR_IDX=(3 4 5)
fdir_tab_remove 1
check "fdir_tab_remove: shifts the later tabs down" \
    "${VAR_TERM_TAB_LINE_LIST_PATH[1]}" "${HOME}"
check "fdir_tab_remove: shortens the path list" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "2"
check "fdir_tab_remove: shifts the scroll start" "${FM_DIR_TAB_START_IDX[1]}" "2"
check "fdir_tab_remove: shifts the cursor index" "${FM_DIR_TAB_CURSOR_IDX[1]}" "5"

# --- fdir_tab_swap ---------------------------------------------------------
VAR_TERM_TAB_LINE_LIST_PATH=("${tree}" "${tree}/gamma")
FM_DIR_TAB_START_IDX=(1 2)
FM_DIR_TAB_CURSOR_IDX=(3 4)
fdir_tab_swap 0 1
check "fdir_tab_swap: swaps the paths" \
    "${VAR_TERM_TAB_LINE_LIST_PATH[0]}" "${tree}/gamma"
check "fdir_tab_swap: swaps the scroll starts" "${FM_DIR_TAB_START_IDX[0]}" "2"
check "fdir_tab_swap: swaps the cursor indices" "${FM_DIR_TAB_CURSOR_IDX[0]}" "4"

# --- fdir_mime_type --------------------------------------------------------
check "fdir_mime_type: resolves a text file" \
    "$(case $(fdir_mime_type "${tree}/alpha.txt") in text/plain*) echo yes;; *) echo no;; esac)" "yes"

# --- fdir_cursor_file ------------------------------------------------------
load_tree
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of alpha.txt)
check "fdir_cursor_file: prints the entry under the cursor" \
    "$(fdir_cursor_file)" "${tree}/alpha.txt"

# --- fdir_selection_file ---------------------------------------------------
FM_CMD_SELECTION_LIST=("${tree}/alpha.txt" "${tree}/delta.txt")
check "fdir_selection_file: prints the selection" \
    "$(fdir_selection_file)" "${tree}/alpha.txt ${tree}/delta.txt"

# ===========================================================================
# L3 Commands
# ===========================================================================

# Known geometry for the scroll cases.
setwin() {
    FM_VIEW_MAINWIN_HEIGHT=20
    FM_VIEW_MAINWIN_WIDTH=80
    FM_VIEW_TAB_LINE_HEIGHT=2
    FM_VIEW_STATUS_LINE_CNT=2
}

# set_tabs <path>... replaces the tab model with one tab per path.
set_tabs() {
    local i=0
    local path
    VAR_TERM_TAB_LINE_LIST_PATH=()
    FM_DIR_TAB_START_IDX=()
    FM_DIR_TAB_CURSOR_IDX=()
    for path in "$@"; do
        VAR_TERM_TAB_LINE_LIST_PATH[i]="${path}"
        FM_DIR_TAB_START_IDX[i]=0
        FM_DIR_TAB_CURSOR_IDX[i]=0
        i=$((i + 1))
    done
    VAR_TERM_TAB_LINE_IDX=0
}

# --- fcmd_left_hand_mode ---------------------------------------------------
fcmd_left_hand_mode on
check "fcmd_left_hand_mode: on sets the flag" "${FM_LEFT_HAND_MODE}" "1"
check "fcmd_left_hand_mode: on rebinds the child key" "${HSFM_KEY_CHILD1}" "g"
fcmd_left_hand_mode off
check "fcmd_left_hand_mode: off clears the flag" "${FM_LEFT_HAND_MODE}" "0"
check "fcmd_left_hand_mode: off restores the child key" "${HSFM_KEY_CHILD1}" "l"
reset_fout
fcmd_left_hand_mode sideways
check "fcmd_left_hand_mode: an unknown value fails" "$?" "255"
check "fcmd_left_hand_mode: an unknown value is reported" \
    "$(has "${fout_calls[*]}" 'Unknown value')" "yes"

# --- fnav_scroll_up --------------------------------------------------------
load_tree
setwin
FM_DIR_SCROLL_IDX=3
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=3
fnav_scroll_up
check "fnav_scroll_up: moves the cursor up" "${FM_DIR_SCROLL_IDX}" "2"
check "fnav_scroll_up: moves the terminal row up" "${FM_DIR_CURSOR_ROW}" "2"

load_tree
setwin
FM_DIR_SCROLL_IDX=1
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=0
reset_fout
redraw_n=0
fnav_scroll_up
check "fnav_scroll_up: above the first row it repaints" "$([[ ${n_print} -gt 0 ]] && echo yes)" "yes"
check "fnav_scroll_up: without clearing the screen" "${n_clear}" "0"
check "fnav_scroll_up: without a full redraw" "${redraw_n}" "0"
check "fnav_scroll_up: the cursor advances" "${FM_DIR_SCROLL_IDX}" "0"

reset_fout
fnav_scroll_up
check "fnav_scroll_up: at the top it does nothing" "${FM_DIR_SCROLL_IDX}" "0"
check "fnav_scroll_up: at the top it paints nothing" "${n_print}" "0"

# --- fnav_scroll_down ------------------------------------------------------
load_tree
setwin
FM_DIR_SCROLL_IDX=1
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=1
fnav_scroll_down
check "fnav_scroll_down: moves the cursor down" "${FM_DIR_SCROLL_IDX}" "2"
check "fnav_scroll_down: moves the terminal row down" "${FM_DIR_CURSOR_ROW}" "2"

FM_DIR_SCROLL_IDX=${FM_DIR_LIST_CNT}
fnav_scroll_down
check "fnav_scroll_down: at the bottom it does nothing" \
    "${FM_DIR_SCROLL_IDX}" "${FM_DIR_LIST_CNT}"

# At the window edge it repaints in place: no clear, no full redraw.
setwin
FM_VIEW_MAINWIN_HEIGHT=20
FM_DIR_LIST_CNT=39
for i in $(seq 0 39); do
    FM_DIR_FILE_LIST[$i]="/tmp/file_${i}"
    FM_DIR_FILE_INFO_LIST[$i]="info"
done
FM_DIR_SCROLL_IDX=$((FM_VIEW_MAINWIN_HEIGHT - 1))
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=$((FM_VIEW_MAINWIN_HEIGHT - 1))
reset_fout
redraw_n=0
fnav_scroll_down
check "fnav_scroll_down: past the bottom it repaints" "$([[ ${n_print} -gt 0 ]] && echo yes)" "yes"
check "fnav_scroll_down: without clearing the screen" "${n_clear}" "0"
check "fnav_scroll_down: without a full redraw" "${redraw_n}" "0"
check "fnav_scroll_down: the window follows" "${FM_DIR_SCROLL_START_IDX}" "1"

# --- fnav_scroll_up_visual -------------------------------------------------
load_tree
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_VISUAL}
FM_INPUT_VISUAL_START=2
FM_DIR_SCROLL_IDX=2
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=2
fdir_mark_reset
fnav_scroll_up_visual
check "fnav_scroll_up_visual: moves the cursor up" "${FM_DIR_SCROLL_IDX}" "1"
check "fnav_scroll_up_visual: marks the entry it reaches" \
    "${FM_DIR_MARKED_LIST[1]}" "${FM_DIR_FILE_LIST[1]}"

load_tree
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_VISUAL}
FM_INPUT_VISUAL_START=2
FM_DIR_SCROLL_IDX=4
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=4
fdir_mark_reset
fdir_mark_add 4
fnav_scroll_up_visual
check "fnav_scroll_up_visual: unmarks the entry it leaves" \
    "$(yes_no test -z "${FM_DIR_MARKED_LIST[4]}")" "yes"

# --- fnav_scroll_down_visual -----------------------------------------------
load_tree
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_VISUAL}
FM_INPUT_VISUAL_START=0
FM_DIR_SCROLL_IDX=0
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=0
FM_DIR_LIST_CNT=${#FM_DIR_FILE_LIST[@]}
fdir_mark_reset
fnav_scroll_down_visual
check "fnav_scroll_down_visual: moves the cursor down" "${FM_DIR_SCROLL_IDX}" "1"
check "fnav_scroll_down_visual: marks the reached entry" \
    "${FM_DIR_MARKED_LIST[1]}" "${FM_DIR_FILE_LIST[1]}"

# --- fnav_scroll_edge_visual -----------------------------------------------
load_tree
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_VISUAL}
FM_INPUT_VISUAL_START=0
FM_DIR_SCROLL_IDX=0
fdir_mark_reset
redraw_n=0
fnav_scroll_edge_visual 2
check "fnav_scroll_edge_visual: moves to the target" "${FM_DIR_SCROLL_IDX}" "2"
check "fnav_scroll_edge_visual: marks the whole span" \
    "${#FM_DIR_MARKED_LIST[@]}" "3"
check "fnav_scroll_edge_visual: repaints to drop stale marks" "${redraw_n}" "1"

redraw_n=0
fnav_scroll_edge_visual 2
check "fnav_scroll_edge_visual: the same target is a no-op" "${redraw_n}" "0"

# --- fnav_scroll_top_visual ------------------------------------------------
load_tree
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_VISUAL}
FM_INPUT_VISUAL_START=2
FM_DIR_SCROLL_IDX=4
fdir_mark_reset
fnav_scroll_top_visual
check "fnav_scroll_top_visual: moves to the top" "${FM_DIR_SCROLL_IDX}" "0"

# --- fnav_scroll_bottom_visual ---------------------------------------------
load_tree
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_VISUAL}
FM_INPUT_VISUAL_START=0
FM_DIR_SCROLL_IDX=0
fdir_mark_reset
fnav_scroll_bottom_visual
check "fnav_scroll_bottom_visual: moves to the last entry" \
    "${FM_DIR_SCROLL_IDX}" "${FM_DIR_LIST_CNT}"

# --- ftab_go_previous ------------------------------------------------------
load_tree
set_tabs "${tree}"
reset_fout
ftab_go_previous
check "ftab_go_previous: a single tab is ignored" \
    "$(has "${fout_calls[*]}" 'PREVIOUS_TAB ignored')" "yes"

set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=1
cd "${tree}/gamma"
ftab_go_previous
check "ftab_go_previous: switches to the previous tab" "${VAR_TERM_TAB_LINE_IDX}" "0"
check "ftab_go_previous: enters the previous tab directory" "${PWD}" "${tree}"

# --- ftab_switch -----------------------------------------------------------
load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
ftab_switch 1
check "ftab_switch: selects the target tab" "${VAR_TERM_TAB_LINE_IDX}" "1"
check "ftab_switch: enters the target directory" "${PWD}" "${tree}/gamma"

# --- ftab_go_next ----------------------------------------------------------
load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
ftab_go_next
check "ftab_go_next: switches to the next tab" "${VAR_TERM_TAB_LINE_IDX}" "1"

VAR_TERM_TAB_LINE_IDX=1
reset_fout
ftab_go_next
check "ftab_go_next: the last tab is ignored" \
    "$(has "${fout_calls[*]}" 'NEXT_TAB ignored')" "yes"
check "ftab_go_next: the index is unchanged" "${VAR_TERM_TAB_LINE_IDX}" "1"

# --- ftab_move_previous ----------------------------------------------------
load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=1
cd "${tree}/gamma"
ftab_move_previous
check "ftab_move_previous: follows the moved tab" "${VAR_TERM_TAB_LINE_IDX}" "0"
check "ftab_move_previous: swaps the paths" \
    "${VAR_TERM_TAB_LINE_LIST_PATH[0]}" "${tree}/gamma"

# --- ftab_swap -------------------------------------------------------------
load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
ftab_swap 1
check "ftab_swap: follows the tab to its new index" "${VAR_TERM_TAB_LINE_IDX}" "1"
check "ftab_swap: moves the other tab into the old slot" \
    "${VAR_TERM_TAB_LINE_LIST_PATH[0]}" "${tree}/gamma"

# --- ftab_move_next --------------------------------------------------------
load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
ftab_move_next
check "ftab_move_next: follows the moved tab" "${VAR_TERM_TAB_LINE_IDX}" "1"
check "ftab_move_next: swaps the paths" \
    "${VAR_TERM_TAB_LINE_LIST_PATH[0]}" "${tree}/gamma"

# --- ftab_insert -----------------------------------------------------------
load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of gamma)
ftab_insert 0
check "ftab_insert: adds a tab" "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "3"
check "ftab_insert: selects the new tab" "${VAR_TERM_TAB_LINE_IDX}" "1"
check "ftab_insert: 0 stays in the current directory" "${PWD}" "${tree}"

load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of gamma)
ftab_insert 1
check "ftab_insert: 1 enters the selected directory" "${PWD}" "${tree}/gamma"

# --- ftab_open -------------------------------------------------------------
load_tree
set_tabs "${tree}"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of gamma)
ftab_open
check "ftab_open: adds a tab" "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "2"
check "ftab_open: opens the selected directory" "${PWD}" "${tree}/gamma"

# --- ftab_duplicate --------------------------------------------------------
load_tree
set_tabs "${tree}"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of gamma)
ftab_duplicate
check "ftab_duplicate: adds a tab" "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "2"
check "ftab_duplicate: stays in the current directory" "${PWD}" "${tree}"

# --- ftab_close ------------------------------------------------------------
load_tree
set_tabs "${tree}"
( ftab_close )
check "ftab_close: the only tab exits the process" "$?" "0"

load_tree
set_tabs "${tree}" "${tree}/gamma" "${HOME}"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
ftab_close right
check "ftab_close: right drops the tabs after the cursor" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "1"
check "ftab_close: right keeps the cursor tab" "${VAR_TERM_TAB_LINE_IDX}" "0"

load_tree
set_tabs "${tree}" "${tree}/gamma" "${HOME}"
VAR_TERM_TAB_LINE_IDX=2
cd "${HOME}"
ftab_close left
check "ftab_close: left drops the tabs before the cursor" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "1"
check "ftab_close: left moves the cursor to the first tab" \
    "${VAR_TERM_TAB_LINE_IDX}" "0"

load_tree
set_tabs "${tree}" "${tree}/gamma" "${HOME}"
VAR_TERM_TAB_LINE_IDX=1
cd "${tree}/gamma"
ftab_close others
check "ftab_close: others keeps one tab" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "1"

load_tree
set_tabs "${tree}" "${tree}/gamma" "${tree}"
VAR_TERM_TAB_LINE_IDX=0
cd "${tree}"
ftab_close duplicate
check "ftab_close: duplicate drops the repeated path" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "2"

load_tree
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=1
cd "${tree}/gamma"
ftab_close
check "ftab_close: closes the current tab" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "1"
check "ftab_close: moves the cursor back one tab" "${VAR_TERM_TAB_LINE_IDX}" "0"
check "ftab_close: enters the surviving tab" "${PWD}" "${tree}"

# --- cmd_newsearch ---------------------------------------------------------
load_tree
cd "${tree}"
cmd_newsearch alp
check "cmd_newsearch: filters the list" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'alpha.txt')" "yes"
check "cmd_newsearch: drops non-matching entries" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'beta.log')" "no"

# --- cmd_find --------------------------------------------------------------
load_tree
cd "${tree}"
cmd_find inner
check "cmd_find: searches below the current directory" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'inner.txt')" "yes"
check "cmd_find: restores the read mode" \
    "${HSFM_READ_DIR_MODE}" "${DEF_TERM_READ_DIR_MODE_FAST_LS}"

# --- cmd_search ------------------------------------------------------------
load_tree
cd "${tree}"
reset_fout
cmd_search delt
check "cmd_search: filters the list" \
    "$(has "${FM_DIR_FILE_LIST[*]}" 'delta.txt')" "yes"
check "cmd_search: repaints the results" \
    "$(yes_no test "${n_print}" -ge 1)" "yes"

# --- cmd_rename ------------------------------------------------------------
w=$(fresh_dir rename)
cd "${w}"
printf 'x\n' > old.txt
fdir_read >/dev/null 2>&1
cursor_on old.txt
cmd_rename new.txt
check "cmd_rename: renames the file under the cursor" \
    "$(yes_no test -f "${w}/new.txt")" "yes"
check "cmd_rename: the old name is gone" \
    "$(yes_no test -e "${w}/old.txt")" "no"
reset_fout
cd "${w}"
fdir_read >/dev/null 2>&1
cursor_on new.txt
cmd_rename new.txt
check "cmd_rename: an existing name is refused" \
    "$(has "${fout_calls[*]}" 'already exists')" "yes"

# --- cmd_backfile ----------------------------------------------------------
w=$(fresh_dir backfile)
cd "${w}"
printf 'x\n' > f.txt
fdir_read >/dev/null 2>&1
cursor_on f.txt
cmd_backfile
check "cmd_backfile: writes a timestamped copy" \
    "$(yes_no test -n "$(compgen -G "${w}/backup_*")")" "yes"
check "cmd_backfile: keeps the original name in the copy" \
    "$(yes_no test -n "$(compgen -G "${w}/backup_*_f.txt")")" "yes"

# --- fcmd_create -----------------------------------------------------------
w=$(fresh_dir create)
cd "${w}"
fcmd_create dir "made_dir"
check "fcmd_create: dir makes a directory" \
    "$(yes_no test -d "${w}/made_dir")" "yes"
fcmd_create file "made_file"
check "fcmd_create: file makes an empty file" \
    "$(yes_no test -f "${w}/made_file")" "yes"
reset_fout
fcmd_create dir "made_dir"
check "fcmd_create: refuses an existing name" \
    "$(has "${fout_calls[*]}" 'already exists')" "yes"

# --- cmd_mkdir -------------------------------------------------------------
w=$(fresh_dir mkdir)
cd "${w}"
cmd_mkdir sub
check "cmd_mkdir: creates a directory" \
    "$(yes_no test -d "${w}/sub")" "yes"

# --- cmd_touch -------------------------------------------------------------
cmd_touch empty.txt
check "cmd_touch: creates a file" \
    "$(yes_no test -f "${w}/empty.txt")" "yes"

# --- fcmd_file_get ---------------------------------------------------------
check "fcmd_file_get: returns an existing file argument" \
    "$(fcmd_file_get "${tree}/alpha.txt")" "${tree}/alpha.txt"
load_tree
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of delta.txt)
check "fcmd_file_get: falls back to the cursor file" \
    "$(fcmd_file_get "")" "${tree}/delta.txt"

# --- cmd_editor ------------------------------------------------------------
w=$(fresh_dir editor)
cd "${w}"
printf 'note\n' > note.txt
: > "${stub}/vim"
reset_fout
cmd_editor "${w}/note.txt"
check "cmd_editor: hands the file to the editor" \
    "$(has "$(cat "${stub}/vim")" 'note.txt')" "yes"
check "cmd_editor: resets the terminal before the editor" "${n_reset}" "1"
check "cmd_editor: sets the terminal up again afterwards" "${n_setup}" "1"

reset_fout
HSFM_TEXT_EDITOR="no-such-editor"
cmd_editor "${w}/note.txt"
check "cmd_editor: reports a missing editor" \
    "$(has "${fout_calls[*]}" 'not found')" "yes"
HSFM_TEXT_EDITOR="vim"

# --- cmd_hex ---------------------------------------------------------------
: > "${stub}/xxd"
: > "${stub}/less"
reset_fout
cmd_hex "${w}/note.txt"
check "cmd_hex: runs xxd on the file" \
    "$(has "$(cat "${stub}/xxd")" 'note.txt')" "yes"
check "cmd_hex: pages the output" \
    "$(yes_no test -s "${stub}/less")" "yes"
check "cmd_hex: resets the terminal before paging" "${n_reset}" "1"

# --- cmd_media -------------------------------------------------------------
load_tree
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of alpha.txt)
: > "${stub}/nohup"
cmd_media
check "cmd_media: launches the configured media player" \
    "$(yes_no wait_for_file "${stub}/nohup")" "yes"
check "cmd_media: passes the cursor file" \
    "$(has "$(cat "${stub}/nohup")" 'alpha.txt')" "yes"

# --- fcmd_spawn_viewer -----------------------------------------------------
: > "${stub}/nohup"
fcmd_spawn_viewer "fakeprog" "${tree}/beta.log" >/dev/null 2>&1
check "fcmd_spawn_viewer: launches the viewer detached" \
    "$(yes_no wait_for_file "${stub}/nohup")" "yes"
check "fcmd_spawn_viewer: passes the viewer and the file" \
    "$(has "$(cat "${stub}/nohup")" 'fakeprog')" "yes"

reset_fout
FM_DIR_FILE_LIST=("${fixture}/no-such-file")
FM_DIR_SCROLL_IDX=0
fcmd_spawn_viewer "fakeprog" "" >/dev/null 2>&1
check "fcmd_spawn_viewer: reports a missing file" \
    "$(has "${fout_calls[*]}" 'not opened')" "yes"

# --- cmd_image -------------------------------------------------------------
load_tree
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of sample.zip)
: > "${stub}/nohup"
cmd_image
check "cmd_image: launches the configured picture viewer" \
    "$(yes_no wait_for_file "${stub}/nohup")" "yes"
check "cmd_image: passes the cursor file" \
    "$(has "$(cat "${stub}/nohup")" 'sample.zip')" "yes"

# --- cmd_preview -----------------------------------------------------------
reset_fout
redraw_n=0
prompt_n=0
cmd_preview > "${fixture}/preview.out" 2>&1
check "cmd_preview: reports the missing catimg" \
    "$(has "$(cat "${fixture}/preview.out")" 'catimg not found')" "yes"
check "cmd_preview: waits for a key" "${prompt_n}" "1"
check "cmd_preview: repaints afterwards" "${redraw_n}" "1"

# --- cmd_extract -----------------------------------------------------------
w=$(fresh_dir extract)
cd "${w}"
printf 'PK\n' > sample.zip
fdir_read >/dev/null 2>&1
cursor_on sample.zip
cmd_extract zip "${w}/sample.zip"
check "cmd_extract: creates the extraction directory" \
    "$(yes_no test -d "${w}/sample.zip_extracted")" "yes"
check "cmd_extract: runs the extractor inside it" \
    "$(yes_no test -f "${w}/sample.zip_extracted/stub_unzip_output")" "yes"

reset_fout
cmd_extract zip "${w}/no-such.zip"
check "cmd_extract: a missing archive fails" "$?" "1"
check "cmd_extract: a missing archive is reported" \
    "$(has "${fout_calls[*]}" 'not a valid file')" "yes"

# --- cmd_shell -------------------------------------------------------------
: > "${stub}/bash"
reset_fout
cmd_shell
check "cmd_shell: resets the terminal first" "${n_reset}" "1"
check "cmd_shell: starts a shell" \
    "$(has "$(cat "${stub}/bash")" 'bash')" "yes"
check "cmd_shell: sets the terminal up again afterwards" "${n_setup}" "1"

# --- cmd_sort --------------------------------------------------------------
cmd_sort size
check "cmd_sort: size sorts by size" "${HSFM_LS_SORTING}" "-S"
cmd_sort time
check "cmd_sort: time sorts by time" "${HSFM_LS_SORTING}" "-t"
cmd_sort extension
check "cmd_sort: extension restores the default" "${HSFM_LS_SORTING}" "-X"
reset_fout
cmd_sort bogus
check "cmd_sort: an unknown order leaves the setting alone" \
    "${HSFM_LS_SORTING}" "-X"
check "cmd_sort: an unknown order is reported" \
    "$(has "${fout_calls[*]}" 'Sorting Options')" "yes"

# --- fcmd_alias_get --------------------------------------------------------
check "fcmd_alias_get: resolves a known alias" "$(fcmd_alias_get home)" "${HOME}"
check "fcmd_alias_get: an unknown alias fails" \
    "$(yes_no test "$(fcmd_alias_get nosuchalias >/dev/null; echo $?)" = 1)" "yes"

# --- cmd_cd ----------------------------------------------------------------
load_tree
cd "${tree}"
cmd_cd "${tree}/gamma"
check "cmd_cd: enters a directory argument" "${PWD}" "${tree}/gamma"
cmd_cd home
check "cmd_cd: follows an alias" "${PWD}" "${HOME}"
reset_fout
cmd_cd "${fixture}/no-such-dir"
check "cmd_cd: a missing directory fails" "$?" "1"
check "cmd_cd: a missing directory is reported" \
    "$(has "${fout_calls[*]}" 'not found')" "yes"

# --- cmd_reenter -----------------------------------------------------------
load_tree
cd "${tree}"
cmd_reenter
reenter_rc=$?
check "cmd_reenter: stays in the current directory" "${PWD}" "${tree}"
check "cmd_reenter: succeeds" "${reenter_rc}" "0"

# --- cmd_select ------------------------------------------------------------
FM_CMD_FILE_PROGRAM=(fakeprog)
FM_CMD_SELECTION_LIST=("${tree}/alpha.txt" "${fixture}/no-such-file")
reset_fout
prompt_n=0
redraw_n=0
cmd_select
check "cmd_select: lists the pending program" \
    "$(has "${fout_calls[*]}" 'Program:')" "yes"
check "cmd_select: flags a missing selection" \
    "$(has "${fout_calls[*]}" 'Not found')" "yes"
check "cmd_select: waits for a key" "${prompt_n}" "1"
check "cmd_select: repaints afterwards" "${redraw_n}" "1"

# --- cmd_stat --------------------------------------------------------------
load_tree
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of alpha.txt)
: > "${stub}/stat"
prompt_n=0
cmd_stat > /dev/null 2>&1
check "cmd_stat: runs stat on the cursor file" \
    "$(has "$(cat "${stub}/stat")" 'alpha.txt')" "yes"
check "cmd_stat: waits for a key" "${prompt_n}" "1"

# --- fcmd_page -------------------------------------------------------------
: > "${stub}/fakeprog"
reset_fout
prompt_n=0
redraw_n=0
fcmd_page "Label" 1 fakeprog argument
check "fcmd_page: runs the command" \
    "$(has "$(cat "${stub}/fakeprog")" 'argument')" "yes"
check "fcmd_page: shows the status label" \
    "$(has "${fout_calls[*]}" 'Label')" "yes"
check "fcmd_page: waits for a key" "${prompt_n}" "1"
check "fcmd_page: repaints afterwards" "${redraw_n}" "1"

# --- cmd_disk --------------------------------------------------------------
: > "${stub}/df"
prompt_n=0
cmd_disk >/dev/null 2>&1
check "cmd_disk: runs df" "$(yes_no test -s "${stub}/df")" "yes"
check "cmd_disk: waits for a key" "${prompt_n}" "1"

# --- cmd_dump --------------------------------------------------------------
reset_fout
prompt_n=0
cmd_dump >/dev/null 2>&1
check "cmd_dump: shows the cache paths" \
    "$(has "${fout_calls[*]}" 'HSFM_PATH_CACHE')" "yes"
check "cmd_dump: waits for a key" "${prompt_n}" "1"

# --- cmd_help --------------------------------------------------------------
reset_fout
prompt_n=0
cmd_help > "${fixture}/help.out" 2>&1
check "cmd_help: prints the help text" \
    "$(has "$(cat "${fixture}/help.out")" 'FileManager')" "yes"
check "cmd_help: waits for a key" "${prompt_n}" "1"

# --- fcmd_bottomwin_toggle -------------------------------------------------
FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
fcmd_bottomwin_toggle "${DEF_TERM_WIN_TYPE_MSG}"
check "fcmd_bottomwin_toggle: shows the requested window" \
    "${FM_VIEW_BOTTOMWIN_SHOW}" "${DEF_TERM_WIN_TYPE_MSG}"
fcmd_bottomwin_toggle "${DEF_TERM_WIN_TYPE_MSG}"
check "fcmd_bottomwin_toggle: the same window hides again" \
    "${FM_VIEW_BOTTOMWIN_SHOW}" "${DEF_TERM_WIN_TYPE_HIDDEN}"

# --- cmd_msg ---------------------------------------------------------------
FM_VIEW_BOTTOMWIN_SHOW=${DEF_TERM_WIN_TYPE_HIDDEN}
cmd_msg
check "cmd_msg: shows the message window" \
    "${FM_VIEW_BOTTOMWIN_SHOW}" "${DEF_TERM_WIN_TYPE_MSG}"

# --- cmd_task --------------------------------------------------------------
cmd_task
check "cmd_task: shows the task window" \
    "${FM_VIEW_BOTTOMWIN_SHOW}" "${DEF_TERM_WIN_TYPE_TASK}"

# --- cmd_debug -------------------------------------------------------------
cmd_debug on
check "cmd_debug: on enables debug" "${FM_DEBUG}" "true"
cmd_debug off
check "cmd_debug: off disables debug" "${FM_DEBUG}" "false"

# --- cmd_eval --------------------------------------------------------------
w=$(fresh_dir eval)
cd "${w}"
cmd_eval touch "${w}/made.txt" >/dev/null 2>&1
check "cmd_eval: runs the command" \
    "$(yes_no test -f "${w}/made.txt")" "yes"
reset_fout
cmd_eval >/dev/null 2>&1
check "cmd_eval: no argument is reported" \
    "$(has "${fout_calls[*]}" 'No command specify')" "yes"
reset_fout
cmd_eval no-such-command >/dev/null 2>&1
check "cmd_eval: an unknown command is reported" \
    "$(has "${fout_calls[*]}" 'No command no-such-command found')" "yes"

# --- cmd_title -------------------------------------------------------------
set_tabs "${tree}"
FM_ENV_TITLE="HSFM"
cmd_title "New Title"
check "cmd_title: sets the title" "${FM_ENV_TITLE}" "New Title"
reset_fout
cmd_title
check "cmd_title: without an argument it reports the title" \
    "$(has "${fout_calls[*]}" 'New Title')" "yes"

# --- cmd_set ---------------------------------------------------------------
cmd_set read ls
check "cmd_set: read ls selects the ls reader" \
    "${HSFM_READ_DIR_MODE}" "${DEF_TERM_READ_DIR_MODE_LS}"
cmd_set read fast
check "cmd_set: read fast selects the fast reader" \
    "${HSFM_READ_DIR_MODE}" "${DEF_TERM_READ_DIR_MODE_FAST_LS}"
cmd_set hidden off
check "cmd_set: hidden off hides dotfiles" "${HSFM_ENABLE_HIDDEN}" "0"
cmd_set hidden on
check "cmd_set: hidden on shows dotfiles" "${HSFM_ENABLE_HIDDEN}" "1"
cmd_set left on
check "cmd_set: left on switches the key map" "${FM_LEFT_HAND_MODE}" "1"
cmd_set left off
check "cmd_set: left off restores the key map" "${FM_LEFT_HAND_MODE}" "0"
check "cmd_set: a bare setting fails" \
    "$(cmd_set >/dev/null 2>&1; echo $?)" "255"
check "cmd_set: an unknown variable fails" \
    "$(cmd_set nosuch x >/dev/null 2>&1; echo $?)" "255"
check "cmd_set: an unknown value fails" \
    "$(cmd_set read bogus >/dev/null 2>&1; echo $?)" "255"

# --- cmd_colorscheme -------------------------------------------------------
cmd_colorscheme black
check "cmd_colorscheme: switches the theme" "${HSFM_COLOR_THEME}" "black"
check "cmd_colorscheme: sets the cursor colour" \
    "${HSFM_COLOR_CURSOR}" "1;37;40"
cmd_colorscheme color
check "cmd_colorscheme: switches back" "${HSFM_COLOR_THEME}" "color"

# --- cmd_test --------------------------------------------------------------
reset_fout
cmd_test
check "cmd_test: draws the check window" \
    "$(has "${fout_calls[*]}" 'Check WIN')" "yes"

# --- the tab wrappers ------------------------------------------------------
ftab_close_calls=()
ftab_close() { ftab_close_calls+=("$*"); }

cmd_tabclose
check "cmd_tabclose: closes the current tab" "${ftab_close_calls[0]}" ""

ftab_close_calls=()
cmd_tabcloseright
check "cmd_tabcloseright: closes the tabs to the right" \
    "${ftab_close_calls[0]}" "right"

ftab_close_calls=()
cmd_tabcloseleft
check "cmd_tabcloseleft: closes the tabs to the left" \
    "${ftab_close_calls[0]}" "left"

ftab_close_calls=()
cmd_tabcloseothers
check "cmd_tabcloseothers: closes the other tabs" \
    "${ftab_close_calls[0]}" "others"

ftab_close_calls=()
cmd_tabcloseduplicate
check "cmd_tabcloseduplicate: closes the duplicate tabs" \
    "${ftab_close_calls[0]}" "duplicate"

# --- cmd_quitngo -----------------------------------------------------------
# The directory line is written through fout_print, so the real printer runs.
: > "${FM_FILE_CD_LASTPATH}"
FM_VIEW_PRINT_BUFFER_ENABLE=false
fout_real
( cd "${tree}" && cmd_quitngo )
quitngo_rc=$?
fout_stub
check "cmd_quitngo: exits successfully" "${quitngo_rc}" "0"
check "cmd_quitngo: records the directory for the parent shell" \
    "$(cat "${FM_FILE_CD_LASTPATH}")" "${tree}"

# --- cmd_config ------------------------------------------------------------
: > "${stub}/vim"
reset_fout
cmd_config
check "cmd_config: opens the config file in the editor" \
    "$(has "$(cat "${stub}/vim")" "${HSFM_FILE_CONFIG}")" "yes"
check "cmd_config: resets the terminal before the editor" "${n_reset}" "1"

# --- cmd_exit --------------------------------------------------------------
( cmd_exit )
check "cmd_exit: exits successfully" "$?" "0"

# --- fsys_open -------------------------------------------------------------
load_tree
cd "${tree}"
fsys_open "${tree}/gamma"
check "fsys_open: enters a directory" "${PWD}" "${tree}/gamma"

w=$(fresh_dir fsys)
cd "${w}"
printf 'text\n' > note.txt
: > "${stub}/vim"
fsys_open "${w}/note.txt"
check "fsys_open: opens a text file in the editor" \
    "$(has "$(cat "${stub}/vim")" 'note.txt')" "yes"

reset_fout
printf '\000\001\002\n' > blob.bin
fsys_open "${w}/blob.bin"
check "fsys_open: reports an unknown file type" \
    "$(has "${fout_calls[*]}" 'Unknown file type')" "yes"

# --- vcmd_compress ---------------------------------------------------------
w=$(fresh_dir compress)
cd "${w}"
printf 'a\n' > a.txt
printf 'b\n' > b.txt
: > "${stub}/zip"
reset_fout
FM_CMD_SELECTION_LIST=("${w}/a.txt")
vcmd_compress > /dev/null 2>&1
check "vcmd_compress: writes the archive next to the file" \
    "$(yes_no test -f "${w}/a.zip")" "yes"
check "vcmd_compress: hands the file to zip" \
    "$(has "$(cat "${stub}/zip")" 'a.txt')" "yes"

reset_fout
FM_CMD_SELECTION_LIST=("${w}/a.txt")
vcmd_compress > /dev/null 2>&1
check "vcmd_compress: an existing archive is skipped" \
    "$(has "${fout_calls[*]}" 'exist, skip compression')" "yes"

reset_fout
FM_CMD_SELECTION_LIST=()
vcmd_compress > /dev/null 2>&1
check "vcmd_compress: an empty selection does nothing" "${n_window}" "0"

# --- fselect_execute -------------------------------------------------------
w=$(fresh_dir execute)
cd "${w}"
printf 'x\n' > one.txt
: > "${stub}/fakeprog"
FM_CMD_FILE_PROGRAM=(fakeprog)
FM_CMD_SELECTION_LIST=("${w}/one.txt")
fselect_execute
check "fselect_execute: runs the file program" \
    "$(has "$(cat "${stub}/fakeprog")" 'one.txt')" "yes"

# --- fselect_execute_block -------------------------------------------------
w=$(fresh_dir execute_block)
cd "${w}"
printf 'x\n' > one.txt
printf 'y\n' > two.txt
: > "${stub}/fakeprog"
FM_CMD_FILE_PROGRAM=(fakeprog)
FM_CMD_SELECTION_LIST=("${w}/one.txt" "${w}/two.txt")
fselect_execute_block
check "fselect_execute_block: passes every selected file" \
    "$(has "$(cat "${stub}/fakeprog")" 'two.txt')" "yes"
check "fselect_execute_block: passes the directory as the target" \
    "$(has "$(cat "${stub}/fakeprog")" './')" "yes"
check "fselect_execute_block: returns to normal mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"

# --- fselect_execute_background --------------------------------------------
w=$(fresh_dir execute_bg)
cd "${w}"
printf 'x\n' > one.txt
: > "${stub}/fakeprog"
FM_CMD_FILE_PROGRAM=(fakeprog)
FM_CMD_SELECTION_LIST=("${w}/one.txt")
fselect_execute_background
wait
check "fselect_execute_background: runs the file program" \
    "$(has "$(cat "${stub}/fakeprog")" 'one.txt')" "yes"
check "fselect_execute_background: clears the selection" \
    "${#FM_CMD_SELECTION_LIST[@]}" "0"

# --- fselect_copy ----------------------------------------------------------
w=$(fresh_dir copy)
cd "${w}"
printf 'x\n' > one.txt
printf 'y\n' > two.txt
mkdir -p dest
prompt_n=0
prompt_reply=y
fselect_copy "${w}/one.txt" "${w}/dest"
check "fselect_copy: copies a file into the target" \
    "$(yes_no test -f "${w}/dest/one.txt")" "yes"
check "fselect_copy: asks before overwriting" "${prompt_n}" "1"

mkdir -p "${w}/src"
printf 'y\n' > "${w}/src/three.txt"
prompt_n=0
prompt_reply=""
fselect_copy "${w}/src/three.txt" "${w}/dest"
check "fselect_copy: a name absent from the current directory needs no question" \
    "${prompt_n}" "0"
check "fselect_copy: copies a new file into the target" \
    "$(yes_no test -f "${w}/dest/three.txt")" "yes"

# --- fselect_remove --------------------------------------------------------
w=$(fresh_dir remove)
cd "${w}"
printf 'x\n' > junk.txt
printf 'y\n' > keep.txt
prompt_reply=y
fselect_remove "${w}/junk.txt" "${w}"
check "fselect_remove: y removes the file" \
    "$(yes_no test -e "${w}/junk.txt")" "no"
check "fselect_remove: counts the files it will remove" \
    "$(has "${prompt_last}" 'trash [1] items')" "yes"

prompt_reply=n
fselect_remove "${w}/keep.txt" "${w}"
check "fselect_remove: any other answer keeps the file" \
    "$(yes_no test -e "${w}/keep.txt")" "yes"

# --- fselect_rename --------------------------------------------------------
w=$(fresh_dir rename_bulk)
cd "${w}"
printf 'x\n' > old.txt
printf 'new.txt\n' > "${w}/newnames"
export export STUB_VIM_REWRITE="${w}/newnames"
FM_VIEW_PRINT_BUFFER_ENABLE=false
fout_real
fselect_rename "${w}/old.txt" "${w}" > /dev/null 2>&1
fout_stub
check "fselect_rename: applies the edited name" \
    "$(yes_no test -f "${w}/new.txt")" "yes"
check "fselect_rename: the old name is gone" \
    "$(yes_no test -e "${w}/old.txt")" "no"
check "fselect_rename: removes its scratch file" \
    "$(yes_no test -e "${XDG_CACHE_HOME}/hsfm/fselect_rename")" "no"

# ===========================================================================
# L4 Input and modes: fin_*, fedit_*, fhist_*, fprompt_*
# ===========================================================================

# --- fin_read_key ----------------------------------------------------------
FM_INPUT_KEY=""
FM_INPUT_KEY_BUFFER=""
fin_read_key < <(printf 'a')
check "fin_read_key: decodes a plain key" "${FM_INPUT_KEY}" "a"
check "fin_read_key: leaves the key in REPLY" "${REPLY}" "a"

FM_INPUT_KEY=""
fin_read_key < <(printf '\033[A')
check "fin_read_key: decodes an escape sequence" "${FM_INPUT_KEY}" "^[A"

FM_INPUT_KEY=""
FM_INPUT_KEY_BUFFER="pre"
fin_read_key < <(printf 'a')
check "fin_read_key: prepends a buffered key" "${FM_INPUT_KEY}" "prea"
check "fin_read_key: drains the key buffer" "${FM_INPUT_KEY_BUFFER}" ""

# --- fin_read_key_timeout --------------------------------------------------
FM_INPUT_KEY=""
fin_read_key_timeout 0.05 < <(printf 'z')
check "fin_read_key_timeout: decodes a key" "${FM_INPUT_KEY}" "+z"
FM_INPUT_KEY=""
fin_read_key_timeout 0.05 < /dev/null
check "fin_read_key_timeout: a timeout is recorded" "${FM_INPUT_KEY}" "+"

# --- fin_mode_setup --------------------------------------------------------
load_tree
cd "${tree}"
FM_DIR_SCROLL_IDX=$(index_of alpha.txt)
fdir_mark_reset
fin_mode_setup "${DEF_TERM_MODE_VISUAL}"
check "fin_mode_setup: visual sets the mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_VISUAL}"
check "fin_mode_setup: visual anchors the selection" \
    "${FM_INPUT_VISUAL_START}" "${FM_DIR_SCROLL_IDX}"
check "fin_mode_setup: visual marks the anchor" \
    "${FM_DIR_MARKED_LIST[${FM_DIR_SCROLL_IDX}]}" "${FM_DIR_FILE_LIST[${FM_DIR_SCROLL_IDX}]}"

fin_mode_setup "${DEF_TERM_MODE_COMMAND}"
check "fin_mode_setup: command sets the mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_COMMAND}"
check "fin_mode_setup: command starts an editor session" "${FM_ED_ACTIVE}" "1"
check "fin_mode_setup: command prefixes the line with a colon" "${FM_ED_PREFIX}" ":"

fin_mode_setup "${DEF_TERM_MODE_SEARCH}"
check "fin_mode_setup: search prefixes the line with a slash" "${FM_ED_PREFIX}" "/"
fin_mode_setup "${DEF_TERM_MODE_FIND}"
check "fin_mode_setup: find prefixes the line with a question mark" \
    "${FM_ED_PREFIX}" "?"

fin_mode_setup "${DEF_TERM_MODE_NORMAL}"
check "fin_mode_setup: normal resets the mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"
check "fin_mode_setup: normal clears the marks" "${#FM_DIR_MARKED_LIST[@]}" "0"

# --- fin_mode_normal -------------------------------------------------------
load_tree
cd "${tree}"
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_NORMAL}
unset var_special_key
FM_DIR_SCROLL_IDX=1
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=1
fin_mode_normal "j"
check "fin_mode_normal: j scrolls down" \
    "${FM_DIR_SCROLL_IDX}" "2"

fin_mode_normal "G"
check "fin_mode_normal: G goes to the bottom" \
    "${FM_DIR_SCROLL_IDX}" "${FM_DIR_LIST_CNT}"

fin_mode_normal "g"
check "fin_mode_normal: g goes to the top" "${FM_DIR_SCROLL_IDX}" "0"

fin_mode_normal "?"
check "fin_mode_normal: ? opens find mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_FIND}"

HSFM_ENABLE_HIDDEN=1
fin_mode_normal "."
check "fin_mode_normal: . hides dotfiles" "${HSFM_ENABLE_HIDDEN}" "0"
fin_mode_normal "."
check "fin_mode_normal: . shows dotfiles again" "${HSFM_ENABLE_HIDDEN}" "1"
fin_mode_setup "${DEF_TERM_MODE_NORMAL}"

# --- fin_mode_visual -------------------------------------------------------
load_tree
cd "${tree}"
setwin
FM_INPUT_MODE=${DEF_TERM_MODE_VISUAL}
FM_INPUT_VISUAL_START=2
FM_DIR_SCROLL_IDX=4
FM_DIR_SCROLL_START_IDX=0
FM_DIR_CURSOR_ROW=4
fin_mode_visual "g"
check "fin_mode_visual: g goes to the top" "${FM_DIR_SCROLL_IDX}" "0"

fin_mode_visual "q"
check "fin_mode_visual: q returns to normal mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"

# --- fin_mode_select -------------------------------------------------------
load_tree
cd "${tree}"
FM_INPUT_MODE=${DEF_TERM_MODE_SELECT}
FM_DIR_SCROLL_IDX=$(index_of beta.log)
fdir_mark_reset
fin_mode_select "s"
check "fin_mode_select: s toggles the mark on the cursor entry" \
    "${FM_DIR_MARKED_LIST[${FM_DIR_SCROLL_IDX}]}" "${FM_DIR_FILE_LIST[${FM_DIR_SCROLL_IDX}]}"

fin_mode_select "q"
check "fin_mode_select: q returns to normal mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"

# --- fin_file_op -----------------------------------------------------------
load_tree
cd "${tree}"
setwin
FM_DIR_MARKED_LIST=("${tree}/alpha.txt" "${tree}/delta.txt")
fdir_mark_reset
FM_DIR_MARKED_LIST=("${tree}/alpha.txt")
fin_file_op yank
check "fin_file_op: yank copies the marks into the selection" \
    "${FM_CMD_SELECTION_LIST[0]}" "${tree}/alpha.txt"
check "fin_file_op: yank clears the marks" "${#FM_DIR_MARKED_LIST[@]}" "0"
check "fin_file_op: yank returns to normal mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"

FM_DIR_MARKED_LIST=("${tree}/beta.log")
fin_file_op cut
check "fin_file_op: cut uses mv" "${FM_CMD_FILE_PROGRAM[0]}" "mv"

w=$(fresh_dir fileop)
cd "${w}"
printf 'x\n' > trashme.txt
FM_DIR_FILE_LIST=("${w}/trashme.txt")
FM_DIR_MARKED_LIST=("${w}/trashme.txt")
prompt_reply=n
fin_file_op trash
check "fin_file_op: trash uses fselect_remove" \
    "${FM_CMD_FILE_PROGRAM[0]}" "fselect_remove"
check "fin_file_op: trash keeps the file when the prompt says no" \
    "$(yes_no test -f "${w}/trashme.txt")" "yes"

# --- fin_quit --------------------------------------------------------------
redraw_n=0
fin_quit
check "fin_quit: returns to normal mode" "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"
check "fin_quit: repaints" "${redraw_n}" "1"

# --- fedit_begin -----------------------------------------------------------
FM_INPUT_MODE=${DEF_TERM_MODE_COMMAND}
fedit_begin ":" "${DEF_TERM_MODE_COMMAND}" "${DEF_ED_DRIVER_MODE}"
check "fedit_begin: stores the prefix" "${FM_ED_PREFIX}" ":"
check "fedit_begin: stores the flavor" "${FM_ED_FUNC}" "${DEF_TERM_MODE_COMMAND}"
check "fedit_begin: stores the driver" "${FM_ED_DRIVER}" "${DEF_ED_DRIVER_MODE}"
check "fedit_begin: activates the editor" "${FM_ED_ACTIVE}" "1"
check "fedit_begin: starts with an empty line" "${FM_ED_BUF}" ""
FM_ED_COMP_MODE_LIST=(stale)
fedit_begin ":" "${DEF_TERM_MODE_COMMAND}" "${DEF_ED_DRIVER_MODE}"
check "fedit_begin: drops a stale completion list" \
    "${#FM_ED_COMP_MODE_LIST[@]}" "0"

# --- fedit_end -------------------------------------------------------------
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_ED_FUNC=${DEF_TERM_MODE_COMMAND}
FM_ED_COMMIT=""
fin_mode_setup "${DEF_TERM_MODE_COMMAND}"
fedit_end
check "fedit_end: leaves the editor inactive" "${FM_ED_ACTIVE}" "0"
check "fedit_end: the mode driver returns to normal mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"

FM_ED_DRIVER=${DEF_ED_DRIVER_PROMPT}
FM_ED_ACTIVE=1
fedit_end
check "fedit_end: the prompt driver leaves the mode alone" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"
check "fedit_end: the prompt driver clears its completion slot" \
    "${#FM_ED_COMP_PROMPT_LIST[@]}" "0"

# --- fedit_line ------------------------------------------------------------
FM_ED_PREFIX=">"
FM_ED_BUF="ab"
FM_ED_POSTBUF="cd"
check "fedit_line: joins prefix, line and tail" "$(fedit_line)" ">abcd "

# --- fedit_cursor_offset ---------------------------------------------------
FM_ED_POSTBUF="xy"
check "fedit_cursor_offset: counts the tail plus the cursor" \
    "$(fedit_cursor_offset)" "3"

# --- fedit_history_name ----------------------------------------------------
FM_ED_FUNC=${DEF_TERM_MODE_COMMAND}
check "fedit_history_name: command uses the command history" \
    "$(fedit_history_name)" "VAR_TERM_CMD_HISTORY"
FM_ED_FUNC=${DEF_TERM_MODE_SEARCH}
check "fedit_history_name: search uses the search history" \
    "$(fedit_history_name)" "VAR_TERM_SEARCH_HISTORY"
FM_ED_FUNC=${DEF_TERM_MODE_FIND}
FM_ED_DRIVER=${DEF_ED_DRIVER_PROMPT}
check "fedit_history_name: find has no prompt history" \
    "$(fedit_history_name >/dev/null 2>&1; echo $?)" "1"
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
check "fedit_history_name: find uses the find history" \
    "$(fedit_history_name)" "VAR_TERM_FIND_HISTORY"

# --- fhist_append ----------------------------------------------------------
VAR_TERM_CMD_HISTORY=()
FM_ED_HISTORY_MAX=100
fhist_append VAR_TERM_CMD_HISTORY one
fhist_append VAR_TERM_CMD_HISTORY two
check "fhist_append: appends in order" "${VAR_TERM_CMD_HISTORY[*]}" "one two"
FM_ED_HISTORY_MAX=2
fhist_append VAR_TERM_CMD_HISTORY three
check "fhist_append: drops the oldest entry at the cap" \
    "${VAR_TERM_CMD_HISTORY[*]}" "two three"
FM_ED_HISTORY_MAX=100

# --- fedit_history_up ------------------------------------------------------
VAR_TERM_CMD_HISTORY=(first second)
FM_ED_FUNC=${DEF_TERM_MODE_COMMAND}
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_ED_BUF="typed"
FM_ED_POSTBUF=""
FM_ED_HISTIDX=0
fedit_history_up
check "fedit_history_up: recalls the newest entry" "${FM_ED_BUF}" "second"
check "fedit_history_up: remembers what was typed" "${FM_ED_BACKUP}" "typed"
fedit_history_up
check "fedit_history_up: walks back through the history" "${FM_ED_BUF}" "first"
fedit_history_up
check "fedit_history_up: stops at the oldest entry" "${FM_ED_HISTIDX}" "2"

# --- fedit_history_down ----------------------------------------------------
fedit_history_down
check "fedit_history_down: walks forward through the history" \
    "${FM_ED_BUF}" "second"
fedit_history_down
check "fedit_history_down: restores what was typed" "${FM_ED_BUF}" "typed"
check "fedit_history_down: the history cursor is back at the line" \
    "${FM_ED_HISTIDX}" "0"

# --- fedit_comp_reset ------------------------------------------------------
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_ED_COMP_MODE_LIST=(redraw)
FM_ED_COMP_MODE_IDX=1
fedit_comp_reset
check "fedit_comp_reset: clears the mode slot" "${#FM_ED_COMP_MODE_LIST[@]}" "0"
check "fedit_comp_reset: resets the mode index" "${FM_ED_COMP_MODE_IDX}" "0"

FM_ED_DRIVER=${DEF_ED_DRIVER_PROMPT}
FM_ED_COMP_PROMPT_LIST=(yes)
fedit_comp_reset
check "fedit_comp_reset: clears the prompt slot" \
    "${#FM_ED_COMP_PROMPT_LIST[@]}" "0"

# --- fedit_complete --------------------------------------------------------
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_INPUT_MODE=${DEF_TERM_MODE_COMMAND}
FM_ED_FUNC=${DEF_TERM_MODE_COMMAND}
FM_ED_BUF="re"
FM_ED_COMP_MODE_LIST=()
FM_ED_COMP_MODE_IDX=0
FM_ED_COMP_MODE_PATH_CMD=""
fedit_complete
check "fedit_complete: builds the candidate list" \
    "$(yes_no test "${#FM_ED_COMP_MODE_LIST[@]}" -ge 2)" "yes"
check "fedit_complete: fills the first candidate" "${FM_ED_BUF}" "redraw"

# --- fedit_read_seq --------------------------------------------------------
check "fedit_read_seq: reads the rest of a sequence" \
    "$(fedit_read_seq < <(printf '[C'))" "[C"

# --- fedit_escape_drain ----------------------------------------------------
check "fedit_escape_drain: swallows the rest of the sequence" \
    "$(fedit_escape_drain < <(printf 'xx'))" ""

# --- fedit_escape_read -----------------------------------------------------
check "fedit_escape_read: rebuilds a cursor key" \
    "$(fedit_escape_read < <(printf '[C'))" $'\e[C'

# --- fedit_key -------------------------------------------------------------
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_ED_FUNC=${DEF_TERM_MODE_COMMAND}
FM_ED_BUF=""
FM_ED_POSTBUF=""
fedit_key "a"
fedit_key "b"
check "fedit_key: a plain key appends to the line" "${FM_ED_BUF}" "ab"
fedit_key $'\e[D'
check "fedit_key: left moves a character to the tail" "${FM_ED_POSTBUF}" "b"
check "fedit_key: left shortens the line" "${FM_ED_BUF}" "a"
fedit_key $'\e[C'
check "fedit_key: right returns the character to the line" "${FM_ED_BUF}" "ab"
check "fedit_key: right empties the tail" "${FM_ED_POSTBUF}" ""
fedit_key $'\177'
check "fedit_key: backspace deletes the last character" "${FM_ED_BUF}" "a"
fedit_key "~"
check "fedit_key: tilde expands to HOME" \
    "${FM_ED_BUF}" "a${HOME}"
fedit_key ""
check "fedit_key: enter submits" "$?" "1"
check "fedit_key: enter commits the line" "${FM_ED_COMMIT}" "a${HOME}"
fedit_key $'\e'
check "fedit_key: escape cancels" "$?" "2"
check "fedit_key: escape clears the commit" "${FM_ED_COMMIT}" ""

# --- fedit_submit ----------------------------------------------------------
FM_INPUT_MODE=${DEF_TERM_MODE_COMMAND}
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_ED_FUNC=${DEF_TERM_MODE_COMMAND}
FM_ED_BUF="echo hello"
FM_ED_POSTBUF=""
VAR_TERM_CMD_HISTORY=()
reset_fout
fedit_submit
check "fedit_submit: records the command in the history" \
    "${VAR_TERM_CMD_HISTORY[0]}" "echo hello"
check "fedit_submit: runs the command" \
    "$(has "${fout_calls[*]}" 'hello')" "yes"
check "fedit_submit: returns to normal mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"

# --- fedit_cancel ----------------------------------------------------------
FM_INPUT_MODE=${DEF_TERM_MODE_SEARCH}
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_ED_FUNC=${DEF_TERM_MODE_SEARCH}
FM_ED_BUF="half typed"
FM_ED_COMMIT="stale"
redraw_n=0
fedit_cancel < /dev/null
check "fedit_cancel: drops the pending commit" "${FM_ED_COMMIT}" ""
check "fedit_cancel: returns to normal mode" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"
check "fedit_cancel: a cancelled search repaints the list" "${redraw_n}" "1"

# --- fedit_dispatch --------------------------------------------------------
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_INPUT_MODE=${DEF_TERM_MODE_COMMAND}
reset_fout
FM_ED_COMMIT="echo dispatched"
fedit_dispatch
check "fedit_dispatch: echo writes to the message line" \
    "$(has "${fout_calls[*]}" 'dispatched')" "yes"

w=$(fresh_dir dispatch)
cd "${w}"
FM_ED_COMMIT="!touch ${w}/made.txt"
fedit_dispatch > /dev/null 2>&1
check "fedit_dispatch: a bang command runs in the shell" \
    "$(yes_no test -f "${w}/made.txt")" "yes"

reset_fout
FM_ED_COMMIT="no-such-command"
fedit_dispatch
check "fedit_dispatch: an unknown command is reported" \
    "$(has "${fout_calls[*]}" 'not found')" "yes"

redraw_n=0
FM_ED_COMMIT="redraw"
fedit_dispatch
check "fedit_dispatch: redraw repaints" "${redraw_n}" "1"

# --- fin_mode_command ------------------------------------------------------
FM_INPUT_MODE=${DEF_TERM_MODE_COMMAND}
fedit_begin ":" "${DEF_TERM_MODE_COMMAND}" "${DEF_ED_DRIVER_MODE}"
FM_ED_BUF=""
reset_fout
fin_mode_command "a"
check "fin_mode_command: a key reaches the line editor" "${FM_ED_BUF}" "a"
check "fin_mode_command: the live line is drawn" "${n_print}" "2"
fin_mode_command $'\e'
check "fin_mode_command: escape leaves the editor" \
    "${FM_INPUT_MODE}" "${DEF_TERM_MODE_NORMAL}"

# --- fin_handler -----------------------------------------------------------
prompt_n=0
FM_INPUT_MODE=${DEF_TERM_MODE_NORMAL}
fin_handler "${DEF_TERM_MODE_COMMAND}"
check "fin_handler: command opens a command prompt" \
    "${prompt_last}" "prompt::|${DEF_TERM_MODE_COMMAND}"

prompt_n=0
redraw_n=0
fin_handler "${DEF_TERM_MODE_SEARCH}"
check "fin_handler: search opens a search prompt" \
    "${prompt_last}" "prompt:/|${DEF_TERM_MODE_SEARCH}"
check "fin_handler: search repaints the results" "${redraw_n}" "1"

# --- fin_prompt ------------------------------------------------------------
FM_INPUT_MODE=${DEF_TERM_MODE_NORMAL}
FM_ED_ACTIVE=0
real_fin_prompt "Press" "${DEF_ED_FUNC_WAIT}" < <(printf '\n')
check "fin_prompt: enter ends a wait prompt" "${FM_ED_ACTIVE}" "0"

# --- fprompt_open ----------------------------------------------------------
FM_ED_PREFIX="saved"
FM_ED_FUNC=${DEF_TERM_MODE_COMMAND}
FM_ED_DRIVER=${DEF_ED_DRIVER_MODE}
FM_ED_ACTIVE=1
FM_ED_BUF="keep me"
FM_ED_HISTIDX=2
prompt_n=0
fprompt_open "Ask" "${DEF_ED_FUNC_WAIT}"
check "fprompt_open: opens the prompt" \
    "${prompt_last}" "prompt:Ask|${DEF_ED_FUNC_WAIT}"
check "fprompt_open: restores the prefix" "${FM_ED_PREFIX}" "saved"
check "fprompt_open: restores the line buffer" "${FM_ED_BUF}" "keep me"
check "fprompt_open: restores the active session" "${FM_ED_ACTIVE}" "1"
FM_ED_ACTIVE=0

# --- fprompt_wait ----------------------------------------------------------
prompt_n=0
real_fprompt_wait "Press Enter"
check "fprompt_wait: opens a wait prompt" \
    "${prompt_last}" "prompt:Press Enter|${DEF_ED_FUNC_WAIT}"

# --- fprompt_confirm -------------------------------------------------------
prompt_n=0
real_fprompt_confirm "Sure?"
check "fprompt_confirm: opens a confirm prompt" \
    "${prompt_last}" "prompt:Sure?|${DEF_ED_FUNC_CONFIRM}"

# ===========================================================================
# L5 Lifecycle: fapp_*
# ===========================================================================

# --- fapp_resize_win -------------------------------------------------------
redraw_n=0
fapp_resize_win
check "fapp_resize_win: re-reads the terminal size" \
    "${FM_VIEW_HEIGHT}x${FM_VIEW_WIDTH}" "24x80"
check "fapp_resize_win: repaints" "${redraw_n}" "1"

# --- fapp_exit -------------------------------------------------------------
FM_RUNNING=1
reset_fout
fapp_exit
check "fapp_exit: clears the running flag" "${FM_RUNNING}" "0"
check "fapp_exit: resets the terminal" "${n_reset}" "1"
check "fapp_exit: says goodbye" \
    "$(has "${fout_calls[*]}" 'FM finished.')" "yes"

# --- fapp_save_env ---------------------------------------------------------
VAR_TERM_CMD_HISTORY=("cmd one")
VAR_TERM_SEARCH_HISTORY=("search one")
VAR_TERM_FIND_HISTORY=("find one")
fapp_save_env
check "fapp_save_env: writes the runtime env file" \
    "$(yes_no test -f "${FM_FILE_RUNTIME_ENV}")" "yes"
check "fapp_save_env: stores the command history" \
    "$(has "$(cat "${FM_FILE_RUNTIME_ENV}")" 'cmd one')" "yes"
check "fapp_save_env: stores the settings" \
    "$(has "$(cat "${FM_FILE_RUNTIME_ENV}")" "HSFM_READ_DIR_MODE=${HSFM_READ_DIR_MODE}")" "yes"

# --- fapp_load_env ---------------------------------------------------------
VAR_TERM_CMD_HISTORY=()
VAR_TERM_SEARCH_HISTORY=()
VAR_TERM_FIND_HISTORY=()
fapp_load_env
check "fapp_load_env: restores the command history" \
    "${VAR_TERM_CMD_HISTORY[0]}" "cmd one"
check "fapp_load_env: restores the search history" \
    "${VAR_TERM_SEARCH_HISTORY[0]}" "search one"

rm -f "${FM_FILE_RUNTIME_ENV}"
fapp_load_env
check "fapp_load_env: a missing file is ignored" "$?" "0"

# --- fapp_save_session -----------------------------------------------------
load_tree
cd "${tree}"
set_tabs "${tree}" "${tree}/gamma"
VAR_TERM_TAB_LINE_IDX=1
fapp_save_session
check "fapp_save_session: writes the session file" \
    "$(yes_no test -f "${FM_FILE_SESSION}")" "yes"
check "fapp_save_session: stores the tabs" \
    "$(has "$(cat "${FM_FILE_SESSION}")" "${tree}/gamma")" "yes"
check "fapp_save_session: stores the current directory" \
    "$(has "$(cat "${FM_FILE_SESSION}")" "cd '${tree}'")" "yes"

# --- fapp_load_session -----------------------------------------------------
VAR_TERM_TAB_LINE_LIST_PATH=()
VAR_TERM_TAB_LINE_IDX=0
fapp_load_session
check "fapp_load_session: restores the tab list" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "2"
check "fapp_load_session: restores the tab index" "${VAR_TERM_TAB_LINE_IDX}" "1"

rm -f "${FM_FILE_SESSION}"
cd "${tree}"
fapp_load_session
check "fapp_load_session: without a file it starts one tab" \
    "${#VAR_TERM_TAB_LINE_LIST_PATH[@]}" "1"
check "fapp_load_session: the single tab is the current directory" \
    "${VAR_TERM_TAB_LINE_LIST_PATH[0]}" "${tree}"

# --- fapp_save_settings ----------------------------------------------------
rm -f "${FM_FILE_RUNTIME_ENV}" "${FM_FILE_SESSION}"
set_tabs "${tree}" "${tree}/gamma"
fapp_save_settings
check "fapp_save_settings: saves the runtime env" \
    "$(yes_no test -f "${FM_FILE_RUNTIME_ENV}")" "yes"
check "fapp_save_settings: saves the session" \
    "$(yes_no test -f "${FM_FILE_SESSION}")" "yes"

# --- fapp_setup_env_cache --------------------------------------------------
fapp_setup_env_cache
check "fapp_setup_env_cache: points the runtime env at the cache" \
    "${FM_FILE_RUNTIME_ENV}" "${HSFM_PATH_CACHE}/hsfm_runtimeenv.sh"
check "fapp_setup_env_cache: points the session at the cache" \
    "${FM_FILE_SESSION}" "${HSFM_PATH_CACHE}/hsfm_session.sh"
check "fapp_setup_env_cache: points the last path at the cache" \
    "${FM_FILE_CD_LASTPATH}" "${HSFM_PATH_CACHE}/hsfm_last.sh"
check "fapp_setup_env_cache: points the message log at the cache" \
    "${FM_FILE_MESSAGE}" "${HSFM_PATH_CACHE}/hsfm_message.log"
check "fapp_setup_env_cache: points the debug log at the cache" \
    "${FM_FILE_LOGS}" "${HSFM_PATH_CACHE}/hsfm_logs.sh"

# --- fapp_setup_env --------------------------------------------------------
FM_ENV_FILE_ARGS=""
FM_ENV_DIR_LS_ARGS=()
fapp_setup_env
check "fapp_setup_env: sets the file argument" "${FM_ENV_FILE_ARGS}" "biL"
check "fapp_setup_env: sets the ls colour argument" \
    "${FM_ENV_DIR_LS_ARGS[0]}" "--color=none"
check "fapp_setup_env: also sets the cache paths" \
    "${FM_FILE_SESSION}" "${HSFM_PATH_CACHE}/hsfm_session.sh"

# --- fapp_setup_options ----------------------------------------------------
printf 'HSFM_FILE_FORMAT="[%%f]"\nHSFM_MARK_FORMAT="%%f!"\nHSFM_FAV1="%s"\nHSFM_FAV2="%s"\n' \
    "${tree}" "${fixture}/no-such-bookmark" > "${HSFM_FILE_CONFIG}"
fapp_setup_options
check "fapp_setup_options: parses the file format prefix" "${FM_VIEW_FILE_PRE}" "["
check "fapp_setup_options: parses the file format suffix" "${FM_VIEW_FILE_POST}" "]"
check "fapp_setup_options: parses the mark format prefix" "${FM_VIEW_MARK_PRE}" ""
check "fapp_setup_options: parses the mark format suffix" "${FM_VIEW_MARK_POST}" "!"
check "fapp_setup_options: keeps an existing bookmark directory" \
    "${HSFM_FAV1}" "${tree}"
check "fapp_setup_options: blanks a missing bookmark directory" \
    "${HSFM_FAV2}" ""

# --- fapp_setup_shell ------------------------------------------------------
reset_fout
fapp_setup_shell
check "fapp_setup_shell: sets a read timeout" "${FM_INPUT_READ_ARGS[*]}" "-t 0.05"
check "fapp_setup_shell: traps the exit signal" \
    "$(has "$(trap -p EXIT)" 'fapp_exit')" "yes"
check "fapp_setup_shell: traps the resize signal" \
    "$(has "$(trap -p WINCH)" 'fapp_resize_win')" "yes"
check "fapp_setup_shell: enables nullglob" "$(yes_no shopt -q nullglob)" "yes"
check "fapp_setup_shell: exports the ls colours" \
    "$(yes_no test -n "${di}")" "yes"
# Put the harness traps back and undo the global shell options.
trap cleanup EXIT
trap - SIGINT SIGTERM WINCH
shopt -u nullglob nocaseglob
FM_INPUT_READ_ARGS=()

# --- fapp_export_ls_colors -------------------------------------------------
unset LS_COLORS di ex ls_patterns
fapp_export_ls_colors
check "fapp_export_ls_colors: falls back when LS_COLORS is empty" \
    "${HSFM_LS_COLORS}" "0"
check "fapp_export_ls_colors: defines the directory colour" "${di}" "01;34"
check "fapp_export_ls_colors: defines the executable colour" "${ex}" "01;32"
check "fapp_export_ls_colors: builds the pattern list" \
    "$(yes_no test -n "${ls_patterns}")" "yes"

# --- fapp_setup_theme ------------------------------------------------------
HSFM_COLOR_THEME="color"
fapp_setup_theme
check "fapp_setup_theme: no argument uses the current theme" \
    "${HSFM_COLOR_TITLE}" "30;104"
fapp_setup_theme black
check "fapp_setup_theme: black sets the title colour" \
    "${HSFM_COLOR_TITLE}" "97;40"
reset_fout
fapp_setup_theme neon >/dev/null 2>&1
check "fapp_setup_theme: an unknown theme fails" "$?" "255"
check "fapp_setup_theme: an unknown theme is reported" \
    "$(has "${fout_calls[*]}" 'Theme neon not found')" "yes"

# --- fapp_help_keymap ------------------------------------------------------
reset_fout
fapp_help_keymap
check "fapp_help_keymap: prints the key map" \
    "$(has "${fout_calls[*]}" 'Go to child directory')" "yes"
check "fapp_help_keymap: prints the sections" \
    "$(has "${fout_calls[*]}" '## Tab operations.')" "yes"

# --- fapp_help_commands ----------------------------------------------------
reset_fout
fapp_help_commands > "${fixture}/commands.out" 2>&1
check "fapp_help_commands: names the program" \
    "$(has "$(cat "${fixture}/commands.out")" 'FileManager')" "yes"
check "fapp_help_commands: lists the options" \
    "$(has "${fout_calls[*]}" '[Options]')" "yes"
check "fapp_help_commands: lists the commands" \
    "$(has "${fout_calls[*]}" 'Changes the current directory')" "yes"

# --- fapp_help -------------------------------------------------------------
reset_fout
fapp_help key
check "fapp_help: key prints the key map" \
    "$(has "${fout_calls[*]}" '[KeyMap]')" "yes"
reset_fout
fapp_help > /dev/null 2>&1
check "fapp_help: no argument prints the commands" \
    "$(has "${fout_calls[*]}" '[Options]')" "yes"

# --- fapp_info -------------------------------------------------------------
check "fapp_info: reports verbose mode on stderr" \
    "$(fapp_info 2>&1 >/dev/null)" "hsfm: verbose mode"

# --- fapp_err_control ------------------------------------------------------
check "fapp_err_control: reports function and line on stderr" \
    "$(fapp_err_control myfunc 42 2>&1 >/dev/null)" "hsfm: myfunc:42"
check "fapp_err_control: fills an unknown position" \
    "$(fapp_err_control 2>&1 >/dev/null)" "hsfm: ?:?"

# --- fapp_core -------------------------------------------------------------
# Run it in a subshell: it is an event loop that exits when stdout is not a
# terminal, and the setup helpers are replaced with markers.
HSFM_COLOR_THEME="color"
core_log="${fixture}/core.log"
: > "${core_log}"
(
    cd "${tree}"
    fin_read_key() { return 1; }
    fapp_load_env() { printf 'load_env\n' >> "${core_log}"; }
    fapp_setup_env() { printf 'setup_env\n' >> "${core_log}"; }
    fapp_setup_options() { printf 'setup_options\n' >> "${core_log}"; }
    fapp_setup_shell() { printf 'setup_shell\n' >> "${core_log}"; }
    fapp_setup_theme() { printf 'setup_theme %s\n' "$1" >> "${core_log}"; }
    fout_setup() { printf 'fout_setup\n' >> "${core_log}"; }
    fapp_core
) > "${fixture}/core.out" 2>&1
core_rc=$?
check "fapp_core: runs the setup in order" \
    "$(tr '\n' ' ' < "${core_log}")" \
    "load_env setup_env setup_options setup_shell setup_theme color fout_setup "
check "fapp_core: exits when no terminal is attached" "${core_rc}" "1"

# --- fapp_main -------------------------------------------------------------
# The entry point is tested through its argument handling; fapp_core is stubbed
# so no UI starts.
fapp_core() {
    printf '%s|%s|%s\n' "${FM_DEBUG}" "${VAR_TERM_TAB_LINE_IDX}" \
        "${VAR_TERM_TAB_LINE_LIST_PATH[*]}" > "${fixture}/core.args"
}

cd "${tree}"
rm -f "${fixture}/core.args"
FM_RUNNING=0
( fapp_main "${tree}/gamma" ) >/dev/null 2>&1
check "fapp_main: a directory argument opens it as a tab" \
    "$(cat "${fixture}/core.args")" "false|1|${tree} ${tree}/gamma"

FM_RUNNING=0
rm -f "${fixture}/core.args"
( fapp_main -d ) >/dev/null 2>&1
check "fapp_main: -d enables debug" \
    "$(cat "${fixture}/core.args")" "true|0|${tree}"

FM_RUNNING=0
check "fapp_main: --help prints the help" \
    "$(has "$( fapp_main --help 2>&1 )" 'FileManager')" "yes"
check "fapp_main: --help succeeds" \
    "$( ( FM_RUNNING=0; fapp_main --help >/dev/null 2>&1 ); echo $? )" "0"

printf '%s\n' "${tree}" > "${FM_FILE_CD_LASTPATH}"
check "fapp_main: --last-path prints the saved directory" \
    "$( FM_RUNNING=0; fapp_main --last-path 2>/dev/null )" "${tree}"
rm -f "${FM_FILE_CD_LASTPATH}"
check "fapp_main: --last-path without a file fails" \
    "$( ( FM_RUNNING=0; fapp_main --last-path >/dev/null 2>&1 ); echo $? )" "1"

check "fapp_main: a running instance is refused" \
    "$( ( FM_RUNNING=1; fapp_main >/dev/null 2>&1 ); echo $? )" "1"

check "fapp_main: -s with an existing config fails" \
    "$( ( touch "${HSFM_FILE_CONFIG}"; FM_RUNNING=0; fapp_main -s >/dev/null 2>&1 ); echo $? )" "1"

check "fapp_main: an unknown option fails" \
    "$( ( FM_RUNNING=0; fapp_main --no-such-option >/dev/null 2>&1 ); echo $? )" "1"

# ---------------------------------------------------------------------------
# Coverage guard: every function in the script must own at least one case.
# Case labels start with the function name, so the check is a plain search.
# ---------------------------------------------------------------------------
missing=""
for fn in $(grep -oE '^(function )?[a-z_]+\(\)' "${script}" |
    sed -e 's/^function //' -e 's/()$//'); do
    grep -q "\"${fn}:" "${self}" || missing+="${fn} "
done
check "coverage: every function has at least one case" "${missing}" ""

printf '\n%s failure(s) in %s case(s)\n' "${fail}" "${total}"
[[ ${fail} -eq 0 ]]
