#!/bin/sh

ISTIO_DIST=${ISTIO_DIST:-./istio-release-1.0-20180710-09-15}

helm upgrade --install --force istio $ISTIO_DIST/install/kubernetes/helm/istio --values ./values-install-$1.yaml --namespace istio-system


#helm upgrade --install --force istio istio-release-1.0-20180710-09-15/install/kubernetes/helm/istio --namespace istio-system