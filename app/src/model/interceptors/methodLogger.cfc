component accessors=true extends="_base" {
    property loggerService;

    /**
     * use the target bean name to find the appropriate private function to handle *before* authorizations
     */
    public void function before(required component targetBean, required string methodName, required array args) {
        var beanMetaData = getMetaData(arguments.targetBean);
        loggerService.debug("Method Logger - Object: #beanMetaData.name#, Method: #arguments.methodName#");
    }

}