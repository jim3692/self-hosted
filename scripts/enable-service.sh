#!/bin/bash

if [ ! -f init.sh || ! -f nginx.template.conf ]; then
    echo Invalid service >> /dev/stderr
    exit 1
fi

service=${PWD##*/}
ln -s ../sites-available/$service ../../sites-enabled/
