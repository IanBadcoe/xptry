#!/bin/bash

~ubuntu/xptry/deploy/deploy.sh

if [ -f /var/run/reboot-required ]; then
  reboot
fi
