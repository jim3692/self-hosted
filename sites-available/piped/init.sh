#!/bin/bash

source $root/scripts/lib.sh
__generate_service

__copy_nginx

__replace configs/Caddyfile.template > configs/Caddyfile
__replace configs/config.template.properties > configs/config.properties

docker-compose up -d
