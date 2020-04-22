#!/bin/bash
# Made by Poli
if [ "$USER" = "root" ]; then
    apt install screen -y
    mkdir /home/temp
    cd /home/temp
    wget --no-cache https://raw.githubusercontent.com/Poli-Systems/quick/master/install.sh
    screen bash install.sh
    cd ..
    rm -r /home/temp
else
    echo "Run this script as root or using sudo in the front of it !"
fi
rm -rf /home/temp
apt update
echo "Script Finished"
service ssh restart
echo "SSH service restarted you maybe need to reconnect"
