#!/bin/bash
cd /home/container

# Attempt Server Update
mkdir /home/container/tmp/
wget --no-check-certificate https://brokeprotocol.com/wp-content/uploads/game.tar.gz -O /home/container/tmp/game.tar.gz
tar -zxvf /home/container/tmp/game.tar.gz -C /home/container/tmp/
rsync -ah --exclude "settings.json" --exclude "Maps" --exclude "game.tar.gz" /home/container/tmp/ /home/container/
rm -rf /home/container/tmp/

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo "${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
