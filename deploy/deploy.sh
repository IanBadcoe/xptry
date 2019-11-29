#!/bin/bash

SITE="xptry.com"
EEVERSION="5.3.0"
PHPVERSION="7.2"

apt update
apt upgrade -y
apt autoremove -y
apt install mariadb-server -y

mysql -e "CREATE USER IF NOT EXISTS ee@localhost IDENTIFIED BY 'eepwd'"
mysql -e "CREATE DATABASE IF NOT EXISTS EE"
mysql -e "GRANT ALL PRIVILEGES ON EE.* TO 'ee'@'localhost'"

apt install apache2 -y

apt install php libapache2-mod-php php-mysql php-curl php-zip php-mbstring php-gd -y

apt install unzip curl -y

sudo apt install php${PHPVERSION}-fpm php${PHPVERSION}-common php${PHPVERSION}-mysql php${PHPVERSION}-xml php${PHPVERSION}-xmlrpc php${PHPVERSION}-curl php${PHPVERSION}-gd php${PHPVERSION}-imagick php${PHPVERSION}-cli php${PHPVERSION}-dev php${PHPVERSION}-imap php${PHPVERSION}-mbstring php${PHPVERSION}-soap php${PHPVERSION}-zip php${PHPVERSION}-bcmath -y
a2enmod proxy_fcgi
a2enmod setenvif

apt install ruby -y
erb site="${SITE}" phpversion="${PHPVERSION}" -T - files/apache.conf.erb > /etc/apache2/sites-available/${SITE}.conf
a2ensite ${SITE}.conf

rm -rf /var/www/${SITE}

# to install the EE compatibility wizard
#mkdir ~/wizard
#curl https://ellislab.com/asset/file/ee_server_wizard.zip > /var/www/html/wizard.zip
#unzip -o /var/www/html/wizard.zip -d /var/www/${SITE}
#rm /var/www/html/wizard.zip

if [[ " $@ " =~ " -clean " ]]
then
  echo "Cleaning ~/www"
  rm -rf ~/www
fi

if [ ! -d "~/www" ]
then
  echo "Unzipping EE into ~/www"
  mkdir -p ~/www
  unzip -qu installs/ExpressionEngine${EEVERSION}.zip -d ~/www
  find ~/www \( -type d -exec chmod 755 {} \; \) -o \( -type f -exec chmod 644 {} \; \)
  chown -R www-data:www-data ~/www
fi

mkdir -p ~/www/upload/images/author
mkdir -p ~/www/upload/images/article

ln -sfn ~/www /var/www/${SITE}

a2dissite 000-default.conf
systemctl restart apache2
systemctl restart mysql.service
