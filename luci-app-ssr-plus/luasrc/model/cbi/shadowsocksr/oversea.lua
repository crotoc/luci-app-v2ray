local fs = require "nixio.fs"
local conffile = "/etc/config/oversea.list"

f = SimpleForm("custom", translate("Oversea Custom List"), translate("Please refer to the following writing"))

t = f:field(TextValue, "conf")
t.rmempty = true
t.rows = 13
function t.cfgvalue()
	return fs.readfile(conffile) or ""
end

function f.handle(self, state, data)
	if state == FORM_VALID then
		if data.conf then
			fs.writefile(conffile, data.conf:gsub("\r\n", "\n"))
			luci.sys.call("bash /usr/share/shadowsocksr/oversea2ipset.sh >> /tmp/ssrpro.log 2>>/tmp/ssrerr.log  && /etc/init.d/dnsmasq restart")
		end
	end
	return true
end

return f
