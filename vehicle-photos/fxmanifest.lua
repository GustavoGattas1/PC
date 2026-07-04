fx_version "cerulean"
game "gta5"
lua54 "yes"

name "vehicle-photos"
author "Creative Uncharted"
description "Estúdio automático de fotos de veículos — PNG 16:9 para NUI"
version "2.0.0"

shared_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"client.lua"
}

server_scripts {
	"server.lua"
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/app.js",
	"vehicles.txt"
}

dependency "vrp"

exports {
	"CaptureVehicle",
	"IsCapturing"
}
