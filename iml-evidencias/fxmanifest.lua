fx_version "bodacious"
game "gta5"
lua54 "yes"

name "iml-evidencias"
author "Creative Uncharted"
description "Sistema completo de IML e evidências forenses"
version "1.1.0"

shared_scripts {
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
	"config.lua",
	"shared/*.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client/main.lua",
	"client/death.lua",
	"client/forensics.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
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
