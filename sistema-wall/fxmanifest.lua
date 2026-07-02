fx_version "bodacious"
game "gta5"
lua54 "yes"

name "sistema-wall"
author "Creative Uncharted"
description "Sistema completo de Wall (ESP) para staff — informações de jogadores em tempo real"
version "1.0.3"

shared_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua",
	"shared/*.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client/main.lua",
	"client/render.lua",
	"client/vehicles.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server/bridge.lua",
	"server/main.lua"
}

dependency "vrp"
