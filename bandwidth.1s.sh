#!/usr/bin/env bash

INTERFACE=enp0s31f6

echo "$(ifstat -n -w -i $INTERFACE 0.1 1 | tail -n 1 | awk '{print $1, "Mbps ⇌",$2;}')Mbps"
