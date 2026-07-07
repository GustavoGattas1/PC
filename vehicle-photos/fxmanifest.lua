fx_version "bodacious"
game "gta5"
lua54 "yes"

name "vehicle-photos"
author "Creative Uncharted"
description "Estúdio automático de fotos de veículos para NUI — 16:9, fundo escuro, ângulo 3/4"
version "1.0.3"

shared_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua",
	"shared/*.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server.lua"
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/app.js"
}

dependency "vrp"

-- Descomente se tiver screenshot-basic instalado (recomendado):
-- dependency "screenshot-basic"

exports {
	"CaptureVehicle",
	"IsCapturing"
}
