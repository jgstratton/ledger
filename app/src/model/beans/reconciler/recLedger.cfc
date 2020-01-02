component accessors="true" {
	variables.transactions = {}; 

	public component function init(required array transactions){
		var transactionStruct = StructNew("ordered");
		for (var transaction in transactions) {
			transactionStruct[transaction.getRecTransactionid()] = transaction;
		}
		variables.transactions = transactionStruct;
		return this;
	}

	public void function deleteTransaction(required component transaction) {
		structDelete(variables.transactions, transaction.getRecTransactionId());
	}

	//Returns the transactions as an array
	public array function getTransactions() {
		var transactionArray = Arraynew();
		for (var transactionId in variables.transactions) {
			transactionArray.append(variables.transactions[transactionid]);
		}
		return transactionArray;
	}

	/**
	 * A function to call on each of the transactions, the callback should return true or false.
	 * If the callback returns false then it will exit early.
	 */ 
	public void function iterate(required function callback) {
		for (var transactionId in variables.transactions) {
			if (!callback(variables.transactions[transactionId])) {
				return;
			}
		}
	}

	public numeric function len() {
		return structCount(variables.transactions);
	}
}