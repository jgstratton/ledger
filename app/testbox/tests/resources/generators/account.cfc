component account{

    public component function init(struct accountParameters){
        cfparam(name ="arguments.accountParameters.user", default = new generators.user());
        var accountBean = EntityNew("account", arguments.accountParameters);	
        accountBean.save();
        return accountBean;	
    }
    
}