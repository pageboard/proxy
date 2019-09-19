install: luarocks luapatches nginx/mime.types lualnclean lualn

lualnclean:
	rm -f lua/upcache*

luarocks:
	luarocks --tree=rocks install inifile 1.0
	luarocks --tree=rocks install lua-resty-http 0.13
	luarocks --tree=rocks install lua-resty-auto-ssl 0.12.0
	luarocks --tree=rocks install upcache 1.2.0
	curl -L https://github.com/openresty/lua-resty-lock/archive/v0.08.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-core/archive/v0.1.17.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --wildcards '*/lib/ngx/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-lrucache/archive/v0.09.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	luarocks --tree=rocks install nginx-lua-prometheus

lualn:
	cd rocks/share/lua/5.1/ && ln -sf ../../../../lua/* .

luapatches:
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-otf.patch
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-allow-domain.patch
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-no-store-cert-backups.patch
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-delete-expired-certificates.patch
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/inifile-fix-key-reg.patch

nginx/mime.types:
	cd nginx && ln -sf /etc/nginx/mime.types .

leclean:
	rm -rf autossl/storage
	rm -rf autossl/letsencrypt/certs
	rm -rf autossl/letsencrypt/accounts
