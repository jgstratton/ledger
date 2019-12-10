component accessors="true" extends="reconciler.aReconcileService" {
	property metaDataService;
	property arrayUtil;
		
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
		var amountMatchPoints = 10;
		var maxDatePoints = 5;
		var maxDescriptionPoints = 5;
		var maxCategoryPoints = 3;

		var matchIndex = 0;
		if (transaction1.getAmount() == transaction2.getAmount()) {
			matchIndex += amountMatchPoints;
		}

		var daysBetween = abs(datediff('d',transaction1.getTransactionDate(),transaction2.getTransactionDate()));
		var matchIndex += (daysBetween <= maxDatePoints) ? (maxDatePoints - daysbetween) : 0;
		
		var descriptionMatchCount = getArrayUtil().arrayIntersect(listToArray(transaction1.getDescription()," "), listToArray(transaction2.getDescription()," ")).len();
		var matchIndex += (descriptionMatchCount >= maxDescriptionPoints) ? maxDescriptionPoints : descriptionMatchCount;

		var categoryMatchCount = getArrayUtil().arrayIntersect(listToArray(transaction1.getCategory()," "), listToArray(transaction2.getCategory()," ")).len();
		var matchIndex += (categoryMatchCount >= maxCategoryPoints) ? maxCategoryPoints : categoryMatchCount;
		
		return matchIndex;
	}

	//compare two ledger components and return a ledger component back
	public component function reconcile(required component ledger1, required component ledger2){
		return component;
	}
	
}