component name="account" output="false"  accessors=true {
    property greetingService;
    public void function list( struct rc = {} ) {
        param name="rc.name" default="anonymous";
        rc.name = variables.greetingService.greet( rc.name );        
    }
}
