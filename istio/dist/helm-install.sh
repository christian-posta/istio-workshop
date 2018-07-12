#!/bin/sh

ISTIO_DIST=${ISTIO_DIST:-./istio-release-1.0-20180710-09-15}

helm install --replace $ISTIO_DIST/install/kubernetes/helm/istio  --values values-install-$1.yaml --namespace istio-system --name $1
