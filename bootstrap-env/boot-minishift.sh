#!/usr/bin/env bash

## initial bootstrap
export XHYVE_EXPERIMENTAL_NFS_SHARE=true
minishift start --memory=4096 --disk-size=30g --openshift-version=v3.7.0

## login as admin
oc login -u system:admin


## relax some of the default security context in openshift to allow istio components to run
# Many thanks Veer Muchandi
# https://github.com/VeerMuchandi/istio-on-openshift/blob/master/DeployingIstioWithOcclusterup.md
oc new-project istio-system
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-egress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z default -n istio-system

# our sample project will be in this namespace
oc adm policy add-scc-to-user privileged -z default -n istio-samples