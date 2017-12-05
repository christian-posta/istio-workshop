#!/usr/bin/env bash

# Many thanks Veer Muchandi
# https://github.com/VeerMuchandi/istio-on-openshift/blob/master/DeployingIstioWithOcclusterup.md
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-egress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z default -n istio-system