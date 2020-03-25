#!/bin/sh
kubectl apply -f kube/keycloak-deployment.yaml
kubectl apply -f kube/keycloak-svc.yaml

kubectl apply -f istio/default-gateway.yaml
kubectl apply -f istio/keycloak-virtualservice-for-customer.yaml
