#!/usr/bin/env bash
#
# Nested prompt: a ':' command that opens a wait prompt must return to normal
# mode and leave the command line usable. Regression guard for a global editor
# state shared by the mode session and the prompt.
#
# Usage: tests/smoke/nested_prompt_test.sh [script]

set -uo pipefail

here=$(dirname "$(realpath "$0")")
script=${1:-filemanager.sh}
case ${script} in
    /*) ;;
    *) script=${here}/../../${script} ;;
esac

fx=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-nest.XXXXXX")
trap 'tmux -L hsfmnest -f /dev/null kill-server 2>/dev/null; rm -rf "${fx}"' EXIT

mkdir -p "${fx}/home/.cache/hsfm" "${fx}/tree/dir_a"
printf 'x\n' > "${fx}/tree/file_a"
touch -t 202001010000 "${fx}/tree"/* "${fx}/tree"

tmux -L hsfmnest -f /dev/null kill-server 2>/dev/null
tmux -L hsfmnest -f /dev/null new-session -d -s s -x 80 -y 24 \
    "bash -c 'cd ${fx}/tree && HOME=${fx}/home HSFM_FILE_CONFIG=${fx}/home/.hsfm.sh HSFM_PATH_CACHE=${fx}/home/.cache/hsfm TERM=xterm-256color bash ${script}' 2>${fx}/err.log"
sleep 3

fail=0
check() {
    local name=$1
    local pattern=$2
    if tmux -L hsfmnest capture-pane -p -t s | grep -q "${pattern}"; then
        printf 'ok   %s\n' "${name}"
    else
        printf 'FAIL %s (no "%s")\n' "${name}" "${pattern}"
        tmux -L hsfmnest capture-pane -p -t s | sed -n '1,3p;22,24p'
        fail=$((fail + 1))
    fi
}

send() {
    tmux -L hsfmnest send-keys -t s -l "$1"
}

check "starts in normal mode" " normal "

# ':help' opens a wait prompt from inside the ':' session.
send ':'
sleep 0.3
send 'help'
tmux -L hsfmnest send-keys -t s Enter
sleep 1
check "prompt is shown" "Press Enter Key To Continue"

tmux -L hsfmnest send-keys -t s Enter
sleep 1
check "returns to normal mode" " normal "

# The command line still works afterwards.
send ':'
sleep 0.3
send 'cd dir_a'
tmux -L hsfmnest send-keys -t s Enter
sleep 1
check "command line works after the prompt" " dir_a "

tmux -L hsfmnest send-keys -t s q
tmux -L hsfmnest send-keys -t s a
sleep 1

printf '\n%s failure(s)\n' "${fail}"
[[ "${fail}" -eq 0 ]]
