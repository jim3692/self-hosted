#!/bin/bash

source $PROJECT_ROOT/scripts/lib.sh

serviceCount=$(echo "$LIB_SERVICES" | wc -l)

host=$(echo $SERVER_SUBNET | egrep -o '[0-9]+$')

rm -rf $PROJECT_ROOT/ip
mkdir $PROJECT_ROOT/ip

script=""
i=1
for service in $LIB_SERVICES
do
    newHost=$(expr $host + $i)
    ip=$(echo $SERVER_SUBNET | sed -E "s/[0-9]+$/$newHost/")
    brName="${SERVER_BRIDGE_PREFIX}${service}"

    echo $ip > $PROJECT_ROOT/ip/$service

    script="${script} brctl addbr ${brName} ;"
    script="${script} ip addr add ${ip}/32 dev ${brName} ;"
    i=$(expr $i + 1)
done

bash -c "$script"
