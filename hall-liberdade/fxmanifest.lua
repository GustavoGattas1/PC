fx_version 'cerulean'

game 'gta5'

author 'Hall Liberdade'
description 'Sistema de controle de palco, telões, luzes e mídia para eventos'
version '1.0.0'

lua54 'yes'

files {
    'client/ui/index.html',
    'client/ui/javascript/**/*.js',
    'client/ui/images/**/*.svg',
    'client/ui/images/**/*.png',
    'client/ui/css/**/*.css',
    'client/ui/fonts/**/*.woff2',
    'client/dui/index.html',
    'client/dui/images/**/*.png',
    'client/dui/javascript/**/*.js'
}

ui_page 'client/ui/index.html'

shared_scripts {
    'enums.lua',
    'helpers.lua',
    'config.lua'
}

client_scripts {
    'client/core.lua',
    'integration/client.lua',
    'integration/scenes/*.lua'
}

server_scripts {
    'server/core.lua',
    'integration/server.lua'
}

escrow_ignore {
    'config.lua',
    'enums.lua',
    'integration/server.lua',
    'integration/client.lua',
    'integration/scenes/*.lua',
    'client/ui/**/*.js',
    'client/ui/**/*.css',
    'client/ui/**/*.html',
    'client/dui/**/*.js'
}

dependency 'hall-liberdade-stream'
dependency '/onesync'
dependency '/assetpacks'
