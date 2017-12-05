#!/usr/bin/env bash
minikube start --vm-driver=xhyve --memory=4096 --disk-size=30g --kubernetes-version=v1.7.5

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: istio-system
EOF