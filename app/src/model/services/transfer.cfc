component output="false" accessors="true" {
    property transactionService;

    public component function getTransferByTransactionId( required any transactionId ){
        var transaction = queryExecute("
            SELECT  id
            FROM    transactions
            WHERE   linkedTransID = :transactionId or id = :transactionId",
            { transactionId: arguments.transactionId });

        var transfer = new beans.transfer();
        transfer.populateFromTransaction( transactionService.getTransactionByid(transaction.id[1] ) );
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
        if ( !IsNull(arguments.transfer.getFromTransaction())  && arguments.transfer.getFromTransaction().getAccount().getId() != arguments.transfer.getFromAccount().getId() ){
            errors.append("Transaction / Account mismatch");
        }
        return errors;
    }
}