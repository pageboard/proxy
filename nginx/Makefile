
all: ssl dhparam fallback

ssl:
	mkdir -p ssl

dhparam:
	openssl dhparam 4096 -outform pem > ssl/dhparam.pem
	chmod 640 ssl/dhparam.pem

fallback:
	openssl req -new -newkey rsa:2048 -days 36500 \
		-nodes -x509 -subj '/CN=sni-support-required-for-valid-ssl' \
		-keyout ssl/resty-auto-ssl-fallback.key \
		-out ssl/resty-auto-ssl-fallback.crt
