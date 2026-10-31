#!/usr/bin/env bash
# Fresh side-by-side: same fixture, same keys, compare rendered panes.
set -uo pipefail

here=$(dirname "$(realpath "$0")")
script_dir=/mnt/projects/tools/shellscripts/tools/filemanager
fx=$(mktemp -d "${here}/smoke-fx.XXXXXX")

mkdir -p "${fx}/home/.cache/hsfm" "${fx}/tree/dir_a" "${fx}/tree/dir_b"
printf 'x\n' > "${fx}/tree/file_a"
printf 'x\n' > "${fx}/tree/file_b"
find "${fx}/tree" -exec touch -t 202001010000 {} +

tmux -L hsfmcmp -f /dev/null kill-server 2>/dev/null

start() {
    local name=$1
    local script=$2
    tmux -L hsfmcmp -f /dev/null new-session -d -s "${name}" -x 80 -y 24 \
        "bash -c 'cd ${fx}/tree && HOME=${fx}/home HSFM_FILE_CONFIG=${fx}/home/.hsfm.sh HSFM_PATH_CACHE=${fx}/home/.cache/hsfm TERM=xterm-256color bash ${script_dir}/${script}' 2>${fx}/${name}.err"
}

start base filemanager_legacy.sh
start llm filemanager.sh
sleep 3

fail=0
compare() {
    local name=$1
    tmux -L hsfmcmp capture-pane -p -t base | sed -e 's/[[:space:]]*$//' > "${fx}/pane-base.txt"
    tmux -L hsfmcmp capture-pane -p -t llm | sed -e 's/[[:space:]]*$//' > "${fx}/pane-llm.txt"
    if diff -u "${fx}/pane-base.txt" "${fx}/pane-llm.txt" > "${fx}/pane-diff.txt"
    then
        printf 'ok   %s\n' "${name}"
    else
        printf 'FAIL %s\n' "${name}"
        sed -n '1,14p' "${fx}/pane-diff.txt"
        fail=$((fail + 1))
    fi
}

both() {
    tmux -L hsfmcmp send-keys -t base -l "$1"
    tmux -L hsfmcmp send-keys -t llm -l "$1"
}

both_key() {
    tmux -L hsfmcmp send-keys -t base "$1"
    tmux -L hsfmcmp send-keys -t llm "$1"
}

compare "startup"
both 'l'
sleep 0.5
compare "cursor down"

# Tab open, switch and close: the context save and restore round trip.
both 't'
sleep 0.8
compare "tab open"
both_key C-l
sleep 0.8
compare "tab switch"
both 'w'
sleep 0.8
compare "tab close"

both_key Enter
sleep 0.7
compare "open directory"
both ':'
sleep 0.3
both 'cd ..'
sleep 0.4
compare "command line typing"
both_key Enter
sleep 0.8
compare "command submit"
both '/'
sleep 0.3
both 'file_'
sleep 0.5
compare "search typing"
both_key Enter
sleep 0.8
compare "search submit"
both '?'
sleep 0.3
both 'dir'
sleep 0.5
compare "find typing"
both_key Enter
sleep 0.8
compare "find submit"
both ':'
sleep 0.3
both_key Escape
sleep 0.6
compare "escape cancel"
both ':'
sleep 0.3
both_key Up
sleep 0.6
compare "history recall"
both_key C-c
sleep 0.3
both_key q
both_key a
sleep 1

printf '\nerrors base: %s\n' "$(wc -l < "${fx}/base.err")"
printf 'errors llm: %s\n' "$(wc -l < "${fx}/llm.err")"
printf '%s failure(s)\n' "${fail}"

tmux -L hsfmcmp -f /dev/null kill-server 2>/dev/null
rm -rf "${fx}"
[[ "${fail}" -eq 0 ]]
