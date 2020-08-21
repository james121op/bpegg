#!/bin/bash
cd /home/container

# Attempt Server Update
mkdir /home/container/tmp/
echo "Downloading latest server release"
wget --no-check-certificate https://brokeprotocol.com/wp-content/uploads/game.tar.gz -O /home/container/tmp/game.tar.gz
echo "Download complete"
echo "Extracting files and overwriting existing files"
tar -zxvf /home/container/tmp/game.tar.gz -C /home/container/tmp/
rsync -avh --exclude "settings.json" --exclude "Maps" --exclude "game.tar.gz" /home/container/tmp/ /home/container/
echo "Update completed"
echo "Cleaning up temporary files"
rm -rf /home/container/tmp/
echo "Resuming boot sequence"

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo "${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
