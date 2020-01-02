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
		state.currentLevel = reconcileSettings.matchRange[2];
		while (state.currentLevel >= reconcileSettings.matchRange[1]) {
			var matched = false;
			for (var i = 1; i <= state.ledger1.len(); i++) {
				for (var j = 1; j <= state.ledger2.len(); j++) {
					if (compareTransactions(state.ledger1[i], [state.ledger2[j]]) >= state.currentLevel) {
						state.recResult.setMatch(state.ledger1[i], state.ledger2[j]);
						state.ledger2.deleteAt(j);
						state.ledger1.deleteAt(i);
						matched = true;
						break;
					}
				}
				if (matched) {
					break;
				}
			}
			if (!matched && state.currentLevel >= reconcileSettings.matchRange[1]) {
				state.currentLevel -= 1;
			}
		}

	}

	private void function setCombinedMatches(required struct state) {
		var maxMatchLevel = reconcileSettings.matchRange[2];

		for (var direction in ['left','right']) {
			if (direction == 'left') {
				var multiTransactionLedger = state.ledger2;
				var singleTransactionLedger = state.ledger1;
			} else {
				var multiTransactionLedger = state.ledger1;
				var singleTransactionLedger = state.ledger2;
			}
			for (var depth = 2; depth <= reconcileSettings.combinationDepth; depth++) {
				state.currentLevel = maxMatchLevel;
				if (multiTransactionLedger.len() >= depth) {

					var combinationObj = new beans.combinations(multiTransactionLedger, depth, function(transaction){
						return transaction.getRecTransactionId();
					});
					var combinations = combinationObj.getCombinations();

					while (state.currentLevel >= reconcileSettings.matchRange[1]){
						var matched = false;
						for (var i = 1; i <= combinations.len(); i++) {
							for (var j = 1; j <= singleTransactionLedger.len(); j++) {
								if (compareTransactions(singleTransactionLedger[j], combinations[i]) >= state.currentLevel) {
									if (direction == 'left') {
										state.recResult.setMatch(singleTransactionLedger[j], combinations[i]);
									} else {
										state.recResult.setMatch(combinations[i], singleTransactionLedger[j]);
									}	
									singleTransactionLedger.deleteAt(j);

									for (var transaction in combinations[i]) {
										combinationObj.removeItem(transaction);

										//this needs improved
										for (var k = 1; k <= multiTransactionLedger.len(); k++) {
											if (multiTransactionLedger[k].getRecTransactionId() == transaction.getRecTransactionId()) {
												multiTransactionLedger.deleteAt(k);
											}
										}
									}
									matched = true;
									break;
								}
							}
							if (matched) {
								break;
							}
						}
						if (!matched && state.currentLevel >= reconcileSettings.matchRange[1]) {
							state.currentLevel -= 1;
						}
					}
				}
			}
		}
	}
}