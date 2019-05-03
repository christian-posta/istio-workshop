FROM envoyproxy/envoy:v1.9.0
MAINTAINER Christian Posta (christian.posta@gmail.com)

COPY conf/**.yaml /etc/envoy/

CMD /usr/local/bin/envoy --v2-config-only -l $loglevel -c /etc/envoy/envoy.yaml