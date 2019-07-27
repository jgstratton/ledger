component extends="testbox.system.BaseSpec" {
    function beforeAll(){
        application.switchDatasource('appds');
    }
    function afterAll(){
        application.switchDatasource('tests');
    }

	function run() {

        var logger = createMock("services.logger")
            .$("debug");

		describe("The api accounts controller", function() {
            apiDataPopulatorService = createMock("services.apiDataPopulator")                
                .$property(propertyName="hashUtil", mock = new utils.hashUtil());

            apiAccountsController = createMock("controllers.api.accounts")
                .$("getApiDataPopulatorService", apiDataPopulatorService);
            
            rc = {
                user: entityLoadByPK("user",1),
                response = new beans.response()
            };
            beforeEach( function(){
                
            }); 

			it("test getAccounts with my user", function() {
                apiAccountsController.getAccounts(rc);
			});
		});
	}
}