#!/bin/bash

export root="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $root/scripts/lib.sh

for service in $services
do
    ip=$(bash -c "cd $root ; cat ip/$service")
    bash -c "cd $root ; cd $service ; echo $service ; docker-compose down"
done

bash -c "cd $root/nginx ; docker-compose down"

bash $root/scripts/drop-bridges.sh
