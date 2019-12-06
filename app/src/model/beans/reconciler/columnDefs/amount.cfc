component accessors="true" extends="abstract.reconciler.aRecColumnDef" {
	public void function init() {
		super.init({
			name: 'amount',
			type: 'dollar'
		});
		return this;
	}

	public numeric function compare(required numeric amount1, required numeric amoun2) {
		if (amount1 == amount2) {
			return 200;
		}
		return 0;
	}
}