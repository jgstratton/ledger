<cfscript>

    matchUtilValid = function(args){
        if(StructKeyExists(args,'val1') and StructKeyExists(args,'val2')){
            return true;
        }
        return false;
    }

    matchUtil = function(val1,val2,method,output){
        switch(method){
            case "eq" :
                if(val1 eq val2){
                    return output;
                }
                break;
            case "neq" :
                if(val1 neq val2){
                    return output;
                }
                break;
        }
        return '';
    }

    matchSelect = function(val1,val2){
        if(matchUtilValid(arguments)){
            return matchUtil(val1,val2,"eq","selected");
        }
    }

    matchCheck = function(val1,val2){
      if(matchUtilValid(arguments)){
            return matchUtil(val1,val2,"eq","checked");
        }
    }

    matchHide = function(val1,val2,output){
        if(val1 eq val2){
            return '';
        }
        return output;
    }

    matchDisplay = function(val1,val2,output_true, output_false = ''){
        if(val1 eq val2){
            return output_true;
        }
        return output_false;
    }

    displayIf = function(condition, value, default){
        if(condition){
            return value;
        } elseif( arguments.keyExists('default') ){
            return default;
        }
        return '';
    }
    
    selectIf = function(condition){
        if(condition){
            return "selected";
        }
        return '';
    }
    
    moneyFormat = function(number){
        return numberformat(arguments.number, "$,0.00");
    }

    dayFormat = function(date){
        return dateformat(arguments.date,"mm/dd/yyyy");
    }
    
   function lenShow( string checkLen, string output ){
        if ( len( arguments.checkLen ) ){
            return arguments.output;
        }
        return '';
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
