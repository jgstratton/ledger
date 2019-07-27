component accessors="true" {
    property name="message" default="";
    property name="errors" type="array";
    property name="data" type="struct";
    property name="statusCode" type="string";

    public component function init() {
        setData(StructNew());
        setErrors(arrayNew());
        setStatusCode(200);
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

    public void function setDataKey(required string key, required any data) {
        var data = getData();
        local.data[key] = arguments.data;
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

    //not yet in use
    public string function toJson(){
        var tempStruct = {
            "message": this.getMessage(),
            "errors": this.getErrors(),
            "status": this.getStatus(),
        }
        return serializeJSON(tempStruct);
    }

    private component function getBeanfactory() {
        return request.beanfactory;
    }

    private component function getAlertService() {
        return getBeanfactory().getBean("alertService");
    }
}