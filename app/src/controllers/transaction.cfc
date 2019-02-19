component name="account" output="false"  accessors=true {

    property accountService;
    property transactionService;
    property categoryService;
    property transferService;
    property alertService;
    property checkbookSummaryService;
    
    public void function init(fw){
        variables.fw=arguments.fw;
    }

/** Lifecycle functions **/

    public void function before( required struct rc ){
        param name="rc.returnTo" default="#variables.fw.getSectionAndItem()#";
    }

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getAccounts();
    }

/** Controller Actions **/

    public void function newTransaction( struct rc = {} ){
        rc.account = accountService.getAccountByID(rc.accountid);
        rc.transaction = transactionService.createTransaction(rc.account);
        rc.transactions = transactionService.getRecentTransactions(rc.account);
        rc.categories = categoryService.getCategories();
        variables.update(rc);
    }

    public void function edit( struct rc = {} ){
        rc.formAction = "transaction.edit";
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.account = rc.transaction.getAccount();
        rc.categories = categoryService.getCategories(rc.transaction);
        variables.update(rc);
    }

    public void function verify( struct rc = {} ){
        param name="rc.includeSubaccounts" default="0";
        rc.account = accountService.getAccountById(rc.accountid);
        rc.unverifiedTransactions = transactionService.getUnverifiedTransactions(rc.account, rc.includeSubaccounts);
        rc.verifiedTransactions = transactionService.getVerifiedTransactions(rc.account, rc.includeSubaccounts);
        rc.lastVerifiedId = transactionService.getLastVerifiedID(rc.account);
    }

    public void function deleteTransaction(required struct rc){
        var transaction = transactionService.getTransactionById(rc.transactionId);
        transactionService.deleteTransaction(transaction);
        checkbookSummaryService.transferSummaryRounding();
        variables.fw.redirect(action='transaction.#rc.returnTo#', append="accountid");
    }

    public void function clear( struct rc = {} ){
        var transaction = transactionService.getTransactionById(rc.transactionId);
        var account = transaction.getAccount();

        transactionService.verifyTransaction(transaction);

        rc.jsonResponse.verifiedLinkedBalance = account.getVerifiedLinkedBalance();
        rc.jsonResponse.lastVerifiedId = transactionService.getLastVerifiedID(account);

        variables.fw.setView('main.jsonresponse');
    }

    public void function undo( struct rc = {} ){
        var transaction = transactionService.getTransactionById(rc.transactionId);
        var account = transaction.getAccount();
        
        transactionService.unverifyTransaction(transaction);

        rc.jsonResponse.verifiedLinkedBalance = account.getVerifiedLinkedBalance();
        rc.jsonResponse.lastVerifiedId = transactionService.getLastVerifiedID(account);

        variables.fw.setView('main.jsonresponse');
    }

/** Private functions **/

    private void function update( required struct rc ){
        var transaction = rc.transaction;
        var errors = [];

        if (StructKeyExists(rc,'submitTransaction')){
            variables.fw.populate(transaction);
            transaction.setCategory(categoryService.getCategoryById(rc.category));
            if (rc.keyExists('newAccountId')) {
                transaction.setAccount(accountService.getAccountById(rc.newAccountId));
            }
            errors = transaction.validate();

            if (arrayLen(errors)){
                alertService.setTitle("danger","Please correct the follow errors:");
                alertService.addMultiple("danger",errors);
            } else {
                transactionService.saveTransaction(transaction);
                checkbookSummaryService.transferSummaryRounding();
                rc.lastTransactionid = transaction.getid();
                variables.fw.redirect(action='transaction.#rc.returnTo#', append="lastTransactionid,accountid");
            }
        }
    }

}