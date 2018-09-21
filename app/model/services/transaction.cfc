component output="false" {

    public any function getTransactionByid(id){
        return entityLoadByPk( "transaction", arguments.id);
    }

    public any function createTransaction(account){
        return entityNew("transaction", {account: arguments.account} );
    }
    
}