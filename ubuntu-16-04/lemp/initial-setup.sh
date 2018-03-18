#!/usr/bin/env bash


# https://scripts.stewpolley.com/lemp-setup.sh

# Initial install of NGINX

echo Initial Update
sudo apt-get update
echo Installing NGINX
sudo apt-get install nginx -y

# Install Python 3.6 as we will use it later
echo Getting new Repo
sudo add-apt-repository ppa:jonathonf/python-3.6
echo Another Update
sudo apt-get update
echo Installing python3.6
sudo apt-get install python3.6  -y

# Get MYSQL Root Password
echo Generating password
MYSQL_ROOT_PASSWORD=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev`

# Install MySQL Automatically
export DEBIAN_FRONTEND=noninteractive
echo "debconf mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
echo "debconf mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
sudo apt-get -y install mysql-server

mysql -u root -p$MYSQL_ROOT_PASSWORD <<-EOF
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

echo $MYSQL_ROOT_PASSWORD
echo "MySQL setup completed"

# Install PHP
sudo apt-get install php-fpm php-mysql -y
curl https://scripts.stewpolley.com/ubuntu-16-04/lemp/fix_php_config.py >> fix_php_config.py
sudo python3.6 fix_php_config.py
rm fix_php_config.py

echo "Final Install for future wordpress installs!"
sudo apt-get install -y php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
sudo systemctl restart php7.0-fpm

echo LEMP Stack Initial Setup Complete
echo Installing Lets Encrypt
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install -y python-certbot-nginx

echo "ROOT User Password for MYSQL - PLEASE SAVE THIS NOW - THIS WILL ONLY DISPLAY ONCE"
echo ""
echo $MYSQL_ROOT_PASSWORD
echo ""
echo "PLEASE SAVE THIS NOW"
