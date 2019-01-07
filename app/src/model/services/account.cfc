component output="false" {
    
    public any function getAccountByid(id){
        return entityLoadByPk( "account", arguments.id);
    }

    /* 
     Soft-delete accounts when transactions exist, if no
     transactions exist then delete the entire account
    */
    public any function deleteAccountByid(id){
    
        transaction{
            var account = EntityLoadByPk("account",arguments.id);
            if(account.hasTransactions()){
                account.setDeleted(now());
            } else {
                EntityDelete(account);
            }
        }  
    
    }

    public any function getAccounts() {
        return ormExecuteQuery("
            Select a
            FROM account a
            left join a.linkedAccount l
            WHERE a.user = :user AND a.deleted IS NULL
            ORDER BY coalesce(l.type.id,a.type.id),
                     coalesce(l.name,a.name),
                     a.id", 
            {user: request.user});
    }

    public any function getAccountTypeById(id){
        return entityLoadByPk("accountType", arguments.id);
    }

    public any function createAccount(){
        return Entitynew( "account" );
    }

    public any function save(account){
        //do not let account link to itself
        if (account.hasLinkedAccount() && account.getLinkedAccountId() == account.getId()) {
            account.removeLinkedAccount();
        }
        EntitySave(arguments.account);
        ormflush();
    }

    public any function getTypes(){
        return EntityLoad("accountType");
    }

    public boolean function hasCommonParent(required component account1, required component account2) {
        if (account1.getId() == account2.getId()) {
            return true;
        } else if (account1.getLinkedAccountId() == account2.getId()) {
            return true;
        } else if (account2.getLinkedAccountId() == account1.getId()) {
            return true;
        }
        return false;
    }
}