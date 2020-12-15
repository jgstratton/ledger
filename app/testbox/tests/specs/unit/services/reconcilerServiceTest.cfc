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

			createTransaction = function(struct options) {
				var allOptions = options.Append({
					id: 0,
					amount: 0,
					description: '',
					category: '',
					transactionDate: '01/01/2000'
				},false);
				return createStub()
					.$("getId", allOptions.id)
					.$("getAmount", allOptions.amount)
					.$("getDescription", allOptions.description)
					.$("getCategoryName", allOptions.category)
					.$("getTransactionDate", allOptions.transactionDate)
					.$("getRecTransactionId", allOptions.id);
			}
	
			compareTransactions = function(struct options1, struct options2) {
				return service.compareTransactions(createTransaction(options1), [createTransaction(options2)]);
			}

			reconcile = function(array transactionArray1, array transactionArray2) {
				for (var i = 1; i <= transactionArray1.len(); i++){
					transactionArray1[i] = createTransaction(transactionArray1[i]);
				}
				for (var i = 1; i <= transactionArray2.len(); i++){
					transactionArray2[i] = createTransaction(transactionArray2[i]);
				}
				return service.reconcile(
					new beans.reconciler.recLedger(transactionArray1), 
					new beans.reconciler.recLedger(transactionArray2)
				);
			}

			describe("compares two transactions and assigns an numeric match index", function(){

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

			describe("reconciles two ledgers and returns a reconcile results object", function(){
				it("When transactions in both ledgers have the same amount and date, they should be matched", function(){
					var matchResults = reconcile(
						[
							{id:'1', amount: '50', date: '01/01/2000'}
						], 
						[
							{id:'2', amount: '50', date: '01/01/2000'},
							{id:'3', amount: '51', date: '01/01/2000'},
						]
					);
					expect(matchResults.getMatchMaps()).toBe([['1','2']]);
				});
	
				it("Transactions with the same amount and a matching keyword should match before a transaction with just a matching amount", function(){
					var matchResults = reconcile(
						[
							{id:'1', amount: '50', description:'Wine and Sprits'}
						], 
						[
							{id:'1', amount: '50', description: 'ATM'},
							{id:'2', amount: '50', description: 'The wine store'},
						]
					);
					expect(matchResults.getMatchMaps()).toBe([['1','2']]);
				});

				it("If two transactions combined match to a single transaction, then they should have a combined match", function(){
					var matchResults = reconcile(
						[	
							{id:'google', amount: '125', description: 'Google Pay'},
							{id:'utility', amount: '450', description: 'Utilities'}
						],
						[
							{id:'gas', amount: '250', description: 'Evil Gas Inc'},
							{id:'electric', amount: '200', description: 'ElectricForYou'},
							{id:'thing', amount: '125', description: 'Paid for that thing that day'}
						]
					);
					expect(matchResults.getMatchMaps()).toBe([
						['google', 'thing'],
						['utility', ['gas','electric']]
					]);
				});

				it("If one transaction matches to two transactions combined, then they should have a combined match", function(){
					var matchResults = reconcile(
						[
							{id:'gas', amount: '250', description: 'Evil Gas Inc'},
							{id:'electric', amount: '200', description: 'ElectricForYou'},
							{id:'thing', amount: '125', description: 'Paid for that thing that day'}
						],
						[	
							{id:'google', amount: '125', description: 'Google Pay'},
							{id:'utility', amount: '450', description: 'Utilities'}
						]	
					);
					expect(matchResults.getMatchMaps()).toBe([
						['thing', 'google'],
						[['gas','electric'], 'utility']
					]);
				});

				it("combinations in both directions can work in the same set", function(){
					var matchResults = reconcile(
						[	
							{id:'google', amount: '125', description: 'Google Pay'},
							{id:'utility', amount: '450', description: 'Utilities'},
							{id:'amazon1', amount: '50', description: 'First Amazon Purchase'},
							{id:'amazon2', amount: '50', description: 'Second Amazon Purchase'},
							{id:'amazon3', amount: '50', description: 'Third Amazon Purchase'},
						],
						[
							{id:'gas', amount: '250', description: 'Evil Gas Inc'},
							{id:'electric', amount: '200', description: 'ElectricForYou'},
							{id:'thing', amount: '125', description: 'Paid for that thing that day'},
							{id:'amazon', amount: '150', description: 'Combined amazon purchases'}
						]
							
					);
					expect(matchResults.getMatchMaps()).toBe([
						['google', 'thing'],
						['utility',['gas','electric']],
						[['amazon1','amazon2','amazon3'], 'amazon']
					]);
				});
			});
		});
	}
}