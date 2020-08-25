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
	apt install -y openssh-server mysql-client smartmontools wget curl nano zip unzip sed file libncurses5-dev libncursesw5-dev libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf software-properties-common proftpd screen php htop build-essential make cmake scons gcc g++ pkg-config curl autoconf autogen automake ipset kmod procps traceroute firehol firehol-tools crontab

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

#SSH hardening
	UNTVer=$(lsb_release -ar 2>/dev/null | grep -i release | cut -s -f2)

	if [[ $UNTVer == "20.04" ]]
	then
		rm /etc/ssh/ssh_host_*

		ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""

		ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

		awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe

		mv /etc/ssh/moduli.safe /etc/ssh/moduli
		sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config
		echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com" > /etc/ssh/sshd_config.d/ssh-audit_hardening.conf
		service ssh restart
	elif [[ $UNTVer == "18.04" ]]
	then
		rm /etc/ssh/ssh_host_*

		ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""

		ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

		awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe

		mv /etc/ssh/moduli.safe /etc/ssh/moduli
		sed -i 's/^HostKey \/etc\/ssh\/ssh_host_\(dsa\|ecdsa\)_key$/\#HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config
		echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com" >> /etc/ssh/sshd_config
		service ssh restart
	else
		echo "You don't have Ubuntu 18.04 or 20.04 SSH hardening won't be executed"
	fi
	
#Firehol with public ban lists (added in crontab as well)
	echo "        server all accept" >> /etc/firehol/firehol.conf
	update-ipsets enable feodo palevo sslbl zeus_badips dshield spamhaus_drop spamhaus_edrop openbl blocklist_de bi_ssh-ddos_0_1d bi_ssh-ddos_2_30d bi_ssh_0_1d bi_ssh_1_7d bi_ssh_2_30d bi_sshd_0_1d bi_wordpress_0_1d bi_wordpress_1_7d bi_wordpress_2_30d firehol_level1 firehol_level2 firehol_level3 dshield_top_1000 bruteforceblocker malc0de ransomware_rw greensnow myip fullbogons
	update-ipsets -s
	
	crontab -l > /tmp/tmpcron
	echo "*/9 * * * * root update-ipsets -s >/dev/null 2>&1" >> /tmp/tmpcron
	crontab /tmp/tmpcron
	rm /tmp/tmpcron
	
	
#Select the best mirror on ubuntu
#	apt install 'python(3?)-bs4$' -y
#	wget https://github.com/brodock/apt-select/releases/download/0.1.0/apt-select_0.1.0-0_all.deb
#	dpkg -i apt-select_0.1.0-0_all.deb
#	apt-select
#	mv sources.list /etc/apt/sources.list
