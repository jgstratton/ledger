component category{

    public component function generateTransaction(struct transactionParameters){
        cfparam(name ="arguments.transactionParameters.category", default = new generators.category());
        var transactionBean = EntityNew("transaction", arguments.transactionParameters);	
        transactionBean.save();
        return transactionBean;	
    }

    public component function generateExpenseTransaction(struct argTransactionParameters){
        var category = EntityLoad("Category",{name: "Miscellaneous"},true);
        var transactionParameters = {};
        if (arguments.keyExists('argTransactionParameters')) {
            transactionParameters = StructCopy(arguments.argTransactionParameters);
        }
        transactionParameters.category = category;

        var transactionBean = EntityNew("transaction", transactionParameters);	
        transactionBean.save();
        return transactionBean;	
    }

    public component function generateCreditTransaction(struct argTransactionParameters){
        var category = EntityLoad("Category",{name: "Income"},true);
        var transactionParameters = {};
        if (arguments.keyExists('argTransactionParameters')) {
            transactionParameters = StructCopy(arguments.argTransactionParameters);
        }
        transactionParameters.category = category;

        var transactionBean = EntityNew("transaction", transactionParameters);	
        transactionBean.save();
        return transactionBean;	
    }
    

}