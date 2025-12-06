component output="false" accessors=true {
    property loggerService;
    property userService;

    public void function logout() {
        lock scope="session" timeout="10"{
            loggerService.debug("Logging out user, clearing session and fbtoken cookie");
            
            // Remove remember me token if it exists
            if (structKeyExists(cookie, "remember_me")) {
                var token = cookie.remember_me;
                var loginToken = entityLoad("LoginToken", {token: token}, true);
                if (!isNull(loginToken)) {
                    entityDelete(loginToken);
                }
                cfcookie(name="remember_me", expires="now");
            }

            structClear(session);
            cfcookie(name="fbtoken" expires="now");
        }
    }

    public void function createRememberMeToken(required component user) {
        var token = hash(createUUID() & now() & user.getId(), "SHA-256");
        var expires = dateAdd("d", 90, now());

        var loginToken = entityNew("LoginToken");
        loginToken.setToken(token);
        loginToken.setExpires(expires);
        loginToken.setUser(arguments.user);
        entitySave(loginToken);

        cfcookie(name="remember_me", value=token, expires="90");
        loggerService.debug("Created remember me token for user #user.getId()#");
    }

    public any function validateRememberMeToken() {
        if (structKeyExists(cookie, "remember_me")) {
            var token = cookie.remember_me;
            var loginToken = entityLoad("LoginToken", {token: token}, true);

            if (!isNull(loginToken)) {
                if (dateCompare(loginToken.getExpires(), now()) > 0) {
                    // Token is valid
                    loggerService.debug("Valid remember me token found for user #loginToken.getUser().getId()#");
                    return loginToken.getUser();
                } else {
                    // Token expired
                    loggerService.debug("Expired remember me token found");
                    entityDelete(loginToken);
                }
            } else {
                loggerService.debug("Invalid remember me token found");
            }
            
            // If we get here, token was invalid or expired
            cfcookie(name="remember_me", expires="now");
        }
        return javaCast("null", "");
    }
}