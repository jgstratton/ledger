/**
 * The transaction data service is for access transaction data directly without returning orm objects
 */
component output="false" accessors="true" {
    property userService;
    property name="limitedResultsCount" default=1000;
    property queryUtilService;

    public function init(){
        variables.queryUtilService = new services.utils.queryUtil();
    }

    public array function getTransactionData(required account account){
        userService.checkAccount(arguments.account);

        var qryTransactions = queryExecute("
            SELECT *
            FROM
                vw_transactionData
            WHERE 
                account_id = :accountId AND
                isHidden = 0
            ORDER BY 
                transactionDate desc,
                id desc
                LIMIT :limit", 
            {
                accountId: arguments.account.getId(),
                limit: {value=variables.limitedResultsCount, cfsqltype="cf_sql_integer"}
            }
        );

        return queryUtilService.queryToArray(qryTransactions);
    }

}