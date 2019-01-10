component accessors="true" {
    property alertService;

    property name="message" default="";
    property name="errors" type="array";

    public component function init() {
        setErrors(arrayNew());
        return this;
    }

    private void function getStatus(){
        if (getErrors.len()) {
            return 'fail';
        }
        return 'success'
    }

    public void function addError(required string error) {
        getErrors().append(arguments.error);
    }

    public boolean function isSuccess(){
        return getStatus() == 'success';
    }

    public boolean function generateAlerts(){
        alertService.generateAlerts('danger',getErrors());
    }

    public void function appendResponseErrors(required component secondaryResponse) {
        setErrors(getErrors().append(arguments.secondaryResponse.getErrors(),true));
    }

}