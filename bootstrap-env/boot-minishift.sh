#!/usr/bin/env bash

## initial bootstrap
export XHYVE_EXPERIMENTAL_NFS_SHARE=true
minishift addon enable admin-user
minishift start --memory=4096 --disk-size=30g --openshift-version=v3.9.0-alpha.3


## login as admin
#  oc adm policy add-cluster-role-to-user cluster-admin admin --as=system:admin
#  docker exec -it $(docker ps | grep origin:v3.7.0 | awk '{ print $1}') sh -c " oc adm policy add-cluster-role-to-user cluster-admin admin --as=system:admin"
oc login -u system:admin


## relax some of the default security context in openshift to allow istio components to run
# Many thanks Veer Muchandi
# https://github.com/VeerMuchandi/istio-on-openshift/blob/master/DeployingIstioWithOcclusterup.md
oc new-project istio-system
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z default -n istio-system

# our sample project will be in this namespace
oc adm policy add-scc-to-user privileged -z default -n istio-samples
oc adm policy add-scc-to-user privileged -z default -n tutorial
