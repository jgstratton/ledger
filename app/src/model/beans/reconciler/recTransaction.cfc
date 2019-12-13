component accessors="true" implements="reconciler.iRecTransaction" {
	property name="id" type="string";
	property name="description" type="stirng";
	property name="transactionDate" type="date";
	property name="amount" type="numeric";
	property name="category" type="string";

	public void function populate(required struct){
		
	}

	public string function getRecTransactionId() {
		return getId();
	}
}