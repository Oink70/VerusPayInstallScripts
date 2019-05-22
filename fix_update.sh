#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
#Get variables and user input
echo ""
echo "     *** WARNING: Before continuing please disable your VerusPay plugin in your WooCommerce store, so your shoppers don't run into any strange errors. This script will wait for you to verify you've done this."
echo ""
echo "         Press any key when ready to proceed"
read anykeytwo
clear
shopt -s nocasematch
locwpconfig="$(sudo find /var/www -type d -name 'veruschaintools')"
if [ -z "$locwpconfig" ];then
    echo "VerusChainTools not found! Exiting."
    exit
else
    rootpath="$(sudo find /var/www -type d -name 'veruschaintools')"
    echo "It appears your VerusChainTools are installed at $rootpath"
    echo "if that is incorrect, press CTRL-Z to end this script."
    echo ""
    echo ""
fi
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
    count_vrsc_z=0
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
    count_arrr_z=0
fi
echo "Do You Have KMD Installed? (Yes or No)"
read kmdupans
if [[ $kmdupans == "yes" ]] || [[ $kmdupans == "y" ]];then
    kmdupgrade=1
    echo ""
    echo "Now you need to enter valid KOMODO wallet addresses YOU OWN which will be used to withdraw store funds."
    echo "To paste in the addresses within a Linux terminal right-click and paste, or SHIFT-CTRL-V."
    echo ""
    echo ""
    echo "Carefully enter a valid KMD Transparent address, where you'll receive Transparent store cash outs:"
    read kmd_t
    count_kmd_t=${#kmd_t}
    kmdname="KMD: "
else
    kmdupgrade=0
    count_kmd_t=0
fi
clear
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
echo ""
echo "Do the above addresses all look COMPLETELY ACCURATE? (Yes or No)"
read confirmaddr
if [[ $confirmaddr == "yes" ]] || [[ $confirmaddr == "y" ]];then
    clear
    echo "You have confirmed that the addresses you entered are accurate"
    echo "and that you own these and hold the private keys, and can access"
    echo "funds sent to them.  Remember, these are your cash-out addresses"
    echo "for when you cashout from your online store crypto. If you enter"
    echo "them incorrectly here, and can't actually get funds sent to them"
    echo "there is absolutely no way to recover crypto sent to them!!"
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
    echo ""
    echo "So let's just confirm ONCE more! Are you sure these are accurate"
    echo "and that the addresses accurately coincide with the coin as they"
    echo "show above? Addresses are below the coin heading. Confirm? (Yes or No)"
    read confirmaddragain
    if [[ $confirmaddragain == "yes" ]] || [[ $confirmaddragain == "y" ]];then
        echo ""
        echo "Okay! Continuing..."
        sleep 3
    else
        clear
        echo ""
        echo ""
        echo "Okay, good thing we double-checked! This script will now end, you can"
        echo "start it again and try again :)"
        exit
    fi
else
    clear
    echo ""
    echo ""
    echo "Okay, good thing we checked! This script will now end, you can"
    echo "start it again and try again :)"
    exit
fi
clear
echo ""
echo "Beginning Fix..."
echo ""
echo ""
u="$( cat /opt/verus/VRSC.conf | grep 'rpcuser=' )"
p="$( cat /opt/verus/VRSC.conf | grep 'rpcpassword=' )"
c="$( cat /opt/verus/VRSC.conf | grep 'rpcport=' )"
rpcpass=${p:12}
rpcuser=${u:8}
mkdir /tmp/veruspayupdate
cd /tmp/veruspayupdate
[ "$plength" == "" ] && plength=66
access="v012"$(tr -dc A-Za-z0-9 < /dev/urandom | head -c ${plength} | xargs)
cat >veruschaintools_config.php <<EOL
<?php a:4:{s:6:"access";a:1:{s:4:"pass";s:70:"$access";}s:4:"vrsc";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"27486";s:5:"taddr";s:$count_vrsc_t:"$vrsc_t";s:5:"zaddr";s:$count_vrsc_z:"$vrsc_z";}s:4:"arrr";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:5:"45453";s:5:"taddr";s:0:"";s:5:"zaddr";s:$count_arrr_z:"$arrr_z";}s:3:"kmd";a:5:{s:8:"rpc_user";s:14:"$rpcuser";s:8:"rpc_pass";s:70:"$rpcpass";s:4:"port";s:4:"7771";s:5:"taddr";s:$count_kmd_t:"$kmd_t";s:5:"zaddr";s:0:"";}}
EOL
sudo rm $rootpath/veruschaintools_config.php
sudo rm $rootpath/index.php
wget https://github.com/joliverwestbrook/VerusChainTools/archive/master.zip
unzip master.zip
sudo mv /tmp/veruspayupdate/VerusChainTools-master/index.php $rootpath
sudo mv /tmp/veruspayupdate/veruschaintools_config.php $rootpath
sudo chown -R www-data:www-data $rootpath
sudo chmod 755 -R $rootpath
echo ""
echo ""
echo "Update Fix is Complete"
echo ""
echo "Your new Access Code is: $access"
echo ""
rm /tmp/veruspayupdate -r