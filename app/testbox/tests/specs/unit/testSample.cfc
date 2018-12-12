component displayName="My test suite" extends="testbox.system.BaseSpec" {
    // executes before all tests
    function beforeTests() {}
    // executes after all tests
    function afterTests() {}

    function testFailTest() {
        $assert.isTrue(false);
    }
}