#!/bin/bash

SITE="xptry.com"
EEVERSION="5.3.0"
PHPVERSION="7.2"

apt update
apt upgrade -y
apt install mariadb-server -y

mysql -e "CREATE USER IF NOT EXISTS ee@localhost IDENTIFIED BY 'eepwd'"
mysql -e "CREATE DATABASE IF NOT EXISTS EE"
mysql -e "GRANT ALL PRIVILEGES ON EE.* TO 'ee'@'localhost'"

apt install apache2 -y

apt install php libapache2-mod-php php-mysql php-curl php-zip -y

apt install unzip

mkdir ~/wizard
rm /var/www/html/index.html
curl https://ellislab.com/asset/file/ee_server_wizard.zip > /var/www/html/wizard.zip
unzip -o /var/www/html/wizard.zip -d /var/www/html
rm /var/www/html/wizard.zip

#sudo apt install php${PHPVERSION}-fpm php${PHPVERSION}-common php${PHPVERSION}-mysql php${PHPVERSION}-xml php${PHPVERSION}-xmlrpc php${PHPVERSION}-curl php${PHPVERSION}-gd php${PHPVERSION}-imagick php${PHPVERSION}-cli php${PHPVERSION}-dev php${PHPVERSION}-imap php${PHPVERSION}-mbstring php${PHPVERSION}-soap php${PHPVERSION}-zip php${PHPVERSION}-bcmath -y
#a2enmod proxy-fcgi setenvif
#a2enconf php7.2-fpm

#apt install ruby -y
#erb site="${SITE}" -T - files/apache.conf.erb > /etc/apache2/sites-available/${SITE}.conf

#mkdir -p ~/www
#unzip -qu installs/ExpressionEngine${EEVERSION}.zip -d ~/www
#find ~/www \( -type d -exec chmod 755 {} \; \) -o \( -type f -exec chmod 644 {} \; \)
#chown $USER:$USER ~/www

#ln -sfn ~/www /var/www/${SITE}

#a2ensite ${SITE}.conf
#a2dissite 000-default.conf
systemctl restart apache2
systemctl restart mysql.service
