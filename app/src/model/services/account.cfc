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

    public any function getUserAccounts( user ) {
        return ormExecuteQuery("
            Select a
            FROM account a
            left join a.linkedAccount l
            WHERE a.user = :user AND a.deleted IS NULL
            ORDER BY coalesce(l.type.id,a.type.id),
                     coalesce(l.name,a.name),
                     a.id", 
            {user: arguments.user});
    }

    public any function getAccountTypeById(id){
        return entityLoadByPk("accountType", arguments.id);
    }

    public any function createAccount(){
        return Entitynew( "account" );
    }

    public any function save(account){
        //by default, link an accoun to iteself
        if(not arguments.account.hasLinkedAccount()){
            arguments.account.setLinkedAccount(arguments.account);
        }
        EntitySave(arguments.account);
        ormflush();
    }

    public any function getTypes(){
        return EntityLoad("accountType");
    }
}