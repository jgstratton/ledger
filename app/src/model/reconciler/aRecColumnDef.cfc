abstract component {
	property name="name" type="string";
	property name="type" type="string";

	public component function init(struct properties = {}) {
		local.properties = arguments.properties.append({
			name: '',
			type: ''
		}, false);

		variables.columnDefinitions = local.properties.columnDefinitions;
		variables.transactions = local.properties.columnDefinitions;
	}

	abstract numeric function compare(required any value1, required any value2);
}