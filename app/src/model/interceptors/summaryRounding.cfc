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
                        checkbookSummaryService.transferSummaryRounding(request.user);
                        return;
                    default: 
                        return;
                }
                break;
            default:
                loggerService.error('Bean was configued for authorize interceptor, but ot match was found for "#beanMetaData.name#"');
        } 

    }
}