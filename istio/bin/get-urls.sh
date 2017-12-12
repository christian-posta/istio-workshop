#!/usr/bin/env bash


GATEWAY_URL=$(kubectl get po -l istio=ingress -n istio-system -o jsonpath={.items[0].status.hostIP}):$(kubectl get svc istio-ingress -n istio-system -o jsonpath={.spec.ports[0].nodePort})

echo "Istio Ingress URL: $GATEWAY_URL"



# Let's find the dashboard URL
GRAFANA_HOST=$(oc get pod -n istio-system $(oc get pod -n istio-system | grep -i running | grep grafana | awk '{print $1 }') -o yaml | grep hostIP | cut -d ':' -f2 | xargs)
GRAFANA_PORT=$(oc get svc/grafana -n istio-system -o yaml | grep nodePort | cut -d ':' -f2 | xargs)
ISTIO_GRAFANA_URL=http://$GRAFANA_HOST\:$GRAFANA_PORT/dashboard/db/istio-dashboard

echo "Istio Grafana: $ISTIO_GRAFANA_URL"




SERVICE_GRAPH=$(kubectl get po -l app=servicegraph -n istio-system -o jsonpath={.items[0].status.hostIP}):$(kubectl get svc servicegraph -n istio-system -o jsonpath={.spec.ports[0].nodePort})
SERVICE_GRAPH_URL=http://$SERVICE_GRAPH/dotviz

echo "Istio Service Graph: $SERVICE_GRAPH_URL"



ZIPKIN_HOST=$(oc get pod -n istio-system $(oc get pod -n istio-system | grep -i running | grep zipkin | awk '{print $1 }') -o yaml | grep hostIP | cut -d ':' -f2 | xargs)
ZIPKIN_PORT=$(oc get svc/zipkin -n istio-system -o yaml | grep nodePort | cut -d ':' -f2 | xargs)
ISTIO_ZIPKIN_URL=http://$ZIPKIN_HOST\:$ZIPKIN_PORT/

echo "Istio Zipkin: $ISTIO_ZIPKIN_URL"
