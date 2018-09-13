component extends="framework.one" output="false" {

	this.name = 'ledger';
	this.version = "0.0.1";
	this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 0, 30, 0);

	this.mappings["/migrations"] = "/database/migrations";

	// FW/1 settings
	variables.framework = {
		action = 'action',
		defaultSection = 'account',
		defaultItem = 'list',
		generateSES = false,
		SESOmitIndex = false,
		diEngine = "di1",
		diComponent = "framework.ioc",
		diLocations = "./model/services", // ColdFusion ORM handles Beans
        diConfig = { },
        routes = [
			{ "/login" = "/auth/login"},
			{ "/logout" = "/auth/logout"}
		 ]
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
	this.datasources["appds"] = {
		type: 'mysql',
		database: this.getEnvVar('MYSQL_DATABASE'),
		host: "db",
		port: "3306",
		username: this.getEnvVar('MYSQL_USER'),
		password: this.getEnvVar('MYSQL_PASSWORD'),
		custom: {allowMultipleQueries: true}
	};
	this.datasource = "appds";
	
	this.ormEnabled = true;
	this.ormsettings = {
		cfclocation="model/beans",
		dbcreate = "none",	//using migrations for db table creation instead of letting hibernate create the tables
		dialect="MySQL",         
		eventhandling="true",
		eventhandler="model.beans.eventhandler",
		logsql="true",
		flushatrequestend=false
	};

	public string function getEnvironment(){
		return this.getEnvVar('TIER');
	}

	public void function setupApplication(){
		
		
		lock scope="application" timeout="3"{
			application.root_path = "#getPageContext().getRequest().getScheme()#://#cgi.server_name#:#this.getEnvVar('LUCEE_PORT')#";
			application.version = "#this.version#";
			application.facebook = createobject("component","model/services/facebook").init(
				this.getEnvVar('FACEBOOK_APPID'),
				this.getEnvVar('FACEBOOK_APPSECRET'),
				"#application.root_path#/login?type=fb"
			)
		}
	}
	public void function setupSession() {  
		lock scope="session" timeout="5"{
			session.state = createUUID();
			session.loggedin = false;
		}
	}

	public void function setupRequest() {  

		if(structkeyexists(url,"ormreload")){
			ormReload();
		}

		if(structkeyexists(url,"reloadSession")){
			StructClear(Session);
			setupSession();
		}
		
		if(structKeyExists(url, "init")) { // use index.cfm?init to reload ORM
			setupApplication();
			StructClear(Session);
			setupSession();
			if(this.getEnvironment() eq 'dev'){
				migrate();
			}
			ormReload();
            location(url="index.cfm",addToken=false);
		}

		if(not session.loggedin and listlast(cgi.path_info,"/") neq "login"){
			location("#application.root_path#/login",false);
		}
	
	}

	public void function setupView() {  
		include 'lib/viewHelpers.cfm';
	}

	public void function setupResponse() {  }

	public string function onMissingView(struct rc = {}) {
		return "Error 404 - Page not found.";
	}

	public void function migrate(){
		
		local.migrate = new migrations.migrate("appds");
		if(this.getEnvironment() eq 'dev'){
			local.migrate.refresh_migrations();
		}
		local.migrate.run_migrations();

	}
}