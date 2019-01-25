component account{

    public component function getAccount(struct accountParameters){
        cfparam(name ="arguments.accountParameters.user", default = getUserFactory().getTestUser());
        var account = EntityNew("account", arguments.accountParameters);	
        account.save();
        return account;
    }

    public function getUserFactory() {
        return new factories.userFactory();
    }
}