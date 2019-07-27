component extends="testbox.system.BaseSpec" {

	function run() {
        var accountFactory = new resources.factories.accountFactory();
        var userFactory = new resources.factories.userFactory();

		describe("The api accounts controller", function() {
            populator = createMock("services.apiDataPopulator")
                .$("getHashUtil", new utils.hashUtil(), false);
            controller = createMock("controllers.api.accounts")
                .$("getApiDataPopulatorService", populator);     
            rc = {
                user: userFactory.getTestUser(),
                response: new beans.response()
            }

            //wrap all functions in a transaction and rollback.  We don't need to persist any changes
            aroundEach( function( spec, suite ){
                transaction action="begin"{
                    arguments.spec.body();
                    transaction action="rollback";
                }
            });

			describe("has a getAccounts function", function() {

                it("that will return accounts data as a struct", function() {
                    var parentAccount = accountFactory.getAccount();
                    var subAccount = accountFactory.getAccount( {linkedAccount: parentAccount} );
                    rc.user.addAccount(parentAccount);
                    ormFlush();
                    controller.getAccounts(rc);

                    var responseData = rc.response.getData()
                    expect( responseData ).toBeTypeOf( 'struct' );
                    expect( responseData ).toHaveKey( 'accounts' );
                    expect( len(responseData) ).notToBe(0);
                });
                    
			});
		});
	}
}