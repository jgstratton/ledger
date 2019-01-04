component accessors=true extends="_base" {
    property loggerService;
    property checkbookSummaryService;
    
    /**
     * Use the target bean name to find the appropriate private function to handle *after* authorizations
     */
    public void function after(required component targetBean, required string methodName, required array args, result) {
        var beanMetaData = getMetaData(arguments.targetBean);

        switch (beanMetaData.name){
            case "services.Transaction" :
                switch (arguments.methodName){
                    case "deleteTransaction" :
                    case "save" :
                        transferSummaryRoundingAndLog(beanMetaData.name,arguments.methodName);
                        return;
                    default: 
                        return;
                }
                break;
            default:
                loggerService.error('Bean was configued for authorize interceptor, but ot match was found for "#beanMetaData.name#"');
        } 

    }

    private void function transferSummaryRoundingAndLog(required string beanName, required string methodName){
        checkbookSummaryService.transferSummaryRounding(request.user);
        loggerService.debug("auto rounding called from summaryRounding intercepter.  Bean name: #arguments.beanName#. Method name: #arguments.methodName#");
    }
}