#!/bin/sh

source ./environment-vars.sh
echo "Installing from: $ISTIO_DIST"
helm upgrade --install --force istio $ISTIO_DIST/install/kubernetes/helm/istio --namespace istio-system
