CONFIG_MYSQL=$(expect -c "
set timeout 3
spawn mysql -u root -p $rootpass
expect \"mysql>\"
send \"CREATE DATABASE $wpdb DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;\r\"
expect \"mysql>\"
send \"GRANT ALL ON $wpdb.* TO '$wpuser'@'localhost' IDENTIFIED BY '$wppass';\r\"
expect \"mysql>\"
send \"FLUSH PRIVILEGES;\r\"
expect \"mysql>\"
send \"exit;\r\"
expect eof
")
echo "$CONFIG_MYSQL"