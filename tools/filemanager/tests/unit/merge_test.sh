#!/usr/bin/env bash
#
# The generic helpers the merged command and view families share.
#
# Usage: tests/unit/merge_test.sh <script>

set -uo pipefail

script=${1:-filemanager_llm.sh}
case ${script} in
    /*) ;;
    *) script=$(realpath "${script}") ;;
esac

fixture=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-merge.XXXXXX")
trap 'rm -rf "${fixture}"' EXIT

export HOME="${fixture}"
export HSFM_FILE_CONFIG="${HOME}/.hsfm.sh"
export HSFM_PATH_CACHE="${HOME}/.cache/hsfm"
export TERM=dumb
export LC_ALL=C

mkdir -p "${HSFM_PATH_CACHE}"

set +u
# shellcheck disable=SC1090
source "${script}" >/dev/null 2>&1
set -u


# The display layer needs a terminal; these helpers do not.
fout_clear() { :; }
tab_draws=0
fview_draw_tab_line() { tab_draws=$((tab_draws + 1)); }
fview_draw_status_line() { :; }
fout_print() { :; }
fview_redraw() { after_redraw=$((after_redraw + 1)); }
fout_draw_window() { drawn="$*"; }
fdir_mark_reset() { marks+="reset "; }
fdir_mark_add() { marks+="$1 "; }
waited=0
fprompt_wait() { waited=$((waited + 1)); }
messages=""
fview_log() { messages+="$* "; }
drawn=""
marks=""
after_redraw=0

fail=0
check() {
    local name=$1
    local got=$2
    local want=$3
    if [ "${got}" = "${want}" ]; then
        printf 'ok   %s\n' "${name}"
    else
        printf 'FAIL %s\n     got:  %s\n     want: %s\n' "${name}" "${got}" "${want}"
        fail=$((fail + 1))
    fi
}

# --- fcmd_create: one path for mkdir and touch -----------------------------

cd "${fixture}"
fcmd_create dir "made_dir" >/dev/null 2>&1
check "create makes a directory" "$(test -d "${fixture}/made_dir" && echo yes)" "yes"

fcmd_create file "made_file" >/dev/null 2>&1
check "create makes an empty file" "$(test -f "${fixture}/made_file" && echo yes)" "yes"

# Both refuse an existing name.
fcmd_create dir "made_dir"
check "existing name is refused" "$(printf '%s' "${messages}" | grep -c 'already exists')" "1"

# --- fcmd_page: run, wait, repaint -----------------------------------------

tab_draws=0
fcmd_page "" 1 echo "page output" > "${fixture}/page.out"
check "page runs the command" "$(grep -c 'page output' "${fixture}/page.out")" "1"
check "page waits once" "${waited}" "1"
check "page repaints the frame for full-screen output" "${tab_draws}" "2"

tab_draws=0
fcmd_page "Help info" 0 echo "help text" > /dev/null
check "page leaves a text page alone" "${tab_draws}" "1"

# --- fcmd_spawn_viewer: detached, with a real command ----------------------

cat > "${fixture}/viewer" <<EOF
#!/bin/sh
printf '%s' "\$*" > "${fixture}/viewer.args"
EOF
chmod +x "${fixture}/viewer"

printf 'x\n' > "${fixture}/photo.png"
fcmd_spawn_viewer "${fixture}/viewer" "${fixture}/photo.png" >/dev/null 2>&1

for _ in 1 2 3 4 5 6 7 8 9 10; do
    test -f "${fixture}/viewer.args" && break
    sleep 0.1
done
check "viewer receives the file" "$(cat "${fixture}/viewer.args" 2>/dev/null)" "${fixture}/photo.png"

# --- fnav_scroll_edge_visual: selection range ------------------------------

FM_DIR_LIST_CNT=5
FM_INPUT_VISUAL_START=2
FM_DIR_SCROLL_IDX=4
FM_VIEW_PRINT_BUFFER_ENABLE=false
marks=""
fnav_scroll_top_visual
check "edge scroll moves to the top" "${FM_DIR_SCROLL_IDX}" "0"
check "edge scroll marks the span" "${marks}" "reset 0 1 2 "

# --- view helpers pass the right geometry and buffer -----------------------

FM_VIEW_MAINWIN_START_IDX=(0 10)
FM_VIEW_MAINWIN_HEIGHT=8
FM_VIEW_WIDTH=80
FM_VIEW_SUBWIN_BOTTOM_SIZE=12
FM_VIEW_MSGWIN_BUFFER=("hello")
FM_VIEW_TASKWIN_BUFFER=("task one" "task two")

fview_draw_msgwin
check "bottom window carries its buffer" "${drawn}" "18 0 80 12 Message WIN hello"

fview_draw_taskwin
check "task window carries its title" "$(printf '%s' "${drawn}" | grep -c 'Task WIN task one task two')" "1"

FM_VIEW_HEIGHT=24
after_redraw=0
fview_draw_checkwin "working"
check "action window centres itself" "${drawn}" "6 20 40 12 Check WIN Action ongoing working"
check "check window repaints" "${after_redraw}" "1"

printf '\n%s failure(s)\n' "${fail}"
[[ "${fail}" -eq 0 ]]
