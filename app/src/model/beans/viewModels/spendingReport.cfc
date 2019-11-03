component accessors="true" {
	property name="startDate" input="viewModels.inputs.date";
	property name="endDate" input="viewModels.inputs.date";
	property name="accounts" input="viewModels.inputs.select";
	property name="includeLinked" input="viewModels.inputs.boolean";

	//values that come from the rc struct when viewModel is initialized
	property name="user" rcProperty="true";

	public struct function getReportData() {
		return {};
	}

	public component function init(required struct rc) {
		initializeInputs();
		populatePropertiesFromRc(rc);
		setOptions();
		setDefaultValues();
		populateInputsFromRc(rc);
		return this;
	}

	/**
	 * Initialize each of the "input" properties with a new instance.
	 */
	private void function initializeInputs() {
		var meta = getMetaData(this);
		for (var property in meta.properties) {
			if (property.keyExists('input')) {
				invoke(this,"set#property.name#", { "#property.name#": createObject(property.input)});
				var value = invoke(this,"get#property.name#");
				value.init();
				value.setName(property.name);
			}
		}
	}

	/**
	 * Copy the relavent values directly from the rc struct
	 */
	private void function populatePropertiesFromRc(required struct rc) {
		var meta = getMetaData(this);

		//update values with rcProperty attribute
		for (var property in meta.properties) {
			if (property.keyExists('rcProperty') && rc.keyExists(property.name)) {
				invoke(this,"set#property.name#", { "#property.name#": rc[property.name]});
			}
		}
	}

	/**
	 * Copy the relavent values directly from the rc struct
	 */
	private void function populateInputsFromRc(required struct rc) {
		var meta = getMetaData(this);
		//set the input values based on rc
		for (var property in meta.properties) {
			if (property.keyExists('input') && rc.keyExists(property.name)) {
				var inputProperty = invoke(this,"get#property.name#");
				inputProperty.setValue(rc[property.name]);
			}
		}
	}

	private void function setOptions() {
		var userAccounts = getAccountService().getAccounts();
		if (local.keyExists('userAccounts')) {
			getAccounts().setOptions(arrayMap(userAccounts, function(userAccount){
				return {value: userAccount.getId(), text: userAccount.getName()}
			}));
		}
	}

	private void function setDefaultValues() {
		getStartDate().setValue(dateadd('yyyy',-1,now()));
		getEndDate().setValue(now());
		if (getAccounts().getOptions().len()) {
			getAccounts().setValueByIndex(1);
		}
		getIncludeLinked().setValue(false);
	}

	private component function getTransactionDataService() {
		return request.beanfactory.getBean("transactionDataService");
	}

	private component function getLoggerService() {
		return request.beanfactory.getBean("loggerService");
	}

	private component function getAccountService() {
		return request.beanfactory.getBean("accountService");
	}
}