component accessors="true" {
    property alertService;

    property name="status" default="success";
    property name="message" default="";
    property name="errors" type="array";

    public component function init() {
        setErrors(arrayNew());
        return this;
    }
    public void function addError(required string error) {
        getErrors().append(arguments.error);
        setStatus('fail');
    }

    public boolean function isSuccess(){
        return getStatus() == 'success';
    }

    public boolean function generateAlerts(){
        alertService.generateAlerts('danger',getErrors());
    }
}