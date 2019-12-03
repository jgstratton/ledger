component name="reports" output="false" accessors=true extends="_baseController"  {
	public void function init(fw){
		variables.fw=arguments.fw;
	}

	/**
	 * @authorizer "noAuthorizer"
	 */
	public void function accountChart( struct rc = {}){
		rc.viewModel = new viewModels.accountChart(rc);
	}

	/**
	 * @authorizer "authorizeByAccountId"
	 * @authorizerFields "accounts"
	 */
	public void function getChartData( struct rc = {}){
		rc.viewModel = new viewModels.accountChart(rc);
		var chartData = rc.viewModel.getChartData();
		variables.fw.renderData().data( chartData ).type( 'json' );
	}

	/**
	 * @authorizer "noAuthorizer"
	 */
	public void function spendingReport( struct rc = {}){
		rc.viewModel = new viewModels.spendingReport(rc);
	}

	/**
	 * @authorizer "authorizeByAccountId"
	 * @authorizerFields "accounts"
	 */
	public void function getSpendingReportData( struct rc = {}){
		rc.viewModel = new viewModels.spendingReport(rc);
		var reportData = rc.viewModel.getReportData();
		variables.fw.renderData().data( reportData ).type( 'json' );	
	}
}