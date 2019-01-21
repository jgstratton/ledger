component accessors="true" {
    property name="message" default="";
    property name="errors" type="array";

    public component function init() {
        variables.beanFactory = application.beanFactory;
        variables.alertService = beanFactory.getBean("alertService");
        setErrors(arrayNew());
        return this;
    }

    private string function getStatus(){
        if (getErrors().len()) {
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

    public void function generateAlerts(){
        if (getErrors().len()) {
            alertService.addMultiple('danger',getErrors());
        } else {
            alertService.setTitle('success',getMessage());
        }
    }

    public void function appendResponseErrors(required component secondaryResponse) {
        setErrors(getErrors().append(arguments.secondaryResponse.getErrors(),true));
    }

}