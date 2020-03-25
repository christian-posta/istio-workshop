#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh


SOURCE_DIR=$PWD

desc "Run a simple httpbin service"
run "docker run -itd --name httpbin --rm citizenstig/httpbin"

desc "Try curl the httpbin service"
run "docker run -it --rm --link httpbin tutum/curl curl -X GET http://httpbin:8000/headers"


desc "Checkout envoy!"
run "docker run -it --rm envoyproxy/envoy:v1.10.0 envoy --help"

desc "Try running it"
run "docker run -it --rm envoyproxy/envoy:v1.10.0 envoy"

desc "Go checkout simple config file"
read -s
backtotop


desc "Run envoy with a config file"
read -s


# split the screen and run the polling script in bottom script
tmux split-window -v -d -c $SOURCE_DIR
tmux select-pane -t 0
tmux send-keys -t 1 "docker run -it --rm --name proxy --link httpbin ceposta/envoy:v1.10.0 envoy -c /etc/envoy/simple.yaml" C-m

read -s
desc "Try curl the envoy proxy now"
run "docker run -it --rm --link proxy tutum/curl curl  -X GET http://proxy:15001/headers"

desc "Let's add retries"
tmux send-keys -t 1  C-c
read -s
tmux send-keys -t 1 "docker run -it --rm --name proxy --link httpbin ceposta/envoy:v1.10.0 envoy -c /etc/envoy/simple_retry.yaml" C-m

read -s
desc "Now let's call and expect a failure"
run "docker run -it --rm --link proxy tutum/curl curl -X GET http://proxy:15001/status/500"


desc "Check the envoy stats"
run "docker run -it --rm --link proxy tutum/curl curl -X GET http://proxy:15000/stats | grep retry"


desc "clean up"
tmux send-keys -t 1  C-c
run "docker rm httpbin -f"