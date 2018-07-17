#!/bin/bash

kubectl delete meshpolicy --all
kubectl delete destinationrule --all
kubectl delete destinationrule --all -n default

