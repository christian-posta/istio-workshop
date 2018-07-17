#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh




SOURCE_DIR=$PWD



desc "We have our services running"
run "kubectl get pod"

read -s
desc "Let's say we want to deploy a new version of our service, v2"

read -s

desc "we will create a new deployment and inject the Istio sidecar. Let's take a look at what that looks like:"

run "cat $(relative kube/recommendation-v2-deployment.yml)"
run "istioctl kube-inject  -f $(relative kube/recommendation-v2-deployment.yml)"

desc "Okay. let's actually create it:"
read -s
run "kubectl apply -f <(istioctl kube-inject -f $(relative kube/recommendation-v2-deployment.yml))"

run "kubectl get pod -w"


backtotop

desc "Woah: we don't want this. We dont want to release this version"
read -s

# show routing?
#
# everything to v1?
desc "Let's route everything to v1"
run "istioctl create -f $(relative istio/recommendation-service-all-v1.yml) -n tutorial"


desc "Using Istio, let's purposefully balance traffic between v1 and v2"
run "istioctl replace -f $(relative istio/recommendation-service-v1-v2-50-50.yml) -n tutorial"


