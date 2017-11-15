
all: dhparam fallback

dhparam:
	echo "this is going to take a minute..."
	openssl dhparam 2048 -outform pem -out ${PWD}/ssl/dhparam.pem > /dev/null 2>&1
	chmod 640 ${PWD}/ssl/dhparam.pem

fallback:
	openssl req -new -newkey rsa:2048 -days 36500 \
		-nodes -x509 -subj '/CN=sni-support-required-for-valid-ssl' \
		-keyout ${PWD}/ssl/resty-auto-ssl-fallback.key \
		-out ${PWD}/ssl/resty-auto-ssl-fallback.crt
