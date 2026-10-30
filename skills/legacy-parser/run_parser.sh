if [[ $# -ne 1 ]]; then
    echo "usage: run_parser.sh <path-to-log-file-in-inbox>" >&2
    exit 2
fi

REQUESTED="$1"

cd ~/csce465-agentsec
exec ./src/legacy_log_parser "inbox/$REQUESTED"