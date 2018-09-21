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
            rc.errors = transaction.validate();
        }
        rc.categories = categoryService.getCategories();

    }

    public void function new( struct rc = {} ){
        rc.account = accountService.getAccountByID(rc.accountid);
        rc.transaction = transactionService.createTransaction(rc.account);
        variables.editCreate(rc);
    }
}