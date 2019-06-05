#!/usr/bin/env bash
#
# Displays the status of stores

echo "🛒 | dropdown=false"
echo "---"
export KUBECONFIG=/home/dz0ny/woocart-app/k8s/cluster/showcase/admin.conf

CONTAINERS=$(kubectl get statefulsets -l "woocart=web" --all-namespaces -o json -o go-template='{{range .items}}{{.metadata.name}} {{.metadata.namespace}} {{.status.readyReplicas}} {{"\n"}}{{end}}')

if [ -n "$CONTAINERS" ]; then
    echo "${CONTAINERS}" | while read -r CONTAINER; do
      NAME=$(echo "$CONTAINER" | awk '{print $1}')
      NAMESPACE=$(echo "$CONTAINER" | awk '{print $2}')
      STATUS=$(echo "$CONTAINER" | awk '{print $3}')
      SYM=""
      case "$STATUS" in
        *1*) 
          echo "$SYM ${NAME::-4} | dropdown=true color=green";;
        *)
          echo "$SYM ${NAME::-4} | dropdown=true color=red";;
      esac
      echo "-- Dasboard | href="https://app.woocart.com/stores/$NAMESPACE" terminal=false refresh=true"
      echo "-- GKE Console | href="https://console.cloud.google.com/kubernetes/statefulset/europe-west3-b/showcase/$NAMESPACE/$NAME?project=woocart-191408" terminal=false refresh=true"
      echo "-- Shell | bash=kubectl param1="exec $NAME-0 -it --namespace $NAMESPACE -- shell" terminal=true refresh=true"
      echo "-- Logs | href="https://console.cloud.google.com/logs/viewer?interval=PT1H&project=woocart-191408&minLogLevel=0&expandAll=false&timestamp=2019-06-02T11:09:32.957000000Z&customFacets=&limitCustomFacetWidth=true&advancedFilter=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id%3D%22woocart-191408%22%0Aresource.labels.location%3D%22europe-west3-b%22%0Aresource.labels.cluster_name%3D%22showcase%22%0Aresource.labels.namespace_name%3D%22$NAMESPACE%22%0Aresource.labels.pod_name%3D%22$NAME-0%22%0Aresource.labels.container_name%3D%22web%22&dateRangeStart=2019-06-02T10:09:32.955Z&dateRangeEnd=2019-06-02T11:09:32.955Z" terminal=false refresh=true"
      echo "-- Config | href="https://console.cloud.google.com/kubernetes/configmap/europe-west3-b/showcase/$NAMESPACE/store-config?project=woocart-191408" terminal=false refresh=true"

    done
else
  echo "No running containers"
fi
  echo "⟳ Refresh | refresh=true"
