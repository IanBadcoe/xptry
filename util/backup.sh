#!/bin/bash

if [ $(date +%H) -gt 3 ]
then
c="h"
elif [[ $(date +%d) == 1 && $(date +%m) == 1 ]]
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

name=${c}_$(date +%d-%m-%Y_%H:%M:%S).tar.gz

mkdir -p ~ubuntu/backup/
rm -rf ~ubuntu/backup/*

mkdir -p ~ubuntu/backup_c/
rm -rf ~ubuntu/backup_c/*

cp -r ~ubuntu/www ~ubuntu/backup/www
mysqldump --all-databases > ~ubuntu/backup/db.sql

tar -cvf - -C ~ubuntu/backup . | gzip --best > ~ubuntu/backup_c/${name}

rm -rf ~ubuntu/backup/*

/usr/local/bin/aws s3 cp ~ubuntu/backup_c/${name} s3://xptry-backups
