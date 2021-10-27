#!/bin/bash

source $PROJECT_ROOT/scripts/lib.sh
__generate_service

__copy_nginx

docker-compose up -d
