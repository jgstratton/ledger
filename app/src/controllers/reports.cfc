component name="reports" output="false" accessors=true extends="_baseController"  {
    public void function init(fw){
        variables.fw=arguments.fw;
    }

    /**
     * @authorizer noAuthorizer
     */
    public void function accountChart( struct rc = {}){
        rc.viewModel = new viewModels.accountChart(rc);
    }

    /**
     * @authorizer "authorizeByAccountId"
     * @authorizerField "accounts"
     */
    public void function getChartData( struct rc = {}){
        rc.viewModel = new viewModels.accountChart(rc);
        var chartData = rc.viewModel.getChartData();
        variables.fw.renderData().data( chartData ).type( 'json' );
    }
}