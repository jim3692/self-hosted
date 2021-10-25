#!/bin/bash

# Forward 4443/tcp, 10000/udp

source $root/scripts/lib.sh
__generate_service

__copy_nginx

function generatePassword() {
    openssl rand -hex 16
}

if [ -f "$path/keys.env" ]; then
    source $path/keys.env
else
    JICOFO_AUTH_PASSWORD=$(generatePassword)
    echo JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD} >> $path/keys.env

    JVB_AUTH_PASSWORD=$(generatePassword)
    echo JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD} >> $path/keys.env

    JIGASI_XMPP_PASSWORD=$(generatePassword)
    echo JIGASI_XMPP_PASSWORD=${JIGASI_XMPP_PASSWORD} >> $path/keys.env

    JIBRI_RECORDER_PASSWORD=$(generatePassword)
    echo JIBRI_RECORDER_PASSWORD=${JIBRI_RECORDER_PASSWORD} >> $path/keys.env

    JIBRI_XMPP_PASSWORD=$(generatePassword)
    echo JIBRI_XMPP_PASSWORD=${JIBRI_XMPP_PASSWORD} >> $path/keys.env
fi

sed -i \
    -e "s#JICOFO_AUTH_PASSWORD=.*#JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD}#g" \
    -e "s#JVB_AUTH_PASSWORD=.*#JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}#g" \
    -e "s#JIGASI_XMPP_PASSWORD=.*#JIGASI_XMPP_PASSWORD=${JIGASI_XMPP_PASSWORD}#g" \
    -e "s#JIBRI_RECORDER_PASSWORD=.*#JIBRI_RECORDER_PASSWORD=${JIBRI_RECORDER_PASSWORD}#g" \
    -e "s#JIBRI_XMPP_PASSWORD=.*#JIBRI_XMPP_PASSWORD=${JIBRI_XMPP_PASSWORD}#g" \
    "$(dirname "$0")/.env"

docker-compose up -d

__replace config.template.js > config.js
cp $path/config.js $path/data/web/
