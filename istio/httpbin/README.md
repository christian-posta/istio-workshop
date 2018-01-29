 
FORTIO_POD=$(kubectl get pod | grep fortio | awk '{ print $1 }')
kubectl exec -it $FORTIO_POD  -c fortio /usr/local/bin/fortio -- load -c 2 -qps 0 -n 20 http://httpbin:8080/get
 