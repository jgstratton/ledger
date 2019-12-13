component accessors="true" extends="reconciler.aReconcileService" {
	property metaDataService;
	property arrayUtil;
	property combinatoricsUtil;

	compareSettings = {
		amountMatchPoints: 10,
		maxDatePoints: 5,
		maxDescriptionPoints: 5,
		maxCategoryPoints:3
	}
		
	reconcileSettings = {
		matchRange: [10, 20],
		suggestRange: [5,9],
		combinationDepth: 3
	}

	public numeric function compareTransactions(required component transaction1, required array transaction2Array) {
		var matchIndex = 0;
		
		var combinedAmount = transaction2Array.reduce(function(amount, transaction){
			return amount + transaction.getAmount();
		}, 0);

		if (transaction1.getAmount() == combinedAmount) {
			matchIndex += compareSettings.amountMatchPoints;
		}

		//get closest day difference of all the transactions
		var avgDaysBetween = transaction2Array.map(function(transaction){
			return abs(datediff('d',transaction1.getTransactionDate(),transaction.getTransactionDate()));
		}).avg();

		var matchIndex += (avgDaysBetween <= compareSettings.maxDatePoints) ? (compareSettings.maxDatePoints - avgDaysBetween) : 0;
		
		var combinedDescription = transaction2Array.reduce(function(list, transaction){
			return listAppend(list, transaction.getDescription(), " ");
		}, "");

		var descriptionMatchCount = getArrayUtil().arrayIntersect(listToArray(transaction1.getDescription()," "), listToArray(combinedDescription, " ")).len();
		var matchIndex += (descriptionMatchCount >= compareSettings.maxDescriptionPoints) ? compareSettings.maxDescriptionPoints : descriptionMatchCount;

		var combinedCategories = transaction2Array.reduce(function(list, transaction){
			return listAppend(list, transaction.getCategory(), " ");
		}, "");

		var categoryMatchCount = getArrayUtil().arrayIntersect(listToArray(transaction1.getCategory()," "), listToArray(combinedCategories," ")).len();
		var matchIndex += (categoryMatchCount >= compareSettings.maxCategoryPoints) ? compareSettings.maxCategoryPoints : categoryMatchCount;
		
		return matchIndex;
	}

	//compare two ledger components and return a results component back
	public component function reconcile(required array ledger1, required array ledger2){
		var recResult = new beans.reconciler.recResults(ledger1, ledger2);
		var state = {
			ledger1: ledger1, 
			ledger2: ledger2, 
			recResult: recResult, 
			currentLevel: reconcileSettings.matchRange[2]
		};

		setMatches(state);
		setCombinedMatches(state);
		return recResult;
	}

	private void function setMatches(required struct state) {

		for (var i = 1; i <= state.ledger1.len(); i++) {
			for (var j = 1; j <= state.ledger2.len(); j++) {
				if (compareTransactions(state.ledger1[i], [state.ledger2[j]]) >= state.currentLevel) {
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

	private void function setCombinedMatches(required struct state) {
		for (var i=2; i <= reconcileSettings.combinationDepth; i++) {
			
		}
	}
}