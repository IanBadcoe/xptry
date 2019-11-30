#!/bin/bash
mkdir -p ~/backup_c
mkdir -p ~/backup

name=${1}.tar.gz

aws s3 cp s3://xptry-backups/${name} ~/backup_c

cat ~/backup_c/${name} | gunzip | tar -C ~/backup -xvf -

if [[ -d ~/backup/www && -e ~/backup/db.sql ]]
then
  systemctl stop apache2
  rm -rf ~/www
  mv ~/backup/www ~/www
  bash util/fix_www_permissions.sh ~/www
  cat ~/backup/db.sql | mysql
  systemctl start apache2
fi
