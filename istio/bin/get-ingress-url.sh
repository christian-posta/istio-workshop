echo $(minishift ip):$(kubectl get svc/istio-ingress -n istio-system -o yaml | grep -i nodeport | head -n 1 | awk '{ print $2 }')
