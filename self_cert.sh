SELF_CERT_GO=$(expect -c "
set timeout 10
spawn openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
expect \"Country Name (2 letter code)\"
send \"\r\"
expect \"State or Province Name (full name)\"
send \"\r\"
expect \"Locality Name (eg, city)\"
send \"\r\"
expect \"Organization Name (eg, company)\"
send \"\r\"
expect \"Organizational Unit Name (eg, section)\"
send \"\r\"
expect \"Common Name (e.g. server FQDN or YOUR name)\"
send \"$domain\r\"
expect \"Email Address\"
send \"\r\"
expect eof
")
echo "$SELF_CERT_GO"
