component name="auth" output="false"  accessors=true {
    property userService;
    property alertService;
    property loggerService;
    property authenticatorService;

    facebook = application.facebook;

    public void function init(fw){
        variables.fw = arguments.fw;
    }

    /**
     * Use the proxy login trying to log in via proxy (like from a node front end)
     */
    public void function proxyLogin ( struct rc = {} ) {
        loggerService.debug("Starting login via proxy");
        multiStepLogin(rc, true);
    }

    public void function login( struct rc = {} ) {
        multiStepLogin(rc, false);
    }

    private void function multiStepLogin( struct rc = {}, boolean isProxy = false) {

        //if user clicked the log into facebook link, then redirect them to the fb login
        if(structKeyExists(rc, 'startfb' )){
            startFacebookLogin(isProxy);
        }

        /*  if the user is returning from the facebook login, log them in
            Create the user record if it doesn't exsist yet*/
        if( structKeyExists(rc, 'code' )  and rc.state is session.state  ){
            local.fbToken = facebook.getAccessToken(rc.code);
        } else if(structKeyExists(cookie,'fbToken')){
            local.fbToken = cookie.fbToken;
        }      

        //if the token is set, then log in the user.
        if(structKeyExists(local,"fbToken")){
          completeFacebookLogin(local.fbToken);
        }
    }

    //Set session variables and navigate to facebook auth url
    private void function startFacebookLogin(boolean isProxy = false) {
        session.state = createUUID();
        session.loginByProxy = false;
        if(isProxy) {
            session.loginByProxy = true;
            session.logInSource = cgi.HTTP_REFERER;
        }
        var faceBookAuthUrl = "#facebook.getAuthURL("email",session.state)#";
        loggerService.debug(faceBookAuthUrl);
        location url=faceBookAuthUrl;
    }

    //log in user (via facebook authentication)
    private void function completeFacebookLogin(required string fbToken) {
        var fbUser = variables.facebook.getMe(fbToken);
        var username = fbUser.id;
        
        if (fbUser.keyExists('email')) {
            username = fbUser.email;
        }

        session.userid = variables.userService.getOrCreate( username ).getId();
        session.loggedin = true;

        cfcookie(
            name="fbtoken"
            value="#fbToken#"
            expires="30");
        
        if(session.loginByProxy) {
            loggerService.debug("navigating to #session.loginSource#");
            location("#session.logInSource#",false);
        } else {
            location("#application.root_path#",false);
        }
    }

    public void function logout( struct rc = {} ){
        authenticatorService.logout();
        alertService.setTitle("success","You have sucessfully been logged out.");
        variables.fw.redirect("auth.login");
    }

}
