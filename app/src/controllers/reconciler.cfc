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
	 */
	public void function reconcile( struct rc = {} ){
		rc.account = accountService.getAccountByID(rc.accountid);
	}
}