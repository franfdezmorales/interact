fx_version 'cerulean'

version '1.0.0'

game 'gta5'

name 'interact'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    'shared/*.lua'
}

lua54 'yes'

ui_page "ui/dist/index.html"

files {
    "ui/dist/*.html",
    "ui/dist/assets/*.js",
    "ui/dist/assets/*.css",
}