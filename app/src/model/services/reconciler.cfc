component output="false" accessors="true" {
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
			return amount + transaction.getSignedAmount();
		}, 0);

		if (transaction1.getSignedAmount() == combinedAmount) {
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
			return listAppend(list, transaction.getCategoryName(), " ");
		}, "");

		var categoryMatchCount = getArrayUtil().arrayIntersect(listToArray(transaction1.getCategoryName()," "), listToArray(combinedCategories," ")).len();
		var matchIndex += (categoryMatchCount >= compareSettings.maxCategoryPoints) ? compareSettings.maxCategoryPoints : categoryMatchCount;
		return matchIndex;
	}

	//compare two ledger components and return a results component back
	public component function reconcile(required component ledger1, required component ledger2){
		var recResult = new beans.reconciler.recResults();
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
			state.ledger1.iterate( function(transaction1) {
				state.ledger2.iterate( function(transaction2) {
					if (compareTransactions(transaction1, [transaction2]) >= state.currentLevel) {
						state.recResult.setMatch(transaction1, transaction2);
						state.ledger1.deleteTransaction(transaction1);
						state.ledger2.deleteTransaction(transaction2);
						matched = true;
					}
					return !matched;
				});
				return !matched;
			});

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

					var combinationObj = new beans.combinations(multiTransactionLedger.getTransactions(), depth, function(transaction){
						return transaction.getRecTransactionId();
					});
					
					var combinations = combinationObj.getCombinations();

					while (state.currentLevel >= reconcileSettings.matchRange[1]){
						var matched = false;
						for (var i = 1; i <= combinations.len(); i++) {
							singleTransactionLedger.iterate( function(compareTransaction) {
								if (compareTransactions(compareTransaction, combinations[i]) >= state.currentLevel) {
									if (direction == 'left') {
										state.recResult.setMatch(compareTransaction, combinations[i]);
									} else {
										state.recResult.setMatch(combinations[i], compareTransaction);
									}	
									singleTransactionLedger.deleteTransaction(compareTransaction);

									for (var transaction in combinations[i]) {
										combinationObj.removeItem(transaction);
										multiTransactionLedger.deleteTransaction(transaction);
									}
									matched = true;									
								}
								return !matched;
							});
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

	/**
	 * Takes a json string and generates a ledger object from it.  Expected syntax:
	 * data: [
	 * 	[id,date,description,amount,category],...
	 * ]
	 */
	public component function createLedgerFromRawJson(required string jsonData) {
		var jsonData = deserializeJSON(jsonData);
		var transactions = [];
		//delete the header row
		jsonData.data.deleteAt(1);

		for (var rawTransaction in jsonData.data) {
			var transaction = new beans.reconciler.recTransaction(rawTransaction)
			transaction.populateByRawArray(rawTransaction);
			transactions.append(transaction);
		}
		return new beans.reconciler.recLedger(transactions);
	}

	public component function createTransactionLedger(required array transactions) {
		return new beans.reconciler.recLedger(transactions);
	}
}