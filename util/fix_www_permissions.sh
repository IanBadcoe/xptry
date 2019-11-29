#!/bin/bash

find ~/www \( -type d -exec chmod 755 {} \; \) -o \( -type f -exec chmod 644 {} \; \)
chown -R www-data:www-data ~/www
