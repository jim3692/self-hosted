#!/bin/bash

export PROJECT_ROOT="$( cd -- "$(dirname "$0")" > /dev/null 2>&1 ; pwd -P )"
source $PROJECT_ROOT/scripts/lib.sh

bash -c "cd $PROJECT_ROOT/nginx ; docker-compose exec nginx nginx -s reload"
