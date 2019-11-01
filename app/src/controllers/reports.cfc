component name="account" output="false"  accessors=true {
    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function accountChart( struct rc = {}){
        rc.viewModel = new viewModels.accountChart(rc);
    }

    public void function getChartData( struct rc = {}){
        rc.viewModel = new viewModels.accountChart(rc);
        var chartData = rc.viewModel.getChartData();
        variables.fw.renderData().data( chartData ).type( 'json' );
    }
}