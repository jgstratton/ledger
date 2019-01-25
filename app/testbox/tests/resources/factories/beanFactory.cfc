component extends="fw.ioc" {

    public any function init( any folders, struct config = { } ) {
        variables.mockBox = new testbox.system.mockBox();
        variables.baseSpec = new testbox.system.baseSpec();
        super.init(arguments.folders, arguments.config);
        return this;
    }

    public function mockAllBeans(){
        for (var bean in variables.beaninfo) {
            var mockedBean = prepareMock(this.getBean(bean));
        }
    }

    public any function getBean( string beanName, struct constructorArgs = { } ) {
        var newBean = super.getBean(arguments.beanName, arguments.constructorArgs);
        variables.mockBox.prepareMock(newBean);
        return newBean;
    }

    public any function addBean( string beanName, any beanValue ) {
        return super.addBean(arguments.beanName, variables.mockBox.prepareMock(arguments.beanValue));
    }

    public void function populateBeanFactory(required array beanConfigs){
        for (var beanConfig in beanConfigs) {
            if (!beanConfig.keyExists('isSingleton')){
                beanConfig.isSingleton = true;
            }
            declareBean(beanConfig.beanName, beanConfig.dottedPath, beanConfig.isSingleton);
            getBean(beanConfig.beanName);
        }
    }
}