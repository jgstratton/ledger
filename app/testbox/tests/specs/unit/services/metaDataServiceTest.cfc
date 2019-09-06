component extends="testbox.system.BaseSpec" {
	function run() {

		describe("The annotation service", function() {
			beforeEach(function(){
				service = new services.metaDataService();
			});

			describe("checks if a method on an object has an annotation", function() {
				it("returns true if the annotation exists", function() {
					expect(service.methodHasAnnotation(this,'sampleFunction','annotation1')).toBeTrue();
				});
				it("returns false if the annotation doesn't exists", function() {
					expect(service.methodHasAnnotation(this,'sampleFunction','annotation2')).toBeFalse();
				});
				it("throws an error if the function doesn't exist", function() {
					expect(function(){
						service.methodHasAnnotation(this,'sampleFunctionNoExist','annotation1')
					}).ToThrow("invalidMethodName");
				});
			});

			describe("gets the annotation for an objects method", function() {
				it("returns the annotation's value if it is defined", function() {
					expect(service.getMethodAnnotation(this,'sampleFunction','annotation1')).toBe("value");
				});
				it("returns null if it's not defined", function() {
					expect(service.getMethodAnnotation(this,'sampleFunction','annotation2')).toBeNull();
				});
				it("throws an error if the method doesn't exist", function() {
					expect(function(){
						service.getMethodAnnotation(this,'sampleFunctionNoExist','annotation1')
					}).ToThrow("invalidMethodName");
				});
			});
		});
	}

	/**
	 * Test functions
	 * @annotation1 "value"
	 */
	public void function sampleFunction() {
		return;
	}
}
