component name="account" output="false"  accessors=true {

    property accountService;
    property transactionService;
    property categoryService;
    property transferService;

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    private void function update( required struct rc ){
        var transaction = rc.transaction;

        if(StructKeyExists(rc,'submitTransaction')){
            variables.fw.populate(transaction);
            transaction.setCategory(categoryService.getCategoryById(rc.category));
            rc.errors = transaction.validate();
            if(arrayLen(rc.errors) eq 0){
                transactionService.save(transaction);
                rc.lastTransactionid = transaction.getid();
                variables.fw.redirect(action='transaction.#rc.returnpage#', append="lastTransactionid,accountid");            }
        }
    }

    public void function new( struct rc = {} ){
        rc.account = accountService.getAccountByID(rc.accountid);
        rc.transaction = transactionService.createTransaction(rc.account);
        rc.transactions = transactionService.getRecentTransactions(rc.account);
        rc.returnTo = 'transaction.new';
        variables.update(rc);
    }

    public void function edit( struct rc = {} ){
        rc.formAction = "transaction.edit";
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.account = rc.transaction.getAccount();
        variables.update(rc);
    }

    public void function verify( struct rc = {} ){
        rc.account = accountService.getAccountById(rc.accountid);
        rc.unverifiedTransactions = transactionService.getUnverifiedTransactions(rc.account);
        rc.verifiedTransactions = transactionService.getVerifiedTransactions(rc.account);
        rc.lastVerifiedId = transactionService.getLastVerifiedID(rc.account);
    }

    public void function clearOrUndo( struct rc = {}){
        
        var transaction = transactionService.getTransactionById(rc.transactionId);
        var account = transaction.getAccount();

        switch (listGetAt(rc.action,2,".")){
            case 'clear' :
                transactionService.verifyTransaction(transaction);
                break;
            case 'undo' :
                transactionService.unverifyTransaction(transaction);
                break;
        }
        
        rc.jsonResponse.verifiedLinkedBalance = account.getVerifiedLinkedBalance();
        rc.jsonResponse.lastVerifiedId = transactionService.getLastVerifiedID(account);
        
        variables.fw.setView('main.jsonresponse');
        
    }

    public void function clear( struct rc = {} ){
        variables.clearOrUndo(rc);
    }

    public void function undo( struct rc = {} ){
        variables.clearOrUndo(rc);
    }

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getUserAccounts(rc.user);
        rc.categories = categoryService.getCategories();
    }
}