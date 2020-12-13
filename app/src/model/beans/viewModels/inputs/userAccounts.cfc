component accessors="true" extends="select" {
	//inherited properties:

	//property name="value";
    //property name="name";
	//property name="options" type="array";

	public component function init() {
		setOptions([]);
		var userAccounts = getAccountService().getAccounts();
		if (local.keyExists('userAccounts')) {
			for (var userAccount in userAccounts) {
				variables.options.append({
					value: userAccount.getId(), 
					text: userAccount.getName(),
					data: {
						isParent: userAccount.hasLinkedAccount() ? 1 : 0
					}
				});
			}
		}
		return this;
	}

	//if only parent accounts are needed, the child accounts can be removed
	public void function removeChildAccounts() {
		var options = [];
		for (var option in getOptions()) {
			if (option.data.keyExists('isParent') && !option.data.isParent) {
				options.append(option);
			}
		}
		setOptions(options);
	}

	private component function getAccountService() {
		return request.beanfactory.getBean("accountService");
	}
}