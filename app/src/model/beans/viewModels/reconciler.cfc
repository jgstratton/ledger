component accessors="true" {
	property name="startDate" input="viewModels.inputs.date";
	property name="endDate" input="viewModels.inputs.date";
	property name="accounts" input="viewModels.inputs.userAccounts";

	variables.rc = {};

	public component function init(required struct rc) {
		variables.formBase = new _formBase(this);
		variables.formBase.initializeInputs()
			.populateInputsFromRc(rc);
		variables.rc = rc;
		variables.accounts.setName('accountIds');
		setDefaultValues();	
		return this;
	}

	private void function setDefaultValues() {
		getStartDate().setValue(dateFormat(dateadd('m',-1,now()), "mm/dd/yyyy"));
		getEndDate().setValue(dateFormat(now(),"mm/dd/yyyy"));
		if (getAccounts().getOptions().len()) {
			getAccounts().setValueByIndex(1);
		}
	}

	public array function getResults() {
		var transactions = getTransactionService().searchTransactions(variables.rc);

		return transactions;
	}

	private component function getTransactionService() {
		return request.beanfactory.getBean("transactionService");
	}

	private component function getReconcilerService() {
		return request.beanfactory.getBean("reconcilerService");
	}
}