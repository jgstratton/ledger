component name="account" output="false"  accessors=true {

    property greetingService;
    property userService;
    property accountService;
    
    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function list( struct rc = {} ) {

        if(not rc.user.hasAccounts()){
            variables.fw.setView('account.blank');
        } else {
            rc.mainAccounts = rc.user.getAccountGroups();
            rc.summary = rc.user.getSummaryBalance();
        }
    }

    private void function createEdit (struct rc = {}, account){
        var account = arguments.account;
        var accountService = variables.accountService;

        cfparam( name="rc.accountTypeId", default="");
        cfparam( name="rc.summary", default="N");

        rc.errors = [];
        rc.errorMsg = "Correct the following items and try saving your account again.";

        /* If the account was submitted, run the validation */
        if(StructKeyExists(rc,"submitAccount")){
            
            variables.fw.populate(account, "user, name, summary");
            account.setType( accountService.getAccountTypeByid(rc.accountTypeId) );
   
            if(account.isVirtual()){
                account.setLinkedAccount(accountService.getAccountByid(rc.linkedAccount));
            } else {
                account.setLinkedAccount(javacast("null",""));
            }

            rc.errors = account.validate();
            
            /* All validation passed, add the account */
            if(arraylen(rc.errors) eq 0){
                accountService.save(account);
                variables.fw.redirect("account.list");
            }
        }

        //get the select list items
        rc.accountTypes = accountService.getTypes();
        rc.accounts = rc.user.getAccountGroups();
    }

    public void function create( struct rc = {} ){
        var account = accountService.createAccount();
        createEdit(rc, account);
        rc.mode = 'create';
        rc.account = account;
        fw.setView('account.createEdit');
    }

    public void function edit( struct rc = {} ){
        
        var account = accountService.getAccountByid(rc.accountid);
        createEdit(rc, account);
        rc.mode = 'edit';
        rc.account = account;
        fw.setView('account.createEdit');
    }

    public void function delete( struct rc = {}){
        accountService.deleteAccountByid(rc.accountid);
        variables.fw.redirect('account.list');
    }

}
