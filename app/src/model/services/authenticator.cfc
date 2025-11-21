component output="false" accessors=true {
    property loggerService;

    public void function logout() {
        lock scope="session" timeout="10"{
            loggerService.debug("Logging out user, clearing session and fbtoken cookie");
            structClear(session);
            cfcookie(name="fbtoken" expires="now");
        }
    }
}