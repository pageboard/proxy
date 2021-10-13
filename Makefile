install: luarocks luapatches nginx/mime.types lualnclean lualn

lualnclean:
	rm -f lua/upcache*

luarocks:
	luarocks --tree=rocks install lua-toml 2.0
	luarocks --tree=rocks install lua-resty-http 0.15
	luarocks --tree=rocks install lua-resty-auto-ssl 0.13.1
	luarocks --tree=rocks install upcache 2.2.1
	curl -L https://github.com/openresty/lua-resty-lock/archive/v0.08.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-core/archive/v0.1.21.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --wildcards '*/lib/ngx/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-lrucache/archive/v0.10.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-redis/archive/v0.29.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	luarocks --tree=rocks install nginx-lua-prometheus 0.20181120

lualn:
	cd rocks/share/lua/5.1/ && ln -sf ../../../../lua/* .

luapatches:
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-otf.patch

nginx/mime.types:
	cd nginx && ln -sf /etc/nginx/mime.types .

leclean:
	rm -rf autossl/storage
	rm -rf autossl/letsencrypt/certs
	rm -rf autossl/letsencrypt/accounts
