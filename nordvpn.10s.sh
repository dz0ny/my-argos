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

if [[ $STATUS_CONNECTED == "Connected" ]]; then
  # icon
  # curl -s 'https://s1.nordcdn.com/nordvpn/media/1.170.0/images/global/favicon/apple-touch-icon-57x57.png' | convert png:- -resize 20x25 png:- | base64 -w 0
  echo " | image=iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABmJLR0QA/wD/AP+gvaeTAAACTElEQVQ4y5XTsWvdVRjG8c977u+GKqEYkJRmzFKXopMFLYgOXeogxKUi2SooOOp/0KW61JgWXAoSHCyFDB0c4tJBqNSi6SRGoaDVqkjaijW9v3teh9+tJLe5NT5wlsN5vjzv83LCI/T6xXMgmiyQbVRYWXhzoifGLxZXz0qa4FCK53BY5CzI+BXXQ36Bb9F+/MpbO4GvXTpL0rRhmJTiMN4OXsYBoexwpIpbySUs1er6vjbce7xC97g/CBlKKU5gNTgpHHwI1s1UhIPBSayW4sT9qSxXn9nsgI/9XdRewiKWI8w/XMTuZUWYxzK5+OzVJ/QHoQyaKtLRkKcizOwBtZPbeU4VjmakkmJ/indFzE0yZbqT6c5kaMyleCfF/oJjeHFihJRYwoeZjwz7Eo41WIgwPZnna5zrWnMcT08YfTrTQsGRXUbMTF9m+oU8E/wU/IilTLcyXcku+biONNitu+/wBl4lvtp2fxFP4TMs49CYb66gP5ZugA/wDVa6qRk0VbCJT7CBM6O329UvuDt2uYaV+DdpbmxNVSG8cOVJWBdujsBrY94/S/D9tnS/43Rwe9BUwybrsLHVqx3+8+d/0zY5bHs5CG7j9MjzQBslWRstAc6Tl/uDEBO+S4zOzdkt5GWcz+wWibWCC/gZ61gOUe/tq/5Ls39MCVFHy1kfMS40uIaP8ENwoyt/L5+5W1S/LTeS9zGPa01Qk/cwnL7bszmTe4J144dSGRafoldSbdom4S/YnGn3DHug+/2UJbcSpYbmfxN22VLkqKTgH7jK56fCM3duAAAAAElFTkSuQmCC"
else
  echo " | image=iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAZiS0dEAP8A/wD/oL2nkwAAAwZJREFUOMuVlF+IVHUUxz/f37137t2ddly3dVgLH3KJ7SFJMokSFoUVopcKH3qSHiNCBOtJrAeFDWMR1mXtwSdBAlHoqQhG0BY0QtK2LFpYkxbW8h/NlKtzZ+69p4eZ6s60I/WFH/w45/f7nu/v/M45iopl2hBgZkbSuEeaPOCFPd8iF8j5Bd8VimSNBwlgl4+P04xrOC9EEnkoT5glsU1MVYmrcSDnj4G2STxtaLgd8Y6ZXQW7kGXNhb7BqFl5dxDnh52EZkZ8/zYv7r2q/nVjz+C8twUvAyOAoxMZ8KvBZ1g6e//Wj/MXpzdZ2L8OSQhg52QG4AGvAweBUWvnYDXkfNeA94FTQFrZ71rR67VlgN3ADDDKQ8i6fKPtO7vbHLjDZoSlkXHgEDDE/8cQcCgsjYzPmOGltm/QC6IPga29bhj8DsSCsMeRkuQe/f5s7XPnhcUJYIf1VmBgx1oL63EAYIcXDkz4yO0CBjpypjZNa3uFNP0IAc5/CdjcnVC1GAeQ2+UEW1YJmQGXBDeA6b7hYClcGywBx4BfgEu0yqdDs2CLD2zoLhGDRSx7S9IroMv1KliWApyRtNGMc0hHBWP5Zws2OKCgnBFoCGYk97WZnTQzA2iu3EXO+82MU5IWBEeBhv2jDiBwQI1OY8UsO2mWYWmymNRri6XH4avpTWAgue9AN8zSjw0qXWJqPrCI2VYDJN0BjghXLZTEp3v8DIj/CljZL4D02Tc+SYeferVqWXYE6XkzGxaAdM03OC/pudZn2YnGHzfn5j54jKhYJjc4OvDDmTepr7zG9vfuzgV9a09Iegcwg/PO0uZpg2WDeUubs19Mrk+iYlntDPRcUbGscweHkixtzBrMGyxb2jzt15a+vDL4xPhxzH46eyC8HkZr5PzoYa38N8JoDXG9dn3nZDaFtLH288VvBGj7gdv9zXo1vTD1ZNw1cFdrCuWrr75yi237FkIvKvlzk+tXFBbLShr3zMmTF/T9F2H/QprEYBnOj/AFFhQeySvIQ/To37zfy03sPwG6KjeZviQWSQAAAABJRU5ErkJggg=="
fi

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
