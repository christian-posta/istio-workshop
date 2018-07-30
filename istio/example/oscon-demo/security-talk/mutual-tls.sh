#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

# grafana: http://localhost:3000
# kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 


# jaeger: http://localhost:16686
# kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686



SOURCE_DIR=$PWD

desc "Let's capture traffic from customer->preference with tcpdump"
desc "We'll figure out the IP of the preference pod and watch traffic to/from there"
run "kubectl get pod"


PREF_POD_IP=$(kubectl get pod -o wide | grep pref | awk '{ print $6 }')
run "echo $PREF_POD_IP"

desc "We need to change the perms on the customer pod... brb..."

# split the screen and run the polling script in bottom script
tmux split-window -v -d -c $SOURCE_DIR
tmux select-pane -t 1
tmux send-keys -t 1 "kubectl edit deploy customer" C-m
read -s 


backtotop

desc "let's capture traffic"
CUSTOMER_POD=$(kubectl get pod | grep cust | awk '{ print $1}' )
kubectl exec $CUSTOMER_POD -c istio-proxy -- sh -c 'rm /opt/output*.* > /dev/null 2>&1'
run "kubectl exec -it $CUSTOMER_POD  -c istio-proxy -- sh -c \"sudo tcpdump -i eth0 '((tcp) and (net $PREF_POD_IP))' -w /opt/output.pcap\""


desc "Let's copy the pcap file over to our local machine so we can take a look"
rm -f ~/temp/output.pcap > /dev/null 2>&1
run "kubectl cp -c istio-proxy istio-samples/$CUSTOMER_POD:opt/output.pcap /Users/ceposta/temp/output.pcap"

backtotop

desc "now let's enable mtls"
run "cat $(relative istio/meshpolicy.yaml)"
run "cat $(relative istio/default-destrule.yaml)"
run "istioctl create -f $(relative istio/meshpolicy.yaml)"
run "istioctl create -f $(relative istio/default-destrule.yaml)"

backtotop

desc "Let's capture traffic again"
kubectl exec $CUSTOMER_POD -c istio-proxy -- sh -c 'rm /opt/output*.* > /dev/null 2>&1'
run "kubectl exec -it $CUSTOMER_POD  -c istio-proxy -- sh -c \"sudo tcpdump -i eth0 '((tcp) and (net $PREF_POD_IP))' -w /opt/output.pcap\""


desc "Let's copy the pcap file over to our local machine so we can take a look"
rm -f ~/temp/output-tls.pcap > /dev/null 2>&1
run "kubectl cp -c istio-proxy istio-samples/$CUSTOMER_POD:opt/output.pcap /Users/ceposta/temp/output-tls.pcap"
