component name="account" output="false"  accessors=true {
    property transactionService;
    property accountService;
    property categoryService;

    public void function init(fw){
        variables.fw=arguments.fw;
    }

/** Lifecycle functions **/

    public void function after( struct rc = {} ){
        rc.accounts = accountService.getAccounts();
    }

/** Controller Actions **/

    public void function search( struct rc = {} ){
        rc.categories = categoryService.getCategories();
    }

    public void function getSearchResults( struct rc = {} ) {
        rc.transactions = transactionService.searchTransactions(rc);
        variables.fw.setLayout("ajax");
        variables.fw.setView("transactionSearch._searchResults");
    }

    public void function editTransaction( struct rc = {} ){
        rc.formAction = "transactionSearch.editTransaction";
        rc.transaction = transactionService.getTransactionById(rc.transactionid);
        rc.account = rc.transaction.getAccount();
        rc.categories = categoryService.getCategories(rc.transaction);
        variables.update(rc);
    }

}