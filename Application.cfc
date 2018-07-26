component extends="framework.one" output="false" {
	this.name = 'ledger';
	this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 0, 30, 0);

	//include enviornment details
	include 'env.cfm';

	// FW/1 settings
	variables.framework = {
		action = 'action',
		defaultSection = 'main',
		defaultItem = 'default',
		generateSES = false,
		SESOmitIndex = false,
		diEngine = "di1",
		diComponent = "framework.ioc",
		diLocations = "./model/services", // ColdFusion ORM handles Beans
        diConfig = { },
        routes = [ ]
	};

	variables.framework.environments = {
		dev = { 
				reloadApplicationOnEveryRequest = true, 
				error = "main.error_dev" },
		prod = { 
			reloadApplicationOnEveryRequest = false, 
			error = "main.error" }
	};
	
	//enable and set up ORM
	this.datasource = this.env.datasource;
	this.ormEnabled = true;
	this.ormsettings = {
		cfclocation="model/beans",
		dbcreate = (getEnvironment() eq "dev") ? "dropCreate": "update",       // update database tables only
		dialect="MySQL",         
		eventhandling="true",
		eventhandler="model.beans.eventhandler",
		logsql="true"
	};
	
	public string function getEnvironment(){
		return this.env.tier;
	}

	public void function setupSession() {  }

	public void function setupRequest() {  
		if(structKeyExists(url, "init")) { // use index.cfm?init to reload ORM
            setupApplication();
            ormReload();
            location(url="index.cfm",addToken=false);
        }
	}

	public void function setupView() {  }

	public void function setupResponse() {  }

	public string function onMissingView(struct rc = {}) {
		return "Error 404 - Page not found.";
	}
}