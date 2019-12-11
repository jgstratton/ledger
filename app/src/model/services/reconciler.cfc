component accessors="true" extends="reconciler.aReconcileService" {
	property metaDataService;
	property arrayUtil;

	compareSettings = {
		amountMatchPoints: 10,
		maxDatePoints: 5,
		maxDescriptionPoints: 5,
		maxCategoryPoints:3
	}
		
	reconcileSettings = {
		matchRange: [10, 20],
		suggestRange: [5,9]
	}

	/**
	 * Compares two transactions.  Returns a numeric value representing their match index.
	 */
	public numeric function compareTransactions(required component transaction1, required component transaction2) {
		var matchIndex = 0;

		if (transaction1.getAmount() == transaction2.getAmount()) {
			matchIndex += compareSettings.amountMatchPoints;
		}

		var daysBetween = abs(datediff('d',transaction1.getTransactionDate(),transaction2.getTransactionDate()));
		var matchIndex += (daysBetween <= compareSettings.maxDatePoints) ? (compareSettings.maxDatePoints - daysbetween) : 0;
		
		var descriptionMatchCount = getArrayUtil().arrayIntersect(listToArray(transaction1.getDescription()," "), listToArray(transaction2.getDescription()," ")).len();
		var matchIndex += (descriptionMatchCount >= compareSettings.maxDescriptionPoints) ? compareSettings.maxDescriptionPoints : descriptionMatchCount;

		var categoryMatchCount = getArrayUtil().arrayIntersect(listToArray(transaction1.getCategory()," "), listToArray(transaction2.getCategory()," ")).len();
		var matchIndex += (categoryMatchCount >= compareSettings.maxCategoryPoints) ? compareSettings.maxCategoryPoints : categoryMatchCount;
		
		return matchIndex;
	}

	//compare two ledger components and return a results component back
	public component function reconcile(required array ledger1, required array ledger2){
		var recResult = new beans.reconciler.recResults(ledger1, ledger2);

		setMatches({
			ledger1: ledger1, 
			ledger2: ledger2, 
			recResult: recResult, 
			currentLevel: reconcileSettings.matchRange[2]
		});
		return recResult;
	}

	private void function setMatches(required struct state) {
		for (var i = 1; i <= state.ledger1.len(); i++) {
			for (var j = 1; j <= state.ledger2.len(); j++) {
				if (compareTransactions(state.ledger1[i], state.ledger2[j]) >= state.currentLevel) {
					state.recResult.setMatch(state.ledger1[i], state.ledger2[j]);
					state.ledger2.deleteAt(j);
					state.ledger1.deleteAt(i);
					setMatches(state);
				}
			}
		}
		if (state.currentLevel >= reconcileSettings.matchRange[1]) {
			state.currentLevel -= 1;
			setMatches(state);
		}
	}
	
}