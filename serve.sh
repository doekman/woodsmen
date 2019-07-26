#!/usr/bin/env bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

PORT=8000
ADDR=127.0.0.1
ROOT=./wwwroot/
if [[ ${1:-} != "--no-open" ]]; then
    (sleep 1 && open http://$ADDR:$PORT) &
    disown $!
fi
python3 -m http.server $PORT --bind $ADDR --directory $ROOT
