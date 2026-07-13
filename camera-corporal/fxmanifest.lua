fx_version "bodacious"
game "gta5"
lua54 "yes"

name "camera-corporal"
author "Creative Uncharted"
description "Sistema profissional de câmera corporal policial — gravação, bookmarks, painel de revisão e logs forenses"
version "2.0.0"

shared_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua",
	"shared/*.lua"
}

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client/prop.lua",
	"client/hud.lua",
	"client/camera.lua",
	"client/live.lua",
	"client/playback.lua",
	"client/nui.lua",
	"client/main.lua"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server/database.lua",
	"server/bridge.lua",
	"server/main.lua",
	"server/live.lua"
}

ui_page "web/index.html"

files {
	"web/index.html",
	"web/css/style.css",
	"web/js/app.js"
}

dependency "vrp"

server_exports {
	"IsRecording",
	"GetActiveSession",
	"ForceStopRecording"
}

exports {
	"IsBodycamActive",
	"IsRecording",
	"GetSessionId"
}
