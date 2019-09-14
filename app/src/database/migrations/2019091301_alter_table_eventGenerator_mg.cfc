<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Add deleted column --->
		<cfquery>
			ALTER TABLE eventGenerators 
            ADD COLUMN deleted TINYINT DEFAULT 0;
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the transfers table --->
		<cfquery>
			ALTER TABLE eventGenerators 
            DROP COLUMN deleted;
		</cfquery>
		
	</cffunction>
</cfcomponent>