component accessors="true" extends="reconciler.aReconcileService" {
	property metaDataService;
		
	public component function createLedger() {
		return new beans.reconciler.recLedger();
	}
	
	//populate the ledger component with an array of structs
	public void function populateLedger(required component ledger, required array transactions){
		for (var transaction in transactions) {
			if(!isObject(transaction) || !getMetadataService().implements(ledger, 'iRecTransaction')) {
				throw(type="invalidTransactionType", message="Transaction data does not implement from iRecTransaction");
			}
		}
	}

	/**
	 * Compares two transactions.  Returns a numeric value representing their match index.
	 */
	public numeric function compareTransactions(required component transaction1, required component transaction2) {

	}

	//compare two ledger components and return a ledger component back
	public component function reconcile(required component ledger1, required component ledger2){
		return component;
	}
	
}