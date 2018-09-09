<!--- adapted from... https://github.com/dominknow/CFMigrate --->

<cfcomponent output="true" hint="This component provides the methods necessary to create, run and rollback database migrations">

	<cfproperty name="datasource" type="string" />

	<cffunction
		name="init"
		access="public"
		output="false"
		returntype="any"
		hint="The public constructor">

		<cfargument name="datasource" type="string" required="true" hint="The datasource to operate on" />
	
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.directory_name = getDirectoryFromPath(getCurrentTemplatePath()) />
		<cfset variables.directory_path = "migrations." />

		<cfreturn this />
	</cffunction>

	<cffunction name="run_migrations"
		displayname="run_migrations"
		access="public"
		output="true"
		returntype="boolean"
		hint="Method called to run outstanding migrations, or to roll back to a previous migration">

		<cfargument
			name="migrate_to_version"
			displayName="migration_name"
			type="String"
			required="false"
			hint="If provided, will rollback any previously run migrations to the given migration name.  If omitted, will run all outstanding migrations. Use 0 to roll back all" />

			<cfset var migrations_list = "">
			<cfset var migration_number = "">
			<cfset var get_migrations = "" />
			<cfset var sorted_migrations = "" />
			<cfset var store_migration = "" />

			<cfset migrations_list = get_migration_list() />
			<cfset sorted_migrations = get_migration_files() />

			<!--- If a migration version was provided to revert to, check that it is a valid version
				that was previously run --->
			<cfif isdefined("ARGUMENTS.migrate_to_version") and (ListFind(migrations_list, migrate_to_version) eq 0 and migrate_to_version neq 0)>
				<cfthrow type="cfmigrate.invalid" message="A migration version to revert to was provided, but a previously run migration matching this version number could not be found. You must supply a version that was previously run." />
				<cfabort>
			</cfif>

			<cfif isdefined("ARGUMENTS.migrate_to_version")>
				<!--- The user want to run migrations to a certain migration number. If a previous migration
				has been run, revert it. Do not run migrations that have not been run --->
				<cfloop query="sorted_migrations">
					<cfset migration_number = get_migration_file_number(sorted_migrations.name)>
					<!--- strip the .cfc from the file name --->
					<cfset migration_name = left(sorted_migrations.name, len(sorted_migrations.name) - 4)>

					<!--- If the migration is a later version than the version to revert to,
					and the migration was previously run, revert the migration --->
					<cfif (migration_number gt ARGUMENTS.migrate_to_version) and ListFind(migrations_list, migration_number) neq 0 >
						<!--- wrap the migration in a transaction so if it fails --->
						<cftransaction>
							<cfset migration_cfc = createObject("component", "#variables.directory_path##migration_name#").init(variables.datasource)>
							<cfset migration_cfc.migrate_down() >
							<cfquery name="store_migration" datasource="#variables.datasource#">
								Delete from migrations where migration_number = '#migration_number#'
							</cfquery>
						</cftransaction>
					</cfif>

				</cfloop>
			<cfelse>
			<!--- No migration version was passed in, so run all of the migrations that have not yet been run --->
				<cfloop query="sorted_migrations">
					<cfset migration_number = get_migration_file_number(sorted_migrations.name)>
					<!--- strip the .cfc from the file name --->
					<cfset migration_name = left(sorted_migrations.name, len(sorted_migrations.name) - 4)>

					<!--- If the migration has not been run, run it --->
					<cfif ListFind(migrations_list, migration_number) eq 0 >
						<!--- wrap the migration in a transaction so if it fails --->
						<cftransaction>
							<cfset migration_cfc = createObject("component", "#variables.directory_path##migration_name#").init(variables.datasource)>
							<cfset migration_cfc.migrate_up() >
							<cfquery name="store_migration" datasource="#variables.datasource#">
								Insert into migrations (migration_number, migration_run_at) values
									('#migration_number#', now())
							</cfquery>
						</cftransaction>
					</cfif>

				</cfloop>

			</cfif>

		<cfreturn true />
	</cffunction>

	<cffunction name="list_migrations"
		displayname="list_migrations"
		access="public"
		output="true"
		returntype="any"
		hint="Returns a list of migration files to be run">

		<cfset var migrations_list = "" />
		<cfset var migration_files_sorted = "" />
		<cfset var toRun = arrayNew(1) />
		<cfset var migration_number = "" />

		<cfset migrations_list = get_migration_list() />
		<cfset migration_files_sorted = get_migration_files() />
		<cfloop query="migration_files_sorted">
			<cfset migration_number = get_migration_file_number(migration_files_sorted.name) />
			<cfif NOT listFind(migrations_list, migration_number)>
				<cfset arrayAppend(toRun, migration_files_sorted.name) />
			</cfif>
		</cfloop>

		<cfreturn toRun />
	</cffunction>

	<cffunction name="get_migration_list" access="private" output="false" returntype="any">

		<cfset var get_migrations = "" />
		<cfset var migrations_list = "" />

		<cfquery name="get_migrations" datasource="#variables.datasource#">
			Select migration_number from migrations
		</cfquery>
		<cfset migrations_list = ValueList(get_migrations.migration_number)>

		<cfreturn migrations_list />
	</cffunction>

	<cffunction name="get_migration_files" access="private" output="false" returntype="query">

		<cfset var migration_files = "" />
		<cfset var sorted_migrations = "" />
		<!--- get the list of migration cfc's from the migrations folder --->
		<cfdirectory action="LIST"
			directory="#variables.directory_name#"
			name="migration_files"
			filter="*_mg.cfc"> <!--- valid migration files must end in _mg --->

		<cfquery name="sorted_migrations" dbtype="query">
				select * from migration_files
				order by name ASC
		</cfquery>

		<cfreturn sorted_migrations />
	</cffunction>

	<cffunction name="get_migration_file_number" access="private" output="false" returntype="string">
		<cfargument name="migrationFileName" type="string" required="true" />
		<cfset var st = "">
		<cfset var REmigration_version = "\d{10}">

		<cfset st = REFind(REmigration_version,arguments.migrationFileName,1,"TRUE")>
		<cfreturn Mid(arguments.migrationFileName,st.pos[1],st.len[1])>
	</cffunction>

	<cffunction name="refresh_migrations" access="public" output="false" returntype="boolean" hint="Clear all loaded migrations">
		<cfreturn variables.run_migrations(0)> 
	</cffunction>
</cfcomponent>