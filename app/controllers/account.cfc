component name="account" output="false"  accessors=true {

    property greetingService;
    property userService;
    property accountService;
    
    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function list( struct rc = {} ) {
        local.user = variables.userService.getUserById(session.userid);
        if(not local.user.hasAccounts()){
            variables.fw.setView('account.blank');
        } else {
            rc.accounts = local.user.getAccounts();
        }
    }

    public void function createEdit( struct rc = {} ){
        var accountService = variables.accountService;
        
        local.user = variables.userService.getUserById(session.userid);

        cfparam( name='rc.accountId', default="");
        cfparam( name="rc.accountTypeId", default="");
        cfparam( name="rc.summary", default="N");

        rc.errors = [];
        rc.errorMsg = "Correct the following items and try saving your account again.";

        /* If the account was submitted, run the validation */
        if(StructKeyExists(rc,"submitAddAccount")){
            

            rc.account = accountService.createAccount();
            rc.account.setUser(local.user);
            rc.account.setName( rc.name );
            rc.account.setType( accountService.getAccountByid(rc.accountTypeId) );
            rc.account.setSummary( rc.summary);

            if(rc.accountTypeId neq 0){
                rc.account.setLinkedAccount(rc.account);
            } else {
                rc.account.setLinkedAccount(accountService.getAccountByid(rc.linkedAccount));
            }

            rc.errors = rc.account.validate();
            
            /* All validation passed, add the account */
            if(arraylen(rc.errors) eq 0){
                accountService.save(rc.account);
                location(url="../", addToken="false" );
            }

        } elseif (len(rc.accountId) eq 0) {

            rc.mode = 'create';
            rc.account = accountService.createAccount();
        }

        //get the select list items
        rc.accountTypes = accountService.getTypes();
        rc.accounts = local.user.getAccounts();

    }


}
