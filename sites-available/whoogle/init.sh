#!/bin/bash

source $root/scripts/lib.sh
__generate_service

__copy_nginx

docker-compose up -d
