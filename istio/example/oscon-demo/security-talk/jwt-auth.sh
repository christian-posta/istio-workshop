#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

# grafana: http://localhost:3000
# kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 


# jaeger: http://localhost:16686
# kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686



SOURCE_DIR=$PWD

desc "We can call customer:"
read -s 
tmux send-keys -t 1 "curl http://oscondemo" C-m
read -s

desc "Let's add a new policy on customer to require a JWT auth token"
run "cat $(relative istio/customer-jwt-policy.yaml)"

desc "Let's create this policy"
run "istioctl create -f $(relative istio/customer-jwt-policy.yaml)"

desc "We should wait a few moments for the changes to propagate"
read -s

desc "Now let's try call the customer service again"
tmux send-keys -t 1 "curl -vvvv http://oscondemo" C-m

desc "Ouch! we got denied!"
read -s 
desc "Let's call with a JWT token"
pushd ~/go/src/istio.io/istio/security/tools/jwt
TOKEN=$(python ./sa-jwt.py  -iss test-jwt-sa@istio-test-jwt.iam.gserviceaccount.com -aud foo,bar ~/Downloads/istio-test-jwt-b4a756530705.json)
echo $TOKEN
popd

desc "Now let's try calling again with the token!"
read -s 

tmux send-keys -t 1 "curl -vvvv --header \"Authorization: Bearer $TOKEN\" http://oscondemo" C-m

