Quick notes setting up keycloak for use with this demo:

Admin un/pw:

admin/admin

Create a realm: istio
Create a client id: httpbin
Create a role: user
Create a user: demo/demo
Add "*" for redirect URLs and web origins for the coolstore-web-ui client-id

You could just use the configure script to set up all the right credentials.

Can get a JWT like this:

kubectl run -i --rm --restart=Never tokenizer --image=tutum/curl --command -- curl -X POST -vvvv 'http://keycloak.istio-samples:8080/auth/realms/istio/protocol/openid-connect/token' -H "Content-Type: application/x-www-form-urlencoded" -d 'username=demo&password=demo&grant_type=password&client_id=httpbin'



Make sure the at least first create a realm (this is a manual step)
