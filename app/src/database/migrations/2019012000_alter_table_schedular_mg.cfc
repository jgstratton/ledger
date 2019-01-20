<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<cfquery>
			ALTER TABLE schedular MODIFY monthsOfYear VARCHAR(100);
		</cfquery>
		<cfquery>
			ALTER TABLE schedular MODIFY daysOfMonth VARCHAR(100);
		</cfquery>

	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			ALTER TABLE schedular MODIFY monthsOfYear VARCHAR(20);
		</cfquery>
		<cfquery>
			ALTER TABLE schedular MODIFY daysOfMonth VARCHAR(50);
		</cfquery>

	</cffunction>
</cfcomponent>