#!/usr/bin/env bash
#
# Probe one directory read. Prints the resulting model on stdout so the caller
# can diff two scripts against the same fixture.
#
# Usage: probe_read_dir.sh <script> <dir> <mode> <home> <oldpwd>

set -uo pipefail

script=$1
dir=$2
mode=$3
home=$4
oldpwd=$5

export HOME="${home}"
export HSFM_FILE_CONFIG="${HOME}/.hsfm.sh"
export HSFM_PATH_CACHE="${HOME}/.cache/hsfm"
export TERM=dumb
export LC_ALL=C

mkdir -p "${HSFM_PATH_CACHE}"

# The script relies on unset-as-empty. Stay in that mode afterwards: the
# baseline uses the pre-rename state names.
set +u
# shellcheck disable=SC1090
source "${script}" >/dev/null 2>&1

cd "${dir}" || exit 1

HSFM_READ_DIR_MODE=${mode}
HSFM_ENABLE_HIDDEN=1
# '-d': list the entries themselves. Without it ls recurses into the globbed
# subdirectories and interleaves stderr with stdout, which is nondeterministic
# in the original script too.
VAR_TERM_DIR_LS_ARGS=(-l -a -d)
OLDPWD=${oldpwd}

# Redirection only: a pipe or a subshell would lose the model.
fterminal_read_dir >/dev/null 2>&1

# Accept either the refactored or the original state names.
prev=${FM_DIR_PREV_IDX:-${previous_index:-}}
files=${VAR_TERM_DIR_FILE_LIST[*]:-}
info=${VAR_TERM_DIR_FILE_INFO_LIST[*]:-}

# The only reader of the previous index is arithmetic, where empty is 0.
printf 'PREV=%s\n' "${prev:-0}"
printf 'CNT=%s\n' "${VAR_TERM_DIR_LIST_CNT:-}"
printf 'FILES=%s\n' "${files}"
printf 'INFO=%s\n' "${info}"
