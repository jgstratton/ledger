component accessors="true" extends="base"{
    public string function getName(){
        return 'boolean';
    }

    public boolean function getValue() {
        return super.getValue() ? true : false;
    }
}