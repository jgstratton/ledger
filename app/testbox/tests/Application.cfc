

component {
    this.name = "TestBox" & hash( CreateUUID());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );

	//use this for integration tests
	this.datasources["tests"] = {
		type: 'mysql',
		database: 'tests',
		host: "db_tests",
		port: "3306",
		username: this.getEnvVar('MYSQL_USER'),
		password: this.getEnvVar('MYSQL_PASSWORD')
	};

	//only use this for fiddle, don't run tests on the actual database
	this.datasources["appds"] = {
		type: 'mysql',
		database: this.getEnvVar('MYSQL_DATABASE'),
		host: "db",
		port: "3306",
		username: this.getEnvVar('MYSQL_USER'),
		password: this.getEnvVar('MYSQL_PASSWORD')
	};

	public void function onApplicationStart(){
		application.switchDatasource = function( string name) {
			if (arguments.name != this.datasource) {
				this.datasource = arguments.name;
				ormreload();
				writedump('Reloaded orm with datasource: #name#');
			}
		}
	}


	this.datasource="tests";

	this.rootPath = "/app/";
	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/fw" ] = this.rootPath & "src/framework";
	this.mappings[ "/tests" ] = this.rootPath & "testbox/tests";
	this.mappings[ "/testbox" ] =  this.rootPath & "testbox";
	this.mappings[ "/resources" ] = this.rootPath & "testbox/tests/resources";
	this.mappings[ "/coldbox" ] = this.rootPath & "testbox/tests/resources/coldbox";
	this.mappings[ "/generators" ] = this.rootPath & "testbox/tests/resources/generators";
	this.mappings[ "/factories" ] = this.rootPath & "testbox/tests/resources/factories";

	this.mappings[ "/beans" ] = this.rootPath & "src/model/beans";
	this.mappings[ "/controllers" ] = this.rootPath & "src/controllers";
	this.mappings[ "/services" ] = this.rootPath & "src/model/services";
	this.mappings[ "/utils" ] = this.rootPath & "src/model/utils";
	this.mappings[ "/migrations" ] =this.rootPath & "src/database/migrations";

	this.ormenabled = true;
	this.ormSettings.cfclocation = [this.mappings[ "/beans" ]];
	this.ormSettings.useDBForMapping = false;
	this.ormSettings.dialect = "MicrosoftSQLServer";
	this.ormSettings.flushatrequestend = false;

	this.ormsettings = {
		cfclocation = [this.mappings[ "/beans" ]],
		dbcreate = "none",	//using migrations for db table creation instead of letting hibernate create the tables
		dialect = "MySQL",         
		eventhandling = "true",
		eventhandler = "beans.eventhandler",
		logsql = "true",
		flushatrequestend = false
	};

	public void function onRequestStart() {
		local.migrate = new migrations.migrate();
		if (structKeyExists(url,'reload')) {
			local.migrate.refresh_migrations();
		} else {
			local.migrate.run_migrations();  
		}
		ormreload();
	}

	public string function getEnvVar( string name ) {
        return createObject( "java", "java.lang.System" ).getenv( name );
	}
	
}