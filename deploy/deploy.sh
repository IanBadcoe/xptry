#!/bin/bash

SITE="xptry.com"
EEVERSION="5.3.0"
PHPVERSION="7.2"

echo "-------------------- Packages --------------------"
apt update
apt install mariadb-server apache2 php libapache2-mod-php php-mysql php-curl php-zip php-mbstring php-gd unzip curl ruby php${PHPVERSION}-fpm php${PHPVERSION}-common php${PHPVERSION}-mysql php${PHPVERSION}-xml php${PHPVERSION}-xmlrpc php${PHPVERSION}-curl php${PHPVERSION}-gd php${PHPVERSION}-imagick php${PHPVERSION}-cli php${PHPVERSION}-dev php${PHPVERSION}-imap php${PHPVERSION}-mbstring php${PHPVERSION}-soap php${PHPVERSION}-zip php${PHPVERSION}-bcmath python3-pip samba -y
apt upgrade -y
apt autoremove -y
sudo -H pip3 install awscli --upgrade

echo "-------------------- db user --------------------"
mysql -e "CREATE USER IF NOT EXISTS ee@localhost IDENTIFIED BY 'eepwd'"
mysql -e "CREATE DATABASE IF NOT EXISTS EE"
mysql -e "GRANT ALL PRIVILEGES ON EE.* TO 'ee'@'localhost'"

echo "-------------------- apache config --------------------"
a2enmod proxy_fcgi
a2enmod setenvif

erb site="${SITE}" phpversion="${PHPVERSION}" -T - files/apache.conf.erb > /etc/apache2/sites-available/${SITE}.conf
a2ensite ${SITE}.conf

echo "-------------------- Site setup --------------------"
rm -rf /var/www/${SITE}


# to install the EE compatibility wizard
#mkdir ~/wizard
#curl https://ellislab.com/asset/file/ee_server_wizard.zip > /var/www/html/wizard.zip
#unzip -o /var/www/html/wizard.zip -d /var/www/${SITE}
#rm /var/www/html/wizard.zip

if [[ " $@ " =~ " -clean " ]]
then
  echo "-------------------- Cleaning ~/www --------------------"
  rm -rf ~/www
fi

if [ ! -e ~/www/index.php ]
then
  echo "-------------------- Unzipping EE into ~/www --------------------"
  mkdir -p ~/www
  unzip -qu installs/ExpressionEngine${EEVERSION}.zip -d ~/www
fi

mkdir -p ~/www/upload/images/author
mkdir -p ~/www/upload/images/article
mkdir -p ~/www/upload/images/category
mkdir -p ~/www/upload/images/thread

bash util/fix_www_permissions.sh ~/www

ln -sfn ~/www /var/www/${SITE}

a2dissite 000-default.conf

echo "-------------------- Services --------------------"
systemctl restart apache2
systemctl restart mysql.service

crontab files/crontab.txt
systemctl restart cron

echo "-------------------- Samba --------------------"
usermod -a -G sambashare ubuntu
usermod -a -G sambashare www-data

sed -ie '/\[ubuntu\]/,$d' /etc/samba/smb.conf

cat >> /etc/samba/smb.conf << EOF
[ubuntu]
    path = /home/ubuntu
    browseable = yes
    read only = no
    force create mode = 0660
    force directory mode = 2770
    valid users = ubuntu
EOF

systemctl restart smbd
systemctl restart nmbd
