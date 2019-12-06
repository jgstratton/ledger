component accessors="true" extends="abstract.reconciler.aReconcileService" {
	
	
	//populate the ledger component with an array of structs
	public void function populateLedger(required array data, required component ledger){

	}

	//compare two ledger components and return a ledger component back
	abstract component function reconcile(required component ledger1, required component ledger2);
	
}