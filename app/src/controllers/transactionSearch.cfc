component name="account" output="false"  accessors=true extends="_baseController"{
	property transactionService;
	property accountService;
	property categoryService;

	public void function init(fw){
		variables.fw=arguments.fw;
	}

	public void function after( struct rc = {} ){
		rc.accounts = accountService.getAccounts();
	}

	public void function before( required struct rc ){
		updateLayoutAndView();
		super.before(rc);
	}

	/**
	 * @authorizer "noAuthorizer"
	 */
	public void function search( struct rc = {} ){
		rc.categories = categoryService.getCategories();
	}

	/**
	 * @authorizer "authorizeByAccountId"
	 * @authorizerFields "accountId,accountIds,accounts"
	 * @view "main.jsonresponse"
	 */
	public void function getSearchResultsData( struct rc = {} ) {
		rc.jsonResponse.transactions = transactionService.searchTransactions(rc,"simple");
	}

	/**
	 * @authorizer "authorizeByAccountId"
	 * @authorizerFields "accountId"
	 */
	public void function getSearchResults( struct rc = {} ) {
		rc.transactions = transactionService.searchTransactions(rc);
		variables.fw.setLayout("ajax");
		variables.fw.setView("transactionSearch._searchResults");
	}

	public void function editTransaction( struct rc = {} ){
		rc.formAction = "transactionSearch.editTransaction";
		rc.transaction = transactionService.getTransactionById(rc.transactionid);
		rc.account = rc.transaction.getAccount();
		rc.categories = categoryService.getCategories(rc.transaction);
		variables.update(rc);
	}

}