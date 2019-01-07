component name="schedular" output="false" accessors=true {
    property eventGeneratorService;
    property accountService;
    property categoryService;

    public void function init(fw){
        variables.fw = arguments.fw;
    }

    public void function autoPaymentList(required struct rc){
        rc.generators = eventGeneratorService.getEventGenerators();
        rc.accounts = accountService.getAccounts();
        rc.categories = categoryService.getCategories();
        rc.transactionGenerator = eventGeneratorService.createTransactionGenerator();
        rc.transferGenerator = eventGeneratorService.createTransferGenerator();
    }

    public void function validateTransactionGeneratorForm(required struct rc){
        var response = {errors: []};

        if (!len(rc.eventName)) {
            response.errors.append("Please provide a name for this automatic transaction");
        }
 
        variables.fw.renderData().data( response ).type( 'json' );
    }

    public void function validateTransferGeneratorForm(required struct rc){
        var response = {errors: []};
        if (!len(rc.eventName)) {
            response.errors.append("Please provide a name for this automatic transfer");
        }
        variables.fw.renderData().data( response ).type( 'json' );
    }
}