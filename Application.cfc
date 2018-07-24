component extends="framework.one" output="false" {
	this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 0, 30, 0);

	// FW/1 settings
	variables.framework = {
		action = 'action',
		defaultSection = 'main',
		defaultItem = 'default',
		generateSES = false,
		SESOmitIndex = false,
		diEngine = "di1",
		diComponent = "framework.ioc",
		diLocations = "model, controllers",
        diConfig = { },
        routes = [ ]
	};

	public void function onApplicationStart(){
		lock scope="application" timeout="10"{
			include "env.cfm";
			this.datasource = StructKeyExists(env,'datasource') ? env.datasource:'';

		}
	}


	public void function setupSession() {  }

	public void function setupRequest() {  }

	public void function setupView() {  }

	public void function setupResponse() {  }

	public string function onMissingView(struct rc = {}) {
		return "Error 404 - Page not found.";
	}
}