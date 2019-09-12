component name="_baseController" output="false"  accessors=true {
	
	private void function runAuthorizer(required struct rc, throwErrorOnMissingAuthorizer = false) {
		var methodName = variables.fw.getItem();
		if (!metaDataService.methodHasAnnotation(this, methodName, "authorizer")) {
			if (throwErrorOnMissingAuthorizer){
				throw(type="missingauthorizer", message="#methodName# of the transaction service is missing an authorizer");
			}
			return;
		}

		var authorizer = metaDataService.getMethodAnnotation(this, methodName, "authorizer");
		invoke(this, authorizer, {rc:rc});
	}

	private void function updateLayoutAndView(){
		var methodName = variables.fw.getItem();
		if (metaDataService.methodHasAnnotation(this, methodName, "layout")) {
			variables.fw.setLayout(metaDataService.getMethodAnnotation(this, methodName, "layout"));
		}
		if (metaDataService.methodHasAnnotation(this, methodName, "view")) {
			variables.fw.setView(metaDataService.getMethodAnnotation(this, methodName, "view"));
		}
	}
}