#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
#Get variables and user input
clear
echo "     =========================================================="
echo "     |   WELCOME TO THE VERUS CHAINTOOLS & DAEMON UPDATER!    |"
echo "     |                                                        |"
echo "     |  This updater will update Verus Chain Tools and allow  |"
echo "     |  installation of newly supported wallet daemons. This  |"
echo "     |  updater should be used either on a dedicated remote   |"
echo "     |  wallet server or on your WooCommerce Store server.    |"
echo "     |                                                        |"
echo "     |  If you are updating on your store server, do so       |"
echo "     |  only if you have previously installed on this server. |"
echo "     |                                                        |"
echo "     |  If you are installing on a dedicated wallet server,   |"
echo "     |  please note this updater is meant for servers which   |"
echo "     |  already have VerusChainTools and at least one daemon  |"
echo "     |  installed.  If this is not your config please abort   |"
echo "     |  and contact us in the VerusCoin Discord.              |"
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
echo "Choose a wallet daemon update mode:"
echo ""
echo "1) This server is a DEDICATED WALLET SERVER and is REMOTE FROM MY STORE"
echo "2) This server is THE SAME SERVER AS MY WOOCOMMERCE STORE"
echo ""
echo "Enter a number option (1 or 2) and press ENTER:"
read whatserver
if [ "$whatserver" == "1" ];then
    echo "Okay, we will now update your REMOTE WALLET SERVER"
    locwpconfig="$(sudo find /var/www -type d -name 'veruschaintools')"
    if [ -z "$locwpconfig" ];then
        echo "VerusChainTools not found! Exiting."
        exit
    else
        export rootpath="$(sudo find /var/www -type d -name 'veruschaintools')"
        export domain="$( curl http://icanhazip.com )"
        export remoteinstall=1
        echo "It appears your VerusChainTools are installed at $rootpath"
        echo "if that is incorrect, press CTRL-Z to end this script."
    fi
else
    echo "Okay, we will update the SAME SERVER of your store"
    locwpconfig="$(sudo find /var/www -type d -name 'veruschaintools')"
    if [ -z "$locwpconfig" ];then
        echo "VerusChainTools not found! Exiting."
        exit
    else
        export rootpath="$(sudo find /var/www -type d -name 'veruschaintools')"
        echo "It appears your VerusChainTools are installed at $rootpath"
        echo "if that is incorrect, press CTRL-Z to end this script."
    fi
    export domain="localhost"
    export afterinst="Please Reboot This Server After Writing Down the Above Info"
    export remoteinstall=0
fi
if [ "$remoteinstall" == "1" ];then
    echo "Enter the IP address of your WooCommerce VerusPay store server"
    echo "(e.g. 123.12.123.123):"
    read iptoallow
else
    sleep 1
fi
echo "Install Any New Wallet Daemons along with your Verus Chain Tools Update? (Yes or No)"
read whatinstall
if [[ $whatinstall == "yes" ]] || [[ $whatinstall == "y" ]];then
    export walletinstall=1
else
    export walletinstall=0
fi
if [ "$walletinstall" == "1" ];then
    isarrr="$(sudo find /opt -type d -name 'pirate')"
    if [ -z "$isarrr" ];then
        sleep 1
        tempuser=`cat $isarrr/PIRATE.conf | grep "rpcuser"`
        export rpcuser=${tempuser#"rpcuser="}
        temppass=`cat $isarrr/PIRATE.conf | grep "rpcpassword"`
        export rpcuser=${temppass#"rpcpassword="}
        echo "Carefully enter a valid ARRR Sapling address, where you'll receive store cash outs:"
        read arrr_z
    else
        echo "Install Pirate ARRR Daemon?"
        read arrrans
        if [[ $arrrans == "yes" ]] || [[ $arrrans == "y" ]];then
            export arrr=1
        else
            export arrr=0
        fi
        if [ "$arrr" == "1" ];
            echo "Carefully enter a valid ARRR Sapling address, where you'll receive store cash outs:"
            read arrr_z
        fi
    fi
    isvrsc="$(sudo find /opt -type d -name 'verus')"
    if [ -z "$isvrsc" ];then
        sleep 1
        tempuser=`cat $isvrsc/VRSC.conf | grep "rpcuser"`
        export rpcuser=${tempuser#"rpcuser="}
        temppass=`cat $isvrsc/VRSC.conf | grep "rpcpassword"`
        export rpcuser=${temppass#"rpcpassword="}
        echo "Carefully enter a valid VRSC Transparent address, where you'll receive Transparent store cash outs:"
        read vrsc_t
        echo "Carefully enter a valid VRSC Sapling address, where you'll receive Sapling store cash outs:"
        read vrsc_z
    else
        echo "Install Verus VRSC Daemon?"
        read vrscans
        if [[ $vrscans == "yes" ]] || [[ $vrscans == "y" ]];then
            export vrsc=1
        else
            export vrsc=0
        fi
        if [ "$vrsc" == "1" ];
            echo "Carefully enter a valid VRSC Transparent address, where you'll receive Transparent store cash outs:"
            read vrsc_t
            echo "Carefully enter a valid VRSC Sapling address, where you'll receive Sapling store cash outs:"
            read vrsc_z
        fi
    fi
    iskmd="$(sudo find /opt -type d -name 'komodo')"
    if [ -z "$iskmd" ];then
        sleep 1
        tempuser=`cat $iskmd/KMD.conf | grep "rpcuser"`
        export rpcuser=${tempuser#"rpcuser="}
        temppass=`cat $iskmd/KMD.conf | grep "rpcpassword"`
        export rpcuser=${temppass#"rpcpassword="}
        echo "Carefully enter a valid KMD Transparent address, where you'll receive Transparent store cash outs:"
        read kmd_t
        echo "Carefully enter a valid KMD Sapling address, where you'll receive Sapling store cash outs:"
        read kmd_z
    else
        echo "Install Komodo KMD Daemon?"
        read kmdans
        if [[ $kmdans == "yes" ]] || [[ $kmdans == "y" ]];then
            export kmd=1
        else
            export kmd=0
        fi
        if [ "$kmd" == "1" ];
            echo "Carefully enter a valid KMD Transparent address, where you'll receive Transparent store cash outs:"
            read kmd_t
            echo "Carefully enter a valid KMD Sapling address, where you'll receive Sapling store cash outs:"
            read kmd_z
        fi
    fi
else
    export vrsc=0
    export arrr=0
    export kmd=0
fi
if [[ $vrsc == "0" ]] && [[ $arrr == "0" ]] && [[ $kmd == "0" ]];then
    echo "No Wallet Daemon Selected, make sure you have at least one daemon running on your wallet server. Continuing..."
else
    echo ""
    echo "Beginning server configuration!"
    echo ""
fi
mkdir /tmp/veruspayupdate
clear
echo "Updating Verus Chain Tools..."
echo ""
echo ""
sleep 3
sudo apt update --yes
sudo apt install unzip --yes
cd /tmp/veruspayupdate
wget https://github.com/joliverwestbrook/VerusChainTools/archive/master.zip
unzip master.zip
sudo rm $rootpath/*
sudo mv /tmp/veruspayupdate/VerusChainTools-master $rootpath/
cat >veruschaintools_config.php <<EOL
<?php {"vrsc":{"rpc_user":"$rpcuser","rpc_pass":"$rpcpass","port":"27486","taddr":"$vrsc_t","zaddr":"$vrsc_z"},"arrr":{"rpc_user":"$rpcuser","rpc_pass":"$rpcpass","port":"45453","taddr":"$arrr_t","zaddr":"$arrr_z"},"kmd":{"rpc_user":"$rpcuser","rpc_pass":"$rpcpass","port":"7771","taddr":"$kmd_t","zaddr":"$kmd_z"}}
EOL
sudo mv /tmp/veruspayupdate/veruschaintools_config.php $rootpath/veruschaintools_config.php
sudo chown -R www-data:www-data $rootpath
sudo chmod 755 -R $rootpath
clear
if [ "$vrsc" == "1" ];then
    echo "Downloading and unpacking latest Verus CLI release..."
    echo "installing to: /opt/verus ..."
    echo ""
    echo ""
    sleep 6
    sudo mkdir -p /opt/verus
    sudo chown -R $USER:$USER /opt/verus
    cd /tmp/veruspayupdate
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
    cd /tmp/veruspayupdate
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
    cd /tmp/veruspayupdate
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
    cd /tmp/veruspayupdate
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
    cd /tmp/veruspayupdate
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
wallet=arrr_store.dat
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
    cd /tmp/veruspayupdate
    crontab -l > temppiratecron
    echo "*/5 * * * * /opt/veruschaintools/piratestat.sh" >> temppiratecron
    crontab temppiratecron
    rm temppiratecron
    clear
    arrrstat="Yes"
else
  arrrstat="No"
fi
if [ "$kmd" == "1" ];then
    echo "Downloading and unpacking latest Komodo CLI release..."
    echo "installing to: /opt/komodo ..."
    echo ""
    echo ""
    sleep 6
    sudo mkdir -p /opt/komodo
    sudo chown -R $USER:$USER /opt/komodo
    cd /tmp/veruspayupdate
    wget https://veruspay.io/setup/komodo.tar.xz
    tar -xvf komodo.tar.xz -C /opt
    chmod +x /opt/komodo/*.sh
    clear
    echo "Fetching Zcash parameters if needed..."
    echo ""
    echo ""
    sleep 3
    /opt/komodo/fetch-params
    clear
    echo "Downloading and unpacking KMD bootstrap..."
    echo "setting up configuration files..."
    echo ""
    echo ""
    sleep 3
    mkdir /opt/komodo/VRSC
    cd /tmp/veruspayupdate
    wget https://bootstrap.0x03.services/komodo/KMD-bootstrap.tar.gz
    tar -xvf KMD-bootstrap.tar.gz -C /opt/komodo/KMD
cat >/opt/komodo/KMD.conf <<EOL
rpcuser=$rpcuser
rpcpassword=$rpcpass
rpcport=7771
server=1
txindex=1
rpcworkqueue=256
rpcallowip=127.0.0.1
datadir=/opt/komodo/KMD
wallet=kmd_store.dat
EOL
    clear
    echo "Starting new screen and running Komodo daemon to begin Komodo sync..."
    echo ""
    echo ""
    sleep 6
    screen -d -m /opt/komodo/start.sh
    echo "Installing cron job to run komodostat.sh script every 5 min"
    echo "to check Komodo daemon status and start if it stops..."
    echo ""
    echo ""
    sleep 6
    cd /tmp/veruspayupdate
    crontab -l > tempkomodocron
    echo "*/5 * * * * /opt/veruschaintools/komodostat.sh" >> tempkomodocron
    crontab tempkomodocron
    rm tempkomodocron
    clear
    kmdstat="Yes"
else
    kmdstat="No"
fi
clear
echo ""
echo " Cleaning Up...."
sleep 3
sudo rm /tmp/veruspayupdate -r
clear
echo ""
echo "     ====================================="
echo "     =           IMPORTANT!              ="
echo "     =  Write down the following info    ="
echo "     =  in a secure place.               ="
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
echo "       Komodo KMD:  "$kmdstat
echo "                                          "
echo "       Wallet IP (for VerusPay settings): "
echo "                                          "
echo "           $domain                        "
echo "                                          "
echo "     ====================================="
echo ""
echo "     $afterinst"
echo ""
