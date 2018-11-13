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

    public array function validateTransfer(required component user, required component transfer) {
        var errors = [];
   
        if (arguments.transfer.getFromAccount().getuser().getId() != arguments.user.getId()) {
            errors.append("#arguments.transfer.getToAccount().getName()# is not a valid account for the logged in user");
        }
        if (arguments.transfer.getToAccount().getUser().getId() != arguments.user.getId()) {
            errors.append("#arguments.transfer.getFromAccount().getName()# is not a valid account for the logged in user");
        }
        if (IsDefined(arguments.transfer.getFromTransaction()) && arguments.transfer.getFromTransaction().getAccount() != arguments.transfer.getFromAccount()){
            errors.append("Transaction / Account mismatch");
        }
        return errors;
    }
}