component account{

    public component function getAccount(struct accountParameters){
        cfparam(name ="arguments.accountParameters.user", default = getUserFactory().getTestUser());
        cfparam(name ="arguments.accountParameters.type", default = getAccountType());
        var account = EntityNew("account", arguments.accountParameters);	
        account.save();
        return account;
    }

    public component function getAccountType(struct accountParameters) {
        cfparam(name ="arguments.accountParameters.name", default = 'Test Account Type');
        cfparam(name ="arguments.accountParameters.isVirtual", default = 0);
        var accountType = EntityNew("accountType", arguments.accountParameters);	
        accountType.save();
        return accountType;
    }

    public function getUserFactory() {
        return new factories.userFactory();
    }
}