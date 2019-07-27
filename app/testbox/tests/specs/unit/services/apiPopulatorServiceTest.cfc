component extends="testbox.system.BaseSpec" {
/*
    application.switchDatasource('appds');
    function afterAll(){
        application.switchDatasource('tests');
    }
*/

	function run() {

        var logger = createMock("services.logger")
            .$("debug");

		describe("The api populator service", function() {
            apiDataPopulatorService = createMock("services.apiDataPopulator")
                .$property(propertyName="loggerService", mock = logger)
                .$property(propertyName="hashUtil", mock = new utils.hashUtil());

			describe("will populate an account component", function() {
                
                var subAccount = createMock("beans.account")
                    .$("getId",2)
                    .$("getName","Test Sub Account")
                    .$("getInSummary",true);

                var account = createMock("beans.account")
                    .$("getId",1)
                    .$("getName","Test Account")
                    .$("getInSummary",true)
                    .$("getSubAccounts",[subAccount]);
                
                var transaction = new beans.transaction();
                    account.addTransaction(transaction);

                //create self reference so we can tests depth checks
                subAccount.$("getSubAccounts", [subAccount]);
                //subAccount.$("getLinkedAccount", account);

                it("will set simple data types using the getter functions", function() {
                    var apiData = new beans.apiData();
                    var apiStruct = apiDataPopulatorService.populateApiData(account, apiData);
                    expect(apiStruct.id).toBe(1);
                });

                it("will use custom api getter function if defined", function() {
                    var apiData = new beans.apiData();
                    var apiStruct = apiDataPopulatorService.populateApiData(account, apiData);
                    expect(apiStruct.inSummary).toBeTrue();
                });

                it("will populate a subComponent in a one-to-many relationship", function() {
                    var apiData = new beans.apiData();
                    var apiStruct = apiDataPopulatorService.populateApiData(account, apiData);
                    expect(apiStruct.subAccounts[1].name).toBe("Test Sub Account");
                });

                it("will stop populating when it's reached it's configured depth", function() {
                    var apiData = new beans.apiData({maxDepth: 1});
                    var apiStruct = apiDataPopulatorService.populateApiData(account, apiData);
                    expect(apiStruct.subAccounts.len()).toBe(0);
                });

                it("will skip components that are in the excluded list", function() {
                    var apiData = new beans.apiData({excludeProperties: 'transactions'});
                    var apiStruct = apiDataPopulatorService.populateApiData(account, apiData);
                    expect(apiStruct.keyExists('transactions')).toBe('false');
                });

                it("will only return hash value if obj was already processed", function() {
                    var apiData = new beans.apiData();
                    var apiStruct = apiDataPopulatorService.populateApiData(account, apiData);
                    expect(apiStruct.subAccounts[1]._hashValue).toBe(apiStruct.subAccounts[1].subAccounts[1]._hashValue);
                    expect(listlen(structKeyList(apiStruct.subAccounts[1].subAccounts[1]))).toBe(1);
                });

                    
			});
		});
	}
}