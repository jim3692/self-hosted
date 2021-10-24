#!/bin/bash

export root="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $root/scripts/lib.sh

bash -c "cd $root/nginx ; docker-compose exec nginx nginx -s reload"
