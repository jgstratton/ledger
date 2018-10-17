<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the accounts types table --->
		<cfquery>

			CREATE TABLE accountTypes (

				id 		int(11) 		NOT NULL AUTO_INCREMENT,
				name 	varchar(100) 	DEFAULT NULL,
				sortWeight int(11)		DEFAULT 1,
				fa_icon varchar(20)		DEFAULT NULL,
				isVirtual boolean		DEFAULT 0,
				created datetime 		DEFAULT NULL,
				edited 	datetime 		DEFAULT NULL,

				PRIMARY KEY (id)
			);
		</cfquery>
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the accounttypes table --->
		<cfquery>
			Drop Table if exists accountTypes;
		</cfquery>

	</cffunction>
</cfcomponent>