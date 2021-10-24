#!/bin/bash

for bridge in $(brctl show | egrep -o "service-\w+")
do
    brctl delbr $bridge
done
