#!/bin/sh

source ./environment-vars.sh

helm install --replace $ISTIO_DIST/install/kubernetes/helm/istio  --values values-install-$1.yaml --namespace istio-system --name istio



#helm upgrade --install --force istio install/kubernetes/helm/istio --values ./values-install-$1.yaml
