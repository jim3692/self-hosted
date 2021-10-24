#!/bin/bash

PUBLIC_IP=$(curl -sS ifconfig.me)
path="$root/$SERVICE_NAME"

function __replace () {
    sed \
        -e "s/\${IP}/${SERVICE_IP}/g" \
        -e "s/\${ADDRESS}/${SERVICE_ADDRESS}/g" \
        -e "s/\${DOMAIN}/${SERVICE_DOMAIN}/g" \
        -e "s/\${REGISTRAR}/${SERVICE_REGISTRAR}/g" \
        $@
}

function __generate_service () {
    __replace template.env > .env
    __replace docker-compose.template.yml > docker-compose.yml
    __replace nginx.template.conf > nginx.conf
}

function __random_token () {
    head -c 20 /dev/urandom | sha1sum | egrep -o '[a-z0-9]+'
}

function __copy_nginx () {
    cp $path/nginx.conf $root/nginx/configs/domains/$SERVICE_NAME.conf
}

export services=$(cat $root/services.txt)
