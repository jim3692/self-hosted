#!/bin/bash

export PROJECT_ROOT="$( cd -- "$(dirname "$0")" > /dev/null 2>&1 ; pwd -P )"
source $PROJECT_ROOT/scripts/lib.sh

export SERVICE_DOMAIN=alfonso.top
export SERVICE_REGISTRAR=letsencrypt

bash $PROJECT_ROOT/scripts/create-bridges.sh

for service in $LIB_SERVICES
do
    ip=$(cat $PROJECT_ROOT/ip/$service)
    bash -c "cd $PROJECT_ROOT/$service ; echo $service ; export SERVICE_IP=$ip ; export SERVICE_NAME=$service SERVICE_ADDRESS=$service.$SERVICE_DOMAIN ; bash init.sh"
done

bash -c "cd $PROJECT_ROOT/nginx ; docker-compose up -d"
bash $PROJECT_ROOT/reload.sh
