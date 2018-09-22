component output="false" {

    public any function getTransactionByid(id){
        return entityLoadByPk( "transaction", arguments.id);
    }

    public any function createTransaction(account){
        return entityNew("transaction", {account: arguments.account} );
    }
    
    public any function save(transaction){
        transaction{
            EntitySave(arguments.transaction);
        }
    }

    public any function getRecentTransactions(account){
        return ORMExecuteQuery("
            FROM transaction t
            WHERE account = :account
            ORDER BY t.transactionDate desc
        ",{account:arguments.account, maxresults: 50});

    }

}