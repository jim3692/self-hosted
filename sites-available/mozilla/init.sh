#!/bin/bash

source $PROJECT_ROOT/scripts/lib.sh
__generate_service

__copy_nginx

if [ -f "$LIB_SERVICE_PATH/keys.env" ]; then
    source $LIB_SERVICE_PATH/keys.env
else
    SECRET=$(__random_token)
    echo SECRET=$SECRET >> keys.env
fi

sed -i "s/\${SECRET}/${SECRET}/g" .env

if [ ! -d $LIB_SERVICE_PATH/data ]; then mkdir $LIB_SERVICE_PATH/data; fi
chown -R 1001:1001 $LIB_SERVICE_PATH/data

docker-compose up -d
