#!/usr/bin/env bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

cmd=serve
options=('--open-url')
if [[ ${1:-} == '--no-open' || ${1:-} == '-no' ]]; then
    options=('')
    shift
fi

cd jekyll || exit 1
bundle exec jekyll $cmd --config _config.yml "${options[@]}" "$@"
