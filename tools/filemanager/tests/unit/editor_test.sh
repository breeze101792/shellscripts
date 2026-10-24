#!/usr/bin/env bash
#
# Line editor core: drive fedit_key with scripted keys and assert the state
# transitions. The core does no terminal I/O, so this runs headless.
#
# Usage: tests/unit/editor_test.sh <script>

set -uo pipefail

script=${1:-filemanager_llm.sh}
case ${script} in
    /*) ;;
    *) script=$(realpath "${script}") ;;
esac

fixture=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-editor.XXXXXX")
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

type_keys() {
    local key
    for key in "$@"; do
        fedit_key "${key}"
    done
}

# --- editing ---------------------------------------------------------------

fedit_begin ":" "command" "mode"
type_keys a b c
check "typing appends" "${FM_ED_BUF}" "abc"

fedit_key $'\e[D'
check "left moves the cursor" "${FM_ED_BUF}/${FM_ED_POSTBUF}" "ab/c"
fedit_key $'\e[C'
check "right moves it back" "${FM_ED_BUF}/${FM_ED_POSTBUF}" "abc/"

fedit_key $'\177'
check "backspace deletes" "${FM_ED_BUF}" "ab"

# Delete removes the character under the cursor, not the one before it.
fedit_begin ":" "${DEF_TERM_MODE_COMMAND}" "${DEF_ED_DRIVER_MODE}"
type_keys a b c
fedit_key $'\e[D'
fedit_key $'\e[D'
fedit_key $'\e[3~'
check "delete drops the character under the cursor" "${FM_ED_BUF}/${FM_ED_POSTBUF}" "a/c"

fedit_key $'\e[3~'
fedit_key $'\e[3~'
check "delete stops at the end of the line" "${FM_ED_BUF}/${FM_ED_POSTBUF}" "a/"

fedit_key ":"
check "colon clears the command line" "${FM_ED_BUF}" ""

# ':' only clears the command flavor; elsewhere it is dropped, as before.
fedit_begin "" "wait" "prompt"
type_keys a ":"
check "colon does not clear outside command flavor" "${FM_ED_BUF}" "a"

# '~' expands in every flavor.
fedit_begin ":" "command" "mode"
fedit_key "~"
check "tilde expands to HOME" "${FM_ED_BUF}" "${HOME}"

# --- submit and cancel -----------------------------------------------------

fedit_begin ":" "command" "mode"
type_keys l s
fedit_key $'\e[D'
check "cursor split before submit" "${FM_ED_BUF}/${FM_ED_POSTBUF}" "l/s"
fedit_key ""
check "submit returns 1" "$?" "1"
check "submit joins the buffers" "${FM_ED_COMMIT}" "ls"

fedit_begin ":" "command" "mode"
type_keys x
fedit_key $'\e'
check "cancel returns 2" "$?" "2"
check "cancel clears the input" "${FM_ED_COMMIT}" ""

# --- history ---------------------------------------------------------------

VAR_TERM_CMD_HISTORY=("one" "two")
fedit_begin ":" "command" "mode"
type_keys z z
fedit_key $'\e[A'
check "history up shows the newest" "${FM_ED_BUF}" "two"
fedit_key $'\e[A'
check "history up walks back" "${FM_ED_BUF}" "one"
fedit_key $'\e[B'
check "history down walks forward" "${FM_ED_BUF}" "two"
fedit_key $'\e[B'
check "history down restores the typed line" "${FM_ED_BUF}" "zz"

# Wait and confirm prompts have no history (K8).
fedit_begin "" "wait" "prompt"
type_keys q
fedit_key $'\e[A'
check "wait prompt ignores history" "${FM_ED_BUF}" "q"

# Find history is mode-only.
VAR_TERM_FIND_HISTORY=("needle")
fedit_begin "?" "find" "prompt"
fedit_key $'\e[A'
check "prompt never selects find history" "${FM_ED_BUF}" ""

# --- history trim (K9) -----------------------------------------------------

FM_ED_HISTORY_MAX=3
VAR_TERM_CMD_HISTORY=("a" "b" "c")
fhist_append "VAR_TERM_CMD_HISTORY" "d"
check "history keeps the newest" "${VAR_TERM_CMD_HISTORY[*]}" "b c d"
fhist_append "VAR_TERM_CMD_HISTORY" "e"
check "history stays at max" "${VAR_TERM_CMD_HISTORY[*]}" "c d e"
check "history length is capped" "${#VAR_TERM_CMD_HISTORY[@]}" "3"

# --- completion slots ------------------------------------------------------

FM_ED_HISTORY_MAX=100

# K1: a stale mode list must not survive a new session.
FM_ED_COMP_MODE_LIST=("stale")
FM_ED_COMP_MODE_IDX=1
fedit_begin ":" "command" "mode"
check "begin resets the mode slot" "${#FM_ED_COMP_MODE_LIST[@]}" "0"
check "begin resets the mode index" "${FM_ED_COMP_MODE_IDX}" "0"

# K2: completion appends to an array, not to a string.
FM_ED_CMD_LIST=("aaa" "aab")
FM_ED_COMMIT=""
fedit_begin "" "command" "prompt"
type_keys a
fedit_key $'\t'
check "prompt completion picks the first match" "${FM_ED_BUF}" "aaa"
check "prompt completion is a list" "${#FM_ED_COMP_PROMPT_LIST[@]}" "3"
check "prompt completion keeps the typed text last" \
    "${FM_ED_COMP_PROMPT_LIST[2]}" "a"

fedit_key $'\t'
check "second tab cycles" "${FM_ED_BUF}" "aab"
fedit_key $'\t'
check "third tab wraps to the typed text" "${FM_ED_BUF}" "a"

# Wait prompts take no completion.
fedit_begin "" "wait" "prompt"
type_keys a
fedit_key $'\t'
check "wait prompt ignores tab" "${FM_ED_BUF}" "a"
check "wait prompt builds no list" "${#FM_ED_COMP_PROMPT_LIST[@]}" "0"

# --- line rendering --------------------------------------------------------

fedit_begin ":" "command" "mode"
type_keys h i
fedit_key $'\e[D'
check "line renders prefix and cursor text" "$(fedit_line)" ":hi "
check "cursor offset counts the tail" "$(fedit_cursor_offset)" "2"

printf '\n%s failure(s)\n' "${fail}"
[[ "${fail}" -eq 0 ]]
