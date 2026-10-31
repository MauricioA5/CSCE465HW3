#!/usr/bin/env bash
# Task 3 test cases
set -eu
cd "$(dirname "$0")/.."
root="$PWD"
binary="$root/src/legacy_log_parser_fixed"
payload="$root/src/payload.bin"

if [[ ! -x "$binary" || ! -f "$payload" ]]; then
    echo 'Build src/legacy_log_parser_fixed and supply src/payload.bin first.' >&2
    exit 1
fi
if [[ $(wc -c < "$payload") -le 128 ]]; then
    echo 'The original overflow payload must exceed 128 bytes.' >&2
    exit 1
fi

# Clear the old marker
mkdir -p markers tests/inputs
rm -f markers/ret2win.txt tests/inputs/missing.log
printf 'Normal log entry\n' > tests/inputs/short.log
python3 -c 'print("A" * 128, end="")' > tests/inputs/exact.log
python3 -c 'print("A" * 129, end="")' > tests/inputs/over.log

failures=0
run_case() {
    echo
    echo "Test: $1"
    status=0
    "$binary" "$2" || status=$?
    echo
    echo "Exit status: $status (expected $3)"
    if [[ "$status" -eq "$3" && ! -e markers/ret2win.txt ]]; then
        echo 'PASS: expected exit status; no marker created'
    else
        echo 'FAIL: unexpected exit status or marker created'
        failures=$((failures + 1))
    fi
    rm -f markers/ret2win.txt
}

run_case 'Valid short input: should print the log' tests/inputs/short.log 0
run_case 'Exactly 128 bytes: should print all 128 bytes' tests/inputs/exact.log 0
run_case '129 bytes: should report oversized input' tests/inputs/over.log 1
run_case 'Missing file: should report a file error' tests/inputs/missing.log 1
run_case 'Original exploit: should report oversized input' "$payload" 1

echo
echo "$((5 - failures))/5 exit-status and marker checks passed"
echo 'Also review the displayed log output and error messages.'
[[ "$failures" -eq 0 ]]
