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
                variables.fw.redirect(action='transaction.new', append="lastTransactionid,accountid");
            }
        }
        rc.categories = categoryService.getCategories();

    }

    public void function new( struct rc = {} ){
        rc.account = accountService.getAccountByID(rc.accountid);
        rc.transaction = transactionService.createTransaction(rc.account);
        rc.transactions = transactionService.getRecentTransactions(rc.account);
        variables.editCreate(rc);
    }
}