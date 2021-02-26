#!/bin/bash

#openssl nginx
mkdir /etc/nginx/ssl
mv /tmp/localhost /etc/nginx/sites-available/
openssl genrsa -out /etc/nginx/ssl/server.key 3072
openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/CN=localhost"
openssl x509 -req -in /etc/nginx/ssl/server.csr -days 36500 -signkey /etc/nginx/ssl/server.key > /etc/nginx/ssl/server.crt
ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
unlink /etc/nginx/sites-enabled/default

#mysql(mariadb)
service mysql start
mysql -u root < /tmp/set.sql
service mysql stop

#wordpress
cd tmp
wget https://ja.wordpress.org/latest-ja.tar.gz
tar -zxvf latest-ja.tar.gz
rm latest-ja.tar.gz
mkdir /var/www/html/wordpress
cp -r wordpress/* /var/www/html/wordpress/
rm -rf /var/www/html/wordpress/wp-config-sample.php
mv /tmp/wp-config.php /var/www/html/wordpress/

#phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-all-languages.tar.gz
mkdir /var/www/html/phpmyadmin
tar xzvf phpMyAdmin-4.9.7-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
mv /tmp/config.inc.php /var/www/html/phpmyadmin/

chmod 660 /var/www/html/phpmyadmin/config.inc.php
chown -R www-data:www-data /var/www/html/

/etc/init.d/php7.3-fpm start
service mysql start
service nginx start

tail -f /dev/null
