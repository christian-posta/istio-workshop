var request = require('request');
var sso_service_url = (process.env.SSO_SERVICE_URL || "http://localhost:8080"),
    realm = (process.env.SSO_REALM || "istio"),
    sso_reg_user = (process.env.SSO_SERVICE_USER_NAME || "admin"),
    sso_reg_password = (process.env.SSO_SERVICE_USER_PASSWD || "admin"),
    CLIENT_ID = (process.env.CLIENT_ID || "httpbin")
    ;
console.log("fetching access token");
request.post(
    {
        uri: sso_service_url + '/auth/realms/master/protocol/openid-connect/token',
        strictSSL: false,
        json: true,
        form: {
            username: sso_reg_user,
            password: sso_reg_password,
            grant_type: 'password',
            client_id: 'admin-cli'
        }
    },
    function (err, resp, body) {
        if (!err && resp.statusCode == 200) {
            var token = body.access_token;
            // console.log(token);
            request.post(
                {
                    uri: sso_service_url + '/auth/admin/realms/' + realm + '/clients',
                    strictSSL: false,
                    auth: {
                        bearer: token
                    },
                    json: {
                        clientId: CLIENT_ID,
                        enabled: true,
                        protocol: "openid-connect",
                        secret: "0de7b727-8af3-43cb-84da-988d54dffc01",
                        clientAuthenticatorType: "client-secret",
                        publicClient: true,
                        webOrigins: ["*"],
                        redirectUris: ["*"]
                    }
                }, function (err, resp, body) {
                    console.log("register client result: " + resp.statusCode + " " + resp.statusMessage + " " + JSON.stringify(body));
                });
            request.post(
                {
                    uri: sso_service_url + '/auth/admin/realms/' + realm + '/roles',
                    strictSSL: false,
                    auth: {
                        bearer: token
                    },
                    json: {
                        name: 'user'
                    }
                },
                function (err, resp, body) {
                    if (!err && (resp.statusCode == 201 || resp.statusCode == 409)) {
                        //Successfull created role or role exists
                        request.post(
                            {
                                uri: sso_service_url + '/auth/admin/realms/' + realm + '/users',
                                strictSSL: false,
                                auth: {
                                    bearer: token
                                },
                                json: {
                                    username: 'demo',
                                    enabled: true,
                                    emailVerified: true,
                                    firstName: 'Demo',
                                    lastName: 'User',
                                    email: 'demo@user.org',
                                    requiredActions: []
                                }
                            },
                            function (err, resp, body) {
                                if (!err && (resp.statusCode == 201 || resp.statusCode == 409)) {
                                    request.get({
                                        uri: sso_service_url + '/auth/admin/realms/' + realm + '/users?username=demo',
                                        strictSSL: false,
                                        auth: {
                                            bearer: token
                                        },
                                        json: true
                                    },
                                        function (err, resp, body) {
                                            if (!err && resp.statusCode == 200) {
                                                var userObj = body[0];
                                                console.log("Id for user 'demo' is " + userObj.id);
                                                // set temporary password
                                                request.put({
                                                    uri: sso_service_url + '/auth/admin/realms/' + realm + '/users/' + userObj.id + '/reset-password',
                                                    strictSSL: false,
                                                    auth: {
                                                        bearer: token
                                                    },
                                                    json: {
                                                        type: 'password',
                                                        value: 'demo',
                                                        temporary: false
                                                    }
                                                }, function (err, resp, body) {
                                                    if (!err && resp.statusCode == 204) {
                                                        console.log("Successfully reset password for user 'demo'");
                                                    }
                                                });
                                                console.log("fetching available roles");
                                                request.get({
                                                    uri: sso_service_url + '/auth/admin/realms/' + realm + '/users/' + userObj.id + '/role-mappings/realm/available',
                                                    strictSSL: false,
                                                    auth: {
                                                        bearer: token
                                                    },
                                                    json: true
                                                },
                                                    function (err, resp, body) {
                                                        if (!err && resp.statusCode == 200) {
                                                            var userRoleObj;
                                                            for (var i = 0; i < body.length; i++) {
                                                                if (body[i].name == "user") {
                                                                    userRoleObj = body[i];
                                                                }
                                                            }
                                                            if (userRoleObj != null) {
                                                                console.log("Id for role 'user' is " + userRoleObj.id);
                                                                request.post({
                                                                    uri: sso_service_url + '/auth/admin/realms/' + realm + '/users/' + userObj.id + '/role-mappings/realm',
                                                                    strictSSL: false,
                                                                    auth: {
                                                                        bearer: token
                                                                    },
                                                                    json: [
                                                                        {
                                                                            id: userRoleObj.id,
                                                                            name: 'user',
                                                                            scopeParamRequired: false,
                                                                            composite: false
                                                                        }
                                                                    ]
                                                                },
                                                                    function (err, resp, body) {
                                                                        if (!err && resp.statusCode == 204) {
                                                                            console.log("Successfully assigned role 'user' to user 'demo'");
                                                                        }
                                                                    });
                                                            } else {
                                                                console.log("Could not find available role 'user' for user 'demo'. Either the user already got the role assigned or the role does not exists.")
                                                            }
                                                        }
                                                        else {
                                                            console.error("Failed to get role-mappings with result " + (err || resp.statusCode + " " + resp.statusMessage + " " + JSON.stringify(body)));
                                                        }
                                                    });
                                            }
                                            else {
                                                console.error("Failed to user 'demo' token with result " + (err || resp.statusCode + " " + resp.statusMessage + " " + JSON.stringify(body)));
                                            }
                                        });
                                }
                                else {
                                    console.error("Failed to create user 'demo' with result " + (err || resp.statusCode + " " + resp.statusMessage + " " + JSON.stringify(body)));
                                }
                            });
                    }
                    else {
                        console.error("Failed to create role 'user' with result " + (err || resp.statusCode + " " + resp.statusMessage + " " + JSON.stringify(body)));
                    }
                });
        }
        else {
            console.error("Failed to fetch token with result " + (err || resp.statusCode + " " + resp.statusMessage + " " + JSON.stringify(body)));
            throw new Error('Faled to connect to SSO service using URL' + sso_service_url + ', you might want to try again later.');
        }
    }
);