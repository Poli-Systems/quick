#!/bin/bash
# Made by Poli
echo "We do not recommand to run this script without knowing what it does. Strating now...."

#Updating, apply more time to keep alive ssh client and add the user root to the sudores
    apt install git openssh-server -y
    LINE='ClientAliveInterval 120'
    FILE="/etc/ssh/sshd_config"
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" >>"$FILE"
    LINE='ClientAliveCountMax 720'
    FILE="/etc/ssh/sshd_config"
    grep -qF -- "$LINE" "$FILE" || echo "$LINE" >>"$FILE"
    usermod -a -G sudo root

#Applying upgrade, dist-upgrades, adding the repo universe
	apt upgrade -y
	apt dist-upgrade -y
	add-apt-repository universe

#Installing a few packages
	apt install -y openssh-server mysql-client wget curl nano unzip sed file libncurses5-dev libncursesw5-dev libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf software-properties-common proftpd screen php htop build-essential make cmake scons make gcc g++ pkg-config curl

#Creating  an alias for ll instead of ls -l
        echo "alias ll='ls -l --color=auto'
        alias ls='ls --color=auto'" >> /etc/profile.d/00-aliases.sh

#Installing bash-it
        git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
        ~/.bash_it/install.sh -s

#Installing fail2ban and adding a custom jail for ssh
        apt install fail2ban -y
        wget -O /etc/fail2ban/jail.d/custom.conf https://raw.githubusercontent.com/IIPoliII/Install-Script-For-New-Servers/master/Script/Fail2Ban/custom.conf
        fail2ban-client reload
#Select the best mirror on ubuntu
	apt install 'python(3?)-bs4$' -y
	wget https://github.com/brodock/apt-select/releases/download/0.1.0/apt-select_0.1.0-0_all.deb
	dpkg -i apt-select_0.1.0-0_all.deb
	apt-select
	mv sources.list /etc/apt/sources.list
