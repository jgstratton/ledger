component accessors="true" extends="base"{
    public string function getType(){
        return 'date';
    }

    public string function getFormattedValue() {
        return dateformat(this.getValue(), "mm/dd/yyyy");
    }
}