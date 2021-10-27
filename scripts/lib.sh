#!/bin/bash

export $SERVER_DOMAIN
export $SERVER_REGISTRAR
export $SERVER_SUBNET
export $SERVER_BRIDGE_PREFIX

[ -z ${LIB_PUBLIC_IP+x} ] || export LIB_PUBLIC_IP=$(curl -sS ifconfig.me)
[ -z ${LIB_SERVICES+x} ] || export LIB_SERVICES=$(ls -w 1 $PROJECT_ROOT/sites-enabled)

LIB_SERVICE_PATH="$PROJECT_ROOT/sites-enabled/$SERVICE_NAME"

function __get_service_path () {
    echo $PROJECT_ROOT/sites-enabled/$0
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
    cp $LIB_SERVICE_PATH/nginx.conf $PROJECT_ROOT/nginx/configs/domains/$SERVICE_NAME.conf
}
