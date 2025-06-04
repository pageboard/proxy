install: luarocks luapatches nginx/mime.types nginx/temp nginx/logs lualnclean lualn

lualnclean:
	rm -f lua/upcache*

luarocks:
	luarocks --tree=rocks install upcache 2.7.0
	luarocks --tree=rocks install lua-toml 2.0
	luarocks --tree=rocks install lua-resty-http 0.17.2
	luarocks --tree=rocks install lua-resty-auto-ssl 0.13.1
	#luarocks --tree=rocks install luafilesystem 1.8.0
	#luarocks --tree=rocks install lua-cjson 2.1.0.6
	curl -L https://github.com/openresty/lua-resty-lock/archive/v0.09.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-lrucache/archive/v0.15.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	curl -L https://github.com/openresty/lua-resty-redis/archive/refs/tags/v0.32.tar.gz | \
		tar -C ./rocks/share/lua/5.1/ -x -v -z -f - \
			--wildcards '*/lib/resty/*' --strip-components 2
	echo "Run apt install lua-filesystem"
	echo "Run apt install lua-cjson"

lualn:
	rm -f rocks/share/lua/5.1/lib
	cd rocks/share/lua/5.1/ && ln -s ../../../../lib

luapatches:
	-patch --backup --forward --strip 1 --quiet --reject-file - < patches/autossl-otf.patch

nginx/mime.types:
	cd nginx && ln -sf /etc/nginx/mime.types .

nginx/temp:
	mkdir -p nginx/temp

nginx/logs:
	mkdir -p nginx/logs

leclean:
	rm -rf autossl/storage
	rm -rf autossl/letsencrypt/certs
	rm -rf autossl/letsencrypt/accounts

