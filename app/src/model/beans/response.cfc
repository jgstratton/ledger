component accessors="true" {
    property name="message" default="";
    property name="errors" type="array";

    public component function init() {
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
            getAlertService().addMultiple('danger',getErrors());
        } else {
            getAlertService().setTitle('success',getMessage());
        }
    }

    public void function appendResponseErrors(required component secondaryResponse) {
        setErrors(getErrors().append(arguments.secondaryResponse.getErrors(),true));
    }

    private component function getBeanfactory() {
        return request.beanfactory;
    }

    private component function getAlertService() {
        return getBeanfactory().getBean("alertService");
    }
}