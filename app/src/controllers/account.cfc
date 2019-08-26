component name="account" output="false"  accessors=true {

    property userService;
    property accountService;
    property alertService;

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    private void function createEdit (struct rc = {}, account){
        var account = arguments.account;
        var accountService = variables.accountService;
        var errors = [];

        cfparam( name="rc.accountTypeId", default="");
        cfparam( name="rc.summary", default="N");

        /* If the account was submitted, run the validation */
        if(StructKeyExists(rc,"submitAccount")){
            
            variables.fw.populate(account, "user, name, summary");
            account.setType( accountService.getAccountTypeByid(rc.accountTypeId) );
   
            if(account.isVirtual()){
                account.setLinkedAccount(accountService.getAccountByid(rc.linkedAccount));
            } else {
                account.setLinkedAccount(javacast("null",""));
            }

            errors = account.validate();
            
            /* All validation passed, add the account */
            if(arraylen(errors) eq 0){
                accountService.save(account);
                variables.fw.redirect("account.list");
            }

            alertService.setTitle("danger","Correct the following items and try saving your account again.");
            alertService.addMultiple("danger",errors);
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
