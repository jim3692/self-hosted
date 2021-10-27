#!/bin/bash

for bridge in $(brctl show | egrep -o "${SERVER_BRIDGE_PREFIX}\w+")
do
    brctl delbr $bridge
done
