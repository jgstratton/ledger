component output="true"  accessors=true {

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    /**
     * @middleware "requireLogin"
     */
    public void function getAccounts(required struct rc){
        var accountsData = ArrayNew();
        var accounts = rc.user.getAccountGroups();
        for (var account in accounts) {
            var accountStruct = getApiDataPopulatorService().populateAccountsStruct(account, {maxDepth:10});
            accountsData.append(accountStruct);
        }
        rc.response.setDataKey('accounts',serializeJSON(accountsData));
    }

    public boolean function requireLogin(required struct rc, required struct api){
        return getMiddleWare().requireLogin(rc,api);
    }

    private component function getBeanFactory(){
        return request.beanfactory;
    }

    private component function getMiddleWare(){
        return getBeanFactory().getBean("apiMiddlewareService");
    }

    private component function getLogger(){
        return getBeanFactory().getBean("loggerService");
    }

    private component function getApiDataPopulatorService() {
        return getBeanFactory().getBean("apiDataPopulatorService");
    }

}