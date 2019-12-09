component extends="testbox.system.BaseSpec" {
	function run() {

		describe("The reconciler service", function() {
			beforeEach(function(){
				metaDataService = createMock("services.metaDataService");
				service = createMock("services.reconciler")
					.$property(propertyName="metadataService", mock = metaDataService);
			});

			describe("Creates new ledger objects for reconciling", function(){
				it("creates a new ledger object", function(){
					var ledger = service.createLedger();
				});
			});		

			describe("It populates existing ledger objects", function(){
				beforeEach(function(){
					ledger = service.createLedger();
				});

				it("If the data contains a non component, it throws an error.", function(){
					expect(function(){
						service.populateLedger(ledger, ["not an object"]);
					}).toThrow("invalidTransactionType");
				});

				it("If the data does not implement iRecTransaction, it throws an error.", function(){
					expect(function(){
						service.populateLedger(ledger, [this]);
					}).toThrow("invalidTransactionType");
				});

				it("If the data in the array implements iRecTransaction, it doesn't throw an error an error.", function(){
					var transaction = createStub();
					metaDataService.$("implements", true);
					service.populateLedger(ledger, [transaction]);
				});
			});
		});
	}
}