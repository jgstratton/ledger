component output="false" accessors="true" {

    public boolean function requireLogin(required struct rc, required struct api){
        if (!session.loggedin){
            rc.response.setStatusCode(401);
            rc.response.addError("You need to be logged in to use this feature");
            return false;
        }
        return true;
    }
    
}