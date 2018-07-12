#!/bin/sh

ISTIO_DIST=${ISTIO_DIST:-./istio-release-1.0-20180710-09-15}

kubectl create -f $ISTIO_DIST/install/kubernetes/helm/helm-service-account.yaml

helm init --service-account tiller