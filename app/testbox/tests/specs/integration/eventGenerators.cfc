component displayName="Event Generator Tests" extends="testbox.system.BaseSpec" {

    function setup(){
        request.user = new generators.user().generate();
        eventGeneratorService = new services.eventGenerator();
    }

    function createEventGeneratorTest(){
        transaction{
            var newEventGenerator = eventGeneratorService.createEventGenerator({
                eventName: "New Event Generator",
                eventDescription: "New Event Description"
            });
            EntitySave(newEventGenerator);
            ormFlush();
            var eventGeneratorCount = EntityLoad("eventGenerator", {user:request.user}).len();
            $assert.isEqual(1,eventGeneratorCount);
            transaction action="rollback";
        }
    } 

    function createTransactionGeneratorTest(){
        transaction{
            var newEventGenerator = eventGeneratorService.createTransactionGenerator({
                eventName: "New Event Generator"
            });
            EntitySave(newEventGenerator);
            ormFlush();    
            var eventGeneratorCount = EntityLoad("transactionGenerator", {user:request.user}).len();
            $assert.isEqual(1,eventGeneratorCount);
            transaction action="rollback";
        }
    } 

    function createTransferGeneratorTest() {
        transaction{
            var fromAccount = createMock("beans.account");
            var toAccount = createMock("beans.account");
            fromAccount.$property(propertyname="id", mock="1");
            toAccount.$property(propertyname="id", mock="2");

            var newEventGenerator = eventGeneratorService.createTransferGenerator({
                eventName: "New Event Generator"
                fromAccount: fromAccount,
                toAccount: toAccount
            });
            EntitySave(newEventGenerator);
            ormFlush();
            var eventGeneratorCount = EntityLoad("transferGenerator", {user:request.user}).len();
            $assert.isEqual(1,eventGeneratorCount);
            transaction action="rollback";
        }
    }

    function checkPrepopulatedSchedularTypesTest(){
        var schedularTypesCount  = EntityLoad("schedularType").len();
        $assert.isNotEqual(0,schedularTypesCount);
    }
}