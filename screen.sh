#!/bin/bash
# Made by Poli
if [ "$USER" = "root" ]; then
    apt install screen -y
    mkdir /home/temp
    cd /home/temp
    wget https://raw.githubusercontent.com/Poli-Systems/quick/master/install.sh
    chmod +x Install.sh
    screen ./Install.sh
    cd ..
    rm -r /home/temp
else
    echo "Run this script as root or using sudo in the front of it !"
fi
service ssh restart
echo "SSH service restarted you maybe need to reconnect"
echo "Script Finished"
