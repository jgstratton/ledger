component extends="testbox.system.BaseSpec" {

	function run() {
		describe("The combinatorics combinations model", function() {
			
			it("trying to initialize with object items without providing a hash function will result in an error", function(){
				expect(function(){
					model = new beans.combinations([createStub()], 1);
				}).toThrow('MissingHashFunction');
			});

			it("trying to initialize with array items without providing a hash function will result in an error", function(){
				expect(function(){
					model = new beans.combinations([[1,2,3], [1,2]], 1);
				}).toThrow('MissingHashFunction');
			});

			describe("when initialized with an array of strings, and combination size of 3", function(){
				beforeEach(function(){
					model = new beans.combinations(
						['Dwalin','Balin','Kili','Fili','Dori','Nori','Ori','Oin','Gloin','Bifur','Bofur','Bombur','Thorin'],
						3
					);
				});

				it("will create 286 combinations (using the formula: 13!/3!*(13-3)!)", function(){
					expect(model.getCombinations().len()).toBe(286);
				});

				it("removing an item will reduce the possible cominations down to 220 (using the formula: 12!/3!*(12-3)!)", function(){
					model.removeItem('Oin');
					expect(model.getCombinations().len()).toBe(220);
				});

			});

			describe("when initialized with an array of 5 objects, and combination size of 2", function(){
				beforeEach(function(){
					createObjectStub = function(id) {
						return createStub().$("getId", id);
					}
					
					model = new beans.combinations(
						[createObjectStub(1), createObjectStub(2), createObjectStub(3), createObjectStub(4), createObjectStub(5)],
						2,
						function(item){
							return item.getId();
						}
					);
				});

				it("will create 10 combinations", function(){
					expect(model.getCombinations().len()).toBe(10);
				});

				it("removing an item will reduce the possible cominations down to 6", function(){
					model.removeItem(createObjectStub(2));
					expect(model.getCombinations().len()).toBe(6);
				});

			});

			describe("when duplicate items are included in the array, they will only count as one entry", function(){
				beforeEach(function(){
					model = new beans.combinations([1,2,2,2,2,2,3,3,3,3,4,5],2);
				});

				it("will create 10 combinations", function(){
					expect(model.getCombinations().len()).toBe(10);
				});

				it("removing an item will reduce the possible cominations down to 6", function(){
					model.removeItem(2);
					expect(model.getCombinations().len()).toBe(6);
				});

				
			});

			it("test", function(){
				expect(isBoolean(1) &&!isNumeric(1)).toBeFalse();
				expect(isNumeric(true)).toBeFalse();
			});

		});
	}
}