

component {
    this.name = "TestBox" & hash( CreateUUID());
    this.sessionManagement  = true;
    this.setClientCookies   = true;
    this.sessionTimeout     = createTimeSpan( 0, 0, 15, 0 );
    this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );

	this.datasource="tests";

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	// Map back to its root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)$", "" );
	this.mappings[ "/testbox" ] = rootPath;

	// Map resources
	this.mappings[ "/coldbox" ] = this.mappings[ "/tests" ] & "resources/coldbox";
	
    testsPath = getDirectoryFromPath( getCurrentTemplatePath() );


	this.mappings["/model"] = rootPath & "/src/models";
	this.mappings["/controllers"] = rootPath & "/src/controllers";
	this.mappings["/services"] = rootPath & "/src/services";

	this.ormenabled = true;
	this.ormSettings.cfclocation = this.mappings["/model"];
	this.ormSettings.useDBForMapping = false;
	this.ormSettings.datasource = "";
	this.ormSettings.dialect = "MicrosoftSQLServer";
	this.ormSettings.flushatrequestend = false;


	
	public void function onRequestStart() {
		ormreload();
	}
}