#!/usr/bin/env bash

function root_check {
	if [[ $EUID -ne 0 ]]; then
		>&2 echo "Please run script with 'sudo $(basename "$0") $*', exiting..."
		exit 1
	fi
}

root_check "$@"

CONFIG_CHANGE=0
SCRIPT_PATH="$(dirname "$0")"
WWWROOT="$SCRIPT_PATH/../wwwroot"

if [[ $1 = "http" ]]; then

	# install and enable woodsmen
	cp "$SCRIPT_PATH/woodsmen.nginx" /etc/nginx/sites-available/woodsmen
	ln -s /etc/nginx/sites-available/woodsmen /etc/nginx/sites-enabled/

	CONFIG_CHANGE=1

elif [[ $1 = "https" || $1 = "ssl" ]]; then

	# Certificaat regelen
	certbot certonly --webroot -w "$WWWROOT" -d the.woodsmen.nl -m doekman@icloud.com --agree-tos

	# Certificaat spul veilig stellen
	mkdir -p ~/download/
	timestamp=$(date  --iso-8601=seconds --utc)
	timestamp=${timestamp:0:19}
	zip -r "$HOME/download/etc_letsencrypt_dump_${timestamp}" /etc/letsencrypt

	#install ssl snippets
	cp "$SCRIPT_PATH/snippets/*.conf" /etc/nginx/snippets/

	#overwrite nginx site config with ssl version
	cp "$SCRIPT_PATH/woodsmen-ssl.nginx" /etc/nginx/sites-available/woodsmen

	if grep the.woodsmen.nl < /etc/hosts
	then
		sed $'1 a 127.0.0.1\tthe.woodsmen.nl' /etc/hosts
	fi

	CONFIG_CHANGE=1

else
	echo "Error, no command specified."
	echo "Usage: ./$(basename "$0") (http|https|ssl)"
fi

if [[ $CONFIG_CHANGE -eq 1 ]]; then
	echo "Check nginx config"
	nginx -t && nginx -s reload || echo "Error in nginx config"
fi
