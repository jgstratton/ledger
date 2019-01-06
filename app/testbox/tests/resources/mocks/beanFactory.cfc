component {
    property name="beans" type="struct";

    public component function init(){
        this.beans = structNew();
        return this;
    }

    public function getBean(beanName){
        if (!structKeyExists(this.beans,arguments.beanName)){
            var newBean = createObject(getPathFromBeanName(beanName));
            this[beanName] = initializeBean(newBean);
        }
        return this[beanName];
    }

    private string function getPathFromBeanName(required string beanName) {
        if (right(arguments.beanName,7) == "Service") {
            return "services." & mid(arguments.beanName,1, len(arguments.beanName) - 7);
        }
        return arguments.beanName;
    }

    private component function initializeBean(required component bean){
        var beanMetaData = getComponentMetadata(arguments.bean);
        for (var i = 1; i <= beanMetaData.functions.len(); i++){
            if (beanMetaData.functions[i].name == 'init'){
                return arguments.bean.init();
            }
        }
        return arguments.bean;
    }
}