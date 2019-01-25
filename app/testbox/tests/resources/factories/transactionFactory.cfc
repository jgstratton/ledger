component {


    public component function createTransaction(struct transactionParameters){
        cfparam(name ="arguments.transactionParameters.category", default = getCategoryFactory().getCategory());
        cfparam(name = "arguments.transactionParameters.account", default = getAccountFactory().getAccount());
        var transaction = EntityNew("transaction", arguments.transactionParameters);	
        transaction.save();
        return transaction;	
    }

    public component function createExpenseTransaction(struct argTransactionParameters){
        var category = EntityLoad("Category",{name: "Miscellaneous"},true);
        arguments.argTransactionParameters.category = category;
        return createTransaction(arguments.argTransactionParameters);
    }

    public component function createCreditTransaction(struct argTransactionParameters){
        var category = EntityLoad("Category",{name: "Income"},true);
        arguments.argTransactionParameters.category = category;
        return createTransaction(arguments.argTransactionParameters);
    }
  
    public component function getCategoryFactory() {
        return new factories.categoryFactory();
    }

    public component function getAccountFactory() {
        return new factories.accountFactory();
    }

}