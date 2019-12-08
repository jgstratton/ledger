component accessors="true" extends="reconciler.aReconcileService" {
	property metaDataService;
		
	public component function createLedger(required array columnDefs) {
		return new beans.reconciler.recLedger({
			columnDefinitions: arguments.columnDefs
		});
	}
	
	//populate the ledger component with an array of structs
	public void function populateLedger(required component ledger, required array transactions){
		for (var transaction in transactions) {
			if(!isObject(transaction) || !getMetadataService().inheritsFrom(ledger, 'reconciler.aRecTransactions')) {
				throw(type="invalidTransactionType", message="Transaction data does not inherit from aRecTransactions");
			}
		}
	}

	//compare two ledger components and return a ledger component back
	public component function reconcile(required component ledger1, required component ledger2){
		return component;
	}
	
}