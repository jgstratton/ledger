component accessors="true" {
    property schedularService;
    property userService;
    
    public component function createEventGenerator(struct parameters = {}){
        return EntityNew("eventGenerator", addUserToParameters(arguments.parameters) );
    }

    public component function createGeneratorByType(required string eventGeneratorType, struct parameters = {}) {
        return invoke(this,"create#eventGeneratorType#Generator",arguments.parameters);
    }

    public array function getEventGenerators(){
        return EntityLoad(
            entityName = "eventGenerator", 
            filter = {user: userService.getCurrentUser()}, 
            order = "eventName asc",
            options = {ignorecase: true} );
    }

    public component function getEventGeneratorById(required numeric id) {
        return EntityLoadByPk("eventGenerator", arguments.id);
    }
    
    public void function saveEventGenerator(required component eventGenerator) {
        EntitySave(arguments.eventGenerator);
    }

    public component function createTransactionGenerator(struct parameters = {}) {
        if (!parameters.keyExists('schedular')) {
            arguments.parameters.schedular = schedularService.createSchedular();
        }
        return EntityNew("transactionGenerator", addUserToParameters(arguments.parameters) );
    }

    public component function createTransferGenerator(struct parameters = {}) {
        if (!parameters.keyExists('schedular')) {
            arguments.parameters.schedular = schedularService.createSchedular();
        }
        return EntityNew("transferGenerator", addUserToParameters(arguments.parameters) );
    }

    public void function runEventGenerator(required component eventGenerator) {
        invoke(this,"run#eventGenerator.getGeneratorType()#Generator", [arguments.eventGenerator]);
    }

    public void function runTransferGenerator(required component transferGenerator) {
        var transfer = new beans.transfer();
        populateObjectFromGenerator(arguments.transferGenerator, transfer);
        transfer.setTransferDate(dateAdd('d',transferGenerator.getDeferDate(), transferGenerator.getSchedular().getNextRunDate()));
        transfer.save();
    }

    public void function runTransactionGenerator(required component transactionGenerator) {
        var transaction = new beans.transaction();
        populateObjectFromGenerator(arguments.transactionGenerator, transaction);
        transaction.setTransactionDate(dateAdd('d',arguments.transactionGenerator.getDeferDate(), arguments.transactionGenerator.getSchedular().getNextRunDate()));
        transaction.save();
    }

/** Private functions **/

    private struct function addUserToParameters(required struct parameters) {
        var newParameters = structCopy(arguments.parameters);
        newParameters.user = userService.getCurrentUser();
        return newParameters;
    }

    private void function populateObjectFromGenerator(required component eventGenerator, required component target) {
        var generatorProperties = getMetaData(arguments.eventGenerator).properties;
        var targetProperties = getMetaData(arguments.target).properties;
    
        for (var generatorProperty in generatorProperties) {
            for (var targetProperty in targetProperties) {
                if (generatorProperty.name == targetProperty.name) {
                    var args = {};
                    var sourceValue = invoke(arguments.eventGenerator, "get#generatorProperty.name#");
                    if (!isNull(sourceValue)) {
                        args["#generatorProperty.Name#"] = sourceValue;
                        invoke(arguments.target, "set#generatorProperty.name#", args);
                    }
                }
            }
        }
    }
}