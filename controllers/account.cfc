component name="account" output="false"  accessors=true {
    property greetingService;
    this.user = entityLoadByPK( "user", session.userid);

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function list( struct rc = {} ) {

        if(not this.user.hasAccounts()){
            variables.fw.setView('account.blank');
        }
    }

    public void function createEdit( struct rc = {} ){
        cfparam( name='rc.accountId', default="0");
        cfparam( name="rc.accountTypeId", default="0");

        if(rc.accountId eq 0){
            rc.mode = 'create';
            rc.account = EntityNew("account");
        }

        rc.accountTypes = EntityLoad("accountType");
        rc.accounts = this.user.getAccounts();

        if( isDefined(rc.account.getType())){
            rc.accountTypeId = rc.account.getType().getId();
        }
    }


}
