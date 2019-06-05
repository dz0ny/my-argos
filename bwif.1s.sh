#!/usr/bin/env bash

# <bitbar.title>Bandwidth (Mbit/s)</bitbar.title>
# <bitbar.version>v0.0.1</bitbar.version>
# <bitbar.author>Kaspars Mickevics</bitbar.author>
# <bitbar.author.github>fxlv</bitbar.author.github>
# <bitbar.desc>Displays bandwidth usage for the primary interface in Megabits/s</bitbar.desc>
# <bitbar.dependencies>ifstat</bitbar.dependencies>
# <bitbar.image>https://cloud.githubusercontent.com/assets/2462211/12748504/584bbcea-c9b3-11e5-8109-ad8fdcefdc75.png</bitbar.image>

# based on bandwidth.1s.sh by Ant Cosentino

# only gather stats from interface en0
# no need to samlpe unused interfaces
INTERFACE="wlp58s0"


function get_iw {
    interface=$1
    # 1 sample for 0.5 second interval
    # outputs two values (in/out) in kilobits per second
   iw dev "${interface}" link
}

function print_signal {
    signal=$(echo "$1"  | tail -n7 | head -n1 | awk '{ print $2 }')
    echo "$signal"
}

function print_rxtx {
    tx=$(echo "$1"  | tail -n6 | head -n1 | awk '{ print $3 }')
    rx=$(echo "$1"  | tail -n5 | head -n1 | awk '{ print $3 }')
    echo "TX: $tx Mbit/s"
    echo "RX: $rx Mbit/s"
}
data="$(get_iw ${INTERFACE})"
print_signal "$data"
echo "---"
print_rxtx "$data"

