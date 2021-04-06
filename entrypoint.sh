#!/bin/bash
cd /home/container

#Server Update
function StartUp() {
    echo "StartUp()"
    mkdir /home/container/tmp/
    cd /home/container/tmp/
    mkdir filesafe
    curl https://brokeprotocol.com/version -o serverversion
    serverversion=$(cat serverversion)
    if [ -f LocalVersion ]; then
        Update
    else
        FirstTimeSetup
    fi
}
function Update() {
    echo "Update()"
    localversion=$(cat localversion)
    if [ $localversion == $serverversion ]; then
        echo "your already updated!"
        Done
    fi
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -o bp.tar.gz
    # backup files
    cp Maps filesafe
    cp www filesafe
    cp Plugins filesafe
    cp server_info.txt filesafe
    cp announcements.txt filesafe
    cp groups.json filesafe
    cp settings.json filesafe
    cp skins.txt filesafe
    cp whitelist.txt filesafe
    cp npc_names.txt filesafe
    tar xvzf bp.tar.gz
    rm -rf bp.tar.gz
    #put files back (not plugins they need to be updated)
    cp filesafe/Maps .
    cp filesafe/www .
    cp filesafe/server_info.txt .
    cp filesafe/announcements.txt .
    cp filesafe/groups.json .
    cp filesafe/settings.json .
    cp filesafe/skins.txt .
    cp filesafe/whitelist.txt .
    cp filesafe/npc_names.txt .
    echo "done"
    echo "you might need to update settings.json"
    sleep 5
    Done
}
function FirstTimeSetup() {
    echo "FirstTimeSetup()"
    curl https://brokeprotocol.com/version -o localversion
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -o bp.tar.gz
    tar xvzf bp.tar.gz
}
StartUp
function Done() {
    chmod +x *
    # Replace Startup Variables
    MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
    echo "${MODIFIED_STARTUP}"

    # Run the Server  
    eval ${MODIFIED_STARTUP}
}
