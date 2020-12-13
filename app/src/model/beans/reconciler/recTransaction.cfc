component accessors="true" implements="reconciler.iRecTransaction" {
	property name="id" type="string";
	property name="transactionDate" type="date";
	property name="description" type="string";
	property name="amount" type="numeric";
	property name="category" type="string";

	public void function populateByRawArray(required array rawData){
		setId(rawData[1]);
		setTransactionDate(rawData[2]);
		setDescription(rawData[3]);
		setAmount(rawData[4]);
		setCategory(rawData[5]);
	}

	public string function getRecTransactionId() {
		return getId();
	}
}