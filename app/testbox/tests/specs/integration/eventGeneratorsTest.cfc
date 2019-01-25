component displayName="Event Generator Tests" extends="resources.BaseSpec" {

    function setup(){
        variables.userService = createMock("services.user");
        variables.user = createMock("beans.user");
        user.$property(propertyName="id",mock="1");
        userService.$("getCurrentUser", user);
        eventGeneratorService = createMock("services.eventGenerator");
        eventGeneratorService.$property(propertyName="schedularService", mock= new services.schedular());
        eventGeneratorService.$property(propertyName="userService", mock = userService);
    }

    function createEventGeneratorTest(){
        transaction{
            var newEventGenerator = eventGeneratorService.createEventGenerator({
                eventName: "New Event Generator"
            });
            EntitySave(newEventGenerator);
            ormFlush();
            var eventGeneratorCount = EntityLoad("eventGenerator", {user:userService.getCurrentUser()}).len();
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
            var eventGeneratorCount = EntityLoad("transactionGenerator", {user:userService.getCurrentUser()}).len();
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
                eventName: "New Event Generator",
                fromAccount: fromAccount,
                toAccount: toAccount
            });
            EntitySave(newEventGenerator);
            ormFlush();
            var eventGeneratorCount = EntityLoad("transferGenerator", {user:userService.getCurrentUser()}).len();
            $assert.isEqual(1,eventGeneratorCount);
            transaction action="rollback";
        }
    }

    function checkPrepopulatedSchedularTypesTest(){
        var schedularTypesCount  = EntityLoad("schedularType").len();
        $assert.isNotEqual(0,schedularTypesCount);
    }

}