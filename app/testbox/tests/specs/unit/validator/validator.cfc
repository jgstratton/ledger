component displayName="Validator Tests" extends="testbox.system.BaseSpec" {

    function beforeTests() {
        variables.validatorService = new services.validator();
    }

    public void function structKeyIsSet_Null_Test(){
        var testStruct = {};
        $assert.isFalse(validatorService.structKeyIsSet(testStruct,'keyname'));
    }

    public void function structKeyIsSet_NoLength_Test(){
        var testStruct = {keyName:""};
        $assert.isFalse(validatorService.structKeyIsSet(testStruct,'keyname'));
    }

    public void function structKeyIsSet_HasLength_Test(){
        var testStruct = {keyName:"1"};
        $assert.isTrue(validatorService.structKeyIsSet(testStruct,'keyname'));
    }
}