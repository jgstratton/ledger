component accessors="true" extends="select" {

	public component function init() {
		setOptions([]);
		var userAccounts = getAccountService().getAccounts();
		if (local.keyExists('userAccounts')) {
			for (var userAccount in userAccounts) {
				variables.options.append({value: userAccount.getId(), text: userAccount.getName()});
			}
		}
		return this;
	}

	private component function getAccountService() {
		return request.beanfactory.getBean("accountService");
	}S
}