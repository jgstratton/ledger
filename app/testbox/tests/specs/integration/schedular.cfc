component displayName="Schedular Tests" extends="resources.BaseSpec" {
    
    function eventGeneratorGetsScheduledTest() {
        transaction{
            schedularService = new services.schedular();
            eventGenerator = createMock("beans.generators.eventGenerator");
            eventGenerator.$property(propertyname="eventGeneratorId",mock="1");
            schedularType = createMock("beans.schedularType");
            schedularType.$property(propertyname="id",mock="1");

            schedular = EntityNew("schedular");
            schedular.setEventGenerator(eventGenerator);
            schedular.setSchedularType(schedularType);
            
            schedularService.saveSchedular(schedular);
            ormFlush();
            schedularCount = EntityLoad("schedular").len();
            $assert.isEqual(1, schedularCount);
            transaction action="rollback";
        }
    }

   
}