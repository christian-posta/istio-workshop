#!/bin/sh

ISTIO_DIST=${ISTIO_DIST:-./istio-release-1.0-20180710-09-15}

helm upgrade --install --force istio $ISTIO_DIST/install/kubernetes/helm/istio --namespace istio-system
