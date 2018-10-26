component name="transfer" accessors=true {
    property transferService;
    property accountService;

    public void function new(){
        if(rc.keyExists('transactionid')){
            rc.transfer = transferService.getTransferByTransactionId(rc.transactionid);
            rc.fromAccountId = rc.transfer.getFromAccount().getid();
            rc.toAccountId = rc.transfer.getToAccount().getid();
        } else {
            rc.transfer = new beans.transfer();
            rc.fromAccountId = 0;
            rc.toAccountId = 0;
        }
        rc.accounts = accountService.getUserAccounts(rc.user);
        
    }
}