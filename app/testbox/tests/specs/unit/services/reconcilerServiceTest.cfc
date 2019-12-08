component extends="testbox.system.BaseSpec" {
	function run() {

		describe("The reconciler service", function() {
			beforeEach(function(){
				service = createMock("services.reconciler")
					.$property(propertyName="metadataService", mock = new services.metaDataService());
			});

			describe("Creates new ledger objects for reconciling", function(){
				it("creates a new ledger object", function(){
					var columnDef = createStub();
					var ledger = service.createLedger([columnDef]);
				});
			});		

			describe("It populates existing ledger objects", function(){
				beforeEach(function(){
					columnDef = createStub();
					ledger = service.createLedger([
						createStub().$("getName", "column1"),
						createStub().$("getName", "column2")
					]);
				});

				it("If the data contains a non component, it throws an error.", function(){
					expect(function(){
						service.populateLedger(ledger, ["not an object"]);
					}).toThrow("invalidTransactionType");
				});

				it("If the data does not inherit from 'aRecTransaction, it throws an error.", function(){
					expect(function(){
						service.populateLedger(ledger, [this]);
					}).toThrow("invalidTransactionType");
				});

			});
		});
	}
}