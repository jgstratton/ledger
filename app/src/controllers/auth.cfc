component name="auth" output="false"  accessors=true {
    property userService;
    property alertService;
    facebook = application.facebook;

    public void function init(fw){
        variables.fw = arguments.fw;
    }

    public void function login( struct rc = {} ) {
      
        //if user clicked the log into facebook link, then redirect them to the fb login
        if(structKeyExists(rc, 'startfb' )){
            session.state = createUUID();
            location url="#facebook.getAuthURL("email",session.state)#";
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
            var fbUser = variables.facebook.getMe(local.fbToken);
            var username = fbUser.id;
            
            if (fbUser.keyExists('email')) {
                username = fbUser.email;
            }

            session.userid = variables.userService.getOrCreate( username ).getId();
            session.loggedin = true;

            cfcookie(
                name="fbtoken"
                value="#local.fbToken#"
                expires="30");

            location("#application.root_path#/",false);
        }
    
    }

    public void function logout( struct rc = {} ){
        lock scope="session" timeout="10"{
            structClear(session);
            cfcookie(name="fbtoken" expires="now");
            alertService.setTitle("success","You have sucessfully been logged out.");
            variables.fw.redirect("auth.login");
        }
    }
}
