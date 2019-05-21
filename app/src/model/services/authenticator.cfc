component output="false" accessors=true {

    public void function logout() {
        lock scope="session" timeout="10"{
            structClear(session);
            cfcookie(name="fbtoken" expires="now");
        }
    }
}