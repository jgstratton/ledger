component accessors="true" {

    public void function scheduleEventGenerator(required struct schedularParameters) {
        var schedular = EntityNew("schedular", arguments.schedularParameters);
        schedular.save();
    }

    public void function saveSchedular(required component schedular) {
        EntitySave(schedular);
    }

}