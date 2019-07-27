component output="false"  accessors=true {

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    /**
     * @middleware "requireLogin"
     */
    public void function getAccounts(required struct rc, required struct api){
        var accountsData = ArrayNew();

        var accounts = rc.user.getAccountGroups();
        for (var account in accounts) {
            var accountStruct = {
                id: account.getId(),
                name: account.getName(),
                iconClass: account.getIcon(),
                balance: account.getBalance(),
                linkedBalance: account.getLinkedBalance(),
                verifiedLinkedBalance: account.getVerifiedLinkedBalance(),
                inSummary: account.inSummary() ? true : false,
                subAccounts: []
            };

            accountsData.append(accountStruct);
        }

        rc.response.setDataKey('accounts',accountsData);
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

}