component displayName="Validator Tests" extends="resources.BaseSpec" {

    function beforeTests() {
        variables.validatorService = new services.validator();
    }

    public void function structKeyIsSet_Null_Test(){
        var testStruct = {};
        $assert.isTrue(validatorService.parameterIsMissing(testStruct,'keyname'));
    }

    public void function structKeyIsSet_NoLength_Test(){
        var testStruct = {keyName:""};
        $assert.isTrue(validatorService.parameterIsMissing(testStruct,'keyname'));
    }

    public void function structKeyIsSet_HasLength_Test(){
        var testStruct = {keyName:"1"};
        $assert.isFalse(validatorService.parameterIsMissing(testStruct,'keyname'));
    }
}