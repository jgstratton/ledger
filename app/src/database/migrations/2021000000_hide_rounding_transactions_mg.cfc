<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<!--- Hide transactions if their linked transaction is also hidden --->
		<cfquery>
			UPDATE transactions b
			JOIN transactions a
				ON a.id = b.linkedTransId
				AND b.isHidden = 1
			SET a.isHidden = 1
		</cfquery>

	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">
		<!--- No rollback --->
	</cffunction>
</cfcomponent>