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
	
		<cfset this.datasource = arguments.datasource />
		<cfset this.directory_name = getDirectoryFromPath(getCurrentTemplatePath()) />
		<cfset this.directory_path = "migrations." />

		<cfquery name="get_migrations" datasource="#this.datasource#">
            <!--- If the migrations table doesn't exist yet, then create it now --->
			Create Table if not exists migrations (migration_number varchar(14), migration_run_at datetime)
		</cfquery>

		<cfreturn this />
	</cffunction>
	<cffunction name="run_migrations"
		displayname="run_migrations"
		access="public"
		output="true"
		returntype="boolean"
		hint="Method called to run outstanding migrations, or to roll back to a previous migration">

        <!---
            migrate_to_version

            - If provided and less than last run migration, then it will rollback to given migration number
            - If provided and less greater than last run migration, then it will run up to (and including) that number
            - If omitted, it runs all migrations up to the current version
            - If 0, it refreshes all migrations
        --->
		<cfargument
			name="migrate_to_version"
			displayName="migration_name"
			type="String"
			required="false"
			hint="If provided, will rollback any previously run migrations to the given migration name.  If omitted, will run all outstanding migrations. Use 0 to roll back all" />

			<cfset var migrations_list = "">
			<cfset var migration_number = "">
			<cfset var get_migrations = "" />
			<cfset var migration_files = "" />
			<cfset var store_migration = "" />
			<cfset var i = "" />

			<cfset migrations_list = get_migration_list() />
			<cfset migration_files = get_migration_files() />

            <!--- 
                If a migration version was provided and it is less than the last run migration,
                then rollback the migrations until we hit that version
            --->
			
            <cfif isdefined("arguments.migrate_to_version")>
                
                <!--- If the "migrate to" is greater than last ran migration, then run all the migrations up to that point --->
                <cfif arguments.migrate_to_version gt listLast(migrations_list)>
                    <cfloop query="migration_files">
                        <cfset migration_number = get_migration_file_number(migration_files.name)>
                        <!--- strip the .cfc from the file name --->
                        <cfset migration_name = left(migration_files.name, len(migration_files.name) - 4)>
    
                        <!--- 
                            If the migration hasn't been run yet, then run the migration
                        --->
                        <cfif (arguments.migrate_to_version gte migration_number) and ListFind(migrations_list, migration_number) eq 0 >
                            <!--- wrap the migration in a transaction so if it fails --->
                            <cftransaction>
                                <cfset migration_cfc = createObject("component", "#this.directory_path##migration_name#").init(this.datasource)>
                                <cfset migration_cfc.migrate_up() >
                                <cfquery name="store_migration" datasource="#this.datasource#">
                                    Insert into migrations (migration_number, migration_run_at) 
                                    values ('#migration_number#', getdate())
                                </cfquery>
                            </cftransaction>
                        </cfif>
    
                    </cfloop>
                
                <!--- If the "migrate to" is less than the last ran migration, then we need to revert the migrations down until we hit the target version --->
				<cfelseif arguments.migrate_to_version lt listLast(migrations_list)>

                    <cfloop from="#migration_files.recordcount#" to="1" index="i" step="-1">
                        <cfset migration_number = get_migration_file_number(migration_files.name[i])>
                        <cfset migration_name = left(migration_files.name[i], len(migration_files.name[i]) - 4)>

                        <cfif (migration_number gt arguments.migrate_to_version) and ListFind(migrations_list, migration_number) gt 0 >
              
                            <cftransaction>
                                <cfset migration_cfc = createObject("component", "#this.directory_path##migration_name#").init(this.datasource)>
                                <cfset migration_cfc.migrate_down() >
                                <cfquery name="remove_migration" datasource="#this.datasource#">
                                    Delete from migrations where migration_number = '#migration_number#'
                                </cfquery>
                            </cftransaction>

                        </cfif>
                    </cfloop>

                </cfif>

            </cfif>

       
            <cfif Not StructKeyExists(arguments,"migrate_to_version")>
                
			    <!--- No migration version was passed in, so run all of the migrations that have not yet been run --->
				<cfloop query="migration_files">
					<cfset migration_number = get_migration_file_number(migration_files.name)>
					<!--- strip the .cfc from the file name --->
					<cfset migration_name = left(migration_files.name, len(migration_files.name) - 4)>

					<!--- If the migration has not been run, run it --->
					<cfif ListFind(migrations_list, migration_number) eq 0 >
						<!--- wrap the migration in a transaction so if it fails --->
						<cftransaction>
							<cfset migration_cfc = createObject("component", "#this.directory_path##migration_name#").init(this.datasource)>
							<cfset migration_cfc.migrate_up() >
							<cfquery name="store_migration" datasource="#this.datasource#">
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

    <cffunction 
        name="get_migration_list" 
        access="private" 
        output="false" 
        returntype="any">

		<cfset var get_migrations = "" />
		<cfset var migrations_list = "" />

        <cfquery name="get_migrations" datasource="#this.datasource#">
            Select migration_number from migrations
            order by migration_number
		</cfquery>
		<cfset migrations_list = ValueList(get_migrations.migration_number)>

		<cfreturn migrations_list />
	</cffunction>

    <cffunction 
        name="get_migration_files" 
        access="public" 
        output="false" 
        returntype="query">

		<cfset var migration_files_unsorted = "" />
		<cfset var migration_Files = "" />
		<!--- get the list of migration cfc's from the migrations folder --->
		<cfdirectory action="LIST"
			directory="#this.directory_name#"
			name="migration_files_unsorted"
			filter="*_mg.cfc"> <!--- valid migration files must end in _mg --->

		<cfquery name="migration_Files" dbtype="query">
				select * from migration_files_unsorted
				order by name ASC
		</cfquery>

		<cfreturn migration_Files />
	</cffunction>

	<cffunction name="get_migration_file_number" access="private" output="false" returntype="string">
		<cfargument name="migrationFileName" type="string" required="true" />
		<cfset var st = "">
		<cfset var REmigration_version = "\d{10}">

		<cfset st = REFind(REmigration_version,arguments.migrationFileName,1,"TRUE")>
		<cfreturn Mid(arguments.migrationFileName,st.pos[1],st.len[1])>
	</cffunction>

	<cffunction name="refresh_migrations" access="public" output="false" returntype="boolean" hint="Clear all loaded migrations">
		<cfreturn this.run_migrations(0)> 
		<cfreturn this.run_migrations()> 
	</cffunction>
</cfcomponent>