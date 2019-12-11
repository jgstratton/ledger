abstract component{
	
	public component function init(){
		return this;
	}

	abstract numeric function compareTransactions(required component transaction1, required component transaction2) ;

	//compare two ledger components and return a ledger component back
	abstract component function reconcile(required array ledger1, required array ledger2);
	
}