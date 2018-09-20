component output="false" {
    
    public any function getAccountByid(id){
        return entityLoadByPk( "account", arguments.id);
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