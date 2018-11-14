component name="transfer" accessors=true {
    property transferService;
    property accountService;
    property transactionService;
    property categoryService;

    public component function init(required any fw) {
        variables.fw = arguments.fw;
        variables.validationJson = fileRead("#application.src_dir#/assets/json/validation/validateTransfer.json");
		return this;
    }
    
    public void function new( required struct rc ) {
        param name="rc.returnTo" default="transfer.new";
        rc.transfer = new beans.transfer();
        rc.accounts = accountService.getUserAccounts(rc.user);
        if (rc.keyExists('submit')){
            update(rc);
        }
        
    }

    public void function edit( required struct rc ) {
        param name="rc.returnTo" default="transfer.edit";
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.transfer = transferService.getTransferByTransactionId( rc.transactionid );
        
        if (rc.keyExists('submit')){
            update(rc);
        }
        rc.account = rc.transaction.getAccount();
        variables.fw.setView('transaction.edit');
    }

    private void function update( required struct rc ) {
        /* validate the form variables */
        var transferValidator = new beans.validator(validationJson, rc);
        rc.errors = transferValidator.validate();
        fw.populate(rc.transfer);
        rc.transfer.setFromAccountId(rc.fromAccountId);
        rc.transfer.setToAccountId(rc.toAccountId);

        /** 
         * Populate and validate the transfer 
         * If all validation passes, save the transfer and redirect to clear the form scope
        */
        if(rc.errors.len() == 0){ 
            rc.errors = transferService.validateTransfer(rc.user, rc.transfer);
            if (!rc.errors.len()){
                rc.transfer.save();
                rc.success = "The transfer has been saved";
                fw.redirect(action=rc.returnTo, preserve="success,accountId");
            }
        }
    }

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getUserAccounts(rc.user);
        rc.categories = categoryService.getCategories();
    }
}