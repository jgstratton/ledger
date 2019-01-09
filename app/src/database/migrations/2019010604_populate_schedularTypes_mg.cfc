<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<!---Pre-populate with some basic types --->
		<cfquery>
			Insert Into schedularTypes (name, allowedParameters)
			values 
				('Date','monthsOfYear,daysOfMonth'),
				('Interval','startDate,dayInterval')
		</cfquery>

	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Delete From schedularTypes
		</cfquery>

	</cffunction>
</cfcomponent>