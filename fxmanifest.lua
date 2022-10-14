-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'KZ-Modifications'
description 'Simple House robbery for QBCore'
version '1.0.0'

-- What to run
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'utils.lua',
    'client.lua',  
}
server_script 'server.lua'

shared_scripts {
    'config.lua',
}

dependencies {
    'PolyZone',
    'qb-target',
}

