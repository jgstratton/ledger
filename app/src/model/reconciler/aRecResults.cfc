/**
 * The reconciler results component should store the reconcilation data.
 */
abstract component {

	/**
	 * Gets an array of matches (aRecMatch).
	 * 
	 * Returns a map of transactionIds from ledger 1 mapped to the transactionIds from ledger 2.
	 * If the reverse flag is set it should switch directions and return the map from 2 to 1
	 */
	abstract array function getMatchMaps(boolean reverseMap = false);

}