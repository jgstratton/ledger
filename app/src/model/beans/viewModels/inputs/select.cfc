component accessors="true" extends="base"{
    property name="value";
    property name="options" type="array";
    property name="type" ;

    public string function getName(){
        return 'select';
    }

    /**
     * Clears the current options.
     * @returns this (chaining)
     */
    public component function clearOptions() {
        variables.options = arrayNew();
        return this;
    }

    /**
     * Appends an option to the currenty array of options
     * @returns this (chaining)
     */
    public component function addOption(required struct option) {
        if (arguments.option.keyExists('value') && arguments.option.keyExists('text')) {
            variables.options.append(arguments.option);
        } else {
            throw(type="invalidArgument", message="Each item in the options array must contain both value and text.");
        }
        return this;
    }

    /**
     * Sets the options on the object.  Options must be an array of structs.
     * @returns this (chaining)
     */
    public component function setOptions(required array options) {
        clearOptions();
        for (var option in arguments.options) {
            addOption(option);
        }
        return this;
    }
}