component name="account" output="false"  accessors=true {

    property accountService;
    property transactionService;
    property categoryService;

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function editCreate( struct rc = {}){
        var transaction = rc.transaction;

        if(StructKeyExists(rc,'submitTransaction')){
            variables.fw.populate(transaction);
            transaction.setCategory(categoryService.getCategoryById(rc.category));
            rc.errors = transaction.validate();
            if(arrayLen(rc.errors) eq 0){
                transactionService.save(transaction);
                rc.lastTransactionid = transaction.getid();
                variables.fw.redirect(action='transaction.#rc.returnpage#', append="lastTransactionid,accountid");
            }
        }
        rc.categories = categoryService.getCategories();

    }

    public void function new( struct rc = {} ){
        rc.account = accountService.getAccountByID(rc.accountid);
        rc.transaction = transactionService.createTransaction(rc.account);
        rc.transactions = transactionService.getRecentTransactions(rc.account);
        rc.returnPage = 'new';
        variables.editCreate(rc);
    }

    public void function edit( struct rc = {} ){
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.account = rc.transaction.getAccount();
        rc.accountid = rc.accountid = rc.account.getid();
        variables.editCreate(rc);
    }

    public void function verify( struct rc = {} ){
        rc.account = accountService.getAccountById(rc.accountid);
        rc.unverifiedTransactions = transactionService.getUnverifiedTransactions(rc.account);
        rc.verifiedTransactions = transactionService.getVerifiedTransactions(rc.account);
        rc.lastVerifiedTransaction = transactionService.getLastVerifiedTransaction(rc.account);
    }

    public void function clear( struct rc = {} ){
        rc.account = accountService.getAccountById(rc.accountid);   
    }

    public void function clear( struct rc = {} ){
        rc.account = accountService.getAccountById(rc.accountid);   
    }

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getUserAccounts(rc.user);
    }
}