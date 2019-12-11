/**
 * The reconciler results component should store the reconcilation data.
 */
abstract component {

	/**
	 * Sets two transactions as matched
	 */
	abstract void function setMatch(transaction1, transaction2);

	/**
	 * Returns a map of transactionIds from ledger 1 mapped to the transactionIds from ledger 2.
	 * If the reverse flag is set it should switch directions and return the map from 2 to 1
	 */
	abstract struct function getMatchMaps(boolean reverseMap = false);

}