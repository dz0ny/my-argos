#!/bin/bash


STATUS="$(nordvpn status)"

STATUS_CONNECTED=$(echo $STATUS | awk '{print $2}') # Lazy and quick way
STATUS_COUNTRY=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="Country:") print $(i+1)}')
STATUS_CITY=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="City:") print $(i+1)}')
STATUS_IP=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="IP:") print $(i+1)}')
STATUS_PROTOCOL=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="protocol:") print $(i+1)}')
STATUS_SERVER_NAME=$(echo $STATUS | awk '{for(i=1;i<=NF;i++) if ($i=="server:") print $(i+1)}')


# icon
echo "🌈"

# menu
echo "---"

if [[ $STATUS_CONNECTED == "Connected" ]]; then
	COUNTRY_FLAG=$(curl -s \
	"https://public-us.opendatasoft.com/explore/dataset/country-flags/files/$(curl -s \
	"https://public-us.opendatasoft.com/api/records/1.0/search/?dataset=country-flags&q=$STATUS_COUNTRY&facet=country" \
	| jq -r '.records[0].fields.flag.id')/300/" | base64 -w 0)
  echo "<span color='#54a546'>Connected to:</span> <b>$STATUS_COUNTRY</b> | image='$COUNTRY_FLAG'\
    imageWidth=25"
  echo "IP: <span color='#54a546'>$STATUS_IP</span>"
else
  echo -e "<span color='red'>Disconnected</span>"
  echo "IP: <span color='red'>$(curl -s ident.me)</span>"
fi


echo "---"

if [[ $STATUS_CONNECTED == "Disconnected" ]]; then
  echo "Quick connect | bash='nordvpn c && sleep 1' terminal=false refresh=true"
else
  echo "Disconnect | bash='nordvpn d && sleep 1' terminal=false refresh=true"
fi

echo "Dedicated"
echo "--Germany | bash='nordvpn d ;nordvpn c de545 && sleep 5' terminal=false trim=true refresh=true"
echo "--United States | bash='nordvpn d ;nordvpn c us2928 && sleep 5' terminal=false trim=true refresh=true"

# Start country list submenu
echo "Connect to"

for country in $(nordvpn countries); do
  echo "--$(echo $country | awk '{gsub(/,/,""); gsub(/_/," "); print;}')\
    | bash='nordvpn d ;nordvpn c $(echo $country | awk '{gsub(/,/,""); print}') && sleep 5' terminal=false\
      trim=true refresh=true"
done
# End of country list

echo "---"
