component name="main" output="false"  accessors=true {
    property greetingService;
    public void function default( struct rc = {} ) {
        param name="rc.name" default="anonymous";
        rc.name = variables.greetingService.greet( rc.name );
    }
}
