component accessors="true" {
	property name="startDate" input="viewModels.inputs.date";
	property name="endDate" input="viewModels.inputs.date";
	property name="accounts" input="viewModels.inputs.userAccounts";
	property name="includeLinked" input="viewModels.inputs.boolean";

	public component function init(required struct rc) {
		variables.formBase = new _formBase(this);
		variables.formBase.initializeInputs()
			.populateInputsFromRc(rc);
		return this;
	}

	private void function setDefaultValues() {
		getStartDate().setValue(dateadd('m',-1,now()));
		getEndDate().setValue(now());
		if (getAccounts().getOptions().len()) {
			getAccounts().setValueByIndex(1);
		}
		getIncludeLinked().setValue(false);
	}
}