#!/bin/sh

source ./environment-vars.sh

helm upgrade --install --force istio $ISTIO_DIST/install/kubernetes/helm/istio --values ./values-install-$1.yaml --namespace istio-system
