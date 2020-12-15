interface {

	//all reconciler transactions have to have an id
	public string function getRecTransactionId();

	public string function getCategoryName();

	public numeric function getSignedAmount();
	
}