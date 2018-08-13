component name="account" output="false"  accessors=true {
    property greetingService;
    this.user = entityLoadByPK( "user", session.userid);

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function list( struct rc = {} ) {

        if(not this.user.hasAccounts()){
            variables.fw.setView('account.blank');
        } else {
            rc.accounts = this.user.getAccounts();
        }
    }

    public void function createEdit( struct rc = {} ){
        cfparam( name='rc.accountId', default="");
        cfparam( name="rc.accountTypeId", default="");
        cfparam( name="rc.summary", default="N");

        rc.errors = [];
        rc.errorMsg = "Correct the following items and try saving your account again.";

        /* If the account was submitted, run the validation */
        if(StructKeyExists(rc,"submitAddAccount")){

            rc.account = Entitynew( "account" );
            rc.account.setUser(this.user);
            rc.account.setName( rc.name );
            rc.account.setType( entityLoadByPK( "accountType", rc.accountTypeId) );
            rc.account.setSummary( rc.summary);

            if(rc.accountTypeId neq 0){
                rc.account.setLinkedAccount(rc.account);
            } else {
                rc.account.setLinkedAccount(entityLoadByPk( "account", rc.linkedAccount));
            }

            rc.errors = rc.account.validate();
            
            /* All validation passed, add the account */
            if(arraylen(rc.errors) eq 0){
                EntitySave(rc.account);
                location(url="../", addToken="false" );
            }

        } elseif (len(rc.accountId) eq 0) {

            rc.mode = 'create';
            rc.account = EntityNew("account");
        }

        //get the select list items
        rc.accountTypes = EntityLoad("accountType");
        rc.accounts = this.user.getAccounts();

    }


}
