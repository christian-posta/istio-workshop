#!/bin/sh

source ./environment-vars.sh

helm upgrade --install --force istio $ISTIO_DIST/install/kubernetes/helm/istio --namespace istio-system
