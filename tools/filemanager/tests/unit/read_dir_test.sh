#!/usr/bin/env bash
#
# Differential test for the directory pipeline: the refactored script must
# produce the same directory model as the pre-refactor script for every read
# mode.
#
# Usage: tests/unit/read_dir_test.sh [new.sh] [baseline.sh]

set -uo pipefail

here=$(dirname "$(realpath "$0")")
new=${1:-filemanager_llm.sh}
baseline=${2:-filemanager.sh}
probe=${here}/probe_read_dir.sh

case ${new} in
    /*) ;;
    *) new=${here}/../../${new} ;;
esac
case ${baseline} in
    /*) ;;
    *) baseline=${here}/../../${baseline} ;;
esac

fixture=$(mktemp -d "${TMPDIR:-/tmp}/hsfm-dir.XXXXXX")
trap 'chmod 755 "${fixture}/tree/locked" 2>/dev/null; rm -rf "${fixture}"' EXIT

tree=${fixture}/tree
home=${fixture}/home
mkdir -p "${tree}"/{aaa_dir,bbb_dir,empty_dir,sub/sub_sub} "${home}/.cache/hsfm"

printf 'x\n' > "${tree}/file1"
printf 'x\n' > "${tree}/zzz_file"
printf 'x\n' > "${tree}/.hidden_file"
printf 'x\n' > "${tree}/quo'te file"
printf 'x\n' > "${tree}/sub/sub_file"
printf 'x\n' > "${tree}/sub/sub_sub/deep_file"
ln -s "${tree}/file1" "${tree}/link_file"

# Pinned mtimes: 'ls -l' prints dates, and the two runs must agree.
find "${tree}" -exec touch -t 202001010000 {} +

mkdir -p "${tree}/locked"
printf 'x\n' > "${tree}/locked/secret"
touch -t 202001010000 "${tree}/locked" "${tree}/locked/secret"
chmod 000 "${tree}/locked"

# The baseline still runs fMain when sourced, so neutralise the last line.
guarded=${fixture}/baseline.sh
sed 's/^fMain \$@$/:/' "${baseline}" > "${guarded}"
chmod +x "${guarded}"

fail=0
run_mode() {
    local mode=$1
    local name=$2
    local oldpwd=$3

    "${probe}" "${guarded}" "${tree}" "${mode}" "${home}" "${oldpwd}" \
        > "${fixture}/base.out" 2>/dev/null
    "${probe}" "${new}" "${tree}" "${mode}" "${home}" "${oldpwd}" \
        > "${fixture}/new.out" 2>/dev/null

    if diff -u "${fixture}/base.out" "${fixture}/new.out" > "${fixture}/diff.out"
    then
        printf 'ok   %s\n' "${name}"
    else
        printf 'FAIL %s\n' "${name}"
        sed -n '1,20p' "${fixture}/diff.out"
        fail=$((fail + 1))
    fi
}

run_mode 0  "NONE, no OLDPWD" ""
run_mode 0  "NONE, OLDPWD set" "${tree}/bbb_dir"
run_mode 1  "SORT, no OLDPWD" ""
run_mode 1  "SORT, OLDPWD set" "${tree}/aaa_dir"
run_mode 2  "LS, no OLDPWD" ""
run_mode 2  "LS, OLDPWD set" "${tree}/bbb_dir"
run_mode 4  "LS_SORT, OLDPWD set" "${tree}/aaa_dir"
run_mode 3  "FAST_LS, OLDPWD set" "${tree}/aaa_dir"
run_mode 10 "FIND, no OLDPWD" ""

printf '\n%s failure(s)\n' "${fail}"
[[ "${fail}" -eq 0 ]]
