#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p evidence
gcc -O2 -g -fstack-protector-strong -D_FORTIFY_SOURCE=3 \
    -fPIE -pie -Wl,-z,relro,-z,now -Wl,-z,noexecstack \
    -Wall -Wextra -Werror \
    -o src/legacy_log_parser_fixed src/legacy_log_parser_fixed.c

bash tests/test_task3.sh 2>&1 | tee evidence/task3_tests.txt
{
    echo 'Task 1 vulnerable binary:'
    checksec --file=./src/legacy_log_parser
    echo 'Task 3 fixed and hardened binary:'
    checksec --file=./src/legacy_log_parser_fixed
} 2>&1 | tee evidence/task3_checksec.txt
