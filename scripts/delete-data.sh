#!/bin/bash

root="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $root/..

for service in $(cat services.txt)
do
    rm -rf $service/data
done
