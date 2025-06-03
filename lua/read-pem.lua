local module = {}
local ssl = require "ngx.ssl"

module._VERSION = "0.1"

function module.init(root)
	return readPems(root)
end

function readPems(dir)
	local pem = {}
	local file, err = io.open(dir .. "/privkey.pem", "r")
	if err then
		ngx.log(ngx.ERR, err)
		return
	else
		local keyPem = file:read("*a")
		file:close()
		file = nil
		pem.key = ssl.priv_key_pem_to_der(keyPem)
	end
	file, err = io.open(dir .. "/fullchain.pem", "r")
	if err then
		ngx.log(ngx.ERR, err)
		return
	else
		local certPem = file:read("*a")
		file:close()
		file = nil
		pem.full = ssl.cert_pem_to_der(certPem)
	end
	return pem
end

return module
