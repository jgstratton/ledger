<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Add disabled column --->
		<cfquery>
			ALTER TABLE accounts 
            ADD COLUMN disabled TINYINT(1) DEFAULT 0;
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the disabled column --->
		<cfquery>
			ALTER TABLE accounts 
            DROP COLUMN disabled;
		</cfquery>
		
	</cffunction>
</cfcomponent>