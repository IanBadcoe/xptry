#!/bin/bash

HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`
PUBLIC_IP=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`

erb hostname="${HOSTNAME}" public_ip="${PUBLIC_IP}" -T - files/dns.rec.erb | aws route53 change-resource-record-sets --hosted-zone-id Z06293352KQ2CHECSP0XT --change-batch=file:///dev/stdin


