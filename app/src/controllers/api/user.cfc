component output="false"  accessors=true {

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    /**
     * @middleware "requireLogin"
     */
    public void function getUser(required struct rc, required struct api){
        var user = getUserService().getCurrentUser();
        var userStruct = {
            id: user.getId(),
            email: user.getEmail()
        }
        rc.response.setDataKey('user',userStruct);
    }

    /**
     * @middleware "requireLogin"
     */
    public void function getSummary(required struct rc, required struct api){
        getLogger().debug("getting summary balance");
        var user = getUserService().getCurrentUser();
        rc.response.setDataKey('summary',user.getSummaryBalance());
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

    private component function getUserService(){
        return getBeanFactory().getBean("userService");
    }

    private component function getLogger(){
        return getBeanFactory().getBean("loggerService");
    }

}