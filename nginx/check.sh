#!/usr/bin/env bash

function diffing {
	echo "# Diffing $1 and $2"
	diff $1 $2
}

if [[ $1 = "http" ]]; then
	diffing woodsmen.nginx /etc/nginx/sites-available/intranet
elif [[ $1 = "https" || $1 = "ssl" ]]; then
	diffing woodsmen-ssl.nginx /etc/nginx/sites-available/intranet
else
  echo "Error, no command specified."
	echo "Usage: ./$(basename $0) (http|https|ssl)"
fi
