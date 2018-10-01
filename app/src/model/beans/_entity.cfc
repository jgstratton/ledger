component{

    private void function validate_field(array errors = [], string fieldName = '', string fieldValue = '', string rule_list = ''){
        
        var rules = listtoarray(arguments.rule_list);

        for(local.rule in rules){

            switch(local.rule){
                case "required":
                    if(len(arguments.fieldValue) eq 0){
                        arrayAppend(errors,"#arguments.fieldName# is required.");
                        return;
                    }
                    break;

                case "USDate":
                    if(Not IsValid("UsDate",arguments.fieldValue)){
                        arrayAppend(errors,'"#arguments.fieldValue#" is not a valid date');
                        return;
                    }
                    break;

                case "numeric":
                    if(Not IsValid("Numeric",arguments.fieldValue)){
                        arrayAppend(errors,'"#arguments.fieldValue#" is not a valid number');
                        return;
                    }
                    break;

                default:
                    throw(message = "Validation rule not found.");
            }

        }
    }
}