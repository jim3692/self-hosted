#!/bin/bash

export PROJECT_ROOT="$( cd -- "$(dirname "$0")" > /dev/null 2>&1 ; pwd -P )"

if [ ! -f $PROJECT_ROOT/.env ]; then
    echo .env file not found >> /dev/stderr
    exit 1
fi

source $PROJECT_ROOT/scripts/lib.sh

bash $PROJECT_ROOT/scripts/create-bridges.sh

for service in $LIB_SERVICES
do
    echo $service
    ip=$(cat $PROJECT_ROOT/ip/$service)
    bash -c "
        cd $(__get_service_path $service)
        export SERVICE_IP=$ip
        export SERVICE_NAME=$service
        export SERVICE_ADDRESS=$service.$SERVER_DOMAIN
        bash init.sh
    "
done

bash -c "
    cd $PROJECT_ROOT/nginx
    docker-compose up -d
"
bash $PROJECT_ROOT/reload.sh
