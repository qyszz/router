require("luci.sys")
require("luci.util")
require("luci.model.ipkg")

local uci = require "luci.model.uci".cursor()

local m, s

local running=(luci.sys.call("pidof filemanager > /dev/null") == 0)

local button = ""
local state_msg = ""
local trport = uci:get_first("filemanager", "config", "port") or 10080
local base_url = uci:get_first("filemanager", "config", "base_url") or "/cloud"

if running  then
	button = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"button\" value=\" " .. translate("Open Filemanager Web Interface") .. " \" onclick=\"window.open('http://'+window.location.hostname+':" .. trport .. "'+'".. base_url .. "')\"/>"
end

if running then
        state_msg = "<b><font color=\"green\">" .. translate("Filemanager running") .. "</font></b>"
else
        state_msg = "<b><font color=\"red\">" .. translate("Filemanager not running") .. "</font></b>"
end

m = Map("filemanager", "Filemanager", translate("Filemanager is a simple web base file-manager, here you can configure the settings.") .. button
        .. "<br/><br/>" .. translate("Filemanager Run Status").. " : "  .. state_msg .. "<br/>")
        
s = m:section(TypedSection, "filemanager", "")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enabled", translate("Enable"))
enable.rmempty = false

port=s:option(Value, "port", translate("listen port"))
base_url=s:option(Value, "base_url", translate("base url"))
config_dir=s:option(Value, "database", translate("database directory"))
scope_dir=s:option(Value, "scope", translate("scope directory"))

return m
