component accessors="true" {
	property name="matches" type="array";

	public component function init(){
		setMatches([]);
		return this;
	}

	public void function setMatch(transaction1, transaction2) {
		if (isArray(transaction1) && isArray(transaction2)) {
			throw(type="InvalidArguments", message="At least one argument to the setMatch function must be a transaction");
		}
		getMatches().append([transaction1, transaction2], false);
	}

	/**
	 * Convert the matches from transaction objects to ids.
	 */
	public array function getMatchMaps() {
		var matchMaps = [];
		for (var match in getMatches()) {
			var matchMap = [];
			for (var index in [1,2]) {
				if(isArray(match[index])) {
					matchMap[index] = [];
					for (var transaction in match[index]) {
						matchMap[index].append(transaction.getRecTransactionId());
					}
				} else {
					matchMap[index] = match[index].getRecTransactionId();
				}
			}
			matchMaps.append(matchMap,false);
		}
		return matchMaps;
	}
}