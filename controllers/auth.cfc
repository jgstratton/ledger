component name="auth" output="false"  accessors=true {
    property userService;
    facebook = application.facebook;

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
            session.userid = variables.userService.getOrCreate( variables.facebook.getMe(local.fbToken).email ).getId();
            session.loggedin = true;
            location("#application.root_path#/",false);
        }
             
    }

    public void function logout( struct rc = {} ){
        lock scope="session" timeout="10"{
            structDelete(session,"user");
            session.loggedin = false;
            location("#application.root_path#/login",false);
        }
    }
}
