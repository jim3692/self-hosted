#!/bin/bash

export PROJECT_ROOT="$( cd -- "$(dirname "$0")" > /dev/null 2>&1 ; pwd -P )"
source $PROJECT_ROOT/scripts/lib.sh

for service in $LIB_SERVICES
do
    ip=$(bash -c "cd $PROJECT_ROOT ; cat ip/$service")
    bash -c "cd $PROJECT_ROOT ; cd $service ; echo $service ; docker-compose down"
done

bash -c "cd $PROJECT_ROOT/nginx ; docker-compose down"

bash $PROJECT_ROOT/scripts/drop-bridges.sh
