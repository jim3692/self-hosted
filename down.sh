#!/bin/bash

export PROJECT_ROOT="$( cd -- "$(dirname "$0")" > /dev/null 2>&1 ; pwd -P )"
source $PROJECT_ROOT/scripts/lib.sh

for service in $LIB_SERVICES
do
    echo $service 
    ip=$(cat "$PROJECT_ROOT/ip/$service")
    bash -c "
        cd $PROJECT_ROOT
        cd $service
        docker-compose down
    "
done

bash -c "
    cd $PROJECT_ROOT/nginx
    docker-compose down
"

bash $PROJECT_ROOT/scripts/drop-bridges.sh
