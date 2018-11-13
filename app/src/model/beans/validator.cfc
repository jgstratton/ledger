component output="false" accessors="true" {
    property name="definitions" type="struct";
    property name="values" type="struct";
    property name="errors" type="array";

    public component function init(required string jsonDefinition, required struct values){
        variables.definitions = deserializeJSON(arguments.jsonDefinition);
        variables.values = arguments.values;
        return this;
    }

    public array function validate(){
        variables.errors = [];
        for (var fieldName in variables.getRules()){
            var ruleSet = getDefinitions().rules[fieldName];
            variables.runRules(fieldName);
        }
        return errors;
    }

    private string function getFieldValue(required string fieldName){
        if (variables.values.keyExists(fieldName)) {
            return variables.values[fieldName];
        }
        return '';
    }
    
    private struct function getRules(){
        return variables.definitions.rules;
    }

    private struct function getRule(required string fieldname){
        return variables.definitions.rules[fieldName];
    }
    /**
     * Get the label if one is defined in the definitions file, 
     * otherwise, just return the fieldname
     */
    private string function getlabel(required string fieldName){
        if (structKeyExists(getDefinitions().labels,fieldName)){
            return getDefinitions().labels[arguments.fieldName];
        }
        return fieldName;
    }

    private void function runRules(required string fieldName){
        var fieldRules = variables.getRule(fieldName);
        var fieldError = false;
        var fieldValue = variables.getFieldValue(fieldName);
        var fieldLabel = variables.getLabel(fieldName);

        for (var rule in fieldRules){
            switch(rule) {
                case "required":
                    if (fieldValue.len() == 0) {
                        fieldError = true;
                        variables.errors.append( "#fieldLabel# is required.");
                    }
                    break;
                case "min":
                    if ( !IsValid("number",fieldValue ) ){
                        fieldError = true;
                        variables.errors.append('"#fieldValue#" is not a valid number for #fieldLabel#.');
                    } else {
                        if (fieldValue < fieldRules.min){
                            fieldError = true;
                            variables.errors.append('The value for #fieldLabel# must be greater than or equal to #fieldRules.min#.');    
                        }
                    }
                    break;
                case "number":
                    if ( !IsValid("number",fieldValue ) ){
                        fieldError = true;
                        variables.errors.append('"#fieldValue#" is not a valid number for #fieldLabel#.');
                    }
                    break;
                case "usDate":
                    if ( !IsValid("USDate",fieldValue ) ){
                        fieldError = true;
                        variables.errors.append("#fieldValue# is not a valid date for #fieldLabel#.");
                    }
                    break;
                default: 
                    variables.errors.append('Invalid rule used "#rule#".');
                     fieldError = true;
            }
            if(fieldError){
                break;
            }
            
        }
    }

}