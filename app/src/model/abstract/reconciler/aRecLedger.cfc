abstract component {
	property columnDefinitions type="array";
	property transactions type="array";

	public component function init(struct properties = {}) {
		local.properties = arguments.properties.append({
			columnDefinitions: [],
			transactions: []
		}, false);

		variables.columnDefinitions = local.properties.columnDefinitions;
		variables.transactions = local.properties.columnDefinitions;
	}
	
	public void function addTransaction(required any transaction) {
		variables.transactions.append(arguments.transaction, false);
		return;
	}
}