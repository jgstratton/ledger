component output="false" accessors="true" {

    public component function getTransactionByid(required numeric id){
        return entityLoadByPk( "transaction", arguments.id);
    }

    public component function createTransaction(required account account){
        return entityNew("transaction", {account: arguments.account} );
    }
    
    public void function deleteTransaction(required transaction transaction) {
        transaction{
            if (transaction.isTransfer()){
                EntityDelete(transaction.getLinkedTransaction());
            }
            EntityDelete(transaction);
        }

    }

    public void function save( required transaction transaction ){
        transaction{
            EntitySave(arguments.transaction);
        }
    }

    public array function getRecentTransactions(required account account){
        return ORMExecuteQuery("
            FROM transaction t
            WHERE account = :account
            and isHidden = 0
            ORDER BY t.transactionDate desc
        ",{account:arguments.account, maxresults: 50});
    }

    public array function getUnverifiedTransactions(required account account, boolean includeSubAccounts = false){
        return getTransactions(arguments.account, false, arguments.includeSubAccounts);
    }

    public array function getVerifiedTransactions(required account account, boolean includeSubAccounts = false){
        return getTransactions(arguments.account, true, arguments.includeSubAccounts);
    }

    private array function getTransactions(required account account, required boolean verified, required boolean includeSubAccounts) {
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
            ORDER BY t.transactionDate desc
        ",{account:arguments.account});
    }

    public numeric function getLastVerifiedID(required account account){
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

    public void function verifyTransaction(required transaction transaction){
        transaction{ 
            if( not len(transaction.getVerifiedDate()) ){
                transaction.setVerifiedDate(now());
            }
        }
    }

    public void function unverifyTransaction(required transaction transaction){
        transaction{ 
            transaction.setVerifiedDate(javaCast("null",""));
        }
    }
}