component displayName="Schedular Tests" extends="testbox.system.BaseSpec" {
    
    function eventGeneratorGetsScheduledTest() {
        transaction{
            schedularService = new services.schedular();
            eventGenerator = createMock("beans.generators.eventGenerator");
            eventGenerator.$property(propertyname="id",mock="1");
            schedularType = createMock("beans.schedularType");
            schedularType.$property(propertyname="id",mock="1");

            schedularService.scheduleEventGenerator({
                eventGenerator: eventGenerator,
                schedularType: schedularType,
                startDate: now()
            });
            
            ormFlush();
            schedularCount = EntityLoad("schedular").len();
            $assert.isEqual(1, schedularCount);
            
            transaction action="rollback";
        }
    }

   
}