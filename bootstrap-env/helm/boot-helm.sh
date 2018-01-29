#!/bin/sh
ROOT=$(cd $(dirname $0); pwd)

kubectl apply -f $ROOT/helm-service-account.yaml -n kube-system --validate=false

helm init --tiller-namespace kube-system --service-account tiller



