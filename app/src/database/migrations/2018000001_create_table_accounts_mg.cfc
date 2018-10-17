<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the accounts table --->
		<cfquery>

			CREATE TABLE accounts (

				id 			  int(11) 		NOT NULL AUTO_INCREMENT,
				name 		  varchar(100) 	DEFAULT NULL,
				linkedAccount int(11) 		Default null,
				summary	      char(1)		default 'N',
				created 	  datetime 		DEFAULT NULL,
				edited 	      datetime 		DEFAULT NULL,
				deleted 	  datetime 		DEFAULT NULL,
				user_id 	  int(11) 		DEFAULT NULL,
				accountType_id int(11)	DEFAULT NULL,

				PRIMARY KEY (id),
				KEY FK_accounts_user (user_id),
				KEY FK_accounts_accountTypes (accountType_id)
			);

		</cfquery>	
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the accounts table --->
		<cfquery>
			Drop Table if exists accounts;
		</cfquery>

	</cffunction>
</cfcomponent>