#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
#Get variables and user input
clear
echo "     =========================================================="
echo "     |                        WELCOME                         |"
echo "     |                                                        |"
echo "     |     Press any key to continue or CTRL-Z to Abort       |"
echo "     |                                                        |"
echo "     |                                                        |"
echo "     =========================================================="
read anykeyone
clear
echo "Getting daemon paths..."
rootpath="$(sudo find /var/www -type d -name 'veruschaintools')"
vrsc="$(sudo find /opt -type d -name 'verus')"
arrr="$(sudo find /opt -type d -name 'pirate')"
kmd="$(sudo find /opt -type d -name 'komodo')"
echo "Please verify the following are your installed daemons:"
echo ""
echo $vrsc
echo $arrr
echo $kmd
echo ""
echo "Are the above correct? (press any key to continue or CTRL-Z to quit)"
read anykeytwo
tempuser=`cat $vrsc/VRSC.conf | grep "rpcuser"`
    rpcuser=${tempuser#"rpcuser="}
temppass=`cat $vrsc/VRSC.conf | grep "rpcpassword"`
    rpcpass=${temppass#"rpcpassword="}
[ "$plength" == "" ] && plength=66
access="v036"$(tr -dc A-Za-z0-9 < /dev/urandom | head -c ${plength} | xargs)
        echo "Carefully enter a valid KMD Transparent address, where you'll receive Transparent store cash outs (just press enter if you don't have one):"
        read kmd_t
        count_kmd_t=${#kmd_t}
                echo "Carefully enter a valid VRSC Transparent address, where you'll receive Transparent store cash outs (just press enter if you don't have one):"
        read vrsc_t
        count_vrsc_t=${#vrsc_t}
                echo "Carefully enter a valid VRSC Sapling address, where you'll receive Sapling store cash outs (just press enter if you don't have one):"
        read vrsc_z
        count_vrsc_z=${#vrsc_z}
                        echo "Carefully enter a valid ARRR Sapling address, where you'll receive Pirate Sapling store cash outs (just press enter if you don't have one):"
        read arrr_z
        count_arrr_z=${#arrr_z}
echo ""
echo "Please confirm the following cashout addresses are accurate and owned by YOU:"
echo ""
echo "Pirate:"
echo $arrr_z
echo ""
echo "Verus:"
echo $vrsc_t
echo $vrsc_z
echo ""
echo "Komodo:"
echo $kmd_t
echo ""
echo "Press any key to confirm or CTRL-Z to quit:"
read anykeythree

echo "Configuring Verus Chain Tools with your RPC, cashout addresses, and a new access code (will display at end of upgrade)..."
sudo mkdir /tmp/updateaddresses
cd /tmp/updateaddresses
sudo cat >veruschaintools_config.php <<EOL
<?php a:4:{s:6:"access";a:1:{s:4:"pass";s:70:"$access";}s:4:"vrsc";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"27486";s:5:"taddr";s:$count_vrsc_t:"$vrsc_t";s:5:"zaddr";s:$count_vrsc_z:"$vrsc_z";}s:4:"arrr";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"45453";s:5:"taddr";s:0:"";s:5:"zaddr";s:$count_arrr_z:"$arrr_z";}s:3:"kmd";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:4:"7771";s:5:"taddr";s:$count_kmd_t:"$kmd_t";s:5:"zaddr";s:0:"";}}
EOL
sudo mv /tmp/veruspayupgrade/veruschaintools_config.php $rootpath/veruschaintools_config.php
sudo chown -R www-data:www-data $rootpath
sudo chmod 755 -R $rootpath
clear
echo "Finished!"
echo ""
echo "Please once more confirm the following is accurate, and use the NEW ACCESS CODE in your VerusPay store:"
echo ""
echo "NEW ACCESS CODE:"
echo "$access"
echo ""
echo ""
echo "Pirate:"
echo $arrr_z
echo ""
echo "Verus:"
echo $vrsc_t
echo $vrsc_z
echo ""
echo "Komodo:"
echo $kmd_t
echo ""