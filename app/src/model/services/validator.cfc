component accessors="true" {
    property schedularService;

    public beans.response function runValidators(required array validators, required struct rc){
        var compositeResponse = new beans.response();
        for (var validatorName in arguments.validators) {
            var newResponse = invoke(this,"get#validatorName#",{rc:arguments.rc});
            compositeResponse.appendResponseErrors(newResponse);
        }
        return compositeResponse;
    }

    public beans.response function getValidateTransactionGenerator(required struct rc){
        var response = new beans.response();
        if (parameterIsMissing(rc, 'eventName')) {
            response.addError("Please provide a name for this automatic transaction");
        }
        return response;
    }

    public component function getValidateTransferGenerator(required struct rc){
        var response = new beans.response();
        if (parameterIsMissing(arguments.rc, 'eventName')) {
            response.addError("Please provide a name for this automatic transfer");
        }
        return response;
    }

    public beans.response function getValidateGeneratorSchedular(required struct rc){
        param name="rc.scheduleActive" default="0";
        var response = new beans.response();
        var schedularType = schedularService.getSchedularTypeById(rc.schedularTypeId);

        if (isNull(schedularType) && rc.scheduleActive) {
            response.addError("Schedule type is required if active");
            return response;
        }

        if (schedularParameterIsMissing(arguments.rc, schedularType, 'monthsOfYear') ) {
            response.addError("Months are required for #schedularType.getName()# schedule types");
        }
        
        if (schedularParameterIsMissing(arguments.rc, schedularType, 'daysOfMonth') ) {
            response.addError("Days of the month are required for #schedularType.getName()# schedule types");
        }

        if (schedularParameterIsMissing(arguments.rc, schedularType, 'startDate') ) {
            response.addError("Start date is required for #schedularType.getName()# schedule types");
        }

        if (schedularParameterIsMissing(arguments.rc, schedularType, 'dayInerval') ) {
            response.addError("Interval is required for #schedularType.getName()# schedule types");
        }

        return response;
    }

    private boolean function schedularParameterIsMissing(required struct rc, required component schedularType, required string parameterName) {
        if (!schedularService.schedularParameterValidForType(arguments.parameterName, arguments.schedularType)) {
            return false;
        }
        if (!parameterIsMissing(arguments.rc, arguments.parameterName)) {
            return false;
        }
        return true;
    }

    private boolean function parameterIsMissing(required struct rc, required string key) {
        if (arguments.rc.keyExists(arguments.key) && len(arguments.rc[arguments.key])) {
            return false;
        }
        return true;
    }
}