component name="reconciler" output="true" accessors=true extends="_baseController" {

	public component function init(fw){
		variables.fw=arguments.fw;
		return this;
	}

	public void function before( required struct rc ){
		param name="rc.returnTo" default="#variables.fw.getSectionAndItem()#";
		updateLayoutAndView();
		super.before(rc);
	}

	/**
	 * @authorizer "noAuthorizer"
	 */
	public void function reconcileForm( struct rc = {} ){
		rc.viewModel = new viewModels.reconciler(rc);
	}

	/**
	 * @authorizer "authorizeByAccountId"
	 * @authorizerFields "accountIds"
	 * @view "reconciler.results"
	 * @layout "none"
	 */
	public void function results( struct rc = {} ){
		rc.account = accountService.getAccountByID(rc.accountIds);
		var externalLedger = reconcilerService.createLedgerFromRawJson(rc.csvData);
		var internalLedger = reconcilerService.createTransactionLedger(transactionService.searchTransactions(rc));
		rc.results = reconcilerService.reconcile(externalLedger, internalLedger);
	}
}