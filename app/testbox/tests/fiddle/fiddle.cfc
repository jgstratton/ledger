component extends="testbox.system.BaseSpec" {
    application.switchDatasource('appds');
    function afterAll(){
        application.switchDatasource('tests');
    }

	function run() {
		describe("Fiddle using the database", function() {
            
			it("Fiddle here...", function() {
                // fiddle here to test with "real" data instead of hitting the test database...
			});
		});
	}
}