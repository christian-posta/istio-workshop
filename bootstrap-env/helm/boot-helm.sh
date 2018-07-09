#!/bin/sh
ROOT=$(cd $(dirname $0); pwd)

kubectl apply -f $ROOT/helm-service-account.yaml -n kube-system --validate=false

helm init --tiller-namespace kube-system --service-account tiller

echo "Grant the Tiller server edit access to the current project"
echo "oc policy add-role-to-user edit system:serviceaccount:${TILLER_NAMESPACE}:tiller"
