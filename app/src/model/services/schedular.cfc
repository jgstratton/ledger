component accessors="true" {

    public void function scheduleEventGenerator(required struct schedularParameters) {
        var schedular = EntityNew("schedular", arguments.schedularParameters);
        schedular.save();
    }

    public array function getSchedularTypes(){
        return entityLoad("schedularType");
    }

    public component function getSchedularTypeById(required numeric typeId) {
        return entityLoadByPK("schedularType",arguments.typeId);
    }

    public void function saveSchedular(required component schedular) {
        EntitySave(schedular);
    }

    public boolean function schedularParameterValidForType(required string parameterName, required component schedularType) {
        return (listFindNocase(arguments.schedularType.getAllowedParameters(), arguments.parameterName));
    }

}