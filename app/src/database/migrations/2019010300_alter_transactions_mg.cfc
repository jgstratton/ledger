<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- create the transfers table --->
		<cfquery>
			ALTER TABLE transactions 
            ADD COLUMN isHidden TINYINT DEFAULT 0;
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the transfers table --->
		<cfquery>
			ALTER TABLE transactions 
            DROP COLUMN isHidden;
		</cfquery>
		
	</cffunction>
</cfcomponent>