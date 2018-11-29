
component {
    this.name = "TestBox" & hash( CreateUUID());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );

	this.datasource="tests";


    testsPath = getDirectoryFromPath( getCurrentTemplatePath() );
    this.mappings[ "/tests" ] = testsPath;
    rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );


	this.mappings["/model"] = rootPath & "/src/models";
	this.mappings["/controllers"] = rootPath & "/src/controllers";
	this.mappings["/services"] = rootPath & "/src/services";

	this.ormenabled = true;
	this.ormSettings.cfclocation = this.mappings["/model"];
	this.ormSettings.useDBForMapping = false;
	this.ormSettings.datasource = "";
	this.ormSettings.dialect = "MicrosoftSQLServer";
	this.ormSettings.flushatrequestend = false;


	ormreload();

} 

