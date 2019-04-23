
# VerusPay Install Scripts and Configuration Instructions

Following this guide and with the accompanying easy scripts, you will be able to:

- Setup a new WordPress LAMP Server to use with WooCommerce as an online ecommerce store
- Install Verus Chain Tools and supported crypto wallet daemons on either your webstore or a remote, dedicated "wallet server"

You do not need expert knowledge to follow this guide or use the scripts.  All the necessary scripts found within this repository are released at the official VerusPay domain, https://veruspay.io, and linked to from this guide.

Setting up an online store that accepts cryptocurrency with NO THIRD PARTY PAYMENT processor is quick and easy following this guide.

It is recommended to run your online store and install your crypto wallet(s) on seperate servers.  If you choose to install everything on the same server, please make sure it's "beefy" enough to handle the processing load!  A min of 4GB of RAM and 2 vCPUs is recommended for a "same server" install.

### IMPORTANT: If you already have VerusPay version < 0.2.0 

If you previously setup VerusPay before this new release of version 0.2.0, please note these instructions DO NOT MIGRATE your previous Verus VRSC wallet. You will need to move this Verus wallet manually.  This installer will NOT overwrite the old wallet, so it IS SAFE TO CONTINUE as long as you DO NOT WIPE YOUR PREVIOUS STORE UNLESS YOU'VE BACKED UP YOUR PREVIOUS VERUS WALLET!!  

Contact John Westbrook on the official VerusCoin Discord for help with this backup process.


## Before you begin

Recommended Configuration:

- Store Server (recommended 1GB RAM min, VPS/Dedicated or Shared Hosting): This is the dedicated or shared-host server that will have your actual WordPress install, running WooCommerce with the VerusPay plugin enabled.
- Wallet Server(s) (recommended 2GB RAM min, VPS or Dedicated): This is a dedicated or VPS server that will have your crypto wallet(s) and be configured with Verus Chain Tools, a special script project that enables integration of blockchain and PHP scripting.  All necessary tools and even wallets are installed with a single script, following this guide.  You may want a single "Wallet Server" or a seperate server for each wallet...e.g. a Verus Wallet server and a Pirate Wallet server.  
- Offline Wallet (Personal computer or seperate server): This is for wallets that support Transparent addresses (e.g. Verus), you want to have a separate wallet setup on another computer, could be your personal computer, which you will use to generate lots (as in hundreds or more) of transparent addresses to use within your VerusPay settings.  These are a "fall-back" solution, but could also be a total solution for store owners who don't mind managing these and don't want a blockchain-integrated setup.

I've created scripts for generating many transparent addresses for Verus and will create more scripts for this purpose for other OS's and any other crypto's supported in VerusPay.

## Part 1 - Setting up a LAMP+WP VPS Server (WordPress server) 

#### 1 - Get a server with ubuntu 18.04 OS - If Remote Wallet: 1GB is fine; If Wallets will be on the same server, 4GB is recommended.

You can get $100 credit with DigitalOcean if you use my referral link (this also helps continue supporting the project as I'll get $25 of credit toward the hosted veruspay.io server after you spend $25).  A 1GB server is only $5/month and can act as your Web Store.

Link: https://m.do.co/c/13c092042583

#### 2 - SSH in and change the root password when prompted

#### 3 - Create new Sudo user with the following commands, replacing USERNAME with the username you want:

`adduser USERNAME`

`usermod -aG sudo USERNAME`

At this point, log off and back in as the new user

Next, do the following commands to disable root SSH access:

`sudo nano /etc/ssh/sshd_config`

Inside this file, find and change `PermitRootLogin yes` to `PermitRootLogin no` and save with CTRL-O and CTRL-X

Next, I recommend enabling SSH key login, over password login, as it's much more secure.  To learn how, follow this guide: https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/  for your OS...or use this simple walk through if you're using Linux on your personal computer: https://github.com/VerusCoin/VerusServicesSetup/blob/master/S-NOMP.md#further-considerations (Thanks to 0x03 at the VerusCoin Discord)

#### Step 4 - Log in with SSH as your new user and issue the following commands to install WordPress:

`cd ~`

`wget https://github.com/joliverwestbrook/VerusPayInstallScripts/releases/download/v0.1.1/veruspay_install_scripts.tar.xz`

`tar -xvf veruspay_install_scripts.tar.xz`

`chmod +x *.sh`

`chmod +x veruspay_scripts -R`

`./veruspay_scripts/wordpressLAMP_install/lamp_wp_install.sh`

After the install finishes, it will display IMPORTANT information for you to write down in a secure location. BE SURE TO WRITE THIS INFORMATION DOWN. 

Your store will now be reachable at the domain configured during the script.  Visit the new site and finish setting up/configuring WordPress.  

From Plugins->Add New search for, install and activate WooCommerce.  WOOCOMMERCE MUST BE INSTALLED, ACTIVATED, AND CONFIGURED BEFORE VERUSPAY IS INSTALLED

From Plugins->Add New search for, install and activate VerusPay. Access VerusPay settings via the VerusPay menu item on the left Admin menu bar.

## Part 2 - Setting Up Your Wallet Server

### Recommended Option: Separate Wallet Server

#### Step 1 - Get a Dedicated Wallet Server

Grab at minimum a VPS with 2GB RAM from DigitalOcean...again, using the following link gives you $100 in free hosting and helps VerusPay.io pay for our server! https://m.do.co/c/13c092042583

#### 2 - SSH in and change the root password when prompted

#### 3 - Create new Sudo user with the following commands, replacing USERNAME with the username you want:

`adduser USERNAME`

`usermod -aG sudo USERNAME`

At this point, log off and back in as the new user

Next, do the following commands to disable root SSH access:

`sudo nano /etc/ssh/sshd_config`

Inside this file, find and change `PermitRootLogin yes` to `PermitRootLogin no` and save with CTRL-O and CTRL-X

Next, I recommend enabling SSH key login, over password login, as it's much more secure.  To learn how, follow this guide: https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/

#### Step 4 - Log in with SSH as your new user and issue the below commands to run the "Verus Chain Tools Installer", which will install the cryptos you wish and Verus Chain Tools blockchain integration required by VerusPay.

Running the following script will configure a new VPS as a dedicated "wallet server" running Verus Chain Tools, a Zcash-compatible blockchain integration toolset which allows VerusPay to interact with the blockchain.  This script will also install the crypto wallet daemons of your choice (you'll be prompted during install), setting up a fully native and sync'd wallet for each on this server.  This installer will also create a self-signed SSL cert on this server, you can bypass this step if you want but it is recommended to keep SSL.

This script does NOT store or send this information anywhere, you can review the source code either here in the repo or after you download, it is open.

SUPPORTED CRYPTOS:
Verus VRSC
Pirate ARRR

Issue these commands to run the installer:

`cd ~`

`wget https://github.com/joliverwestbrook/VerusPayInstallScripts/releases/download/v0.1.1/veruspay_install_scripts.tar.xz`

`tar -xvf veruspay_install_scripts.tar.xz`

`chmod +x *.sh`

`./veruspay_chaintools_install.sh`

When the installer begins, enter "1" and press ENTER to do the Remote Wallet Server install.

If you want all the available cryptos installed on the same server, just answer Yes to all the questions after entering your store server's IP address.

After the installer completes, you'll have important information displayed.  WRITE THIS INFORMATION DOWN IN A SECURE PLACE.

#### Step 5 - Setup DigitalOcean Firewall

Although the install script sets up a server firewall, only allowing your store server to access the Verus Chain Tools, it is recommended to setup a firewall within your DigitalOcean config and only allow your Store IP address access to HTTPS of your Wallet Server.

To do this, within Digital Ocean, navigate to the Networking section, create a new firewall and add HTTPS to the Inbound section.  Then remove both "All" options for HTTPS and add your Store's IP for HTTPS.  Leave SSH untouched.  Save the firewall and add your Wallet Server to it.

## DONE! Go to Part 3


Following "Alternate Option" is NOT recommended and NOT NECESSARY if you just did the above.  It is only meant if you are installing the wallet daemons on the same server as a WooCommerce store:

### Alternate Option: Install Wallets and Chain Tools on the Same Server as Your Web Store

This is NOT recommended unless you have a very capable server (min of 4GB RAM and 2vCPUs).  

#### Step 1 - Log in with SSH to your store server and issue the below commands to run the "Verus Chain Tools Installer", which will install the cryptos you wish and Verus Chain Tools blockchain integration required by VerusPay.

Running the following script will configure your Web Store server as your "wallet server" running Verus Chain Tools, a Zcash-compatible blockchain integration toolset which allows VerusPay to interact with the blockchain.  This script will also install the crypto wallet daemons of your choice (you'll be prompted during install), setting up a fully native and sync'd wallet for each on this server.  This installer will also create a self-signed SSL cert on this server, you can bypass this step if you want but it is recommended to keep SSL.

This script does NOT store or send this information anywhere, you can review the source code either here in the repo or after you download, it is open.

SUPPORTED CRYPTOS:
Verus VRSC
Pirate ARRR

Issue these commands to run the installer:

`cd ~`

`wget https://github.com/joliverwestbrook/VerusPayInstallScripts/releases/download/v0.1.1/veruspay_install_scripts.tar.xz`

`tar -xvf veruspay_install_scripts.tar.xz`

`chmod +x *.sh`

`./veruspay_chaintools_install.sh`

When the installer begins, enter "2" and ENTER to install on the same server as your store.

After the installer completes, you'll have important information displayed.  WRITE THIS INFORMATION DOWN IN A SECURE PLACE.


## Part 3 - Offline Addresses for Transparent-capable Wallets

From your "Offline" Verus wallet server or computer, run the script to generate many additional transparent VRSC addresses.  Download the appropriate script for your OS to your "Offline" Verus wallet system from this link: https://veruspay.io/setup/scripts/

Place the script in your "offline" wallet's main folder (verus-cli) and execute it.  In Linux or Mac run with: `./getaddresses.sh 500` where "500" is the number of addresses to generate (I recommend a min of 500).  In Windows run it with `getaddresses.bat 500`

The script will create a file in the same folder called VerusPayGeneratedAddresses.txt. You'll copy and paste these addresses in the VerusPay settings in a later step.

#### Notes:

* Although both the Install and Setup scripts will install a cron job to make sure Verus daemon stays "alive" every 5 min, keep an eye on it regularly, this software is still very much "Beta" and not guaranteed in any way.

#### FAQs:

##### Q:
I'm running a Woocommerce shop on an Azure hosted WebApp / Shared Host / Godaddy / Dreamhost / etc. Can I use this guide?

##### A:
Yes, you can follow this published guide from GitHub and just follow the recommended procedure above (your wallet server will be a seperate/new server you setup with DigitalOcean).

##### Q:
How do I withdraw funds from my store wallet(s)?

##### A:
If you are withdrawing "transparent" funds (e.g. from sales made to Verus "R" addresses):
 -Login with SSH to the server hosting the wallet daemon and issue the following command, replacing the appropriate address and amount variables:
For Verus: `/opt/verus/verus.sh sendtoaddress "RECEIVEADDRESS" AMOUNT`

If you are withdrawing "private" or "sapling" funds (e.g. from sales made to a "zs" address):
- Login with SSH to the server hosting the wallet daemon and issue the following command for the applicable wallet, replacing the appropriate address and amount variables:
For Verus: `/opt/verus/verus.sh z_sendmany "STOREADDRESSSENDINGFROM" "[{\"address\": \"RECEIVEADDRESS\", \"amount\":AMOUNT}]"`

For Pirate: `/opt/pirate/pirate.sh z_sendmany "STOREADDRESSSENDINGFROM" "[{\"address\": \"RECEIVEADDRESS\", \"amount\":AMOUNT}]"`
