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
elif [ $(date +%H) -lt 4 ]
then
c="d"
else
c="h"
fi

name=${c}_$(date +%d-%m-%Y:%H).tar.gz

mkdir -p ~/backup/
rm -rf ~/backup/*

mkdir -p ~/backup_c/
rm -rf ~/backup_c/*

cp -r ~/www ~/backup/www
mysqldump --all-databases > ~/backup/db.sql

tar -cvf - -C ~/backup . | gzip --best > ~/backup_c/${name}

rm -rf ~/backup/*

aws s3 cp ~/backup_c/${name} s3://xptry-backups
