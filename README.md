The Woodsmen
============

Tof man!


Installatie
-----------

Op de VPS van Archipunt:

	cd ~/doekman
	git clone git@bitbucket.org:doekman/woodsmen.git
	cd ~/doekman/woodsmen
	./process_static.sh install-gz

Configuratie van website zelf gaat nu via [config-man](https://bitbucket.org/archipunt/cm_apawa/src/master/)


### Oude info Installatie

> Testen **http**:
> 
> 	# Vanaf VPS
> 	curl http://the.woodsmen.nl/nginx_status
> 	# Vanaf macOS (ivm `open`)
> 	open http://woodsmen.nl/
> 	open http://www.woodsmen.nl/
> 	open http://the.woodsmen.nl/
> 
> 
> Instellen **https**:
> 
> 	cd ~/doekman/woodsmen
> 	sudo nginx/init.sh https #setup NGINX in HTTPS modus
> 
> Testen **https**:
> 
> 	# Vanaf VPS
> 	curl https://the.woodsmen.nl/nginx_status
> 	curl --http2 https://the.woodsmen.nl/nginx_status
> 	# Vanaf macOS (ivm `open`)
> 	open https://woodsmen.nl/
> 	open https://www.woodsmen.nl/
> 	open https://the.woodsmen.nl/
> 	open https://tools.keycdn.com/http2-test # onze URL invullen
> 	openssl s_client -connect the.woodsmen.nl:443 -tls1 -tlsextdebug -status #OCSP test
> 	open https://www.ssllabs.com/ssltest/analyze.html?d=the.woodsmen.nl


Beheer
------

Updaten:

	cd ~/doekman/woodsmen
	git pull
	./process_static.sh clean-install-gz


Restricted
----------

De map `/restricted/` is beschermd door een wachtwoord. Mappen hieronder die met een `_` beginnen worden niet in _git_ gezet.

Voeg een wachtwoord toe:

	# Uitvoeren vanuit de root van dit repository; vervang USER en PASSWORD door de 
	$ htpasswd -bB ./nginx/etc/htpasswd USERNAME 'THE PASSWORD'

