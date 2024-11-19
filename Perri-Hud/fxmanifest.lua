fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'PerriTuber'
description 'https://discord.gg/nqY4QNrXv3'

-- TESTING JS WITHOUT JQUERY

client_scripts {
  'client/main.lua'
}

shared_scripts {
  '@es_extended/imports.lua',
  '@ox_lib/init.lua',
  'config.lua'
}

ui_page 'ui/index.html'

files {
  'ui/index.html',
  'ui/app.js',
  'ui/style.css',
  'ui/img/*.png',
}
