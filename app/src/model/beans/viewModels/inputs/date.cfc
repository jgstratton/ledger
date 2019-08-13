component accessors="true" extends="base"{
    public string function getName(){
        return 'date';
    }

    public string function getFormattedValue() {
        return dateformat(this.getValue(), "mm/dd/yyyy");
    }
}