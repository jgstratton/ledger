<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<cfquery>
			CREATE TABLE schedularTypes (
				id   				int(11)		 	NOT NULL AUTO_INCREMENT,
				name				varchar(50)		DEFAULT NULL,
				allowedParameters	varchar(500)	DEFAULT NULL,
				PRIMARY KEY (id)
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Drop table if exists schedularTypes;
		</cfquery>
		
	</cffunction>
	
</cfcomponent>