component accessors=true extends="_base" {
    property loggerService;

    /**
     * use the target bean name to find the appropriate private function to handle *before* authorizations
     */
    public void function before(required component targetBean, required string methodName, required array args) {
        
        var beanMetaData = getMetaData(arguments.targetBean);
        var namedArgs = _translateArgs(arguments.targetBean, arguments.methodName, arguments.args);
        
        switch (beanMetaData.name){
            case "services.Transaction" :
                variables.beforeTransactionService(arguments.methodName, namedArgs);
                break;
            default:
                loggerService.error('Bean was configued for authorize interceptor, but not match was found for "#beanMetaData.name#"');
        }   

    }

    /**
     * Use the target bean name to find the appropriate private function to handle *after* authorizations
     */
    public void function after(required component targetBean, required string methodName, required array args, result) {
        var beanMetaData = getMetaData(arguments.targetBean);
        var namedArgs = _translateArgs(arguments.targetBean, arguments.methodName, arguments.args);

        if (arguments.keyExists('result')){
            switch (beanMetaData.name){
                case "services.Transaction" :
                    variables.afterTransactionService(arguments.result);
                    break;
                default:
                    loggerService.error('Bean was configued for authorize interceptor, but not match was found for "#beanMetaData.name#"');
            } 
        }
    }
    

    private void function beforeTransactionService(required string methodName, required struct namedArgs) {
        var currentUser = variables.getLoggedInUser();

        //loop through each of the arguments and check them by their type
        for (var argName in arguments.namedArgs){
            var arg = arguments.namedArgs[argName];
            
            //if a user account was passed in, then check to make sure that it matches the logged in user 
            if (getMetadata(arg).name == 'beans.account'){
                if(arg.getUser().getId() != currentUser.getId() ){
                    throw(message="Invalid user account access");
                }
            }

            //if a transaction was passed in, make sure its account matches the user's
            if (getMetadata(arg).name == 'beans.transaction'){
                if(arg.getAccount().getUser().getId() != currentUser.getId() ){
                    throw(message="Invalid user transaction / account access");
                }
            }
        }
    }

    private void function afterTransactionService(required result){
        var currentUser = variables.getLoggedInUser();

        switch (getMetadata(arguments.result).name){

            //if a user account was passed in, then check to make sure that it matches the logged in user 
            case "beans.account":
                if (arguments.result.getUser().getId() != currentUser.getId() ){
                    throw(message="Invalid user account access");
                }
                break;

            //if a transaction was passed in, make sure its account matches the user's
            case "beans.transaction":
                if(arguments.result.getAccount().getUser().getId() != currentUser.getId() ){
                    throw(message="Invalid user transaction / account access");
                }
                break;
        } 
    }
    
    private component function getLoggedInUser() {
        return request.context.user;
    }
}