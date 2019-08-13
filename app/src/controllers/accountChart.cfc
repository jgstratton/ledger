component name="account" output="false"  accessors=true {
    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function setupChart( struct rc = {}){
        rc.viewModel = new viewModels.accountChart(rc);
    }
}