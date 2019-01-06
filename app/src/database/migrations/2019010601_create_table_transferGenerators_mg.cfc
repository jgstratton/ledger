<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<cfquery>
			CREATE TABLE transferGenerators (
				id   				int(11)		 NOT NULL AUTO_INCREMENT,
				eventGenerator_id	int(11)		 NOT NULL,
				fromAccount_id		int(11)		 NOT NULL,
				toAccount_id		int(11) 	 NOT NULL,
				amount          	decimal(10,2)   DEFAULT NULL,
				name            	varchar(100)    DEFAULT NULL,

				PRIMARY KEY (id)
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Drop table if exists transferGenerators;
		</cfquery>
		
	</cffunction>
	
</cfcomponent>
