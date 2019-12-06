#!/bin/bash

find $1 \( -type d -exec chmod 2770 {} \; \) -o \( -type f -exec chmod 660 {} \; \)
chown -R www-data:sambashare $1
