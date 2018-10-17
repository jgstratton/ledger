<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- create the transfers table --->
		<cfquery>
			CREATE TABLE transfers (
				id   			int(11)		NOT NULL AUTO_INCREMENT,
				fromTransaction int(11)		NOT NULL,
				toTransaction   int(11)		NOT NULL,

				PRIMARY KEY (id)
			)
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the transfers table --->
		<cfquery>
			Drop table if exists transfers;
		</cfquery>
		
	</cffunction>
</cfcomponent>