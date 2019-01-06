component displayName="Event Generator Tests" extends="testbox.system.BaseSpec" {

    function setup(){
        request.user = new generators.user().generate();
        eventGeneratorService = new services.eventGenerator();
    }

    function createEventGeneratorTest(){
        transaction{
            eventGeneratorService.createEventGenerator({
                eventName: "New Event Generator",
                eventDescription: "New Event Description"
            });
            ormFlush();
            var eventGeneratorCount = EntityLoad("eventGenerator", {user:request.user}).len();
            $assert.isEqual(1,eventGeneratorCount);
            transaction action="rollback";
        }
    } 

    function createTransactionGeneratorTest(){
        transaction{
            eventGeneratorService.createTransactionGenerator({
                eventName: "New Event Generator",
                eventDescription: "New Event Description"
            });
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

            eventGeneratorService.createTransferGenerator({
                eventName: "New Event Generator",
                eventDescription: "New Event Description",
                fromAccount: fromAccount,
                toAccount: toAccount
            });
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