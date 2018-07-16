#!/bin/sh

source ./environment-vars.sh

kubectl create -f $ISTIO_DIST/install/kubernetes/helm/helm-service-account.yaml

helm init --service-account tiller