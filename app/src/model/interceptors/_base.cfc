component accessors=true  {

    /** Local version of translateArgs that accomidates optional arguments */
    private any function _translateArgs(required any targetBean, required string methodName, required struct args) {
		var argumentInfo = arguments.targetBean.$getArgumentInfo(arguments.methodName);
		var resultArgs = {};

		if (structIsEmpty(arguments.args) || !structKeyExists(arguments.args, "1")){
			return arguments.args;
		}

		for (var i = 1; i <= arrayLen(argumentInfo); i++){
            if (structKeyExists(arguments.args, i)) {
                resultArgs[argumentInfo[i].name] = arguments.args[i];
            }
		}

		return resultArgs;
    }
    
}