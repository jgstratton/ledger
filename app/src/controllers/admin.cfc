component name="account" output="false"  accessors=true {

    public void function devToggles(required struct rc) {
        if (rc.keyExists('submit')) {
            for (key in application.devToggles) {
                application.devToggles[key] = rc[key];
            }
        }
        rc.toggles = application.devToggles;
    }
}