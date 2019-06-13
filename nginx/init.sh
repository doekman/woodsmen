#!/usr/bin/env bash

function root_check {
	if [[ $EUID -ne 0 ]]; then
		>&2 echo "Please run script with 'sudo $(basename $0) $*', exiting..."
		exit 1
	fi
}

root_check

CONFIG_CHANGE=0

if [[ $1 = "http" ]]; then

	# install and enable woodsmen
	cp woodsmen.nginx /etc/nginx/sites-available/woodsmen
	ln -s /etc/nginx/sites-available/woodsmen /etc/nginx/sites-enabled/

	CONFIG_CHANGE=1

elif [[ $1 = "https" || $1 = "ssl" ]]; then

	#install ssl snippets
	cp snippets/*.conf /etc/nginx/snippets/

	#overwrite nginx site config with ssl version
	cp woodsmen-ssl.nginx /etc/nginx/sites-available/woodsmen
	
	CONFIG_CHANGE=1

else
	echo "Error, no command specified."
	echo "Usage: ./$(basename $0) (http|https|ssl)"
fi

if [[ $CONFIG_CHANGE -eq 1 ]]; then
	echo "Check nginx config"
	nginx -t && nginx -s reload || echo "Error in nginx config"
fi
