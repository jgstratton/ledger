component output="false" accessors="true" {
    property userService;
    property name="limitedResultsCount" default=1000;
    property logger;

    public component function getTransactionByid(required numeric id){
        
        var transaction = entityLoadByPk( "transaction", arguments.id);
        if (userService.checkTransaction(transaction)) {
            return transaction;
        }
    }

    public component function createEmptyTransaction() {
        return entityNew("transaction");
    }

    public component function createTransaction(required account account){
        if (userService.checkAccount(arguments.account)) {
            return entityNew("transaction", {account: arguments.account} );
        }  
    }
    
    public void function deleteTransaction(required transaction transaction) {
        if (userService.checkTransaction(transaction)) {
            transaction{
                if (transaction.isTransfer()){
                    EntityDelete(transaction.getLinkedTransaction());
                }
                EntityDelete(transaction);
            }
        }
    }

    public void function saveTransaction( required transaction transaction){
        if (userService.checkTransaction(arguments.transaction)) {
            EntitySave(arguments.transaction);
        }
    }

    /**
     * @returnType: 'objects' or 'simple'
     */
    public array function searchTransactions(required struct searchParams, string returnType = 'objects') {
        var conditions = "a.user = :user";
        var parameters = {user: userService.getCurrentUser()};
        var includeLinked = keyIsSet(arguments.searchParams, 'includeLinked') && arguments.searchParams.includeLinked;

        if (keyIsSet(arguments.searchParams,'accountId')) {
            conditions &= " and (a.id = :accountId #(includeLinked ? 'or a.linkedAccount = :accountId' : '')# )";
            parameters['accountId'] = searchParams.accountId;
        }

        if (keyIsSet(arguments.searchParams,'accountIds')) {
            conditions &= " and (a.id in (:accountIds) #(includeLinked ? 'or a.linkedAccount in (:accountIds)' : '')# )";
            parameters['accountIds'] = listToArray(searchParams.accountIds);
        }

        if (keyIsSet(arguments.searchParams,'keyWords')) {
            conditions &= " and ( 1=1 ";
            for (var i = 1; i <= listlen(arguments.searchParams.keywords,","); i++) {
                var keyword = listGetAt(arguments.searchParams.keywords,i);
                conditions &= " and ( t.name like :keyWord#i# or t.note like :keyWord#i#)";
                parameters['keyWord#i#'] = "%#trim(keyword)#%";
            }
            conditions &= ")"; 
        }

        if (keyIsSet(arguments.searchParams, 'CategoryId')) {
            conditions &= " and c.id = :categoryId";
            parameters['categoryId'] = arguments.searchParams.CategoryId;
        }

        if (keyIsSet(arguments.searchParams, 'StartDate')) {
            conditions &= " and t.transactionDate >= :startDate";
            parameters['startDate'] = arguments.searchParams.StartDate;
        }

        if (keyIsSet(arguments.searchParams, 'EndDate')) {
            conditions &= " and t.transactionDate <= :endDate";
            parameters['endDate'] = arguments.searchParams.endDate;
        }

        //this doesn't work ... the logic is all wrong....
        //we need exclude where.... blah I'm going to sleep.
        // if (keyIsSet(arguments.searchParams, 'ExcludeInternalTransfers')) {
        //     conditions &= " 
        //         and t.id not in (
        //             SELECT transactionId1
        //             FROM internalTransfer
        //             WHERE user_id = :user_id
        //         )
        //         and t.id not in (
        //             SELECT transactionId2
        //             FROM internalTransfer
        //             WHERE user_id = :user_id
        //         )";
        //     parameters['user_id'] = userService.getCurrentUser().getId();
        // }

        var selectString = 't';
        if (returnType == 'simple') {
            selectString = "new map (
                date_format(t.transactionDate, '%m/%d/%Y')   as date, 
                t.name as name,
                a.name as account,
                t.note as note,
                c.name as category,
                ct.multiplier * t.amount as amount
            )";
        }

        return ORMexecuteQuery("
            SELECT #selectString#
            FROM transaction t
            JOIN t.account a
            JOIN t.category c
            JOIN c.type ct 
            WHERE #conditions#
            ORDER BY  t.id desc
        ", parameters, {maxResults:variables.limitedResultsCount});
    }

    public array function getUnverifiedTransactions(required account account, boolean includeSubAccounts = false){
        if (userService.checkAccount(arguments.account)) {
            return getTransactions(arguments.account, false, arguments.includeSubAccounts);
        }
    }

    public array function getVerifiedTransactions(required account account, boolean includeSubAccounts = false){
        if (userService.checkAccount(arguments.account)) {
            return getTransactions(arguments.account, true, arguments.includeSubAccounts);
        }
    }


    public numeric function getLastVerifiedID(required account account){
        if (userService.checkAccount(arguments.account)) {
            var qryLastVerifiedId = queryExecute("
                Select  coalesce(max(ID),0) as lastId
                From    transactions
                Where   VerifiedDate = 
                    (select max(verifiedDate) 
                    from transactions
                    where account_id = :accountid)
                and account_id = :accountid",
                {accountid: account.getId()}
            );  

            return qryLastVerifiedId.lastId;
        }
    }

    public void function verifyTransaction(required transaction transaction){
        if (userService.checkTransaction(arguments.transaction)) {
            transaction{ 
                if( not len(transaction.getVerifiedDate()) ){
                    transaction.setVerifiedDate(now());
                }
            }
        }
    }

    public void function unverifyTransaction(required transaction transaction){
        if (userService.checkTransaction(arguments.transaction)) {
            transaction{ 
                transaction.setVerifiedDate(javaCast("null",""));
            }
        }
    }

/** private functions **/

    private array function getTransactions(required account account, required boolean verified, required boolean includeSubAccounts) {
        if (userService.checkAccount(arguments.account)) {
            var includeSubAccountsClause = "";
            var verifiedCondition = "is null";

            if (arguments.includeSubAccounts) {
                includeSubAccountsClause = " OR a.id in (SELECT id from account sub where sub.linkedAccount = :account)";
            }
            
            if (arguments.verified) {
                verifiedCondition = "is not null";
            }

            return ORMExecuteQuery("
                SELECT t
                FROM transaction t
                JOIN t.account a
                WHERE (a = :account #includeSubAccountsClause#)
                AND   t.verifiedDate #verifiedCondition#
                and   isHidden = 0
                ORDER BY t.transactionDate desc",
            {account:arguments.account}, false, 
            {maxResults:variables.limitedResultsCount} );
        }
    }

    private boolean function keyIsSet(required struct structure, required string key) {
        return structKeyExists(arguments.structure, arguments.key) && len(arguments.structure[arguments.key]) > 0;
    }

}