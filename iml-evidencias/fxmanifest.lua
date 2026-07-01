fx_version "bodacious"
game "gta5"
lua54 "yes"

name "iml-evidencias"
author "Creative Uncharted"
description "Sistema avançado de IML e evidências forenses"
version "2.2.1"

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
	"client/minigames.lua",
	"client/collection.lua",
	"client/nui.lua",
	"client/target.lua",
	"client/scene.lua",
	"client/vehicles.lua",
	"client/forensics.lua",
	"client/tablet.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server/database.lua",
	"server/weapons.lua",
	"server/death.lua",
	"server/cases.lua",
	"server/items.lua",
	"server/main.lua"
}

ui_page "web/index.html"

files {
	"web/index.html",
	"web/css/style.css",
	"web/js/app.js"
}

dependency "vrp"

server_exports {
	"UseItem",
	"UseLuvas",
	"UseTablet",
	"UseLaudo",
	"UseMarcador"
}

exports {
	"UseItem",
	"UseLuvas",
	"UseTablet",
	"UseLaudo"
}
