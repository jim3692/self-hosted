#!/bin/bash

export root="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $root/scripts/lib.sh

export SERVICE_DOMAIN=alfonso.top
export SERVICE_REGISTRAR=letsenecrypt

bash $root/scripts/create-bridges.sh

for service in $services
do
    ip=$(cat $root/ip/$service)
    bash -c "cd $root/$service ; echo $service ; export SERVICE_IP=$ip ; export SERVICE_NAME=$service SERVICE_ADDRESS=$service.$SERVICE_DOMAIN ; bash init.sh"
done

bash -c "cd $root/nginx ; docker-compose up -d"
