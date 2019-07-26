The Woodsmen
============

Tof man!


Installatie
-----------

Op de VPS van Archipunt:

	cd ~/doekman
	# Gebruik uit Keychain: "archipunt-vps, one-time password"
	git clone https://doekman@bitbucket.org/doekman/woodsmen.git
	cd ~/doekman/woodsmen
	./process_static.sh install-gz
	su -m - #provide root password
	nginx/init.sh http #setup NGINX in HTTP modus


Testen **http**:

	# Vanaf VPS
	curl http://the.woodsmen.nl/nginx_status
	# Vanaf macOS (ivm `open`)
	open http://woodsmen.nl/
	open http://www.woodsmen.nl/
	open http://the.woodsmen.nl/


Instellen **https**:

	cd ~/doekman/woodsmen
	su -m - #provide root password
	nginx/init.sh https #setup NGINX in HTTPS modus

Testen **https**:

	# Vanaf VPS
	curl https://the.woodsmen.nl/nginx_status
	curl --http2 https://the.woodsmen.nl/nginx_status
	# Vanaf macOS (ivm `open`)
	open https://woodsmen.nl/
	open https://www.woodsmen.nl/
	open https://the.woodsmen.nl/
	open https://tools.keycdn.com/http2-test # onze URL invullen
	openssl s_client -connect the.woodsmen.nl:443 -tls1 -tlsextdebug -status #OCSP test
	open https://www.ssllabs.com/ssltest/analyze.html?d=the.woodsmen.nl


Verder de certificaten nog even veilig stellen:

	# Vanaf eigen computer
	scp apawa:/home/remotebeheer/download/etc_letsencrypt_dump_*.zip .
	# En dan hierheen kopieren (check of de mount er is)
	cd /Volumes/Keybase\ \(doekman\)/team/archipunt/Webservers/


Beheer
------

	cd ~/doekman/woodsmen
	nginx/check.sh https  #controleer of de configuratie nog correct is

Updaten:

	cd ~/doekman/woodsmen
	git pull
	./process_static.sh clean-install-gz

