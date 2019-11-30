#!/bin/bash

find $1 \( -type d -exec chmod 755 {} \; \) -o \( -type f -exec chmod 644 {} \; \)
chown -R www-data:www-data $1
