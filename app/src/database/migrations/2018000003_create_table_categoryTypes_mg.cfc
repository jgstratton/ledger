<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the Category Types table --->
		<cfquery>

			CREATE TABLE categoryTypes (
				id          int(11)     NOT NULL AUTO_INCREMENT,
				name        varchar(50) DEFAULT NULL,
				multiplier  int(11)     DEFAULT NULL,
				created     datetime    DEFAULT now(),
				edited      datetime    DEFAULT NULL,

				PRIMARY KEY (id)
			);
		</cfquery>	
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the categoryTypes table --->
		<cfquery>
			Drop Table if exists categoryTypes;
		</cfquery>

	</cffunction>
</cfcomponent>