component transaction{

    public component function init(struct transactionParameters){
        cfparam(name ="arguments.transactionParameters.category", default = new generators.category());

        var transactionBean = EntityNew("transaction", arguments.transactionParameters);	
        transactionBean.save();
        return transactionBean;	
    }
    
}