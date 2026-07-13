-----------------------------------------------------------------------------------------------------------------------------------------
-- BBS BODYCAM — FXMANIFEST DA PONTE vRP
-- Use este manifest como referência ao integrar no fxmanifest.lua do bbs_bodycam.
-----------------------------------------------------------------------------------------------------------------------------------------
--[[
No fxmanifest.lua do bbs_bodycam, adicione ANTES dos scripts escrow:

dependency "vrp"
dependency "ox_lib"

shared_scripts {
	"@vrp/lib/Utils.lua",
	"bridge/vrp/config.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"bridge/vrp/bridge.lua",
	"bridge/vrp/server.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"bridge/vrp/client.lua"
}

No config.lua do BBS, defina o framework para vRP/custom e aponte para Framework.*
]]
