<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the magic_link_tokens table --->
		<cfquery>
			CREATE TABLE magic_link_tokens (
				id 				int(11) 		NOT NULL AUTO_INCREMENT,
				token 			varchar(255) 	NOT NULL,
				email 			varchar(255) 	NOT NULL,
				expires 		datetime 		NOT NULL,
				created 		datetime 		NOT NULL,
				
				PRIMARY KEY (id),
				KEY idx_magic_token (token)
			);
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the magic_link_tokens table --->
		<cfquery>
			DROP TABLE IF EXISTS magic_link_tokens;
		</cfquery>	

	</cffunction>
</cfcomponent>
