fx_version "cerulean"
game "gta5"
lua54 "yes"

name "iml-evidencias"
author "Creative Uncharted"
description "Sistema completo de IML e evidências forenses"
version "1.0.0"

shared_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"shared/*.lua"
}

client_scripts {
	"client/main.lua",
	"client/death.lua",
	"client/forensics.lua"
}

server_scripts {
	"server/database.lua",
	"server/weapons.lua",
	"server/death.lua",
	"server/main.lua"
}

ui_page "web/index.html"

files {
	"web/index.html",
	"web/css/style.css",
	"web/js/app.js"
}

dependency "vrp"
