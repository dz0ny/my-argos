#!/usr/bin/env bash
#
# Displays the status of docker containers

echo "⚓️ | dropdown=false"
echo "---"

DOCKER_NATIVE="$(which docker)"

if test -z "$DOCKER_NATIVE"; then
  echo "No docker found"
  exit 0
fi

if [ -n "$DOCKER_NATIVE" ]; then
  MACHINE="$($DOCKER_NATIVE -v)"
  echo "$MACHINE"
fi

CONTAINERS="$($DOCKER_NATIVE ps -a --format "{{.Names}} ({{.Image}})|{{.ID}}|{{.Status}}")"

if [ -n "$CONTAINERS" ]; then
      echo "${CONTAINERS}" | while read -r CONTAINER; do
      CONTAINER_NAME=$(echo "$CONTAINER" | awk -F"|" '{print $1}')
      CONTAINER_ID=$(echo "$CONTAINER" | awk -F"|" '{print $2}')
      CONTAINER_STATE=$(echo "$CONTAINER" | awk -F"|" '{print $3}')
      SYM="💻 "
      echo "$SYM $CONTAINER_NAME  | dropdown=true"
      case "$CONTAINER_STATE" in
        *Up*) 
          echo "-- Stop | color=orange bash=$DOCKER_NATIVE param1=stop param2=$CONTAINER_ID terminal=false refresh=true"
          echo "-- Shell | color=green bash=$DOCKER_NATIVE param1=exec param2=-it param3=$CONTAINER_ID param4=bash terminal=true refresh=true"
        ;;
        *)
          echo "-- Start | color=green bash=$DOCKER_NATIVE param1=start param2=$CONTAINER_ID terminal=false refresh=true"
          echo "-- Delete | color=red bash=$DOCKER_NATIVE param1=rm param2=$CONTAINER_ID terminal=false refresh=true"
	;;
      esac
    done
else
  echo "No running containers"
fi
  echo "⟳ Refresh | refresh=true"
