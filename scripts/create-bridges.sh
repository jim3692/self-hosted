#!/bin/bash

source $root/scripts/lib.sh

subnet=10.0.0.0
serviceCount=$(echo "$services" | wc -l)

host=$(echo $subnet | egrep -o '[0-9]+$')

rm -rf $root/ip
mkdir $root/ip

script=""
i=1
for service in $services
do
    newHost=$(expr $host + $i)
    ip=$(echo $subnet | sed -E "s/[0-9]+$/$newHost/")
    brName="service-${service}"

    echo $ip > $root/ip/$service

    script="${script} brctl addbr ${brName} ;"
    script="${script} ip addr add ${ip}/32 dev ${brName} ;"
    i=$(expr $i + 1)
done

bash -c "$script"
