abstract component{
	
	public component function init(){
		return this;
	}

	abstract component function createLedger(required array columnDefs);

	//populate the ledger component with an array of structs
	abstract void function populateLedger(required component ledger, required array transactions);

	//compare two ledger components and return a ledger component back
	abstract component function reconcile(required component ledger1, required component ledger2);
	
}