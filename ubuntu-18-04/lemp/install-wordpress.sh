#!/usr/bin/env bash

echo "Needed data for the setup!"
read -p 'MYSQL ROOT PW: ' MYSQL_ROOT_PW
read -p 'Domains of new installation: ' DOMAINS
echo 'What path to install Wordpress under'
read -p '/var/www/html/...?: ' NEW_PATH

FULL_NEW_PATH="/var/www/html/"$NEW_PATH
echo "Data collated - time to work magic"

MYSQL_NEW_PW=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev`
MYSQL_NEW_USER=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
MYSQL_NEW_DB=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

mysql -u root -p$MYSQL_ROOT_PW -e "CREATE USER '$MYSQL_NEW_USER'@'localhost' IDENTIFIED BY '$MYSQL_NEW_PW';"
mysql -u root -p$MYSQL_ROOT_PW -e "CREATE DATABASE $MYSQL_NEW_DB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -p$MYSQL_ROOT_PW -e "GRANT ALL ON $MYSQL_NEW_DB.* TO '$MYSQL_NEW_USER'@'localhost';"
mysql -u root -p$MYSQL_ROOT_PW -e "FLUSH PRIVILEGES;"

echo "MYSQL Profile Created"
echo "Updating NGINX"
curl https://scripts.stewpolley.com/ubuntu-18-04/lemp/new_nginx.py >> new_nginx.py
curl https://scripts.stewpolley.com/ubuntu-18-04/lemp/default_nginx >> default_nginx
python new_nginx.py $FULL_NEW_PATH $NEW_PATH $DOMAINS

# NGINX Config
sudo mkdir /var/log/$NEW_PATH
sudo cp $NEW_PATH /etc/nginx/sites-available/$NEW_PATH
sudo ln -s /etc/nginx/sites-available/$NEW_PATH /etc/nginx/sites-enabled/$NEW_PATH
sudo systemctl restart nginx
sudo rm $NEW_PATH
sudo rm new_nginx.py
sudo rm default_nginx

echo "NGINX Conf Created"

cd /tmp && curl -O https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. $FULL_NEW_PATH

sudo chown -R $USER:www-data $FULL_NEW_PATH
sudo find $FULL_NEW_PATH -type d -exec chmod g+s {} \;
sudo chmod g+w $FULL_NEW_PATH/wp-content
sudo chmod -R g+w $FULL_NEW_PATH/wp-content/themes
sudo chmod -R g+w $FULL_NEW_PATH/wp-content/plugins

curl https://scripts.stewpolley.com/ubuntu-18-04/lemp/fix_wordpress.py >> fix_wordpress.py
sudo python3 fix_wordpress.py $MYSQL_NEW_DB $MYSQL_NEW_USER $MYSQL_NEW_PW $FULL_NEW_PATH
sudo rm fix_wordpress.py

sudo chown -R www-data $FULL_NEW_PATH


sudo certbot --nginx

curl https://scripts.stewpolley.com/ubuntu-18-04/lemp/activate-security-headers.py >> activate-security-headers.py
sudo python activate-security-headers.py $NEW_PATH
rm activate-security-headers.py
sudo systemctl restart nginx

echo Wordpress installation complete!
echo "Wordpress Database password can be found in wp-config.php if desired"

