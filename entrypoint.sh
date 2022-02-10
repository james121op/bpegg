#!/bin/bash

#Server Update
function StartUp() {
    cd /home/container
    if [ -f tmp/localversion ]; then
        Update
    else
        FirstTimeSetup
    fi
    exit 0
}
function Update() {
    echo "Checking for updates."
    #not currently being used (SoonTM)
    #BuildId=$(curl -sSL https://api.steamcmd.net/v1/info/696370 | jq -r '.data."696370".depots.branches.public.buildid')
    serverversion=$(curl -sSL https://brokeprotocol.com/version)
    localversion=$(cat tmp/localversion)
    if [ "$localversion" == "$serverversion" ]; then
        echo "No update found."
        Done
    fi
    echo "Update found."
    curl https://brokeprotocol.com/version -sSLo tmp/localversion
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -sSLo bp.tar.gz
    # backup files
    cp -r {Maps,www,Plugins,server_info.txt,announcements.txt,groups.json,settings.json,videos.json,GameSource\ Jobs.json,skins.txt,whitelist.txt,npc_names.txt} tmp/filesafe
    tar xzf bp.tar.gz
    rm -rf bp.tar.gz
    cp -r tmp/filesafe/{Maps,www,server_info.txt,announcements.txt,groups.json,settings.json,videos.json,GameSource\ Jobs.json,skins.txt,whitelist.txt,npc_names.txt} .
    Done
    exit 0
}
function FirstTimeSetup() {
    mkdir -p tmp/filesafe
    curl https://brokeprotocol.com/version -sSLo tmp/localversion
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -sSLo bp.tar.gz
    tar xzf bp.tar.gz
    rm -rf bp.tar.gz
    #strip json comments
    echo "$(sed '\|//.*|d' settings.json)" >settings.json
    #change port
    echo "$(jq ".port = "${SERVER_PORT}"" settings.json)" >settings.json
    Done
    exit 0
}
function Done() {
    # Replace Startup Variables
    MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
    #pipes log file to /dev/stdout (unfortunately this locks the log file)
    ln -sf /dev/stdout server.log
    #start bp server
    eval ${MODIFIED_STARTUP}
}
StartUp
exit 0
