component name="main" output="false"  accessors=true {
    property userService;

    public void function init(fw){
        variables.fw=arguments.fw;
    }

    public void function accountsList( struct rc = {} ) {

        if(not rc.user.hasAccount()){
            variables.fw.setView('account.blank');
        } else {
            rc.mainAccounts = rc.user.getAccountGroups();
            rc.summary = rc.user.getSummaryBalance();
        }
        variables.fw.setView('account.list');
    }

}
