component accessors="true" extends="reconciler.aRecResults" {
	ledgers = [[],[]];
	ledgerMaps = [{},{}];
	matches = [{},{}];

	public component function init(required array ledger1, required array ledger2){
		ledgers[1] = arguments.ledger1;
		ledgers[2] = arguments.ledger2;
		
		ledgers.each(function(ledger, index){
			ledger.each(function(transaction){
				ledgerMaps[index][transaction.getId()] = transaction;
			});
		});
		return this;
	}

	public void function setMatch(transaction1, transaction2) {
		if (isArray(transaction1) && isArray(transaction2)) {
			throw(type="InvalidArguments", message="At least one argument to the setMatch function must be a transaction");
		}
		if (isArray(transaction1)) {
			matches[2][transaction2.getId()] = transaction1.map(function(transaction){
				return getId();
			});
		} else if (isArray(transaction2)) {
			matches[1][transaction1.getId()] = transaction2.map(function(transaction){
				return getId();
			});
		} else {
			matches[1][transaction1.getId()] = transaction2.getId();
			matches[2][transaction2.getId()] = transaction1.getId();
		}
	}

	public struct function getMatchMaps(boolean reverseMap = false) {
		return matches[ reverseMap ? 2 : 1];
	}


}