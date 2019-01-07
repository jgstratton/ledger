<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<cfquery>
			CREATE TABLE transactionGenerators (
				id   				int(11)		 NOT NULL AUTO_INCREMENT,
				eventGenerator_id	int(11)		 NOT NULL,
				account_id      	int(11)         DEFAULT NULL,
				category_id     	int(11)         DEFAULT NULL,
				name            	varchar(100)    DEFAULT NULL,
				amount          	decimal(10,2)   DEFAULT NULL,
				note            	varchar(200)    DEFAULT NULL,
				deferDate			int(11)			DEFAULT NULL,
				PRIMARY KEY (id)
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Drop table if exists transactionGenerators;
		</cfquery>
		
	</cffunction>
	
</cfcomponent>