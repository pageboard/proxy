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
		pem.key = ssl.priv_key_pem_to_der(file:read("*a"))
		file:close()
		file = nil
	end
	local fullDer
	file, err = io.open(dir .. "/fullchain.pem", "r")
	if err then
		ngx.log(ngx.ERR, err)
		return
	else
		pem.full = ssl.cert_pem_to_der(file:read("*a"))
		file:close()
		file = nil
	end
	return pem
end

return module
