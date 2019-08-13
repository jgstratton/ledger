component accessors="true" {
    property name="value";
    property name="name";

    public component function init() {
        return this;
    }

    public string function getName(){
        return 'input';
    }
}