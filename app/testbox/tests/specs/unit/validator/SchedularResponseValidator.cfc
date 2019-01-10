component displayName="Validator Tests" extends="testbox.system.BaseSpec" {
    

    function beforeTests() {
        variables.validatorService = createMock("services.validator");
        variables.schedularService = createMock("services.schedular");
        variables.schedularType = createMock("beans.schedularType");
        validatorService.$property(propertyName = "schedularService", mock = schedularService);
        schedularType.$("getAllowedParameters","monthsOfYear,daysOfMonth");
        schedularService.$("getSchedularTypeById",schedularType);

        makePublic(validatorService,'schedularParameterIsMissing');
        makePublic(validatorService,'structKeyIsSet');
    }

    public void function getValidateGeneratorSchedularResponse_AllParamatersMissing_Test(){
        var rc = {
            schedularTypeId:1,
            scheduleActive: 1
        }
        var errorCount = validatorService.getValidateGeneratorSchedularResponse(rc).getErrors().len();
        $assert.isEqual(2,errorCount);
    }

    public void function getValidateGeneratorSchedularResponse_OneParameterMissing_test() {
        var rc = {
            schedularTypeId:1,
            scheduleActive:1,
            monthsOfYear:"",
            daysOfMonth:"value"
        }
        var errors = validatorService.getValidateGeneratorSchedularResponse(rc).getErrors();
        $assert.isEqual(1,errors.len());
    }

    public void function schedularParameterIsMissing_NotRequired_test(){
        var rc = {daysOfMonth:"value"}
        $assert.isFalse(validatorService.schedularParameterIsMissing(rc, schedularType, "parameterNotRequired"));
    }

    public void function schedularParameterIsMissing_RequiredAndSet_test(){
        var rc = {daysOfMonth:"value"}
        $assert.isFalse(validatorService.schedularParameterIsMissing(rc, schedularType, "daysOfMonth"));
    }

    public void function schedularParameterIsMissing_RequiredButNotSet_test(){
        var rc = {daysOfMonth:"value"}
        $assert.isTrue(validatorService.schedularParameterIsMissing(rc, schedularType, "monthsOfYear"));
    }


}