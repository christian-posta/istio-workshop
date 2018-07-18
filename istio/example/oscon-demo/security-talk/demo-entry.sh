#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh




SOURCE_DIR=$PWD



desc "We have our services running"
run "kubectl get pod"

desc "That v1 is taking some load..."
read -s

# split the screen and run the polling script in bottom script
tmux split-window -v -d -c $SOURCE_DIR
tmux select-pane -t 0
tmux send-keys -t 1 "sh $(relative bin/poll_customer.sh)" C-m

read -s
desc "Let's say we want to deploy a new version of our service, v2"

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
run "istioctl replace -f $(relative istio/recommendation-service-v1-v2-70-30.yml) -n tutorial"


