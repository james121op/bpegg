#!/bin/bash
cd /home/container

# Attempt Server Update
mkdir /home/container/tmp/
cd /home/container/tmp/
echo "Downloading and extracting latest server release"
curl -L https://brokeprotocol.com/wp-content/uploads/game.tar.gz | tar -xzv
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
