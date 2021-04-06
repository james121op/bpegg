#!/bin/bash
cd /home/container

#Server Update
function StartUp() {
    echo "StartUp()"
    mkdir /home/container/tmp/
    mkdir /home/container/tmp/filesafe/
    cd /home/container/tmp/
    curl https://brokeprotocol.com/version -o serverversion
    serverversion=$(cat serverversion)
    if [ -f localversion ]; then
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
    rm -rf localversion
    curl https://brokeprotocol.com/version -o localversion
    cd ..
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -o bp.tar.gz
    # backup files
    cp Maps tmp/filesafe
    cp www tmp/filesafe
    cp Plugins tmp/filesafe
    cp server_info.txt tmp/filesafe
    cp announcements.txt tmp/filesafe
    cp groups.json tmp/filesafe
    cp settings.json tmp/filesafe
    cp skins.txt tmp/filesafe
    cp whitelist.txt tmp/filesafe
    cp npc_names.txt tmp/filesafe
    tar xvzf bp.tar.gz
    rm -rf bp.tar.gz
    #put files back (not plugins they need to be updated)
    cp tmp/filesafe/Maps .
    cp tmp/filesafe/www .
    cp tmp/filesafe/server_info.txt .
    cp tmp/filesafe/announcements.txt .
    cp tmp/filesafe/groups.json .
    cp tmp/filesafe/settings.json .
    cp tmp/filesafe/skins.txt .
    cp tmp/filesafe/whitelist.txt .
    cp tmp/filesafe/npc_names.txt .
    echo "done"
    echo "you might need to update settings.json"
    sleep 5
    Done
}
function FirstTimeSetup() {
    echo "FirstTimeSetup()"
    cd /home/container/tmp/
    curl https://brokeprotocol.com/version -o localversion
    cd ..
    curl https://brokeprotocol.com/wp-content/uploads/game.tar.gz -o bp.tar.gz
    tar xvzf bp.tar.gz
    rm -rf bp.tar.gz
    Done
}
function Done() {
    echo "Done()"
    cd /home/container
    chmod +x *
    # Replace Startup Variables
    MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
    echo "${MODIFIED_STARTUP}"

    # Run the Server  
    eval ${MODIFIED_STARTUP}
}
StartUp
