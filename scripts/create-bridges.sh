#!/bin/bash

source $PROJECT_ROOT/scripts/lib.sh

subnet=10.0.0.0
serviceCount=$(echo "$LIB_SERVICES" | wc -l)

host=$(echo $subnet | egrep -o '[0-9]+$')

rm -rf $PROJECT_ROOT/ip
mkdir $PROJECT_ROOT/ip

script=""
i=1
for service in $LIB_SERVICES
do
    newHost=$(expr $host + $i)
    ip=$(echo $subnet | sed -E "s/[0-9]+$/$newHost/")
    brName="service-${service}"

    echo $ip > $PROJECT_ROOT/ip/$service

    script="${script} brctl addbr ${brName} ;"
    script="${script} ip addr add ${ip}/32 dev ${brName} ;"
    i=$(expr $i + 1)
done

bash -c "$script"
