component output="false" {
    property transactionService;
    
    public component function getTransferByTransactionId( int transactionId ){
        var transaction = ORMexecuteQuery("
            from transaction t
            where t.linkedTo = :transactionId or t.linkedFrom = :transactionId",
            { transactionId: arguments.transactionId }, true );
           
        var transfer = new beans.transfer( transaction.linkedFrom );
        return transfer;
    }
}