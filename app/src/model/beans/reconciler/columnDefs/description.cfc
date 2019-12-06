component accessors="true" extends="abstract.reconciler.aRecColumnDef" {
	public void function init() {
		super.init({
			name: 'description',
			type: 'string'
		});
		return this;
	}

	public numeric function compare(required string description1, required string description2) {
		if (description1 == description2) {
			return 100;
		}
		var wordMatch = 0;
		for (var word in listToArray(description1, " ")) {
			for (var word2 in listToArray(description2, " ")) {
				wordMatch += (word1 == word2) ? 1 : 0;
			}
		}
		return wordMatch * 10;
	}
}