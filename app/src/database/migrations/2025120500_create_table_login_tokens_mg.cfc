<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the login_tokens table --->
		<cfquery>
			CREATE TABLE login_tokens (
				id 				int(11) 		NOT NULL AUTO_INCREMENT,
				token 			varchar(255) 	NOT NULL,
				user_id 		int(11) 		NOT NULL,
				expires 		datetime 		NOT NULL,
				created 		datetime 		NOT NULL,
				
				PRIMARY KEY (id),
				KEY idx_token (token),
				CONSTRAINT fk_login_tokens_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
			);
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the login_tokens table --->
		<cfquery>
			DROP TABLE IF EXISTS login_tokens;
		</cfquery>	

	</cffunction>
</cfcomponent>