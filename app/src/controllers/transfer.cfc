component name="transfer" accessors=true {
    property transferService;
    property accountService;
    property transactionService;
    property categoryService;
    property alertService;

    public component function init(required any fw) {
        variables.fw = arguments.fw;
        variables.validationJson = fileRead("#application.src_dir#/assets/json/validation/validateTransfer.json");
		return this;
    }
    
    public void function new( required struct rc ) {
        param name="rc.returnTo" default="transfer.new";
        rc.transfer = new beans.transfer();
        rc.accounts = accountService.getAccounts();
        if (rc.keyExists('submitTransaction')){
            update(rc);
        }
        variables.fw.setView('transaction.newTransfer');
    }

    public void function edit( required struct rc ) {
        param name="rc.returnTo" default="transfer.edit";
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.transfer = transferService.getTransferByTransactionId( rc.transactionid );
        
        if (rc.keyExists('submitTransaction')){
            update(rc);
        }
        rc.account = rc.transaction.getAccount();
        variables.fw.setView('transaction.edit');
    }

    private void function update( required struct rc ) {
        /* validate the form variables */
        var transferValidator = new beans.validator(validationJson, rc);
        var errors = transferValidator.validate();
        fw.populate(rc.transfer);
        rc.transfer.setFromAccountId(rc.fromAccountId);
        rc.transfer.setToAccountId(rc.toAccountId);
        
        if(rc.fromAccountId == rc.toAccountId){
            errors.append("From account and To account cannot be the same");
        }

        /** 
         * Populate and validate the transfer 
         * If all validation passes, save the transfer and redirect to clear the form scope
        */
        if(errors.len() == 0){ 
            errors = transferService.validateTransfer(rc.user, rc.transfer);
            if (!errors.len()){
                rc.transfer.save();
                alertService.add("success","The transfer has been saved");
                fw.redirect(action=rc.returnTo, preserve="success,accountId");
            }
        }

        //display the errors to the user
        alertService.setTitle("danger", "Please correct the following errors and then try to save your transfer again.");
        alertService.addMultiple("danger", errors);
    }

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getAccounts();
        rc.categories = categoryService.getCategories();
    }
    
}