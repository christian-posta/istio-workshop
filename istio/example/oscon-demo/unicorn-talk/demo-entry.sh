#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

SOURCE_DIR=$PWD

desc "Start a simple httpbin service"
run "docker run -d --name httpbin  citizenstig/httpbin"

desc "Verify we can reach the service"
run "docker run -it --rm --link httpbin tutum/curl curl -X GET http://httpbin:8000/headers"


desc "Let's look at a sample Envoy config file:"
run "docker run -it --rm --name proxy --link httpbin ceposta/envoy:v1.7.0 cat /etc/envoy/simple.yaml"

desc "Run the container:"
run "docker run -d --name proxy --link httpbin ceposta/envoy:v1.7.0 envoy -c /etc/envoy/simple.yaml"

desc "Look at the logs of the envoy container:"
run "docker logs proxy"

desc "Let's curl the proxy"
run "docker run -it --rm --link proxy tutum/curl curl  -X GET http://proxy:15001/headers"

desc "Let's restar the proxy with some configuration to do retries"
run "docker rm -f proxy"
run "docker run -it --rm --name proxy --link httpbin ceposta/envoy:v1.7.0 cat /etc/envoy/simple_retry.yaml"
run "docker run -d --name proxy --link httpbin ceposta/envoy:v1.7.0 envoy -c /etc/envoy/simple_retry.yaml"

desc "Let's see some of the envoy stats:"
run "docker run -it --rm --link proxy tutum/curl curl -X GET http://proxy:15000/stats"

desc "Let's curl the envoy statistics"
run "docker run -it --rm --link proxy tutum/curl curl -X GET http://proxy:15000/stats | grep retry"

desc "Let's make a call that throws an error:"
run " docker run -it --rm --link proxy tutum/curl curl -X GET http://proxy:15001/status/500"

desc "Now let's check our retry stats:"
run "docker run -it --rm --link proxy tutum/curl curl -X GET http://proxy:15000/stats | grep retry"

desc "clean up"
run "docker rm -f proxy httpbin"
