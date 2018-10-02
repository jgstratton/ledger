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

    public any function getUnverifiedTransactions(account){
        return ORMExecuteQuery("
            FROM transaction t
            WHERE account = :account
            AND   t.verifiedDate is null
            ORDER BY t.transactionDate desc
        ",{account:arguments.account});
    }

    public any function getVerifiedTransactions(account){
        return ORMExecuteQuery("
            FROM transaction t
            WHERE account = :account
            AND   t.verifiedDate is not null
            ORDER BY t.transactionDate desc
        ",{account:arguments.account});
    }

    public any function getLastVerifiedID(account){
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

    public void function verifyTransaction(transaction){
        transaction{ 
            if( not len(transaction.getVerifiedDate()) ){
                transaction.setVerifiedDate(now());
            }
        }
    }

    public void function unverifyTransaction(transaction){
        transaction{ 
            transaction.setVerifiedDate(javaCast("null",""));
        }
    }
}