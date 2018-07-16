#!/bin/sh

source ./environment-vars.sh


helm install $ISTIO_DIST/install/kubernetes/helm/istio --debug --dry-run --values values-install-$1.yaml --namespace istio-system --name istio