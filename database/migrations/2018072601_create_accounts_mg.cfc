<cfcomponent output="true">

	<cfproperty name="datasource" type="string" />

	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="datasource" type="string" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfreturn this />
	</cffunction>

	<cffunction name="migrate_up" access="public" output="true" returntype="void">
		<cfquery name="migrate_up" datasource="#variables.datasource#">

			CREATE TABLE accounts (

				id 		int(11) 		NOT NULL AUTO_INCREMENT,
				name 	varchar(100) 	DEFAULT NULL,
				created datetime 		DEFAULT NULL,
				edited 	datetime 		DEFAULT NULL,
				deleted datetime 		DEFAULT NULL,
				user_id int(11) 		DEFAULT NULL,

				PRIMARY KEY (id),
				KEY FK_accounts_user (user_id)
			);

		</cfquery>	
	</cffunction>

	<cffunction name="migrate_down" access="public" output="true" returntype="void">
		<cfquery name="migrate_up" datasource="#variables.datasource#">

			Drop Table if exists accounts;

		</cfquery>	
	</cffunction>
</cfcomponent>