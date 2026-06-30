fx_version "bodacious"
game "gta5"
lua54 "yes"

name "loja-vip"
author "Creative Uncharted"
description "Loja VIP completa — veículos, casas, planos VIP e benefícios"
version "1.0.0"

shared_scripts {
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
	"config.lua",
	"shared/*.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client/main.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server/database.lua",
	"server/main.lua"
}

ui_page "web/index.html"

files {
	"web/index.html",
	"web/css/style.css",
	"web/js/app.js"
}

dependency "vrp"
