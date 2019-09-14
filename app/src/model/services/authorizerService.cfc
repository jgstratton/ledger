component output="false" accessors=true {
	property userService;
	property accountService;
	property transactionService;
	property eventGeneratorService;

	public void function authorizeByTransactionId(required numeric transactionId) {
		var transaction = verifyAuthComponent(transactionService.getTransactionById(transactionId));
        authorizerService.authorizeByTransaction(transaction);
	}

	public void function authorizeByTransaction( required component transaction) {
		if (transaction.getAccount().getUser().getId() != getUserService().getCurrentUser().getId()) {
			throw(
				type="UnauthorizedUser", 
				message="User #getUserService().getCurrentUser().getUsername()# attempted to access a transaction(#transaction.getId()#) they are not authorized for."
			);
		}
	}

	public void function authorizeByAccountId(required numeric accountId) {
		var account = verifyAuthComponent(accountService.getAccountById(accountId));
        authorizeByAccount(account);
	}

	public void function authorizeByAccount( required component account) {
		if (account.getUser().getId() != getUserService().getCurrentUser().getId()) {
			throw(
				type="UnauthorizedUser", 
				message="User #getUserService().getCurrentUser().getUsername()# attempted to access an account (#account.getId()#) they are not authorized for."
			);
		}
	}
	
	public void function authorizeByEventGeneratorId(required numeric eventGeneratorId) {
		var eventGenerator = verifyAuthComponent(eventGeneratorService.getEventGeneratorById(eventGeneratorId));
        authorizeByEventGenerator(eventGenerator);
	}

	public void function authorizeByEventGenerator( required component eventGenerator) {
		if (eventGenerator.getUser().getId() != getUserService().getCurrentUser().getId()) {
			throw(
				type="UnauthorizedUser", 
				message="User #getUserService().getCurrentUser().getUsername()# attempted to access an event generator (#eventGenerator.getEventGeneratorId()#) they are not authorized for."
			);
		}
	}

	/**
	 * If the argument passed in is null, then the component doesn't exist so the user attempted to access an item they 
	 * don't have access to.  Throw an error, otherwise return the object back to the caller.
	 */
	private component function verifyAuthComponent(component obj) {
		if (isNull(obj)) {
			throw(
				type="UnauthorizedUser",
				message="User #getUserService().getCurrentUser().getUsername()# attempted to access an object that does not exist"
			)
		}
		return obj;
	}
}