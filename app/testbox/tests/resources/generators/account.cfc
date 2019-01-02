component account{
    property userGenerator;
    public component function init(struct accountParameters){
        this.userGenerator = new generators.user();
        cfparam(name ="arguments.accountParameters.user", default = this.userGenerator.generate());
        var accountBean = EntityNew("account", arguments.accountParameters);	
        accountBean.save();
        return accountBean;	
    }
    
}