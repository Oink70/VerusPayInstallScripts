#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
#Get variables and user input
clear
echo "     =========================================================="
echo "     |   WELCOME TO THE VERUSCHAINTOOLS UPDATE UTILITY!       |"
echo "     |                                                        |"
echo "     |                                                        |"
echo "     |  Updater Only (This will NOT update daemons)           |"
echo "     |                                                        |"
echo "     |  This updater will update Verus Chain Tools only, not  |"
echo "     |  your wallet daemons or VerusPay. This is a simple     |"
echo "     |  update script for veruschaintools index.php file.     |"
echo "     |                                                        |"
echo "     |     Press any key to continue or CTRL-Z to Abort       |"
echo "     |                                                        |"
echo "     |                                                        |"
echo "     =========================================================="
read anykeyone
clear
echo ""
echo "     *** WARNING: Before continuing please disable your VerusPay plugin in your WooCommerce store, so your shoppers don't run into any strange errors. This script will wait for you to verify you've done this."
echo ""
echo "         Press any key when ready to proceed"
read anykeytwo
clear
export rootpath="$(sudo find /var/www -type d -name 'veruschaintools')"
echo "It appears your VerusChainTools are installed at $rootpath"
echo "if that is incorrect, press CTRL-Z to end this script."
echo ""
echo ""
sleep 10
echo ""
echo "Downloading and replacing latest version of Verus Chain Tools..."
echo ""
echo ""
sleep 3
mkdir /tmp/veruspayupdate
cd /tmp/veruspayupdate
wget https://github.com/joliverwestbrook/VerusChainTools/archive/master.zip
unzip master.zip
sudo rm $rootpath/index.php
sudo mv /tmp/veruspayupdate/VerusChainTools-master/index.php $rootpath
clear
echo "Update Complete!"
echo ""
echo ""
rm /tmp/veruspayupdate -r