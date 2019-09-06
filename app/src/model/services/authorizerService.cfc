component output="false" accessors=true {
	property userService;

	public void function authorizeByTransaction( required component transaction) {
		if (transaction.getAccount().getUser().getId() != getUserService().getCurrentUser().getId()) {
			throw(
				type="UnauthorizedUser", 
				message="User #getUserService().getCurrentUser().getUsername()# attempted to access a transaction(#transaction.getId()#) they are not authorized for."
			);
		}
	}

	public void function authorizeByAccount( required component account) {
		if (account.getUser().getId() != getUserService().getCurrentUser().getId()) {
			throw(
				type="UnauthorizedUser", 
				message="User #getUserService().getCurrentUser().getUsername()# attempted to access an account (#account.getId()#) they are not authorized for."
			);
		}
	}
}