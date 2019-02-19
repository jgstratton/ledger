component output="false" accessors="true" {
    property userService;
    property name="limitedResultsCount" default=100;

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

    public array function getRecentTransactions(required account account){
        if (userService.checkAccount(arguments.account)) {
            return ORMExecuteQuery("
                FROM transaction t
                WHERE account = :account
                and isHidden = 0
                ORDER BY t.transactionDate desc, t.id desc
            ",{account:arguments.account}, false, {maxResults:variables.limitedResultsCount});
        }
    }

    public array function searchTransactions(required struct searchParams) {
        var conditions = "a.user = :user";
        var parameters = {user: userService.getCurrentUser()};

        return ORMexecuteQuery("
            SELECT t
            FROM transaction t
            JOIN t.account a
            WHERE #conditions#
            ORDER BY t.transactionDate desc
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
}