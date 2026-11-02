#!/usr/bin/env bash
HW3="$HOME/csce465-agentsec/hw3"
INBOX="$HW3/inbox"
PARSER="$HW3/src/legacy_log_parser"

if [[ $# -ne 1 ]]; then
    echo "usage: run_parser.sh <path-to-log-file-in-inbox>" >&2
    exit 2
fi
REQUESTED="$1"

TARGET=$(realpath -m "$INBOX/$1")
case "$TARGET" in "$INBOX"/*) ;;
    *) echo "ERROR: File is outside the inbox" >&2; exit 1 ;;
esac
[[ -f "$TARGET" ]] || { echo "no such file: $1" >&2; exit 1; }

cd "$HW3"
exec "$PARSER" "$TARGET"