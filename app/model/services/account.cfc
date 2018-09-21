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

    public any function getAccountTypeById(id){
        return entityLoadByPk("accountType", arguments.id);
    }

    public any function createAccount(){
        return Entitynew( "account" );
    }

    public any function save(account){
        EntitySave(arguments.account);
        ormflush();
    }

    public any function getTypes(){
        return EntityLoad("accountType");
    }
}