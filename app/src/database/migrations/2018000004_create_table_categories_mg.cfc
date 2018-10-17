<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the categories table --->
		<cfquery>

			CREATE TABLE categories (
				id              int(11)     NOT NULL AUTO_INCREMENT,
				name            varchar(50) DEFAULT NULL,
				categoryType_id int(11)     DEFAULT NULL,
				created         datetime    DEFAULT now(),
				edited          datetime    DEFAULT NULL,
				deleted         datetime    DEFAULT NULL,
				

				PRIMARY KEY (id),
				KEY FK_categories_categoryType (categoryType_id)

			);
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the categories table --->
		<cfquery>
			Drop Table if exists categories;
		</cfquery>

	</cffunction>
</cfcomponent>