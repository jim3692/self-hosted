#!/bin/bash

source $root/scripts/lib.sh
__generate_service

__copy_nginx

if [ -f "$path/keys.env" ]; then
    source $path/keys.env
    VAPID_PRIVATE=$(echo $VAPID_PRIVATE_B64 | base64 --decode)
else
    VORTEX_TOKEN=$(__random_token)
    echo VORTEX_TOKEN=$VORTEX_TOKEN >> $path/keys.env

    VAPID_PRIVATE=$(openssl ecparam -name prime256v1 -genkey)
    VAPID_PRIVATE_B64=$(echo $"$VAPID_PRIVATE" | base64 | tr -d '\n')
    echo VAPID_PRIVATE_B64=$VAPID_PRIVATE_B64 >> $path/keys.env
fi

vapidPrivateB64=$(echo $"$VAPID_PRIVATE" | base64 | tr -d '\n')
vapidPublicB64=$(echo $"$VAPID_PRIVATE" | openssl ec -outform DER | tail -c 65 | base64 | tr '/+' '_-' | tr -d '\n')

sed -i \
    -e "s/\${VORTEX_TOKEN}/${VORTEX_TOKEN}/g" \
    -e "s/\${VAPID_PRIVATE_KEY}/${vapidPrivateB64}/g" \
    -e "s/\${VAPID_PUBLIC_KEY}/${vapidPublicB64}/g" \
    -e "s/\${PUBLIC_IP}/${PUBLIC_IP}/g" \
    .env

docker-compose up -d
