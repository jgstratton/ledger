<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the users table --->
		<cfquery>
			Create table users (
				id 				int(11) 		NOT NULL AUTO_INCREMENT,
				username	 	varchar(50) 	DEFAULT NULL,
				email 			varchar(255) 	DEFAULT NULL,
				created 		datetime 		DEFAULT NULL,
				edited 			datetime 		DEFAULT NULL,

				PRIMARY KEY (id)
			);
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the users table --->
		<cfquery>
			Drop table if exists users;
		</cfquery>	

	</cffunction>
</cfcomponent>