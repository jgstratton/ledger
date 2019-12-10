component extends="testbox.system.BaseSpec" {
	function run() {

		describe("The reconciler service", function() {
			beforeEach(function(){
				metaDataService = createMock("services.metaDataService");
				arrayUtil = createMock("utils.arrayUtil");
				service = createMock("services.reconciler")
					.$property(propertyName="metadataService", mock = metaDataService)
					.$property(propertyName="arrayUtil", mock = arrayUtil);
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

			describe("compares two transactions and assigns an numeric match index", function(){
				createTransaction = function(struct options) {
					var allOptions = options.Append({
						amount: 0,
						description: '',
						category: '',
						transactionDate: '01/01/2000'
					},false);
					return createStub()
						.$("getAmount", allOptions.amount)
						.$("getDescription", allOptions.description)
						.$("getCategory", allOptions.category)
						.$("getTransactionDate", allOptions.transactionDate);
				}
				compareTransactions = function(struct options1, struct options2) {
					return service.compareTransactions(createTransaction(options1), createTransaction(options2));
				}

				it("Transactions that have a matching amount should have a higher index than ones that don't", function(){
					var index1 = compareTransactions({amount: 1}, {amount:1});
					var index2 = compareTransactions({amount: 1}, {amount:2});
					expect(index1).toBeGT(index2);
				});

				it("Transactions that have matching dates should rank higher than ones that don't", function(){
					var index1 = compareTransactions({transactionDate: '01/01/2000'}, {transactionDate:'01/01/2000'});
					var index2 = compareTransactions({transactionDate: '01/01/2000'}, {transactionDate:'01/02/2000'});
					expect(index1).toBeGT(index2);
				});

				it("Transactions that have mathcing key words should rank higher than ones that don't", function(){
					var index1 = compareTransactions({description: 'Walmart Shopping Center'}, {description:'Walmart SuperCenter'});
					var index2 = compareTransactions({description: 'Lowes'}, {description:'Home Depot'});
					expect(index1).toBeGT(index2);
				});

				it("Transactions that have mathcing categories should rank higher than ones that don't", function(){
					var index1 = compareTransactions({category: 'Gas'}, {category:'Gas'});
					var index2 = compareTransactions({category: 'Dining'}, {category:'Gifts'});
					expect(index1).toBeGT(index2);
				});

				
				it("Matching amounts should rank higher than matching dates", function(){
					var index1 = compareTransactions({amount: '50', date: '01/01/2000'}, {amount:'50', date: '01/04/2000'});
					var index2 = compareTransactions({amount: '51', date: '01/01/2000'}, {amount:'52', date: '01/01/2000'});
					expect(index1).toBeGT(index2);
				});
			});
		});
	}
}