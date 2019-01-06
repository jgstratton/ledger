component accessors="true" {

    public component function createEventGenerator(required struct parameters){
        var newEventGenerator =  EntityNew("eventGenerator", addUserToParameters(arguments.parameters) );
        EntitySave(newEventGenerator);
        return newEventGenerator;
    }

    public array function getEventGenerators(){
        return EntityLoad("eventGenerator", {user: request.user} );
    }

    public component function createTransactionGenerator(required struct parameters) {
        var newtransactionGenerator =  EntityNew("transactionGenerator", addUserToParameters(arguments.parameters) );
        EntitySave(newtransactionGenerator);
        return newtransactionGenerator;
    }

    public component function createTransferGenerator(required struct parameters) {
        var newtransferGenerator =  EntityNew("transferGenerator", addUserToParameters(arguments.parameters) );
        EntitySave(newtransferGenerator);
        return newtransferGenerator;
    }

    private struct function addUserToParameters(required struct parameters) {
        var newParameters = structCopy(arguments.parameters);
        newParameters.user = request.user;
        return newParameters;
    }
}