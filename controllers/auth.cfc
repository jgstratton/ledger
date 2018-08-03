component name="auth" output="false"  accessors=true {
    
    facebook = application.facebook;

    public void function login( struct rc = {} ) {
      
        //if user clicked the log into facebook link, then redirect them to the fb login
        if(not StructKeyExists(session,'fbAccessToken') and structKeyExists(rc, 'startfb' )){
            session.state = createUUID();
            location url="#facebook.getAuthURL("email",session.state)#";
        }

        //if the user is returning from the facebook login, log them in
        if( isDefined("rc.code") and rc.state is session.state  ){
            session.fbAccessToken = facebook.getAccessToken(rc.code);
            session.loggedin = true;
            location("#application.root_path#/login",false);
        }
             
    }

    public void function logout( struct rc = {} ){
        lock scope="session" timeout="10"{
            structDelete(session,"fbaccesstoken");
            session.loggedin = false;
            location("#application.root_path#/login22",false);
        }
    }
}
