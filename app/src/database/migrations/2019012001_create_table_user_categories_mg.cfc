<cfcomponent output="true" extends="migration_base">

	<cffunction name="migrate_up" access="public" output="true" returntype="void">

		<cfquery>
			CREATE TABLE userCategories (
				user_id			int(11)		 NOT NULL,
				category_id		int(11)		 NOT NULL,
				PRIMARY KEY (user_id, category_id)
			)
		</cfquery>

	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">

		<cfquery>
			Drop Table if exists userCategories;
		</cfquery>

	</cffunction>
</cfcomponent>