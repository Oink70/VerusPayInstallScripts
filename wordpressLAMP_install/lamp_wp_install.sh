#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
#Get variables and user input
clear
echo "  ==============================================================="
echo "  |         WELCOME TO THE VERUSPAY LAMP+WP INSTALLER!          |"
echo "  |                                                             |"
echo "  |  This installer is meant for NEW STORES ONLY. If you are    |"
echo "  |  already running WordPress on this server, you should abort |"
echo "  |  now with CTRL-Z. Otherwise continue by answering the       |"
echo "  |  following questions.                                       |"
echo "  |                                                             |"
echo "  | !! This does NOT install Verus Chain Tools or any Wallet !! |"
echo "  |    This is a LAMP+WordPress Install Script ONLY.            |"
echo "  |                                                             |"
echo "  |            Installer will begin in 15 seconds               |"
echo "  |                                                             |"
echo "  ==============================================================="
echo ""
sleep 15
echo "What is your primary domain?"
echo "Enter WITHOUT the www (e.g. yourdomain.com):"
read domain
shopt -s nocasematch
echo ""
echo "Include support for the www version for your domain?"
echo "(e.g. www.yourdomain.com) (yes or no):"
read wwwans
if [[ $wwwans == "yes" ]] || [[ $wwwans == "y" ]];
then
    export subdomain="www."
else
    export subdomain=""
fi
echo ""
echo "Email address for you as the admin"
echo "(used SSL settings):"
read email
echo ""
export domain
export email
[ "$passlength" == "" ] && passlength=32
export rootpass=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${passlength} | xargs)
export wppass=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${passlength} | xargs)
[ "$namelength" == "" ] && namelength=6
export wpdb="wp_db_"$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${namelength} | xargs)
export wpuser="wp_us_"$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${namelength} | xargs)
#Begin operations
echo ""
echo "Thank you. Beginning WordPress server configuration!"
echo ""
mkdir -p /tmp/veruspaystore
cd /tmp/veruspaystore
wget https://veruspay.io/setup/verusstorescripts.tar.xz
tar -xvf /tmp/veruspaystore/verusstorescripts.tar.xz
chmod +x /tmp/veruspaystore/verusstorescripts/add_another_domain.sh
mv /tmp/veruspaystore/verusstorescripts/add_another_domain.sh ~
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
echo "Installing Apache..."
echo ""
echo ""
sleep 3
sudo apt -qq update
sudo apt -y -qq autoremove
sudo apt --yes -qq install curl wget apache2
sudo ufw allow OpenSSH
sudo ufw allow "Apache Full"
echo "y" | sudo ufw enable
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
echo "ServerName $domain" | sudo tee -a /etc/apache2/apache2.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
clear
echo "Configuring $domain directory..."
echo "Enabling Apache config..."
echo ""
echo ""
sleep 6
sudo mkdir -p /var/www/$domain/html
sudo chmod -R 755 /var/www/$domain
cd /tmp/veruspaystore
cat >$domain.conf <<EOL
<VirtualHost *:80>
    ServerAdmin $email
    ServerName $domain
    ServerAlias $subdomain$domain
    DocumentRoot /var/www/$domain/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
RewriteEngine on
RewriteCond %{SERVER_NAME} =$subdomain$domain [OR]
RewriteCond %{SERVER_NAME} =$domain
RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
<Directory /var/www/$domain/html/>
	AllowOverride All
</Directory>
</VirtualHost>
EOL
sudo mv /tmp/veruspaystore/$domain.conf /etc/apache2/sites-available/$domain.conf
sudo a2ensite $domain.conf
sudo ufw delete allow "Apache Full"
sudo ufw allow "Apache Full"
echo "y" | sudo ufw enable
clear
echo "Disabling default config..."
echo ""
echo ""
sleep 3
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
clear
echo "Installing and configuring MySQL and WordPress DB Settings..."
echo ""
echo ""
sleep 6
sudo apt --yes -qq install mysql-server expect
#Run expect script for mysql, retain environment vars
sudo -E /tmp/veruspaystore/verusstorescripts/do_mysql_secure.sh
sudo apt --yes -qq install php libapache2-mod-php php-mysql
sudo rm /etc/apache2/mods-available/dir.conf
cd /tmp/veruspaystore
cat >dir.conf <<EOL
<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOL
sudo mv /tmp/veruspaystore/dir.conf /etc/apache2/mods-available/dir.conf
sudo systemctl restart apache2
clear
echo "Installing CertBot and setting up SSL with Lets Encrypt..."
echo ""
echo ""
sleep 6
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt --yes -qq install python-certbot-apache
sudo systemctl reload apache2
sudo -E /tmp/veruspaystore/verusstorescripts/do_certs.sh
clear
echo "Installing WordPress dependencies..."
echo ""
echo ""
sleep 3
sudo apt -qq update
sudo apt --yes -qq install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
sudo systemctl restart apache2
clear
echo "Downloading and unpacking latest WordPress..."
echo ""
echo ""
sleep 3
cd /tmp/veruspaystore
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
clear
echo "Configuring WordPress files, folders, permissions, and config..."
echo ""
echo ""
sleep 6
touch /tmp/veruspaystore/wordpress/.htaccess
cp /tmp/veruspaystore/wordpress/wp-config-sample.php /tmp/veruspaystore/wordpress/wp-config.php
mkdir /tmp/veruspaystore/wordpress/wp-content/upgrade
sudo cp -a /tmp/veruspaystore/wordpress/. /var/www/$domain/html
sudo perl -pi -e "s/database_name_here/$wpdb/g" /var/www/$domain/html/wp-config.php
sudo perl -pi -e "s/username_here/$wpuser/g" /var/www/$domain/html/wp-config.php
sudo perl -pi -e "s/password_here/$wppass/g" /var/www/$domain/html/wp-config.php
sudo perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' /var/www/$domain/html/wp-config.php
sudo chown -R www-data:www-data /var/www/$domain/html
sudo find /var/www/$domain/html/ -type d -exec chmod 750 {} \;
sudo find /var/www/$domain/html/ -type f -exec chmod 640 {} \;
clear
echo "Setting up simple postfix mail services for WordPress..."
echo ""
echo ""
sleep 3
#Setup mail services
sudo debconf-set-selections <<< "postfix postfix/mailname string $domain"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string Internet Site"
sudo debconf-set-selections <<< "postfix postfix/mailbox_size_limit string 0"
sudo debconf-set-selections <<< "postfix postfix/recipient_delimiter string +"
sudo debconf-set-selections <<< "postfix postfix/inet_interfaces string loopback-only"
sudo apt --yes -qq install postfix
clear
echo "Cleaning up..."
echo ""
echo ""
sleep 3
sudo apt -y -qq purge expect
sudo rm /tmp/veruspaystore -r
clear
echo ""
echo ""
echo "====================================="
echo "=           IMPORTANT!              ="
echo "=  Below are your new credentials   ="
echo "=  and details. Write down these    ="
echo "=  details down in a secure place   ="
echo "====================================="
echo "                                     "
echo "     Server & WordPress Data:        "
echo "  ---------------------------------  "
echo "                                     "
echo "  Root MySQL password: "$rootpass
echo "  WordPress DB Name: "$wpdb
echo "  WordPress DB User: "$wpuser
echo "  WordPress DB Pass: "$wppass
echo ""
echo "  A script called 'add_another_domain.sh'"
echo "  has been placed in your home folder"
echo "  which can be run later if you ever "
echo "  wish to add another domain to this "
echo "  web server.                        "
echo "                                     "
echo "  ---------------------------------  "
echo "====================================="
echo ""