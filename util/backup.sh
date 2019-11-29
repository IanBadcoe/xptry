#!/bin/bash

if [[ $(date +%d) == 1 && $(date +%m) == 1 ]]
then
c="y"
elif [ $(date +%d) == 1 ]
then
c="m"
elif [ $(date +%u) == 1 ]
then
c="w"
else
c="d"
fi

name=${c}_$(date +%s).tar.gz

mkdir -p ~/backup/
rm -rf ~/backup/*

mkdir -p ~/backup_c/
rm -rf ~/backup_c/*

cp -r ~/www ~/backup/www
mysqldump EE > ~/backup/db.sql

tar -cvf - ~/backup | gzip --best > ~/backup_c/${name}

rm -rf ~/backup/*

s3cmd put @/backup_c/${name} s3:xptry-backups
