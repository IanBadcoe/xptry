#!/bin/bash

apt update
apt upgrade -y
apt install mysql-server -y

mysql -e "CREATE USER ee@localhost IDENTIFIED BY 'eepwd'"
mysql -e "CREATE DATABASE IF NOT EXISTS EE"
mysql -e "GRANT ALL PRIVILEGES ON EE.* TO 'ee'@'localhost'"
