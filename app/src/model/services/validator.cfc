component accessors="true" {
    property schedularService;

    public beans.response function runValidators(required array validators, required struct rc){
        var compositeResponse = getReponseBean();
        for (var validatorName in arguments.validators) {
            var newResponse = invoke(this,"get#validatorName#",{rc:arguments.rc});
            compositeResponse.appendResponseErrors(newResponse);
        }
        return compositeResponse;
    }

    public beans.response function getValidateTransactionGenerator(required struct rc){
        var response = getReponseBean();
        if (parameterIsMissing(rc, 'eventName')) {
            response.addError("Please provide a name for this automatic transaction");
        }
        return response;
    }

    public component function getValidateTransferGenerator(required struct rc){
        var response = getReponseBean();
        if (parameterIsMissing(arguments.rc, 'eventName')) {
            response.addError("Please provide a name for this automatic transfer");
        }
        return response;
    }

    public beans.response function getValidateGeneratorSchedular(required struct rc){
        param name="rc.scheduleActive" default="0";
        var response = getReponseBean();
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

    public beans.response function getValidateCategory(required struct rc){
        var response = getReponseBean();
        proccessMissingParameters(rc, response, [
            {name: 'name', errorMsg: "Please provide a name for this category"},
            {name: 'multiplier', errorMsg: "You must indicate if this is a income or expensive category"}
        ]);

        return response;
    }

    public beans.response function validateMissingParameters(required struct rc, required array parameters) {
        var response = getReponseBean();
        proccessMissingParameters(arguments.rc, response, arguments.parameters);
        return response;
    }

    
/** private functions **/

    private boolean function schedularParameterIsMissing(required struct rc, required component schedularType, required string parameterName) {
        if (!schedularService.schedularParameterValidForType(arguments.parameterName, arguments.schedularType)) {
            return false;
        }
        if (!parameterIsMissing(arguments.rc, arguments.parameterName)) {
            return false;
        }
        return true;
    }

    private void function proccessMissingParameters(required struct rc, required component response, required array parameters) {
        for (var param in arguments.parameters) {
            if (parameterIsMissing(rc, param.name)) {
                response.addError(param.errorMsg);
            }
        }
    }

    private boolean function parameterIsMissing(required struct rc, required string key) {
        if (arguments.rc.keyExists(arguments.key) && len(arguments.rc[arguments.key])) {
            return false;
        }
        return true;
    }

    private component function getReponseBean(){
        return new beans.response();
    }
}