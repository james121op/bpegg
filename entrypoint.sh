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
        exit 0
    fi
    echo "Update found."
    curl https://brokeprotocol.com/version -sSLo tmp/localversion
    gdown '1iS2gE_stqMcd8eqqtwXjOmWXUc-IkFLy' -q -O bp.tar.gz
    # backup files
    cp -r {Maps,Plugins,server_info.txt,announcements.txt,groups.json,settings.json,videos.json,Classes.json,LifeSource\ Jobs.json,WarSource\ Jobs.json,skins.txt,whitelist.txt,npc_names.txt} tmp/filesafe
    tar xzf bp.tar.gz
    #remove useless files
    rm -rf {bp.tar.gz,start.sh,stop.sh,steam_appid.txt,.cache}
    cp -r tmp/filesafe/{Maps,server_info.txt,announcements.txt,groups.json,settings.json,videos.json,Classes.json,LifeSource\ Jobs.json,WarSource\ Jobs.json,skins.txt,whitelist.txt,npc_names.txt} .
    Done
    exit 0
}
function FirstTimeSetup() {
    mkdir -p tmp/filesafe
    curl https://brokeprotocol.com/version -sSLo tmp/localversion
    gdown '1iS2gE_stqMcd8eqqtwXjOmWXUc-IkFLy' -q -O bp.tar.gz
    tar xzf bp.tar.gz
    #remove useless files
    rm -rf {bp.tar.gz,start.sh,stop.sh,steam_appid.txt,.cache}
    #strip json comments
    sed -i '\,^[ \t]*//,d' settings.json
    #change port
    echo "$(jq ".port = "${SERVER_PORT}"" settings.json)" >settings.json
    Done
    exit 0
}
function Done() {
    # Replace Startup Variables
    MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
    #for people still using the old version of the egg
    if [ -f server.log ]; then
        ln -sf /dev/stdout server.log
    fi
    #start bp server
    eval ${MODIFIED_STARTUP}
}
StartUp
exit 0
