component{

    public function init(){
        
        CreateObject("java", "org.apache.log4j.PropertyConfigurator").configure(
			"/app/src/log4j.properties"
        );
		
		variables.logger = CreateObject("java", "org.apache.log4j.Logger").getInstance('app');
    }

	public any function trace(required string message) {
		variables.logger.trace(arguments.message);
    }
    
	public any function debug(required string message) {
		variables.logger.debug(arguments.message);
	}

	public any function info(required string message) {
		variables.logger.info(arguments.message);
	}

	public any function warn(required string message) {
		variables.logger.warn(arguments.message);
	}

	public any function error(required string message, any error) {
		if(structKeyExists(arguments,'error')) {
			var err = arguments.error;
			var detail = arguments.message;
			if (isStruct(err)) {
				if (structKeyExists(err, 'detail') && len(err.detail)) detail &= " | Detail: " & err.detail;
				if (structKeyExists(err, 'tagContext') && isArray(err.tagContext) && arrayLen(err.tagContext)) {
					var ctx = err.tagContext[1];
					detail &= " | #ctx.template#:#ctx.line#";
				}
			}
			variables.logger.error(detail);
		} else {
			variables.logger.error(arguments.message);
		}
	}
    

}