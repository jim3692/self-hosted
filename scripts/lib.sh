#!/bin/bash

PUBLIC_IP=$(curl -sS ifconfig.me)
path="$root/sites-enabled/$SERVICE_NAME"

function __get_service_path () {
    echo $root/sites-enabled/$0
}

function __replace () {
    sed \
        -e "s/\${IP}/${SERVICE_IP}/g" \
        -e "s/\${ADDRESS}/${SERVICE_ADDRESS}/g" \
        -e "s/\${DOMAIN}/${SERVICE_DOMAIN}/g" \
        -e "s/\${REGISTRAR}/${SERVICE_REGISTRAR}/g" \
        $@
}

function __generate_service () {
    [ -f template.env ] __replace template.env > .env
    [ -f docker-compose.template.yml ] __replace docker-compose.template.yml > docker-compose.yml
    __replace nginx.template.conf > nginx.conf
}

function __random_token () {
    head -c 20 /dev/urandom | sha1sum | egrep -o '[a-z0-9]+'
}

function __copy_nginx () {
    cp $path/nginx.conf $root/nginx/configs/domains/$SERVICE_NAME.conf
}

export services=$(ls -w 1 $root/sites-enabled)
