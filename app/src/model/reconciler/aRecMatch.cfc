abstract component {

	//The transaction id from the first ledger
	property name="transactionKey" type="string";

	//An array of transaction ids from the second ledger that we're comparing to
	property name="matchTo" type="array";

	//The confidence level assigned to the match
	property name="confidenceLevel" type="integer";

}