
luarocks:
	luarocks --tree=rocks install lua-resty-auto-ssl 0.12.0
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-otf.patch
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-allow-domain.patch
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-no-store-cert-backups.patch
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-delete-expired-certificates.patch
	luarocks --tree=rocks install upcache 0.9.4
	curl -L https://github.com/openresty/lua-resty-lock/archive/v0.07.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-core/archive/v0.1.12.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --wildcards '*/lib/ngx/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-lrucache/archive/v0.07.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	luarocks --tree=rocks install nginx-lua-prometheus


nginx/mime.types:
	cd nginx && ln -sf /etc/nginx/mime.types .

leclean:
	rm -rf autossl/storage
	rm -rf autossl/letsencrypt/certs
	rm -rf autossl/letsencrypt/accounts
