#!/bin/bash

export PROJECT_ROOT="$( cd -- "$(dirname "$0")" > /dev/null 2>&1 ; pwd -P )"
cd $PROJECT_ROOT/../sites-enabled

for service in $(ls -w 1)
do
    rm -rf $service/data
done
