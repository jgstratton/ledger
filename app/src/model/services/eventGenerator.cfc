component accessors="true" {

    public component function createEventGenerator(struct parameters = {}){
        return EntityNew("eventGenerator", addUserToParameters(arguments.parameters) );
    }

    public array function getEventGenerators(){
        return EntityLoad("eventGenerator", {user: request.user} );
    }
    
    public void function saveEventGenerator(required component eventGenerator) {
        transaction{
            return EntitySave(arguments.eventGenerator);
        }
    }

    public component function createTransactionGenerator(struct parameters = {}) {
        return EntityNew("transactionGenerator", addUserToParameters(arguments.parameters) );
    }

    public component function createTransferGenerator(struct parameters = {}) {
        return EntityNew("transferGenerator", addUserToParameters(arguments.parameters) );
    }

    private struct function addUserToParameters(required struct parameters) {
        var newParameters = structCopy(arguments.parameters);
        newParameters.user = request.user;
        return newParameters;
    }

}