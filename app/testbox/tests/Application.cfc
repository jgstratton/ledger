

component {
    this.name = "TestBox" & hash( CreateUUID());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );

	this.datasources["tests"] = {
		type: 'mysql',
		database: 'tests',
		host: "db_tests",
		port: "3306",
		username: this.getEnvVar('MYSQL_USER'),
		password: this.getEnvVar('MYSQL_PASSWORD')
	};

	this.datasource="tests";

	this.rootPath = "/app/";
	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = this.rootPath & "testbox/tests";
	this.mappings[ "/testbox" ] =  this.rootPath & "testbox";
	this.mappings[ "/coldbox" ] = this.rootPath & "testbox/tests/resources/coldbox";
	this.mappings[ "/generators" ] = this.rootPath & "testbox/tests/resources/generators";

	this.mappings[ "/beans" ] = this.rootPath & "src/model/beans";
	this.mappings[ "/controllers" ] = this.rootPath & "src/controllers";
	this.mappings[ "/services" ] = this.rootPath & "src/model/services";
	this.mappings[ "/migrations" ] =this.rootPath & "src/database/migrations";

	this.ormenabled = true;
	this.ormSettings.cfclocation = [this.mappings[ "/beans" ]];
	this.ormSettings.useDBForMapping = false;
	this.ormSettings.dialect = "MicrosoftSQLServer";
	this.ormSettings.flushatrequestend = false;

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