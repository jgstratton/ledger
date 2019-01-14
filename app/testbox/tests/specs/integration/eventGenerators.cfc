component displayName="Event Generator Tests" extends="testbox.system.BaseSpec" {

    function setup(){
        request.user = new generators.user().generate();
        eventGeneratorService = createMock("services.eventGenerator");
        eventGeneratorService.$property(propertyName="schedularService", mock= new services.schedular());
    }

    function createEventGeneratorTest(){
        transaction{
            var newEventGenerator = eventGeneratorService.createEventGenerator({
                eventName: "New Event Generator"
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
                eventName: "New Event Generator",
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

    public void function runTransferGenerator_transferGetsCreated_Test(){ 
        transaction{
            var generatorService = new services.eventGenerator();
            var account1 = EntityNew("account");
            var account2 = Entitynew("account");
            EntitySave(account1);
            EntitySave(account2);
            var schedular = createMock("beans.schedular");
            schedular.$("getNextRunDate",now());
            var transferGenerator = Entitynew("transferGenerator", {
                amount: 10.00,
                fromAccount:account1,
                toAccount: account2,
                deferDate:1,
                schedular: schedular
            });
            $assert.isEqual(0,EntityLoad("transaction").len());
            generatorService.runEventGenerator(transferGenerator);
            ormFlush();
            $assert.isEqual(2,EntityLoad("transaction").len());
            transaction action="rollback";
        }
    }

    public void function runTransactionGenerator_TransactionGetsCreated_Test(){ 
        transaction{
            var generatorService = new services.eventGenerator();
            var account = EntityNew("account");
            var category = EntityNew("category");
            EntitySave(account);
            EntitySave(category);
            var schedular = createMock("beans.schedular");
            schedular.$("getNextRunDate",now());
            var transactionGenerator = Entitynew("transactionGenerator", {
                account: account,
                category: category,
                amount: 10.00,
                name: 'Test transaction',
                schedular: schedular
            });
            $assert.isEqual(0,EntityLoad("transaction").len());
            generatorService.runEventGenerator(transactionGenerator);
            ormFlush();
            $assert.isEqual(1,EntityLoad("transaction").len());
            transaction action="rollback";
        }
    }

}