<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<cfquery>
			CREATE TABLE schedular (
				id   				int(11)		NOT NULL AUTO_INCREMENT,
				schedularType_id   	int(11)		NOT NULL,
				eventGenerator_id	int(11)		NOT NULL,
				startDate			date		NOT NULL,
				monthsOfYear		varchar(20) DEFAULT NULL,
				daysOfMonth			varchar(50) DEFAULT NULL,
				dayInterval 		int(11) DEFAULT NULL,
				status 				varchar(20) DEFAULT NULL,

				PRIMARY KEY (id)
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Drop table if exists schedular;
		</cfquery>
		
	</cffunction>
	
</cfcomponent>