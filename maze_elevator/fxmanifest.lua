fx_version "bodacious"
game "gta5"
lua54 "yes"

name "maze_elevator"
author "Creative Uncharted"
description "Sistema completo de elevadores com NUI moderna — Creative/vRP"
version "1.0.0"

shared_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua"
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
	"html/style.css",
	"html/app.js",
	"html/sounds/*.mp3",
	"html/images/*"
}

dependency "vrp"

exports {
	"OpenElevator"
}

server_exports {
	"OpenElevatorForPlayer"
}
