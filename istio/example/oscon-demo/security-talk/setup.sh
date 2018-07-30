#!/bin/sh
kubectl create -f kube/keycloak-deployment.yaml
kubectl create -f kube/keycloak-svc.yaml

istioctl create -f istio/default-gateway.yaml
istioctl create -f istio/keycloak-virtualservice-for-customer.yaml
