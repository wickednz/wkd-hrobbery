-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'wickednz'
description 'Simple House robbery for QBCore'
version '2.0.0'

lua54 'yes'

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
    'locales/*.lua',
    '@ox_lib/init.lua'

}

dependencies {
    'PolyZone',
    'qb-target',
    'wkd-utils'
}

