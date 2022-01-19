#!/bin/bash

#Server Update
function StartUp() {
    clear
    echo "StartUp()"
    cd /home/container/tmp
    if [ -f localversion ]; then
        Update
    else
        FirstTimeSetup
    fi
    exit 0
}
function Update() {
    clear
    echo "Update()"
    echo "Info: This Could Take Some Time"
    #not currently being used (SoonTM)
    #BuildId=$(curl -sSL https://api.steamcmd.net/v1/info/696370 | jq -r '.data."696370".depots.branches.public.buildid')
    serverversion=$(curl -sSL https://brokeprotocol.com/version)
    localversion=$(cat localversion)
    if [ "$localversion" == "$serverversion" ]; then
        Done
    fi
    curl https://brokeprotocol.com/version -sSLo localversion
    cd /home/container/
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -sSLo bp.tar.gz
    # backup files
    cp -r {Maps,www,Plugins,server_info.txt,announcements.txt,groups.json,settings.json,videos.json,GameSource\ Jobs.json,skins.txt,whitelist.txt,npc_names.txt} /home/container/tmp/filesafe
    tar xzf bp.tar.gz
    rm -rf bp.tar.gz
    #put files back (not plugins they need to be updated)
    cp -r /home/container/tmp/filesafe/{Maps,www,server_info.txt,announcements.txt,groups.json,settings.json,videos.json,GameSource\ Jobs.json,skins.txt,whitelist.txt,npc_names.txt} /home/container
    Done
    exit 0
}
function FirstTimeSetup() {
    clear
    echo "FirstTimeSetup()"
    echo "Info: This Could Take Some Time"
    mkdir -p /home/container/tmp/filesafe/
    cd /home/container/tmp/
    curl https://brokeprotocol.com/version -sSLo localversion
    cd /home/container/
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -sSLo bp.tar.gz
    tar xzf bp.tar.gz
    rm -rf bp.tar.gz
    # jq doesn't support jsonc
    echo '{"serverName":"Unconfigured Server","map":"Default","URL":"","players":32,"hostName":"","port":5557,"maxTransferRate":1000000,"whitelist":false,"dayLength":1440,"difficulty":0.5,"startItems":[{"itemName":"Money","chance":1,"minCount":1000,"maxCount":1000},{"itemName":"SmartPhone1","chance":1,"minCount":1,"maxCount":1}],"cef":false,"announcements":{"enabled":true,"interval":120},"http":{"port":8080,"https":false,"internalHost":"*"},"database":{"path":"users.db","connectionString":null}}' >settings.json
    echo "$(jq ".port = "${SERVER_PORT}"" settings.json)" >settings.json
    Done
    exit 0
}
function Done() {
    clear
    echo "Done()"
    cd /home/container
    chmod +x *
    # Replace Startup Variables
    MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
    echo "${MODIFIED_STARTUP}"
    touch /home/container/server.log
    ln -sf /proc/1/fd/1 /home/container/server.log
    eval ${MODIFIED_STARTUP}
}
StartUp
exit 0
