#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
wget $(curl -s https://api.github.com/repos/joliverwestbrook/VerusPayInstallScripts/releases/latest | grep 'browser_' | cut -d\" -f4 )
tar -xvf veruspay_install_scripts.tar.xz
rm veruspay_chaintools_install.sh
rm veruspay_install_scripts.tar.xz
rm README.md
rm LICENSE
mkdir /tmp/veruspayupgrade
mv veruspay_scripts /tmp/veruspayupgrade/
chmod +x /tmp/veruspayupgrade/veruspay_scripts -R
#Get variables and user input
clear
echo "     =========================================================="
echo "     |   WELCOME TO THE VERUS CHAINTOOLS & DAEMON UPGRADER!   |"
echo "     |                             version 0.1.1              |"
echo "     |                                                        |"
echo "     |  Support for: Verus, Pirate, Komodo                    |"
echo "     |                                                        |"
echo "     |  This updater will update Verus Chain Tools and allow  |"
echo "     |  installation of newly supported wallet daemons. This  |"
echo "     |  upgrader should be used either on a dedicated remote  |"
echo "     |  wallet server or on your WooCommerce Store server.    |"
echo "     |                                                        |"
echo "     |  If you are upgrading on your store server, do so      |"
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
echo "Choose a wallet daemon upgrade mode:"
echo ""
echo "1) This server is a DEDICATED WALLET SERVER and is REMOTE FROM MY STORE"
echo "2) This server is THE SAME SERVER AS MY WOOCOMMERCE STORE"
echo ""
echo "Enter a number option (1 or 2) and press ENTER:"
read whatserver
if [ "$whatserver" == "1" ];then
    echo "Okay, we will now upgrade your REMOTE WALLET SERVER"
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
        echo ""
        echo ""
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
        echo ""
        echo ""
    fi
    export domain="localhost"
    export afterinst="Please Reboot This Server After Writing Down the Above Info"
    export remoteinstall=0
fi

if [ "$remoteinstall" == "1" ];then
    echo "Enter the IP address of your WooCommerce VerusPay store server"
    echo "(e.g. 123.12.123.123):"
    read iptoallow
    echo ""
    echo ""
    echo ""
else
    sleep 1
fi
echo "Before adding any new coins, let's upgrade what you have."
echo ""
echo ""
echo "Do You Have Verus Coin Installed? (Yes or No)"
read vrscupans
if [[ $vrscupans == "yes" ]] || [[ $vrscupans == "y" ]];then
    vrscupgrade=1
    echo ""
    echo "Now you need to enter valid VERUS wallet addresses YOU OWN which will be used to withdraw store funds."
    echo "To paste in the addresses within a Linux terminal right-click and paste, or SHIFT-CTRL-V."
    echo ""
    echo ""
    echo "Carefully enter a valid VRSC Transparent address, where you'll receive Transparent store cash outs:"
    read vrsc_t
    count_vrsc_t=${#vrsc_t}
    echo "Carefully enter a valid VRSC Sapling address, where you'll receive Sapling store cash outs:"
    read vrsc_z
    count_vrsc_z=${#vrsc_z}
    vrscname="VRSC: "
else
    vrscupgrade=0
fi
echo ""
echo ""
echo ""
echo "Do You Have PIRATE Installed? (Yes or No)"
read arrrupans
if [[ $arrrupans == "yes" ]] || [[ $arrrupans == "y" ]];then
    arrrupgrade=1
    echo ""
    echo "Now you need to enter valid PIRATE wallet addresses YOU OWN which will be used to withdraw store funds."
    echo "To paste in the addresses within a Linux terminal right-click and paste, or SHIFT-CTRL-V."
    echo ""
    echo ""
    echo "Carefully enter a valid ARRR Sapling address, where you'll receive store cash outs:"
    read arrr_z
    count_arrr_z=${#arrr_z}
    arrrname="ARRR: "
else
    arrrupgrade=0
fi
echo "Install Newly Available Wallet Daemons along with your Verus Chain Tools Upgrade? (Yes or No)"
read whatinstall
if [[ $whatinstall == "yes" ]] || [[ $whatinstall == "y" ]];then
    export walletinstall=1
    echo "We'll now ask about each available supported coin, if you already have it installed answer no (don't try to install it again)."
    echo ""
    echo ""
    sleep 3
else
    export walletinstall=0
fi
if [ "$walletinstall" == "1" ];then
    if [ "$vrscupgrade" == "0" ];then
        echo "Install Verus VRSC Daemon?"
        read vrscans
        if [[ $vrscans == "yes" ]] || [[ $vrscans == "y" ]];then
            export vrsc=1
        else
            export vrsc=0
        fi
        if [ "$vrsc" == "1" ];then
            echo ""
            echo "Now you need to enter valid VERUS wallet addresses YOU OWN which will be used to withdraw store funds."
            echo "To paste in the addresses within a Linux terminal right-click and paste, or SHIFT-CTRL-V."
            echo ""
            echo ""
            echo "Carefully enter a valid VRSC Transparent address, where you'll receive Transparent store cash outs:"
            read vrsc_t
            count_vrsc_t=${#vrsc_t}
            echo "Carefully enter a valid VRSC Sapling address, where you'll receive Sapling store cash outs:"
            read vrsc_z
            count_vrsc_z=${#vrsc_z}
            vrscname="VRSC: "
            vrscinsname="VRSC Verus"
        fi
    fi
    if [ "$arrrupgrade" == "0" ];then
        echo "Install Pirate ARRR Daemon?"
        read arrrans
        if [[ $arrrans == "yes" ]] || [[ $arrrans == "y" ]];then
            export arrr=1
        else
            export arrr=0
        fi
        if [ "$arrr" == "1" ];then
            echo ""
            echo "Now you need to enter valid PIRATE wallet addresses YOU OWN which will be used to withdraw store funds."
            echo "To paste in the addresses within a Linux terminal right-click and paste, or SHIFT-CTRL-V."
            echo ""
            echo ""
            echo "Carefully enter a valid ARRR Sapling address, where you'll receive store cash outs:"
            read arrr_z
            count_arrr_z=${#arrr_z}
            arrrname="ARRR: "
            arrrinsname="ARRR Pirate"
        fi
    fi
    echo "Install Komodo KMD Daemon?"
    read kmdans
    if [[ $kmdans == "yes" ]] || [[ $kmdans == "y" ]];then
        export kmd=1
        echo ""
        echo "Please note: the Komodo blockchain is VERY LARGE"
        echo "and you'll need a min of 20 GB free to install"
        echo "(10GB for the chain, 10GB for the bootstrap) after"
        echo "the install, only about 11 GB is used."
        echo ""
        echo "If you do not have enough disk space, it's recommended"
        echo "you exit now and increase your disk space avail."
        echo ""
        freespace=$(df --output=avail -h "$PWD" | sed '1d;s/[^0-9]//g')"GB"
        echo "It looks like you have $freespace available."
        echo ""
        echo "Do you want to continue? Have enough free space? (Yes or No)"
        read kmdhdspace
        if [[ $kmdhdspace == "no" ]] || [[ $kmdhdspace == "n" ]];then
            echo ""
            echo "Okay, exiting now..."
            sleep 3
            exit
        else
            echo ""
            echo "Okay, continuing..."
            echo ""
            sleep 2
        fi
    else
        export kmd=0
    fi
    if [ "$kmd" == "1" ];then
        echo ""
        echo "Now you need to enter valid KOMODO wallet addresses YOU OWN which will be used to withdraw store funds."
        echo "To paste in the addresses within a Linux terminal right-click and paste, or SHIFT-CTRL-V."
        echo ""
        echo ""
        echo "Carefully enter a valid KMD Transparent address, where you'll receive Transparent store cash outs:"
        read kmd_t
        count_kmd_t=${#kmd_t}
        echo "Carefully enter a valid KMD Sapling address, where you'll receive Sapling store cash outs:"
        read kmd_z
        count_kmd_z=${#kmd_z}
        kmdname="KMD: "
        kmdinsname="KMD Komodo"
    fi
else
    export vrsc=0
    export arrr=0
    export kmd=0
fi
if [[ $vrsc == "0" ]] && [[ $arrr == "0" ]] && [[ $kmd == "0" ]];then
    echo "No New Installations Selected. We will only upgrade what you already have installed."
    echo ""
    echo "Please CAREFULLY verify that the following"
    echo "RECEIVE addresses you entered for store cashouts"
    echo "are ABSOLUTELY CORRECT.  If not, cancel and"
    echo "restart this script."
    echo ""
    echo "      "$vrscname
    echo $vrsc_t
    echo $vrsc_z
    echo ""
    echo ""
    echo ""
    echo "      "$arrrname
    echo $arrr_z
    echo ""
    echo ""
    echo ""
    echo "      "$kmdname
    echo $kmd_t
    echo $kmd_z
    echo ""
    echo ""
    echo "Do the above addresses all look COMPLETELY ACCURATE? (Yes or No)"
    read confirmaddr
    if [[ $confirmaddr == "yes" ]] || [[ $confirmaddr == "y" ]];then
        echo "You have confirmed that the addresses you entered are accurate"
        echo "and that you own these and hold the private keys, and can access"
        echo "funds sent to them.  Remember, these are your cash-out addresses"
        echo "for when you cashout from your online store crypto. If you enter"
        echo "them incorrectly here, and can't actually get funds sent to them"
        echo "there is absolutely no way to recover crypto sent to them!!"
        echo ""
        echo "So let's just confirm ONCE more! Are you sure these are accurate"
        echo "and that the addresses accurately coincide with the coin as they"
        echo "show above? Addresses are below the coin heading. Confirm? (Yes or No)"
        read confirmaddragain
        if [[ $confirmaddragain == "yes" ]] || [[ $confirmaddragain == "y" ]];then
            echo ""
            echo "Okay! Let's continue..."
            sleep 3
        else
            echo ""
            echo ""
            echo "Okay, good thing we double-checked! This script will now end, you can"
            echo "start it again and try again :)"
            exit
        fi
    else
        echo ""
        echo ""
        echo "Okay, good thing we checked! This script will now end, you can"
        echo "start it again and try again :)"
        exit
    fi
else
    echo ""
    echo "Please CAREFULLY verify that the following"
    echo "RECEIVE addresses you entered for store cashouts"
    echo "are ABSOLUTELY CORRECT.  If not, cancel and"
    echo "restart this script."
    echo ""
    echo "      "$vrscname
    echo $vrsc_t
    echo $vrsc_z
    echo ""
    echo ""
    echo ""
    echo "      "$arrrname
    echo $arrr_z
    echo ""
    echo ""
    echo ""
    echo "      "$kmdname
    echo $kmd_t
    echo $kmd_z
    echo ""
    echo ""
    echo "Do the above addresses all look COMPLETELY ACCURATE? (Yes or No)"
    read confirmaddr
    if [[ $confirmaddr == "yes" ]] || [[ $confirmaddr == "y" ]];then
        echo "You have confirmed that the addresses you entered are accurate"
        echo "and that you own these and hold the private keys, and can access"
        echo "funds sent to them.  Remember, these are your cash-out addresses"
        echo "for when you cashout from your online store crypto. If you enter"
        echo "them incorrectly here, and can't actually get funds sent to them"
        echo "there is absolutely no way to recover crypto sent to them!!"
        echo ""
        echo "So let's just confirm ONCE more! Are you sure these are accurate"
        echo "and that the addresses accurately coincide with the coin as they"
        echo "show above? Addresses are below the coin heading. Confirm? (Yes or No)"
        read confirmaddragain
        if [[ $confirmaddragain == "yes" ]] || [[ $confirmaddragain == "y" ]];then
            echo ""
            echo "Okay! Let's continue..."
            sleep 3
        else
            echo ""
            echo ""
            echo "Okay, good thing we double-checked! This script will now end, you can"
            echo "start it again and try again :)"
            exit
        fi
    else
        echo ""
        echo ""
        echo "Okay, good thing we checked! This script will now end, you can"
        echo "start it again and try again :)"
        exit
    fi
    echo ""
    echo "Beginning Upgrade and new installation of the following:"
    echo ""
    echo $vrscinsname
    echo $arrrinsname
    echo $kmdinsname
    echo ""
    echo ""
fi
isvrsc="$(sudo find /opt -type d -name 'verus')"
isarrr="$(sudo find /opt -type d -name 'pirate')"
if [ -z "$isvrsc" ];then
    hasverus=0
else
    hasverus=1
fi
if [ "$hasverus" == "0" ];then
    if [ -z "$isarrr" ];then
        hasarrr=0
    else
        hasarrr=1
        sleep 1
        tempuser=`cat $isarrr/PIRATE.conf | grep "rpcuser"`
        export rpcuser=${tempuser#"rpcuser="}
        temppass=`cat $isarrr/PIRATE.conf | grep "rpcpassword"`
        export rpcpass=${temppass#"rpcpassword="}
    fi
else
    sleep 1
    tempuser=`cat $isvrsc/VRSC.conf | grep "rpcuser"`
    export rpcuser=${tempuser#"rpcuser="}
    temppass=`cat $isvrsc/VRSC.conf | grep "rpcpassword"`
    export rpcpass=${temppass#"rpcpassword="}
fi
if [[ $hasverus == "0" ]] && [[ $hasarrr == "0" ]];then
    echo "Can't find a pre-existing install of either Verus or Pirate!"
    echo ""
    echo "Exiting..."
    sleep 4
    exit
else
    echo ""
    echo "Using the same RPC user and password from previous installs"
    echo ""
    sleep 2
fi
clear
echo ""
echo "Performing upgrade of VerusChainTools and blockchain integration data..."
echo ""
echo ""
sleep 3
[ "$plength" == "" ] && plength=66
export access="v011"$(tr -dc A-Za-z0-9 < /dev/urandom | head -c ${plength} | xargs)
echo "Downloading and replacing latest version of Verus Chain Tools..."
echo ""
echo ""
sleep 3
cd /tmp/veruspayupgrade
wget https://github.com/joliverwestbrook/VerusChainTools/archive/master.zip
unzip master.zip
sudo rm $rootpath/*
sudo mv /tmp/veruspayupgrade/VerusChainTools-master/* $rootpath
clear
echo "Configuring Verus Chain Tools with your RPC, cashout addresses, and a new access code (will display at end of upgrade)..."
echo ""
echo ""
sleep 3
cd /tmp/veruspayupgrade
cat >veruschaintools_config.php <<EOL
<?php a:4:{s:6:"access";a:1:{s:4:"pass";s:70:"$access";}s:4:"vrsc";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"27486";s:5:"taddr";s:$count_vrsc_t:"$vrsc_t";s:5:"zaddr";s:$count_vrsc_z:"$vrsc_z";}s:4:"arrr";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"45453";s:5:"taddr";s:0:"";s:5:"zaddr";s:$count_arrr_z:"$arrr_z";}s:3:"kmd";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:4:"7771";s:5:"taddr";s:$count_kmd_t:"$kmd_t";s:5:"zaddr";s:$count_kmd_z:"$kmd_z";}}
EOL
sudo mv /tmp/veruspayupgrade/veruschaintools_config.php $rootpath/veruschaintools_config.php
sudo chown -R www-data:www-data $rootpath
sudo chmod 755 -R $rootpath
clear
echo ""
echo ""
if [ "$vrsc" == "1" ];then
    echo "Installing Verus. Getting latest Verus CLI release..."
    echo ""
    echo ""
    sleep 2
    echo "...Installing to: /opt/verus ..."
    echo ""
    echo ""
    sleep 6
    sudo mkdir -p /opt/verus
    sudo chown -R $USER:$USER /opt/verus
    mkdir /tmp/veruspayupgrade/verus
    cd /tmp/veruspayupgrade/verus
    wget $(curl -s https://api.github.com/repos/VerusCoin/VerusCoin/releases/latest | grep 'browser_' | grep -E 'Linux|linux' | grep -v 'sha256' | cut -d\" -f4 )
    tar -xvf *
    cd */
    mv * /opt/verus
    clear
    echo "Fetching Zcash parameters if needed..."
    echo ""
    echo ""
    sleep 3
    mv /tmp/veruspayupgrade/veruspay_scripts/officialsupportscripts/verus/* /opt/verus/
    chmod +x /opt/verus/*.sh
    /opt/verus/fetchparams.sh
    clear
    echo "Downloading and unpacking VRSC bootstrap..."
    echo ""
    sleep 2
    echo "...setting up configuration files..."
    echo ""
    echo ""
    sleep 3
    mkdir /opt/verus/VRSC
    cd /tmp/veruspayupgrade
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
    echo "Starting the Verus daemon in the background to begin Verus sync..."
    echo ""
    echo ""
    sleep 6
    screen -d -m /opt/verus/start.sh
    echo "Installing cron job to run verusstat.sh script every 5 min"
    echo "to check Verus daemon status and start if it stops..."
    echo ""
    echo ""
    sleep 6
    cd /tmp/veruspayupgrade
    crontab -l > tempveruscron
    echo "*/5 * * * * /opt/verus/verusstat.sh" >> tempveruscron
    crontab tempveruscron
    rm tempveruscron
    clear
    vrscstat="Yes"
else
    vrscstat="No"
fi
if [ "$arrr" == "1" ];then
    echo "Installing PIRATE. Getting latest Pirate CLI release..."
    echo ""
    echo ""
    sleep 2
    echo "...Installing to: /opt/pirate ..."
    echo ""
    echo ""
    sleep 6
    sudo mkdir -p /opt/pirate
    sudo chown -R $USER:$USER /opt/pirate
    mkdir /tmp/veruspayupgrade/pirate
    cd /tmp/veruspayupgrade/pirate
    wget $(curl -s https://api.github.com/repos/PirateNetwork/komodo/releases/latest | grep 'browser_' | grep -E 'Linux|linux' | grep -v 'sha256' | cut -d\" -f4 )
    tar -xvf *
    cd */
    mv * /opt/pirate
    clear
    echo "Fetching Zcash parameters if needed..."
    echo ""
    echo ""
    sleep 3
    mv /tmp/veruspayupgrade/veruspay_scripts/officialsupportscripts/pirate/* /opt/pirate/
    chmod +x /opt/pirate/*.sh
    /opt/pirate/fetchparams.sh
    clear
    echo "Downloading and unpacking ARRR bootstrap..."
    echo ""
    sleep 2
    echo "...setting up configuration file..."
    echo ""
    echo ""
    sleep 3
    mkdir /opt/pirate/ARRR
    cd /tmp/veruspayupgrade
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
    echo "Starting Pirate daemon in the background to begin Pirate sync..."
    echo ""
    echo ""
    sleep 6
    screen -d -m /opt/pirate/start.sh
    echo "Installing cron job to run piratestat.sh script every 5 min"
    echo "to check Pirate daemon status and start if it stops..."
    echo ""
    echo ""
    sleep 6
    cd /tmp/veruspayupgrade
    crontab -l > temppiratecron
    echo "*/5 * * * * /opt/pirate/piratestat.sh" >> temppiratecron
    crontab temppiratecron
    rm temppiratecron
    clear
    arrrstat="Yes"
else
    arrrstat="No"
fi
if [ "$kmd" == "1" ];then
    echo ""
    echo "Installing Komodo. Getting latest Komodo CLI release..."
    echo ""
    echo ""
    sleep 2
    echo "...Installing to: /opt/komodo ..."
    echo ""
    echo ""
    sleep 6
    sudo mkdir -p /opt/komodo
    sudo chown -R $USER:$USER /opt/komodo
    mkdir /tmp/veruspayupgrade/komodo
    cd /tmp/veruspayupgrade/komodo
    wget $(curl -s https://api.github.com/repos/KomodoPlatform/komodo/releases/latest | grep 'browser_' | grep -E 'Linux|linux' | grep -v 'sha256' | cut -d\" -f4 )
    tar -xvf *
    cd */
    mv * /opt/komodo
    clear
    echo "Fetching Zcash parameters if needed..."
    echo ""
    echo ""
    sleep 3
    mv /tmp/veruspayupgrade/veruspay_scripts/officialsupportscripts/komodo/* /opt/komodo/
    chmod +x /opt/komodo/*.sh
    /opt/komodo/fetchparams.sh
    clear
    echo "Downloading and unpacking KMD bootstrap..."
    echo ""
    sleep 2
    echo "...setting up configuration files..."
    echo ""
    echo ""
    sleep 3
    mkdir /opt/komodo/KMD
    cd /tmp/veruspayupgrade
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
    cd /tmp/veruspayupgrade
    crontab -l > tempkomodocron
    echo "*/5 * * * * /opt/komodo/komodostat.sh" >> tempkomodocron
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
sudo rm /tmp/veruspayupgrade -r
clear
echo ""
echo "     ======================================================"
echo "     =                     IMPORTANT!                     ="
echo "     =  Write down the following info in a secure place.  ="
echo "     ======================================================"
echo "    |                                                      |"
echo "    |  -------------------------------------------------   |"
echo "    |  RPC Credentials for Both Chains:                    |"
echo "    |  -------------------------------------------------   |"
echo "    |     RPC User: $rpcuser                               |"
echo "    |     RPC Pass: $rpcpass                               |"
echo "    |                                                      |"
echo "    |  -------------------------------------------------   |"
echo "    |   New Wallets Installed:                             |"
echo "    |   ------------------------------------------------   |"
echo "    |      PIRATE ARRR: $arrrstat                          |"
echo "    |      Verus VRSC:  $vrscstat                          |"
echo "    |      Komodo KMD:  $kmdstat                           |"
echo "    |                                                      |"
echo "    |   ------------------------------------------------   |"
echo "    |   VerusPay Plugin Setting Info:                      |"
echo "    |   ------------------------------------------------   |"
echo "    |      Wallet IP: $domain                              |"
echo "    |      Access Code:                                    |"
echo "    |      $access                                         |"
echo "     ======================================================"
echo ""
echo "     $afterinst"
echo ""
