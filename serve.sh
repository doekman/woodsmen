#!/usr/bin/env bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

cd wwwroot
if [[ ${1:-} != "--no-open" ]]; then
    (sleep 1 && open http://0.0.0.0:8000) &
    disown
fi
python3 -m http.server
