component name="account" output="false" accessors=true extends="_baseController" {

	public void function init(fw){
		variables.fw=arguments.fw;
	}

	public void function before( required struct rc ){
		param name="rc.returnTo" default="#variables.fw.getSectionAndItem()#";
		updateLayoutAndView();
		super.before(rc);
	}

	/**
	 * @authorizer "authorizeByAccountId"
	 * @authorizerFields "accounts"
	 */
	public void function reconcileForm( struct rc = {} ){
		rc.account = accountService.getAccountByID(rc.accounts);
		rc.viewModel = new viewModels.reconciler(rc);
	}

	/**
	 * @authorizer "authorizeByAccountId"
	 * @authorizerFields "accounts"
	 * @view "reconciler.results"
	 * @layout "none"
	 */
	public void function results( struct rc = {} ){
		rc.account = accountService.getAccountByID(rc.accounts);
		rc.viewModel = new viewModels.reconciler(rc);
	}
}