#!/bin/sh

ISTIO_DIST=${ISTIO_DIST:-./istio-release-1.0-20180710-09-15}


helm install $ISTIO_DIST/install/kubernetes/helm/istio --debug --dry-run --values values-install-$1.yaml --namespace istio-system --name istio