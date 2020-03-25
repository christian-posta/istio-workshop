#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

# grafana: http://localhost:3000
# kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 


# jaeger: http://localhost:16686
# kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686



SOURCE_DIR=$PWD
#URL=$(k get pod -n istio-system -l istio=ingressgateway -o jsonpath='{.items[0].status.hostIP}'):$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
URL=$(kubectl get svc -n istio-system | grep ingressgateway | awk '{print $4}')
#URL=oscondemo
echo "URL to use $URL"
read -s

desc "We can call customer:"
read -s 
tmux send-keys -t 1 "curl $URL" C-m
read -s

desc "Let's add a new policy on customer to require a JWT auth token"
run "cat $(relative istio/customer-jwt-policy-keycloak.yaml)"

desc "Let's create this policy"
run "kubectl apply -f $(relative istio/customer-jwt-policy-keycloak.yaml)"

desc "We should wait a few moments for the changes to propagate"
read -s

desc "Now let's try call the customer service again"
tmux send-keys -t 1 "curl -vvvv $URL" C-m

desc "Ouch! we got denied!"
read -s 
desc "Let's call with a JWT token"
desc "We'll ask keycloak for a token:"
TOKEN=$(kubectl run -i --rm --restart=Never tokenizer --image=tutum/curl --command -- curl -s -X POST 'http://keycloak.default:8080/auth/realms/istio/protocol/openid-connect/token' -H "Content-Type: application/x-www-form-urlencoded" -d 'username=demo&password=demo&grant_type=password&client_id=httpbin'  | jq .access_token | sed 's/\"//g')
echo $TOKEN

read -s


desc "Now let's try calling again with the token!"
read -s 

tmux send-keys -t 1 "curl -vvvv --header \"Authorization: Bearer $TOKEN\" $URL" C-m

