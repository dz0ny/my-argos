#!/bin/bash


STATUS="$(nordvpn status)"

STATUS_CONNECTED=$(echo $STATUS | awk '{print $2}') # Lazy and quick way
STATUS_COUNTRY=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="Country:") print $(i+1)}')
STATUS_CITY=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="City:") print $(i+1)}')
STATUS_IP=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="IP:") print $(i+1)}')
STATUS_PROTOCOL=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="protocol:") print $(i+1)}')
STATUS_SERVER_NAME=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="server:") print $(i+1)}')
STATUS_UPTIME=$(nordvpn status | grep -m1 "Uptime:")
STATUS_TRRX=$(nordvpn status | grep -m1 "Transfer:")

# icon
echo "🌈"

# menu
echo "---"

if [[ $STATUS_CONNECTED == "Connected" ]]; then

  echo "<span color='green'>Connected to:</span> <b>$STATUS_COUNTRY</b>"
  echo "<span color='green'>$STATUS_PROTOCOL: <b>$STATUS_IP</b></span>"
  echo "<span color='green'>$STATUS_UPTIME</span>"
  echo "<span color='green'>$STATUS_TRRX</span>"
elif [[ $STATUS_CONNECTED == "Connecting" ]]; then
  echo -e "<span color='orange'>Connecting</span>"
else
  echo -e "<span color='red'>Disconnected</span>"
fi


echo "---"

if [[ $STATUS_CONNECTED == "Disconnected" ]]; then
  echo "Quick connect | bash='nordvpn c' terminal=false refresh=true"
else
  echo "Disconnect | bash='nordvpn d' terminal=false refresh=true"
fi

echo "Dedicated"
echo "--Germany | bash='nordvpn d ;nordvpn c de545' terminal=false trim=true refresh=true"
echo "--United States | bash='nordvpn d ;nordvpn c us2928' terminal=false trim=true refresh=true"

# Start country list submenu
echo "Connect to"

for country in $(nordvpn countries); do
  echo "--$(echo $country | awk '{gsub(/,/,""); gsub(/_/," "); print;}')\
    | bash='nordvpn d ;nordvpn c $(echo $country | awk '{gsub(/,/,""); print}')' terminal=false\
      trim=true refresh=true"
done
