component accessors="true" extends="base"{
    property name="value" default="0";
    public string function getType(){
        return 'boolean';
    }

    public boolean function getValue() {
        return variables.value ? true : false;
    }
}