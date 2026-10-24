#!/usr/bin/env bash
#
# Direct tests for fdir_ingest: the parse branches a real 'ls' does not always
# produce deterministically (permission denied, symlink arrow, quote strip,
# non-path lines).
#
# Usage: tests/unit/ingest_test.sh <script>

set -uo pipefail

script=${1:-filemanager_llm.sh}
case ${script} in
    /*) ;;
    *) script=$(realpath "${script}") ;;
esac

fixture=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-ingest.XXXXXX")
trap 'rm -rf "${fixture}"' EXIT

export HOME="${fixture}"
export HSFM_FILE_CONFIG="${HOME}/.hsfm.sh"
export HSFM_PATH_CACHE="${HOME}/.cache/hsfm"
export TERM=dumb
export LC_ALL=C

mkdir -p "${fixture}/tree/aaa_dir" "${HSFM_PATH_CACHE}"
printf 'x\n' > "${fixture}/tree/file1"
printf 'x\n' > "${fixture}/quo'te file"
ln -s "${fixture}/tree/file1" "${fixture}/tree/link"

set +u
# shellcheck disable=SC1090
source "${script}" >/dev/null 2>&1
set -u

root=${fixture}/tree
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

VAR_TERM_DIR_FILE_LIST=()
VAR_TERM_DIR_FILE_INFO_LIST=()
FM_DIR_PREV_IDX=0
OLDPWD="${root}/aaa_dir"

fdir_ingest << EOF
total 12
drwxr-xr-x 2 shaowu shaowu 40 Jan  1  2020 ${root}/aaa_dir
-rw-r--r-- 1 shaowu shaowu  2 Jan  1  2020 ${root}/file1
lrwxrwxrwx 1 shaowu shaowu 31 Jan  1  2020 ${root}/link -> ${root}/file1
-rw-r--r-- 1 shaowu shaowu  2 Jan  1  2020 ${root}/quo'te file
ls: cannot access '${root}/nope': Permission denied
EOF

check "path list" "${VAR_TERM_DIR_FILE_LIST[*]}" \
    "${root}/aaa_dir ${root}/file1 ${root}/link ${root}/quo'te file ${root}/nope"
# info is the ls -l prefix: mode through date.
check "info of the directory" "${VAR_TERM_DIR_FILE_INFO_LIST[0]}" \
    "drwxr-xr-x 2 shaowu shaowu 40 Jan  1  2020"
check "info of a permission failure" "${VAR_TERM_DIR_FILE_INFO_LIST[4]}" \
    "Permission denied"
check "info count matches path count" \
    "${#VAR_TERM_DIR_FILE_INFO_LIST[@]}" "${#VAR_TERM_DIR_FILE_LIST[@]}"
check "previous index points at OLDPWD" "${FM_DIR_PREV_IDX}" "0"

# A failed entry is appended after the readable ones, whatever its position.
VAR_TERM_DIR_FILE_LIST=()
VAR_TERM_DIR_FILE_INFO_LIST=()
fdir_ingest << EOF
ls: cannot access '${root}/gone': Permission denied
-rw-r--r-- 1 shaowu shaowu  2 Jan  1  2020 ${root}/file1
drwxr-xr-x 2 shaowu shaowu 40 Jan  1  2020 ${root}/aaa_dir
EOF
check "denied entry is deferred to the end" "${VAR_TERM_DIR_FILE_LIST[2]}" "${root}/gone"
check "denied info stays aligned" "${VAR_TERM_DIR_FILE_INFO_LIST[2]}" "Permission denied"

# A line without a slash is not a path and is skipped.
VAR_TERM_DIR_FILE_LIST=()
VAR_TERM_DIR_FILE_INFO_LIST=()
fdir_ingest << EOF
total 0
no slash here
EOF
check "slashless lines skipped" "${#VAR_TERM_DIR_FILE_LIST[@]}" "0"

# The previous index only moves for directories.
VAR_TERM_DIR_FILE_LIST=()
VAR_TERM_DIR_FILE_INFO_LIST=()
FM_DIR_PREV_IDX=0
OLDPWD="${root}/file1"
fdir_ingest << EOF
-rw-r--r-- 1 shaowu shaowu  2 Jan  1  2020 ${root}/file1
drwxr-xr-x 2 shaowu shaowu 40 Jan  1  2020 ${root}/aaa_dir
EOF
check "file match does not set the index" "${FM_DIR_PREV_IDX}" "0"

VAR_TERM_DIR_FILE_LIST=()
VAR_TERM_DIR_FILE_INFO_LIST=()
FM_DIR_PREV_IDX=0
OLDPWD="${root}/aaa_dir"
fdir_ingest << EOF
-rw-r--r-- 1 shaowu shaowu  2 Jan  1  2020 ${root}/file1
drwxr-xr-x 2 shaowu shaowu 40 Jan  1  2020 ${root}/aaa_dir
EOF
check "index counts every entry" "${FM_DIR_PREV_IDX}" "1"

printf '\n%s failure(s)\n' "${fail}"
[[ "${fail}" -eq 0 ]]
