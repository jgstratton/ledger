//not using this yet... just kicking around ideas
component output="false"  accessors=true {
    public void function init(fw){
        variables.fw=arguments.fw;
    }
    /**
     * @middleware "requireLogin"
     */
    public void function getTransactions(required struct rc, required struct api){
        rc.response.setDataKey('rc',{testData: true});
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
}