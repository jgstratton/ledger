component accessors="true" extends="abstract.reconciler.aRecLedger" {
	
	//this implementation is going to use an array of structs to hold the transaction data
	public void function addTransaction(required struct transaction) {
		variables.transactions.append(arguments.transaction, false);
		return;
	}

}