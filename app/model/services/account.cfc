component output="false" {
    
    public any function getAccountByid(id){
        return entityLoadByPk( "account", arguments.id);
    }

    public any function createAccount(){
        return Entitynew( "account" );
    }

    public any function save(account){
        return EntitySave(arguments.account);
    }

    public any function getTypes(){
        return EntityLoad("accountType");
    }
}