#!/bin/bash 

POD=$(kubectl get pod | grep httpbin | cut -d ' ' -f 1)
kubectl label pod $POD version=v1
istioctl create -f route-rule-httpbin.yaml
