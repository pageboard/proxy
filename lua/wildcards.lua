local module = {}
local lfs = require "lfs"
local ssl = require "ngx.ssl"

module._VERSION = "0.1"

function module.init(root)
	local wildcards = {}
	for dir in lfs.dir(root) do
		if dir ~= "." and dir ~= ".." then
			local pems = readPems(root .. dir)
			if pems ~= nil then
				wildcards[dir] = pems
				ngx.log(ngx.WARN, "Wildcard certificate "..dir)
			end
		end
	end
	return wildcards
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
