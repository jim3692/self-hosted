#!/bin/bash

# Forward 4443/tcp, 10000/udp

source $PROJECT_ROOT/scripts/lib.sh

__generate_service
__copy_nginx

function generatePassword() {
    openssl rand -hex 16
}

if [ -f "$LIB_SERVICE_PATH/keys.env" ]; then
    source $LIB_SERVICE_PATH/keys.env
else
    JICOFO_AUTH_PASSWORD=$(generatePassword)
    echo JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD} >> $LIB_SERVICE_PATH/keys.env

    JVB_AUTH_PASSWORD=$(generatePassword)
    echo JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD} >> $LIB_SERVICE_PATH/keys.env

    JIGASI_XMPP_PASSWORD=$(generatePassword)
    echo JIGASI_XMPP_PASSWORD=${JIGASI_XMPP_PASSWORD} >> $LIB_SERVICE_PATH/keys.env

    JIBRI_RECORDER_PASSWORD=$(generatePassword)
    echo JIBRI_RECORDER_PASSWORD=${JIBRI_RECORDER_PASSWORD} >> $LIB_SERVICE_PATH/keys.env

    JIBRI_XMPP_PASSWORD=$(generatePassword)
    echo JIBRI_XMPP_PASSWORD=${JIBRI_XMPP_PASSWORD} >> $LIB_SERVICE_PATH/keys.env
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
cp $LIB_SERVICE_PATH/config.js $LIB_SERVICE_PATH/data/web/
