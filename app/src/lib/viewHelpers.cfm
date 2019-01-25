<cfscript>
       
    private string function matchUtilValid(required struct args){
        if (StructKeyExists(arguments.args,'val1') and StructKeyExists(arguments.args,'val2')) {
            return true;
        }
        return false;
    }

    private string function matchUtil(required string val1, required string val2, required string method, string output ='' ) {
        switch(arguments.method){
            case "eq" :
                if(arguments.val1 == arguments.val2){
                    return arguments.output;
                }
                break;
            case "neq" :
                if(arguments.val1 != arguments.val2){
                    return arguments.output;
                }
                break;
        }
        return '';
    }

    public string function matchSelect(required string val1, required string val2) {
        if (matchUtilValid(arguments)) {
            return matchUtil(arguments.val1,arguments.val2,"eq","selected");
        }
    }

    public string function matchCheck(string val1, string val2) {
        if (matchUtilValid(arguments)) {
            return matchUtil(arguments.val1,arguments.val2,"eq","checked");
        }
    }

    public string function matchHide(required string val1, required string val2, required string output) {
        if (arguments.val1 == arguments.val2) {
            return '';
        }
        return arguments.output;
    }

    public string function matchDisplay(required string val1, required string val2, required string output_true, string output_false = ''){
        if(arguments.val1 == arguments.val2){
            return arguments.output_true;
        }
        return arguments.output_false;
    }

    public string function displayIf(required boolean condition, required string value, string default = ''){
        if(arguments.condition){
            return arguments.value;
        } 
        return arguments.default;
    }
    
    public string function selectIf(required boolean condition){
        if(arguments.condition){
            return "selected";
        }
        return '';
    }
    
    public string function checkIF(required boolean condition){
        if(arguments.condition){
            return "checked";
        }
        return '';
    }

    public string function moneyFormat(required numeric number) {
        return numberformat(arguments.number, "$,0.00");
    }

    public string function dayFormat(string date = '') {
        return dateformat(arguments.date,"mm/dd/yyyy");
    }
    
    public string function lenShow(required string checkLen, required string output) {
        if ( len( arguments.checkLen ) ){
            return arguments.output;
        }
        return '';
    }

    public string function clipText(required string text, required numeric charCount) {
        if (len(arguments.text) > arguments.charCount) {
            return left(arguments.text,arguments.charCount) & "...";
        }
        return arguments.text;
    }
    /**
     * Automatically create hidden form fields for existing rc keys
     * */
    public string function formPreserveKeys( required struct rc, required string keyList ) {
        var keyArray = listToArray(keyList);
        var formFieldsString = "";

        for (keyName in keyArray){
            if (rc.keyExists(keyName)) {
                formFieldsString &= '<input type="hidden" name="#keyName#" value="#arguments.rc[keyname]#">';
            }
        }
        return formFieldsString;
    }

    /**
     * Generate a query string (struct) for the build URL
     * If the listed keys exist in the request context, include them
     **/
     public struct function preserveKeysForBuildUrl( required struct rc, required string keyList ) {
        var keyArray = listToArray(keyList);
        var preserveKeys = {};

        for (keyName in keyArray){
            if (rc.keyExists(keyName)) {
                preserveKeys[keyName] = rc[keyname];
            }
        }
        return preserveKeys;
    }

</cfscript>
