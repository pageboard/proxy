
all: ssl dhparam fallback

ssl:
	mkdir -p ssl

dhparam: ssl/dhparam.pem
	openssl dhparam -outform pem -dsaparam 4096 > ssl/dhparam.pem
	chmod 640 ssl/dhparam.pem

fallback: ssl/resty-auto-ssl-fallback.crt
	openssl req -new -newkey rsa:2048 -days 36500 \
		-nodes -x509 -subj '/CN=sni-support-required-for-valid-ssl' \
		-keyout ssl/resty-auto-ssl-fallback.key \
		-out ssl/resty-auto-ssl-fallback.crt
