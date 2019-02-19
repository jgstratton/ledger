component name="account" output="false"  accessors=true {
    property transactionService;
    property accountService;

/** Lifecycle functions **/

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getAccounts();
    }

/** Controller Actions **/

    public void function search( struct rc = {} ){
        rc.transactions = transactionService.searchTransactions({});
    }

    public void function editTransaction( struct rc = {} ){
        rc.formAction = "transactionSearch.editTransaction";
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.account = rc.transaction.getAccount();
        rc.categories = categoryService.getCategories(rc.transaction);
        variables.update(rc);
    }

}