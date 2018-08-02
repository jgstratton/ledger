<cfcomponent output="true">

	<cfproperty name="datasource" type="string" />

	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="datasource" type="string" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfreturn this />
	</cffunction>

	<cffunction name="migrate_up" access="public" output="true" returntype="void">
		<cfquery name="migrate_up" datasource="#variables.datasource#">
			

			Create table users (
				id 				int(11) 		NOT NULL AUTO_INCREMENT,
				username	 	varchar(50) 	DEFAULT NULL,
				emailaddress 	varchar(255) 	DEFAULT NULL,
				created 		datetime 		DEFAULT NULL,
				edited 			datetime 		DEFAULT NULL,

				PRIMARY KEY (id)
			);

			<!--- Create the default user --->
			Insert into users (username)
			values ('defaultUser')

		</cfquery>	
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">
		<cfquery name="migrate_up" datasource="#variables.datasource#">
			
			Drop table if exists users;
			
		</cfquery>	
	</cffunction>
</cfcomponent>