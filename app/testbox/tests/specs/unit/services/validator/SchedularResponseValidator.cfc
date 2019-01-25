component displayName="Validator Tests" extends="resources.BaseSpec" {
    

    function beforeTests() {
        variables.validatorService = createMock("services.validator");
        variables.schedularService = createMock("services.schedular");
        variables.schedularType = createMock("beans.schedularType");
        validatorService.$property(propertyName = "schedularService", mock = schedularService);
        schedularType.$("getAllowedParameters","monthsOfYear,daysOfMonth");
        schedularService.$("getSchedularTypeById",schedularType);

        makePublic(validatorService,'schedularParameterIsMissing');
    }

    public void function getValidateGeneratorSchedular_AllParamatersMissing_Test(){
        var rc = {
            schedularTypeId:1,
            scheduleActive: 1
        }
        var errorCount = validatorService.getValidateGeneratorSchedular(rc).getErrors().len();
        $assert.isEqual(2,errorCount);
    }

    public void function getValidateGeneratorSchedular_OneParameterMissing_test() {
        var rc = {
            schedularTypeId:1,
            scheduleActive:1,
            monthsOfYear:"",
            daysOfMonth:"value"
        }
        var errors = validatorService.getValidateGeneratorSchedular(rc).getErrors();
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