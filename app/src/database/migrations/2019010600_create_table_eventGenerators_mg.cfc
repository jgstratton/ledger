<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<cfquery>
			CREATE TABLE eventGenerators (
				id   				int(11)		 NOT NULL AUTO_INCREMENT,
				user_id				int(11)		 NOT NULL,
				eventName			varchar(50)  DEFAULT '',
				created         	datetime     DEFAULT NULL,
                edited         		datetime     DEFAULT NULL,

				PRIMARY KEY (id)
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Drop table if exists eventGenerators;
		</cfquery>
		
	</cffunction>
	
</cfcomponent>