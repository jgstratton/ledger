component extends="testbox.system.BaseSpec" {

	function run() {
		describe("The array util service", function() {
            var arrayUtilService = new utils.arrayUtilService();

            var createObj = function(objType, propStruct) {
                var obj = createEmptyMock(objType);
                for (var prop in propStruct){
                    obj.$("get#prop#",propStruct[prop]);
                }
                return obj;
            }

			it("Can get distinct components from an array of the same components", function() {
                var obj1 = createObj("beans.user", {id:1, name: 'test1'});
                var obj2 = createObj("beans.user", {id:1, name: 'test1'});
                var obj3 = createObj("beans.user", {id:1, name: 'test2'});

                expect(arrayUtilService.getDistinctComponents([obj1, obj2, obj3], "id,name").len()).toBe(2);
            });
            
            it("Can get distinct components of different types", function() {
                var obj1 = createObj("beans.user", {id:1, name: 'test1'});
                var obj2 = createObj("beans.account", {id:1, name: 'test1'});
                var obj3 = createObj("beans.user", {id:1, name: 'test1'});

                expect(arrayUtilService.getDistinctComponents([obj1, obj2, obj3], "id,name").len()).toBe(2);
            });
            
            it("Uses the property list passed in to determine uniqueness", function() {
                var obj1 = createObj("beans.user", {id:1, name: 'name 1'});
                var obj2 = createObj("beans.user", {id:1, name: 'name 2'});
                var obj3 = createObj("beans.user", {id:1, name: 'name 3'});

                expect(arrayUtilService.getDistinctComponents([obj1, obj2, obj3], "id").len()).toBe(1);
            });

		});
	}
}