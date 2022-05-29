fx_version 'cerulean'
game 'gta5'

description 'Drivers License point system.'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@qb-core/server/functions.lua',
    'server.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    '@qb-core/client/functions.lua'
}
