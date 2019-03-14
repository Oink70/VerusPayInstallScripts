#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
#Get variables and user input
clear
echo "     =========================================================="
echo "     |   WELCOME TO THE VERUS CHAINTOOLS DAEMON INSTALLER!    |"
echo "     |                                                        |"
echo "     |  This installer will install Verus Chain Tools and     |"
echo "     |  the selected wallet daemons. This installer should be |"
echo "     |  used either on a dedicated remote wallet server or on |"
echo "     |  your WordPress-WooCommerce Store server.              |"
echo "     |                                                        |"
echo "     |  If you are installing on your store server, do so     |"
echo "     |  only AFTER you have installed WordPress.              |"
echo "     |                                                        |"
echo "     |  If you are installing on a dedicated wallet server,   |"
echo "     |  please note this installer is meant for a new server. |"
echo "     |  If this is not a new server or you already have a     |"
echo "     |  wallet daemon installed, please abort and contact us  |"
echo "     |  in the official VerusCoin Discord.  Othewise, just    |"
echo "     |  continue!                                             |"
echo "     |                                                        |"
echo "     |          Installer will begin in 30 seconds            |"
echo "     |                                                        |"
echo "     |            Press CTRL-Z Now to Abort                   |"
echo "     |                                                        |"
echo "     =========================================================="
echo ""
sleep 30
echo ""
shopt -s nocasematch
echo "Is this server a REMOTE WALLET server (not the same as your store server)?"
echo "(Yes or No):"
read whatserver
if [[ $whatserver == "no" ]] || [[ $whatserver == "n" ]];
then
    echo "Okay, we will configure this as the SAME SERVER of your"
    echo "VerusPay WooCommerce Store server."
    echo ""
    echo "Please enter the exact root directory path for your"
    echo "web server (e.g. /var/www/mysite.com/html - Note: NO TRAILING SLASH )"
    echo "and then press ENTER:"
    read rootpath
    export rootpath
    export domain="localhost"
    export remoteinstall=0
else
    echo "Okay, we will configure this as a REMOTE WALLET SERVER from your"
    echo "VerusPay WooCommerce Store server."
    export rootpath="/var/www/html"
    export domain="$( curl http://icanhazip.com )"
    export remoteinstall=1
fi
if [ "$remoteinstall" == "1" ];then
echo "Enter the IP address of your WooCommerce VerusPay store server"
echo "(e.g. 123.12.123.123):"
read iptoallow
echo ""
echo "Would you like this script to install a self-signed SSL certificate?"
echo "If you don't know how to do it yourself, answer with Yes: (Yes or No)"
read anscert
if [[ $anscert == "yes" ]] || [[ $anscert == "y" ]];
then
    export certresp=1
else
    export certresp=0
fi
else
    sleep 1
fi
echo "Install Wallet Daemons along with Verus Chain Tools? (Yes or No)"
read whatinstall
if [[ $whatinstall == "yes" ]] || [[ $whatinstall == "y" ]];
then
    export walletinstall=1
else
    export walletinstall=0
fi
if [ "$walletinstall" == "1" ];then
    echo "Install Pirate ARRR Daemon?"
    read arrrans
    if [[ $arrrans == "yes" ]] || [[ $arrrans == "y" ]];
    then
        export arrr=1
    else
        export arrr=0
    fi
    echo "Install Verus VRSC Daemon?"
    read vrscans
    if [[ $vrscans == "yes" ]] || [[ $vrscans == "y" ]];
    then
        export vrsc=1
    else
        export vrsc=0
    fi
else
    export vrsc=0
    export arrr=0
fi
if [[ $vrsc == "0" ]] && [[ $arrr == "0" ]];then
    echo "No Wallet Daemon Selected! It is recommended that you allow"
    echo "the script to install the store wallet daemons, otherwise"
    echo "you'll need to request help at the VerusCoin Official Discord"
    echo "for manual configuration."
    echo ""
    echo "If you didn't meant to do this and want to install one or all"
    echo "wallet daemons, simply start this script again after it breaks."
    break
else
    echo ""
    echo "Thank you. Beginning server configuration!"
    echo ""
fi
[ "$ulength" == "" ] && ulength=10
[ "$plength" == "" ] && plength=66
export rpcuser="user"$(tr -dc A-Za-z0-9 < /dev/urandom | head -c ${ulength} | xargs)
export rpcpass="pass"$(tr -dc A-Za-z0-9 < /dev/urandom | head -c ${plength} | xargs)
mkdir -p /tmp/veruspayinstall/veruschaintools
cd /tmp/veruspayinstall
wget https://veruspay.io/setup/veruschaintools.tar.xz
tar -xvf veruschaintools.tar.xz -C /tmp/veruspayinstall
chmod +x /tmp/veruspayinstall/veruschaintools/*.sh
if [ "$remoteinstall" == "1" ];then
sudo fallocate -l 4G /swapfile
echo "Setting up 4GB swap file..."
sleep 3
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bk
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
echo "vm.swappiness=40" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
clear
else
    clear
fi
echo "Installing some dependencies..."
sleep 1
sudo apt -qq update
sudo apt --yes -qq install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python python-zmq zlib1g-dev wget libcurl4-openssl-dev bsdmainutils automake curl screen
sudo apt -qq update
sudo apt -y -qq autoremove
if [ "$remoteinstall" == "1" ];then
clear
echo "Installing Apache..."
echo ""
echo ""
sleep 3
sudo apt -qq update
sudo apt -y -qq autoremove
sudo apt --yes -qq install curl wget apache2
sudo ufw allow OpenSSH
sudo ufw allow from $iptoallow to any port 443
echo "y" | sudo ufw enable
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
echo "ServerName $domain" | sudo tee -a /etc/apache2/apache2.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
sudo apt --yes -qq install php libapache2-mod-php
sudo rm /etc/apache2/mods-available/dir.conf
sudo touch /etc/apache2/mods-available/dir.conf
cd /tmp/veruspayinstall
cat >dir.conf <<EOL
<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOL
sudo mv /tmp/veruspayinstall/dir.conf /etc/apache2/mods-available/dir.conf
sudo systemctl restart apache2
sudo apt -qq update
sudo apt --yes -qq install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip expect
sudo systemctl restart apache2
if [ "$certresp" == "1" ];then
echo "Installing SSL..."
echo ""
sleep 3
cd /tmp/veruspayinstall
sudo -E /tmp/veruspayinstall/veruschaintools/self_cert.sh
cat >ssl-params.conf <<EOL
SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLHonorCipherOrder On
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
# Requires Apache >= 2.4
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
# Requires Apache >= 2.4.11
SSLSessionTickets Off
EOL
sudo mv /tmp/veruspayinstall/ssl-params.conf /etc/apache2/conf-available/ssl-params.conf
sudo cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
sudo rm /etc/apache2/sites-available/default-ssl.conf
cd /tmp/veruspayinstall
cat >default-ssl.conf <<EOL
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin your_email@example.com
                ServerName $domain

                DocumentRoot $rootpath

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on

                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>

        </VirtualHost>
</IfModule>
EOL
sudo mv /tmp/veruspayinstall/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
sudo a2enmod ssl
sudo a2enmod headers
sudo a2ensite default-ssl
sudo a2enconf ssl-params
sudo systemctl restart apache2
clear
else
    echo "Proceeding without SSL, either configure yourself or uncheck"
    echo "the SSL checkbox within VerusPay when you configure."
fi
else
clear
fi
echo "Downloading and unpacking Verus Chain Tools scripts..."
echo ""
echo ""
sleep 3
cd /tmp/veruspayinstall
sudo mv /tmp/veruspayinstall/veruschaintools/veruschaintools $rootpath/veruschaintools
sudo mv /tmp/veruspayinstall/veruschaintools /opt/veruschaintools
sudo chown -R $USER:$USER /opt/veruschaintools
clear
echo "Installing Verus Chain Tools..."
echo ""
echo ""
sleep 3
cd /tmp/veruspayinstall
cat >veruschaintools_config.php <<EOL
<?php a:2:{s:4:"vrsc";a:3:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"27486";}s:4:"arrr";a:3:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"45453";}}
EOL
sudo mv /tmp/veruspayinstall/veruschaintools_config.php $rootpath/veruschaintools/veruschaintools_config.php
sudo chown -R www-data:www-data $rootpath/veruschaintools
sudo chmod 755 -R $rootpath/veruschaintools
clear
if [ "$vrsc" == "1" ];then
echo "Downloading and unpacking latest Verus CLI release..."
echo "installing to: /opt/verus ..."
echo ""
echo ""
sleep 6
sudo mkdir -p /opt/verus
sudo chown -R $USER:$USER /opt/verus
cd /tmp/veruspayinstall
wget https://veruspay.io/setup/verus.tar.xz
tar -xvf verus.tar.xz -C /opt
chmod +x /opt/verus/*.sh
clear
echo "Fetching Zcash parameters if needed..."
echo ""
echo ""
sleep 3
/opt/verus/fetch-params
clear
echo "Downloading and unpacking VRSC bootstrap..."
echo "setting up configuration files..."
echo ""
echo ""
sleep 3
mkdir /opt/verus/VRSC
cd /tmp/veruspayinstall
wget https://bootstrap.0x03.services/veruscoin/VRSC-bootstrap.tar.gz
tar -xvf VRSC-bootstrap.tar.gz -C /opt/verus/VRSC
cat >/opt/verus/VRSC.conf <<EOL
rpcuser=$rpcuser
rpcpassword=$rpcpass
rpcport=27486
server=1
txindex=1
rpcworkqueue=256
rpcallowip=127.0.0.1
datadir=/opt/verus/VRSC
wallet=vrsc_store.dat
EOL
clear
echo "Starting new screen and running Verus daemon to begin Verus sync..."
echo ""
echo ""
sleep 6
screen -d -m /opt/verus/start.sh
echo "Installing cron job to run verusstat.sh script every 5 min"
echo "to check Verus daemon status and start if it stops..."
echo ""
echo ""
sleep 6
cd /tmp/veruspayinstall
crontab -l > tempveruscron
echo "*/5 * * * * /opt/veruschaintools/verusstat.sh" >> tempveruscron
crontab tempveruscron
rm tempveruscron
clear
vrscstat="Yes"
else
    vrscstat="No"
fi
if [ "$arrr" == "1" ];then
echo "Downloading and unpacking latest Pirate CLI release..."
echo "installing to: /opt/pirate ..."
echo ""
echo ""
sleep 6
sudo mkdir -p /opt/pirate
sudo chown -R $USER:$USER /opt/pirate
cd /tmp/veruspayinstall
wget https://veruspay.io/setup/pirate.tar.xz
tar -xvf pirate.tar.xz -C /opt
chmod +x /opt/pirate/*.sh
clear
echo "Fetching Zcash parameters if needed..."
echo ""
echo ""
sleep 3
/opt/pirate/fetch-params
clear
echo "Downloading and unpacking ARRR bootstrap..."
echo "setting up configuration file..."
echo ""
echo ""
sleep 3
mkdir /opt/pirate/ARRR
cd /tmp/veruspayinstall
wget https://bootstrap.0x03.services/pirate/ARRR-bootstrap.tar.gz
tar -xvf ARRR-bootstrap.tar.gz -C /opt/pirate/ARRR
cat >/opt/pirate/PIRATE.conf <<EOL
rpcuser=$rpcuser
rpcpassword=$rpcpass
rpcport=45453
server=1
txindex=1
rpcworkqueue=256
rpcallowip=127.0.0.1
datadir=/opt/pirate/ARRR
wallet=vrsc_store.dat
EOL
clear
echo "Starting new screen and running Pirate daemon to begin Pirate sync..."
echo ""
echo ""
sleep 6
screen -d -m /opt/pirate/start.sh
echo "Installing cron job to run piratestat.sh script every 5 min"
echo "to check Pirate daemon status and start if it stops..."
echo ""
echo ""
sleep 6
cd /tmp/veruspayinstall
crontab -l > temppiratecron
echo "*/5 * * * * /opt/veruschaintools/piratestat.sh" >> temppiratecron
crontab temppiratecron
rm temppiratecron
clear
arrrstat="Yes"
else
  arrrstat="No"
fi
clear
echo ""
echo " Cleaning Up...."
sleep 3
sudo rm /tmp/veruspayinstall -r
clear
echo ""
echo "     ====================================="
echo "     =           IMPORTANT!              ="
echo "     =  Below are your new credentials   ="
echo "     =  and details. Write down these    ="
echo "     =  details down in a secure place   ="
echo "     ====================================="
echo "                                          "
echo "       RPC Credentials for Both Chains:   "
echo "       ---------------------------------  "
echo "       RPC User: "$rpcuser
echo "       RPC Pass: "$rpcpass
echo "                                          "
echo "       ---------------------------------  "
echo "          Wallets Installed:              "
echo "       ---------------------------------  "
echo "       PIRATE ARRR: "$arrrstat
echo "       Verus VRSC:  "$vrscstat
echo "                                          "
echo "       Wallet IP (for VerusPay settings): "
echo "                                          "
echo "           $domain                        "
echo "                                          "
echo "     ====================================="
echo ""
