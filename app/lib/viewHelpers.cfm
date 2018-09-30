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

</cfscript>
