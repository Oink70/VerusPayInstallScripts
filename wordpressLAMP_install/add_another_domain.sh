#!/bin/bash
#set working directory to the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
#Get variables and user input
echo "What is your primary domain? Enter WITHOUT the www:"
read domain
shopt -s nocasematch
echo "Include the www for your domain? (yes or no)"
read wwwans
if [[ $wwwans == "yes" ]] || [[ $wwwans == "y" ]];
then
    subdomain="www."
else
    subdomain=""
fi
echo "Email address for you as the admin:"
read email
sudo mkdir -p /var/www/$domain/html
sudo chmod -R 755 /var/www/$domain
sudo touch /etc/apache2/sites-available/$domain.conf
echo "<VirtualHost *:80>" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "    ServerAdmin $email" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "    ServerName $domain" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "    ServerAlias $subdomain$domain" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "    DocumentRoot /var/www/$domain/html" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "    ErrorLog ${APACHE_LOG_DIR}/error.log" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "    CustomLog ${APACHE_LOG_DIR}/access.log combined" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "RewriteEngine on" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "RewriteCond %{SERVER_NAME} =$subdomain$domain [OR]" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "RewriteCond %{SERVER_NAME} =$domain" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "<Directory /var/www/$domain/html/>" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "	AllowOverride All" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "</Directory>" | sudo tee -a /etc/apache2/sites-available/$domain.conf
echo "</VirtualHost>" | sudo tee -a /etc/apache2/sites-available/$domain.conf
sudo a2ensite $domain.conf
sudo systemctl reload apache2
if [[ $subdomain == "www." ]]
then
    sudo certbot --apache -d $domain -d $subdomain$domain
else 
    sudo certbot --apache -d $domain
fi
echo "Finished!"
