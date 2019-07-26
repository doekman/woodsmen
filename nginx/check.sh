#!/usr/bin/env bash
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

function diffing {
	echo "# Diffing $1 and $2"
	diff "$1" "$2"
}

SCRIPT_PATH="$(dirname "$0")"
CMD="${1:-}"

if [[ $CMD = "http" ]]; then
	diffing "$SCRIPT_PATH/woodsmen.nginx" /etc/nginx/sites-available/woodsmen
elif [[ $CMD = "https" || $CMD = "ssl" ]]; then
	diffing "$SCRIPT_PATH/snippets/ssl-woodsmen.archipunt.nl.conf" /etc/nginx/snippets/ssl-woodsmen.archipunt.nl.conf
	diffing "$SCRIPT_PATH/woodsmen-ssl.nginx" /etc/nginx/sites-available/woodsmen
	nginx -t && echo "Nginx configuration is good" || echo "Error in nginx config"
else
	echo "Error, no command specified."
	echo "Usage: ./$(basename "$0") (http|https|ssl)"
fi
