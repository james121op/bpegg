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
    curl https://brokeprotocol.com/version -so serverversion
    serverversion=$(cat serverversion)
    localversion=$(cat localversion)
    if [ $localversion == $serverversion ]; then
        echo "Server Version=$serverversion"
        echo "Local Version=$localversion"
        echo "No New Version"
        Done
    fi
    rm -rf localversion
    curl https://brokeprotocol.com/version -so localversion
    cd /home/container/
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -so bp.tar.gz
    # backup files
    cp -r Maps tmp/filesafe
    cp -r www tmp/filesafe
    cp -r Plugins tmp/filesafe
    cp server_info.txt tmp/filesafe
    cp announcements.txt tmp/filesafe
    cp groups.json tmp/filesafe
    cp settings.json tmp/filesafe
    cp skins.txt tmp/filesafe
    cp whitelist.txt tmp/filesafe
    cp npc_names.txt tmp/filesafe
    tar xzf bp.tar.gz
    rm -rf bp.tar.gz
    #put files back (not plugins they need to be updated)
    cp -r tmp/filesafe/Maps .
    cp -r tmp/filesafe/www .
    cp tmp/filesafe/server_info.txt .
    cp tmp/filesafe/announcements.txt .
    cp tmp/filesafe/groups.json .
    cp tmp/filesafe/settings.json .
    cp tmp/filesafe/skins.txt .
    cp tmp/filesafe/whitelist.txt .
    cp tmp/filesafe/npc_names.txt .
    Done
    exit 0
}
function FirstTimeSetup() {
    clear
    echo "FirstTimeSetup()"
    echo "Info: This Could Take Some Time"
    mkdir -p /home/container/tmp/filesafe/
    cd /home/container/tmp/
    curl https://brokeprotocol.com/version -so serverversion
    curl https://brokeprotocol.com/version -so localversion
    cd /home/container/
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -so bp.tar.gz
    tar xzf bp.tar.gz
    rm -rf bp.tar.gz
    Done
    exit 0
}
function Done() {
    clear
    echo "Done()"
    cd /home/container
    chmod +x *
    # Replace Startup Variables
    MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
    echo "${MODIFIED_STARTUP}"
    timeout 1
    clear
    # Run the Server  
    eval ${MODIFIED_STARTUP}
}
StartUp
exit 0
