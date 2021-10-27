#!/bin/bash

source $root/scripts/lib.sh
__generate_service

__copy_nginx

if [ -f "$path/keys.env" ]; then
    source $path/keys.env
else
    SECRET=$(__random_token)
    echo SECRET=$SECRET >> keys.env
fi

sed -i "s/\${SECRET}/${SECRET}/g" .env

if [ ! -d $path/data ]; then mkdir $path/data; fi
chown -R 1001:1001 $path/data

docker-compose up -d
