#!/usr/bin/env bash
#
# Regression tests for the bugs REFACTOR.md section 7.1 lists.
#
# The suite runs under 'set -u' on purpose: the script does not, so an unbound
# reference here is a stricter check than production.
#
# Usage: tests/unit/bugs_test.sh <script>

set -uo pipefail

script=${1:-filemanager_llm.sh}
case ${script} in
    /*) ;;
    *) script=$(realpath "${script}") ;;
esac

fixture=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-bugs.XXXXXX")
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

# The UI is out of scope here.
fterminal_print() { :; }
fterminal_redraw() { :; }
fterminal_flush() { :; }
fterminal_draw_command_line() { :; }
fterminal_draw_status_line() { :; }
fterminal_draw_window() { :; }
fterminal_draw_miniwin() { :; }
fterminal_mark_reset() { :; }
fterminal_clear() { :; }
fmode_setup() { :; }
flog_msg() { :; }

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

# --- K5: cmd_set left reports success and still redraws ----------------------

cmd_set "left" "on" >/dev/null 2>&1
check "K5 left on succeeds" "$?" "0"
check "K5 left on switches the keys" "${HSFM_KEY_CHILD1}" "g"

cmd_set "left" "bogus" >/dev/null 2>&1
check "K5 unknown value fails" "$?" "255"
check "K5 unknown value keeps the keys" "${HSFM_KEY_CHILD1}" "g"

# --- K7: the duplicate and no arms are reachable -----------------------------

mkdir -p "${fixture}/k7/src" "${fixture}/k7/dst"
printf 'old1\n' > "${fixture}/k7/dst/f1.txt"
printf 'old2\n' > "${fixture}/k7/dst/f2.txt"
printf 'new1\n' > "${fixture}/k7/src/f1.txt"
printf 'new2\n' > "${fixture}/k7/src/f2.txt"

prompts=0
answer="n"
fprompt_confirm() {
    prompts=$((prompts + 1))
    FM_ED_COMMIT="${answer}"
}

# The overwrite check looks at the basename in the current directory, so the
# paste happens from the destination, as the UI does.
cd "${fixture}/k7/dst"
fselect_copy "${fixture}/k7/src/f1.txt" "${fixture}/k7/src/f2.txt" "${fixture}/k7/dst"
check "K7 n asks once per file" "${prompts}" "2"
check "K7 target is left alone" "$(cat "${fixture}/k7/dst/f1.txt")" "old1"

# 'd' applies to the rest of the batch, so it asks once.
rm -f "${fixture}/k7/dst"/copy_*
prompts=0
answer="d"
fselect_copy "${fixture}/k7/src/f1.txt" "${fixture}/k7/src/f2.txt" "${fixture}/k7/dst"
check "K7 d asks once for the batch" "${prompts}" "1"
check "K7 two copies are made" \
    "$(ls "${fixture}/k7/dst" | grep -c '^copy_')" "2"

# --- K11: a single selection names the archive after the file ----------------

unset -f fprompt_confirm
mkdir -p "${fixture}/k11" "${fixture}/bin"
printf 'x\n' > "${fixture}/k11/file.txt"
printf 'x\n' > "${fixture}/k11/a.b.tar.gz"
printf 'x\n' > "${fixture}/k11/.bashrc"
printf 'x\n' > "${fixture}/k11/sp ace.txt"

# A fake zip keeps the command on the zip branch, which names the archive
# without a trailing space in the command string.
printf '#!/bin/sh\nexit 0\n' > "${fixture}/bin/zip"
chmod +x "${fixture}/bin/zip"
PATH="${fixture}/bin:${PATH}"

EVAL_CMD=""
eval() { EVAL_CMD="$*"; }

cd "${fixture}/k11"

archive_name() {
    FM_CMD_SELECTION_LIST=("${fixture}/k11/$1")
    EVAL_CMD=""
    vcmd_compress "" >/dev/null 2>&1
    printf '%s' "${EVAL_CMD}"
}

# The archive and the source both contain the name, so an unquoted match on
# the whole command is ambiguous. Count instead: the stem appears twice.
name_count() {
    printf '%s' "$1" | grep -o -F "$2" | wc -l
}

check "K11 single file uses its own name" \
    "$(name_count "$(archive_name "file.txt")" "/k11/file.")" "2"
check "K20 multi-dot keeps the inner dots" \
    "$(name_count "$(archive_name "a.b.tar.gz")" "/k11/a.b.tar.")" "2"
check "K20 dotfile keeps its whole name" \
    "$(name_count "$(archive_name ".bashrc")" "/k11/.bashrc.")" "1"
check "K20 the archive follows the command with a space" \
    "$(case "$(archive_name "file.txt")" in "zip -j '"*) echo ok ;; *) echo bad ;; esac)" "ok"
check "K20 a spaced name is one argument" \
    "$(archive_name "sp ace.txt" | grep -c -F " '${fixture}/k11/sp ace.zip' '${fixture}/k11/sp ace.txt' ")" "1"

unset -f eval

# --- K12: tab context restores the list and the cursor ----------------------

mkdir -p "${fixture}/tab_a" "${fixture}/tab_b"
printf 'x\n' > "${fixture}/tab_a/one"
printf 'x\n' > "${fixture}/tab_a/two"
printf 'x\n' > "${fixture}/tab_b/other"

HSFM_READ_DIR_MODE=0
HSFM_ENABLE_HIDDEN=1

cd "${fixture}/tab_a"
fterminal_read_dir
FM_DIR_SCROLL_START_IDX=0
FM_DIR_SCROLL_IDX=1
fterminal_tab_save_contex 0

cd "${fixture}/tab_b"
fterminal_read_dir
FM_DIR_SCROLL_START_IDX=0
FM_DIR_SCROLL_IDX=0
fterminal_tab_save_contex 1

# A file added while the tab is parked must show up on the way back.
printf 'x\n' > "${fixture}/tab_a/late"
fterminal_tab_load_contex 0
check "K12 tab returns to its directory" "$(basename "${PWD}")" "tab_a"
check "K12 tab restores the cursor" "${FM_DIR_SCROLL_IDX}" "1"
check "K12 tab restores the list from disk" "${#FM_DIR_FILE_LIST[@]}" "3"

# --- K15: OLDPWD is a path, not a pattern -----------------------------------

mkdir -p "${fixture}/k15"
touch "${fixture}/k15/0first" "${fixture}/k15/a.b" "${fixture}/k15/aaa" "${fixture}/k15/axb"

cd "${fixture}/k15"
HSFM_READ_DIR_MODE=0
OLDPWD="${fixture}/k15/a.b"
FM_DIR_PREV_IDX=0
fterminal_read_dir
check "K15 exact path wins over a regex match" "${FM_DIR_PREV_IDX}" "1"

# --- K18: an empty opener is not launched -----------------------------------

mkdir -p "${fixture}/k18"
printf '\000\001\002binary\003' > "${fixture}/k18/file.bin"

cmd_editor() { :; }
FLOG=()
flog_msg() { FLOG+=("$*"); }
DISPLAY=":0"
HSFM_OPENER=""

cd "${fixture}/k18"
fsys_open "${fixture}/k18/file.bin" >/dev/null 2>&1
check "K18 empty opener falls through to the message" \
    "$(printf '%s\n' "${FLOG[@]}" | grep -c "Unknown file type")" "1"

unset DISPLAY
flog_msg() { :; }

# --- K16: the verbose hooks exist -------------------------------------------

check "K16 fInfo is defined" "$(type -t fInfo)" "function"
check "K16 fErrControl is defined" "$(type -t fErrControl)" "function"
fInfo >/dev/null 2>&1
check "K16 fInfo runs" "$?" "0"
fErrControl fMain 42 >/dev/null 2>&1
check "K16 fErrControl runs" "$?" "0"

printf '\n%s failure(s)\n' "${fail}"
[[ "${fail}" -eq 0 ]]
