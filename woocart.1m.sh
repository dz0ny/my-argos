#!/usr/bin/env bash
#
# Displays the status of stores

echo "| image=iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABmJLR0QA/wD/AP+gvaeTAAADS0lEQVQ4y52TTWjcVRTFf+f9/zNJJ0kZ0o/Q2toaRI2RKlhp2qoURLpJXFi6EAQriIIk1L2g4kJctFiNLnTTUsGFoCh+0IK2WbSJpQGVTkSbtiRSm6r1KykZ5+P/jouZSAc/EO/qvXvPO/ece3l69dYqZEAnkAeA4Ynm4X+ERgcqTwNrgE6hOePPMKeBSyOn2v718St3RsjVujErQEiOGh2olIB+IRC2nYEOE/UkcmXk1N+rPdx3jitpnlxHz4vAwyCDvwlIn4N+Ml6wLUkpeItD3GD5H9XNL19PvtCzErhX0nWS1wFTqWCf4SBwG/As0A3cKLiFEM6Obq4yU8qxcVO1neCQBRaDwRGAfqC32eMXYCwMT+S/lHVM6KCgBEaoDdjuWgyksOGOegeB50H7kix0EwO5tAbidqDHGJtzgskA4BCpy1ctjhkwBrjbUmeSBkQcQjwB2oN46KqhWs8VgO2SaMCZzJeTiwEghpTUNuaEzLwkgI1JcF9Wra8H9gLLJZaBR7oUN0msBDYDCKqCTyuF6ACw92SCEcDXhlITtNpwD0GPAXepUQe4GWkY2CFY1czNYL7AkC6hshBZaJv/rlguTtreJinF3gOskkhs/wYESV3GD2K2WRSadickLgkTlgifGl9GsVwEGEMsNNP9wGqbDHgD2I9dF6yQ6Bck4AowbqtMcg1h0yaC05iLAM1ZAkwivQZ+3XDcbiIbMWcYt8zwyfZWQhti5EfghN24A78CB9rrcTY1lw37wT/YXqqXopjOms3TFoUxQfmsQqa3jbqaMs7YfFCWUGJkH8d6AcJWIILfzeVrFVdzf7psiQfuexRQcFrrgawoMxtSFt/7+C0Ahu5/BFAg1HqAYkZlprcwWC4tHGLsk7FWwl07drPYlpBEb7X0kuB6w6EYwnPgaogZKAF7ADEKrMW8iWrPIKofHXmndYaVfEISHZAGBVuQ1oB2KfomxYahrF4TMIS1WWgtsBunNxATgFbCiElCWzTMGn63jfD3AV8JGFsU2lMDM+Bqcytztn5244+QXEs4fX6K3t4+DBckZoEp4Zcvd3ecffz9EkfW5ekI7dhckPgW+Ap8oJZk0wli+vzUX5cCMLhzZ8v9w6NH/3P9D7/wctSY8Vh5AAAAAElFTkSuQmCC"
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
      echo "-- Namespace: $NAMESPACE | bash=bash param1=-c param2='echo $NAMESPACE | xclip -sel clip' terminal=false refresh=true"
      echo "-- Kubectl CP: $NAMESPACE | bash=bash param1=-c param2='echo kubectl cp . $NAMESPACE/$NAME-0:/var/www/content.tar.gz| xclip -sel clip' terminal=false refresh=true"
      echo "-- Dasboard | href="https://app.woocart.com/stores/$NAMESPACE" terminal=false refresh=true"
      echo "-- GKE Console | href="https://console.cloud.google.com/kubernetes/statefulset/europe-west3-b/showcase/$NAMESPACE/$NAME?project=woocart-191408" terminal=false refresh=true"
      echo "-- Workloads | bash=fish param1=-c param2='xdg-open \"https://console.cloud.google.com/kubernetes/workload?project=woocart-191408&workload_list_tablesize=50&workload_list_tablequery=%255B%257B_22k_22_3A_22is_system_22_2C_22t_22_3A10_2C_22v_22_3A_22_5C_22false_5C_22_22_2C_22s_22_3Atrue%257D_2C%257B_22k_22_3A_22metadata%252Fnamespace_22_2C_22t_22_3A10_2C_22v_22_3A_22_5C_22${NAMESPACE}_5C_22_22%257D%255D\"' terminal=false refresh=true"
      echo "-- Services | bash=fish param1=-c param2='xdg-open \"https://console.cloud.google.com/kubernetes/discovery?project=woocart-191408&service_list_tablesize=50&service_list_tablequery=%255B%257B_22k_22_3A_22is_system_22_2C_22t_22_3A10_2C_22v_22_3A_22_5C_22false_5C_22_22_2C_22s_22_3Atrue%257D_2C%257B_22k_22_3A_22metadata%252Fnamespace_22_2C_22t_22_3A10_2C_22v_22_3A_22_5C_22${NAMESPACE}_5C_22_22_2C_22s_22_3Atrue%257D%255D\"' terminal=false refresh=true"
      echo "-- Shell | bash=fish param1=-c param2='kubectl exec $NAME-0 -it --namespace $NAMESPACE -- shell' terminal=true refresh=true"
      echo "-- INIT Shell | bash=fish param1=-c param2='kubectl exec $NAME-init-0 -it --namespace $NAMESPACE -- shell' terminal=true refresh=true"
      echo "-- CLI Shell | bash=fish param1=-c param2='kubectl exec cli-0 -it --namespace $NAMESPACE -- bash' terminal=true refresh=true"
      echo "-- Logs | bash=fish param1=-c param2='xdg-open \"https://console.cloud.google.com/logs/viewer?interval=PT1H&project=woocart-191408&minLogLevel=0&expandAll=false&timestamp=2019-06-02T11:09:32.957000000Z&customFacets=&limitCustomFacetWidth=true&advancedFilter=resource.type%3D%22k8s_container%22%0Aresource.labels.project_id1%3D%22woocart-191408%22%0Aresource.labels.location%3D%22europe-west3-b%22%0Aresource.labels.cluster_name%3D%22showcase%22%0Aresource.labels.namespace_name%3D%22$NAMESPACE%22%0Aresource.labels.pod_name%3D%22$NAME-0%22%0Aresource.labels.container_name%3D%22web%22&dateRangeStart=2019-06-02T10:09:32.955Z&dateRangeEnd=2019-06-02T11:09:32.955Z\"' terminal=false refresh=true"
      echo "-- Config | bash=fish param1=-c param2='xdg-open \"https://console.cloud.google.com/kubernetes/configmap/europe-west3-b/showcase/$NAMESPACE/store-config?project=woocart-191408\"' terminal=false refresh=true"

    done
else
  echo "No running containers"
fi
  echo "⟳ Refresh | refresh=true"
