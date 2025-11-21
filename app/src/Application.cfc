component extends="framework.one" output="false" {

	this.name = 'ledger';
	this.version = "0.0.1";
	this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 4, 0, 0);

	this.mappings["/framework"] = "/framework";
	this.mappings["/migrations"] = "/database/migrations";
	this.mappings["/services"] = "/model/services";
	this.mappings["/utils"] = "/model/utils";
	this.mappings["/beans"] = "/model/beans";
	this.mappings["/viewModels"] = "/model/beans/viewModels";
	this.mappings["/api"] = "/controllers/api";
	this.mappings["/reconciler"] = "/model/reconciler";
	this.mappings["/sendgrid"] = "/modules/sendgridcfc";

	// FW/1 settings
	variables.framework = {
		action = 'action',
		baseURL = "useRequestURI",
		defaultSection = 'account',
		defaultItem = 'list',
		diLocations = "./model/beans,./model/services,./model/utils",
		diConfig = {
			singulars : { generators : "bean", viewModels: "bean" }
		},
		SESOmitIndex = false,
		generateSES = true
	};

	variables.framework.environments = {
		dev = { 
				reloadApplicationOnEveryRequest = false, 
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
		custom: {allowMultiQueries:true}
	};
	this.datasource = "appds";
	
	this.ormEnabled = true;
	this.ormsettings = {
		cfclocation="model/beans",
		dbcreate = "none",	//using migrations for db table creation instead of letting hibernate create the tables
		dialect="MySQL",         
		eventhandling="true",
		eventhandler="model.beans.eventhandler",
		logsql="false",
		flushatrequestend=false
	};

	public string function getEnvironment(){
		return this.getEnvVar('TIER');
	}

	/**
	 * Put any custom configuration that we don't want to get reloaded when the framework reloads, 
	 * for example, if we have reloadApplicationOnEveryRequest set to true in dev, but want to have dev toggles that we don't want
	 * to be cleared on every request, set those up here.
	 */
	public void function onApplicationStart(){
		super.onApplicationStart();

		application.devToggles = {
			showTemplateWrappers: false
		}
	}

	/**
	 * Add logging when the target path doesn't exist.  We can't onMissingTemplate here because the application alreay uses onRequest in 
	 * framework one, and lucee won't let you use both on Request and onMissingTemplate.  If the template exists, we hand it off to fw1, if not
	 * log the error.
	 */
	function onRequest( targetPath ) {
		var absolutePath = ExpandPath(targetPath);
		if (fileExists(absolutePath)) {
			super.onRequest(targetPath);
		} else {
			getLogger().error("Page not found (#absolutePath#): #cgi.request_url#");
			echo("Page not found");
		}
	}

	/**
	 * There is an issue where the onRequestStart runs twice for one request,  creating the log entry makes the problem
	 * go away, I have no idea why.
	 */
	public void function onRequestStart( string targetPath ) {
		logger = new services.logger();
		logger.debug("(Request started)");
		request.beanfactory = application.beanfactory;
		super.onRequestStart(arguments.targetPath);
	}
	
	/**
	 * When error makes it all the way up the application error handler, create a dump file in the 
	 * logs folder and log the error.  Note, this will override the default fw1 onError method.
	 */
	public void function onError(struct exception, string eventName) {
		getLogger().error("An application error occured: #exception.message#");
		writedump(var="#exception#", output="/var/log/dump_#datetimeFormat(now(),"yyyy-mm-dd hh-mm-ssttt")#.html", top="10", format="html");
		writedump(var="An error has occured");
		if (this.getEnvironment() eq 'dev'){
			writedump(var="#exception#", top="10", format="html");
		}
	}

	/**
	 * The setupApplication function is called each time the framework is reloaded.
	 */
	public void function setupApplication(){
		ormReload();
		lock scope="application" timeout="300" {
			buildRootPath();
			application.src_dir = "#expandPath(".")#";
			application.cache = "#createuuid()#";
			application.facebook = createobject("component","model/services/facebook").init(
				this.getEnvVar('FACEBOOK_APPID'),
				this.getEnvVar('FACEBOOK_APPSECRET'),
				"#getAuthReturnPath(false)#",
				"#getAuthReturnPath(true)#"
			);
			application.sendgrid = {
				key: this.getEnvVar('SENDGRID_API_KEY'),
				fromEmail: this.getEnvVar('SENDGRID_FROM_EMAIL'),
				toEmail: this.getEnvVar('SENDGRID_TO_EMAIL')
			};
			application.adminKey = this.getEnvVar('ADMIN_OVERRIDE_KEY');
			application.beanfactory = this.getBeanFactory();
		}
		migrate();
	}
	
	public void function setupSession() {  
		lock scope="session" timeout="5"{
			session.state = createUUID();
			session.init = now();
			session.loggedin = false;
		}
	}

	/*
		Note, there's an issue somewhere when orm reloads that causes random null pointer exception errors.  Don't run ormReload on every request.
		Run it manually when changes are made.
	*/
	public void function setupRequest() {
		//use refresh_dev_database to reload application and refresh all migrations (start from scratch)
		if (url.keyExists("refresh_dev_database")) {
			setupApplication();
			StructClear(Session);
			setupSession();
			ormReload();
			location(url="index.cfm",addToken=false);	
		} else if(structkeyexists(url,"ormreload")) {	
			ormReload();
		}

		if (url.keyExists("reloadSession") || !session.keyExists('init')) {
			StructClear(Session);
			setupSession();
		}
		
		if (url.keyExists('migrate')) {
			migrate();
		}

		if(session.loggedin){
			request.user = this.getBeanFactory().getBean("userService").getUserByid(session.userid);
			this.getBeanFactory().getBean('schedularService').runSchedule();
		}
	}

	public void function setupView( struct rc) {  
		include 'lib/viewHelpers.cfm';
	}

	public void function before(struct rc){
		getLogger().debug("Started request on controller #getSectionAndItem()#");
		//user is used in most controllers and views
		if(session.loggedin){
			getLogger().debug("User is logged in, continuing request");
			rc.user = request.user;
		} else if (arrayfind(["auth", "public", "api"], getSection()) == 0) {
			getLogger().debug("User not logged in, redirecting to login");
			redirect("auth.login","all");
		}
	}

	public void function setupResponse() {  }

	/**
	 * Add logging when target view doesn't exist.
	 */
	public string function onMissingView(struct rc = {}) {
		getLogger().error("View not found: #cgi.request_url#");
		return "Error 404 - Page not found.";
	}	
	
	/**
	 * Override the customTemplateEngine to provide view/layout wrapper
	 */
	public any function customTemplateEngine( string type, string path, struct args ) {
		var response = '';

		//create a view/layout id
		var templateId = arguments.type & randrange(1,10000000); 

		//populate the local struct needed for the view/layout
		structAppend( local, arguments.args );

		//Load the view/layout UI 
		savecontent variable="response" {
			include '#arguments.path#';
		}

		//Create a custom id and wrap all views and layouts
		if (findnocase("default.cfm", arguments.path) == 0 && not local.keyExists('noTemplateWrappers') && arguments.type != 'layout' ) {
			var response = '<div 
				id="#templateId#"
				class="template-wrapper template-#type#-wrapper"
				data-template-type="#arguments.type#"
				data-template-path="#arguments.path#"
				data-template-id="#templateId#">#response#</div>';
		}
		return response;	

	}
	
	public void function migrate(){
		lock scope="application" timeout="300"{
			if(this.getEnvironment() eq 'dev' && structKeyExists(url, "refresh_dev_database")){	
				local.migrate = new migrations.migrate("_mg,_dev");	
				local.migrate.refresh_migrations();
				return;				
			}

			local.migrate = new migrations.migrate();
			local.migrate.run_migrations();
		}
	}

	private void function buildRootPath() {
		var protocol = "http";
		var lucee_port = this.getEnvVar('LUCEE_PORT');
		var root_path = '';
		var root_react_path = '';

		if (this.getEnvVar('ENABLE_SSL')) {
			lucee_port = this.getEnvVar('LUCEE_SSL_PORT');
			protocol = "https";
		}

		root_path = "#protocol#://#this.getEnvVar('LUCEE_HOST')#";
		root_react_path = "#protocol#://#this.getEnvVar('REACT_HOST')#";

		/*In dev we need to include the port and the /src directory.  In production we don't need 
		a port because I'm using a reverse proxy to forward to the ports internally*/
		if (this.getEnvironment() == "dev") {
			root_path &= ":#lucee_port#/src";
			root_react_path = root_path;
		}

		application.root_path = root_path;
		application.root_react_path = root_react_path;
	}


	private string function getAuthReturnPath(boolean isProxy = false) {
		//when not using a proxy, or in dev, use the root_path and controller action
		if (!isProxy || this.getEnvironment() == "dev") {
			return "#application.root_path#/?action=auth.login";
		}

		//when using proxy in prod, use the react path with /auth (so request will get reforwarded back to the back end) 
		return "#application.root_react_path#/auth/?action=auth.login"		
	}

	private component function getLogger() {
		return new services.logger();
	}
}