component{

    public any function getUserById(id){
        return entityLoadByPK( "user", arguments.id);
    }

    public any function getOrCreate( string email ) {
        local.user = entityLoad( "user", {email: arguments.email},true);
        if( not structKeyExists(local,"user")){
            local.user = entityNew( "user" );
            local.user.setEmail(arguments.email);
            local.user.setUserName(arguments.email);
            EntitySave(local.user);
        } 
        return local.user;
    }

    public boolean function checkAccount(required component account) {
        if (arguments.account.getUser().getId()  != getCurrentUser().getId() ) {
            throw("Invalid acccount access");
        }
        return true;
    }

    public boolean function checkTransaction(required component transaction) {
        if (arguments.transaction.getAccount().getUser().getId() != getCurrentUser().getId()) {
            throw("Invalid account access");
        }
        return true;
    }

    public component function getCurrentUser(){
        return request.user;
    }
    
}