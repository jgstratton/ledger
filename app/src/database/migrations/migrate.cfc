<!--- adapted from... https://github.com/dominknow/CFMigrate --->

/**
 * This component provides the methods necessary to create, run and rollback database migrations
 */
component{
	property name="file_ends";

	public any function init(string file_ends = "_mg") {
		this.file_ends = arguments.file_ends;
		this.directory_name = getDirectoryFromPath( getCurrentTemplatePath() );
		this.directory_path = "migrations.";

		// If the migrations table doesn't exist yet, then create it now 
		QueryExecute("
			Create Table if not exists migrations (migration_number varchar(14), migration_run_at datetime)
		");

		return this;
	}

	/**
	 * Method called to run outstanding migrations, or to roll back to a previous migration
	 *
	 * @migrate_to_version 
	 * 	- If provided and less than last run migration, then it will rollback to given migration number
     *  - If provided and less greater than last run migration, then it will run up to (and including) that number
     *  - If omitted, it runs all migrations up to the current version
     *  - If 0, it refreshes all migrations
	 * 
	 */
	public void function run_migrations(string migrate_to_version) {
		var migrations_list = get_migration_list() ;
		var migration_files = get_migration_files();
		getLogger().debug("Migrating to version: #arguments.migrate_to_version#");
		getLogger().debug(" --- list used: #migrations_list#");

		// If a migration version was provided and it is less than the last run migration,
		// then rollback the migrations until we hit that version

		if( structKeyExists(arguments,"migrate_to_version") ){
			// If the "migrate to" is greater than last ran migration, then run all the migrations up to that point
			if( arguments.migrate_to_version > listLast( migrations_list ) ){

				getLogger().debug(" #arguments.migrate_to_version# is greater than #listLast( migrations_list )#...");

				for( migrationFile in migration_files ){
					var migration_number = get_migration_file_number( migrationFile.name );
					// strip the .cfc from the file name
					var migration_name = left( migrationFile.name, len(migrationFile.name) - 4 );
					// If the migration hasn't been run yet, then run the migration
					if( arguments.migrate_to_version >= migration_number and listFind( migrations_list, migration_number ) == 0 ){
					var migration_cfc = createObject("component", "#this.directory_path##migration_name#").init();
						run_migration(migration_cfc, migration_number);
					}
				}

			 // If the "migrate to" is less than the last ran migration, then we need to revert the migrations down until we hit the target version
			} else if( arguments.migrate_to_version < listLast( migrations_list ) ){

				getLogger().debug(" #arguments.migrate_to_version# is less than #listLast( migrations_list )#...");

				for( var i = migration_files.recordcount; i >= 1; i--){
					var migration_number = get_migration_file_number( migration_files.name[i] );
					var migration_name = left( migration_files.name[i], len(migration_files.name[i]) - 4);
					if( migration_number > arguments.migrate_to_version and listFind(migrations_list, migration_number) > 0 ){
						var migration_cfc = createObject("component", "#this.directory_path##migration_name#").init();
						revert_migration(migration_cfc, migration_number);

					}
				}
			}

		} else {

			// No migration version was passed in, so run all of the migrations that have not yet been run
			for( migrationFile in migration_files ){
				var migration_number = get_migration_file_number( migrationFile.name );
				var migration_name = left( migrationFile.name, len(migrationFile.name) - 4 );

				//if the migration has not been run yet then run it
				if( listFind( migrations_list, migration_number ) == 0 ){

					getLogger().debug("#migration_number# has not yet been run, running now:");

					var migration_cfc = createObject("component", "#this.directory_path##migration_name#").init();
					run_migration(migration_cfc, migration_number);

				}
			}
		}

	}

	public void function run_migration( component migration, string migration_number ){
		getLogger().debug("Migrate up #migration_number#");
		transaction{
			try{	
				migration.migrate_up();
				queryExecute("
					Insert into migrations (migration_number, migration_run_at) 
					values (:migration_number, now())
					", {migration_number: migration_number});
			} catch(any e) {
				getLogger().error("Error running migration: #migration_number#.. attempting to roll back changes");
				try{
					migration.migrate_down();
				} catch(any e) {
					getLogger().error("Error during rollback: #e.message#");
				}
				
				rethrow;
			}
		}
	}

	public void function revert_migration( component migration, string migration_number ){
		getLogger().debug("Migrate down #migration_number#");
		transaction{
			try{
				migration.migrate_down();
				queryExecute("
					Delete from migrations 
					where migration_number = :migration_number
				", { migration_number: migration_number} );
			} catch( any e) {
				migration.migrate_up();
				getLogger().error("Error reverting migration: #migration_number#");
				rethrow;
			}
		}
	}

	/**
	 * list_migrations
	 * 
	 * Returns an array of migration files names to be run
	 */
	public array function list_migrations(){
		var migrationsNeedRan = [];
		var migrations_list = get_migration_list();
		var migration_files_sorted = get_migration_files();

		for( migration_file in migration_files_sorted ){
			var migration_number = get_migration_file_number(migration_files_sorted.name);
			if( !listFind( migrations_list, migration_number ) ){
				migrationsNeedRan.append(migration_files_sorted.name);
			}
		}

		return migrationsNeedRan;
	}

	/**
	 * return a list of migation numbers that have already been run
	 */
	private string function get_migration_list() {
		var get_migrations = queryExecute("
			Select migration_number from migrations
			order by migration_number
		");
		return valueList(get_migrations.migration_number);
	}

	public query function get_migration_files(){
		var fileEndsArray = listToArray(this.file_ends);
		var filter = '';

		for( fileEnd in fileEndsArray ){
			filter = listAppend(filter, "*#fileEnd#.cfc","|");
		}

		var migration_files_unsorted = directoryList("#this.directory_name#", false, "query", filter);
		var migration_files_sorted = queryExecute("
			select * from migration_files_unsorted
			order by name ASC
		", {}, { dbtype: "query" } );

		return migration_files_sorted;
	}

	private function get_migration_file_number(string migrationFileName){
		var REmigration_version = "\d{10}";
		var st = ReFind(Remigration_version, arguments.migrationFileName,1,"true");
		return mid( arguments.migrationFileName, st.pos[1], st.len[1] );
	}

	/**
	 * refresh_migrations
	 * 
	 * @migrate_to_version
	 *  - If provided, will rollback any previously run migrations to the given migration name.  
	 *  - If omitted, will run all outstanding migrations. Use 0 to roll back all
	 */
	public void function refresh_migrations( migrate_to_version ){
		run_migrations(0);
		if( structKeyExists(arguments, "migrate_to_version" ) ){
			run_migrations( arguments.migrate_to_version );
		} else {
			run_migrations();
		}
	}

	private any function getLogger(){
		return new services.logger();
	}

}