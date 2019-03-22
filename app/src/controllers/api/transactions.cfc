//not using this yet... just kicking around ideas
component output="false"  accessors=true {
    public void function init(fw){
        variables.fw=arguments.fw;
    }
    /**
     * @middleware "requireLogin"
     */
    public void function getTransactions(required struct rc, required struct api){
        rc.response.setDataKey('rc',{testData: true});
    }

    public boolean function requireLogin(required struct rc, required struct api){
        if (!session.loggedin){
            rc.response.setStatusCode(401);
            rc.response.addError("You need to be logged in to use this feature");
            return false;
        }
        return true;
    }
}