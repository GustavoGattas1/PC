fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Live Bodycam By Reza @BBS discord.gg/bbs — integrado vRP Creative Uncharted'

escrow_ignore {
  'config.lua',
  'Framework/*.lua',
  'items_reference.lua',
  'README.md'
}

shared_script {
  '@ox_lib/init.lua',
}

client_scripts {
  '@vrp/config/Native.lua',
  '@vrp/lib/Utils.lua',
  'Client/client.lua',
  'Framework/Client.lua'
}

server_scripts {
  '@vrp/lib/Utils.lua',
  'Server/server.js',
  'Server/server.lua',
  'Framework/Server.lua'
}

shared_script 'config.lua'

dependency 'ox_lib'
dependency 'vrp'

server_exports {
	'UseGovermentCam',
	'UseCommercialCam'
}

data_file 'DLC_ITYP_REQUEST' 'stream/bodycam_bbs_pc.ytyp'
ui_page 'html/streamer.html'

files { "module/*.js", "module/animation/tracks/*.js", "module/animation/*.js", "module/audio/*js",
  "module/cameras/*.js", "module/core/*.js", "module/extras/core/*.js", "module/extras/curves/*.js",
  "module/extras/objects/*.js", "module/extras/*.js", "module/geometries/*.js", "module/helpers/*.js",
  "module/lights/*.js", "module/loaders/*.js", "module/materials/*.js", "module/math/interpolants/*.js",
  "module/math/*.js", "module/objects/*.js", "module/renderers/shaders/*.js",
  "module/renderers/shaders/ShaderChunk/*.js", "module/renderers/shaders/ShaderLib/*.js",
  "module/renderers/webgl/*.js", "module/renderers/webvr/*.js",
  "module/renderers/*.js", "module/scenes/*.js", "module/textures/*.js", 'script.js' }

files {
  'html/*.html',
  'html/*.js',
  'html/*.png',
  'html/*.css',
  'html/fonts/**/*.*',
  'html/images/*.*',

}
dependency '/assetpacks'