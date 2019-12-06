component accessors="true" extends="abstract.reconciler.aRecColumnDef" {
	public void function init() {
		super.init({
			name: 'transactionDate',
			type: 'date'
		});
		return this;
	}

	public numeric function compare(required string date1, required string date2) {
		if (!IsValid("date", date1) || !isValid("date",date2)) {
			return false;
		}

		var daysOff = abs(datediff('d', date1, date2));
		return 100 - 5 * daysOff;
	}
}