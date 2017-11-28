
luarocks:
	luarocks --tree=rocks install lua-resty-auto-ssl
	-cd rocks/bin/resty-auto-ssl && patch --backup --forward --strip 1 --quiet --reject-file - < ../../../patches/dehydrated-7eca8aec.patch
	luarocks --tree=rocks install upcache 0.7.0
	curl -L https://github.com/openresty/lua-resty-lock/archive/v0.07.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-core/archive/v0.1.12.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --wildcards '*/lib/ngx/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-lrucache/archive/v0.07.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2


nginx/mime.types:
	cd nginx && ln -sf /etc/nginx/mime.types .

leclean:
	rm -rf autossl/storage
	rm -rf autossl/letsencrypt/certs
	rm -rf autossl/letsencrypt/accounts
