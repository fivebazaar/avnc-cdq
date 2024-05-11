fx_version 'cerulean'
game 'gta5'
description 'avnc-cdq'
version '1.0'
author 'Akyolm383'


client_scripts {
    "client.lua",
}
 
server_scripts {
    "server.lua",
    '@oxmysql/lib/MySQL.lua'
}

shared_scripts {
    "config.lua",
    "@qb-policejob/config.lua",
    '@ox_lib/init.lua'
}

files {
    'locales/*.json'
}

dependency {
    'oxmysql',
}

lua54 'yes'
