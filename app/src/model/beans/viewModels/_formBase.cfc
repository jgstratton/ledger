component accessors="true" {
	
	public component function init(required component viewModel) {
		variables.viewModel = arguments.viewModel;
		return this;
	}

	/**
	 * Initialize each of the "input" properties with a new instance.
	 */
	public component function initializeInputs() {
		var meta = getMetaData(variables.viewModel);
		for (var property in meta.properties) {
			if (property.keyExists('input')) {
				invoke(variables.viewModel,"set#property.name#", { "#property.name#": createObject(property.input)});
				var value = invoke(variables.viewModel,"get#property.name#");
				value.init();
				value.setName(property.name);
			}
		}
		return this;
	}

	/**
	 * Copy the relavent values directly from the rc struct
	 */
	public component function populatePropertiesFromRc(required struct rc) {
		var meta = getMetaData(variables.viewModel);

		//update values with rcProperty attribute
		for (var property in meta.properties) {
			if (property.keyExists('rcProperty') && rc.keyExists(property.name)) {
				invoke(variables.viewModel,"set#property.name#", { "#property.name#": rc[property.name]});
			}
		}
		return this;
	}

	/**
	 * Copy the relavent values directly from the rc struct
	 */
	public component function populateInputsFromRc(required struct rc) {
		var meta = getMetaData(variables.viewModel);
		//set the input values based on rc
		for (var property in meta.properties) {
			if (property.keyExists('input') && rc.keyExists(property.name)) {
				var inputProperty = invoke(variables.viewModel,"get#property.name#");
				inputProperty.setValue(rc[property.name]);
			}
		}
		return this;
	}

	private component function getLoggerService() {
		return request.beanfactory.getBean("loggerService");
	}
}