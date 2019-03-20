//not using this yet... just kicking around ideas
component name="account" output="false"  accessors=true {
    public void function init(fw){
        variables.fw=arguments.fw;
    }

    /** Lifecycle functions **/

    public void function before( required struct rc ){
        rc.response = new beans.response();
    }

    public void function after( struct rc = {} ){
        variables.fw.renderData( 'json', rc.response.toJson() );
    }

}