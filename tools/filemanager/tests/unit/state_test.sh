#!/usr/bin/env bash
#
# Headless state assertions: source the script with a hermetic HOME and drive
# the functions directly.
#
# Usage: tests/unit/state_test.sh <script>

set -uo pipefail

script=${1:-filemanager_llm.sh}
script=$(realpath "${script}")

fixture=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-unit.XXXXXX")
trap 'rm -rf "${fixture}"' EXIT

export HOME="${fixture}"
export HSFM_FILE_CONFIG="${HOME}/.hsfm.sh"
export HSFM_PATH_CACHE="${HOME}/.cache/hsfm"
export TERM=xterm-256color
export LC_ALL=C

mkdir -p "${HSFM_PATH_CACHE}"

# The script relies on unset-as-empty.
set +u
# shellcheck disable=SC1090
source "${script}" >/dev/null 2>&1
set -u

fail=0
check() {
    local name=$1
    shift
    if "$@"; then
        printf 'ok   %s\n' "${name}"
    else
        printf 'FAIL %s\n' "${name}"
        fail=$((fail + 1))
    fi
}

# Callers keep a local named args_value; the helper must not read it.
stale_scope_on() {
    local args_value="off"
    fenv_left_hande_mode "on"
}

alias_unknown_fails() {
    ! fenv_dir_alias_get nosuchalias
}

# K13: two elements, not one string "0,0".
check "K13 mainwin_start_idx has 2 elements" \
    test "${#FM_VIEW_MAINWIN_START_IDX[@]}" -eq 2

# K10: alias lookup through parallel arrays.
check "K10 alias home" test "$(fenv_dir_alias_get home)" = "${HOME}"
check "K10 alias log" test "$(fenv_dir_alias_get log)" = "/var/log"
check "K10 alias unknown fails" alias_unknown_fails

# K6: the mode helper reads its own argument, not a caller's local.
check "K6 on wins over caller local" stale_scope_on
check "K6 mode flag set" test "${FM_LEFT_HAND_MODE}" = "1"
check "K6 child key rebound" test "${HSFM_KEY_CHILD1}" = "g"

fenv_left_hande_mode "off"
check "K6 mode flag cleared" test "${FM_LEFT_HAND_MODE}" = "0"
check "K6 child key restored" test "${HSFM_KEY_CHILD1}" = "l"

printf '\n%s failure(s)\n' "${fail}"
[[ "${fail}" -eq 0 ]]
