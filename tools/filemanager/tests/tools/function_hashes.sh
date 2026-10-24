#!/usr/bin/env bash
#
# Print "name sha256" for every function in a bash script, sorted by name.
#
# The body is taken from 'declare -f', so the hash covers the parsed function,
# not its layout: moving a function or reformatting it keeps the hash, editing
# a statement changes it.
#
# Usage: function_hashes.sh <script>

set -uo pipefail

script=${1:?usage: function_hashes.sh <script>}

# The target is sourced with nounset off: it relies on unset-as-empty.
set +u
# shellcheck disable=SC1090
source "${script}" >/dev/null 2>&1
set -u

while read -r _ _ name; do
    printf '%s\n' "${name}"
done < <(declare -F) |
    sort |
    while read -r name; do
        printf '%s %s\n' "${name}" \
            "$(declare -f "${name}" | sha256sum | cut -d' ' -f1)"
    done
