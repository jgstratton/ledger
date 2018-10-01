<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the users table --->
		<cfquery datasource="#this.datasource#">
			Create table users (
				id 				int(11) 		NOT NULL AUTO_INCREMENT,
				username	 	varchar(50) 	DEFAULT NULL,
				email 			varchar(255) 	DEFAULT NULL,
				created 		datetime 		DEFAULT NULL,
				edited 			datetime 		DEFAULT NULL,

				PRIMARY KEY (id)
			);
		</cfquery>

		<!--- Create the accounts table --->
		<cfquery datasource="#this.datasource#">

			CREATE TABLE accounts (

				id 			  int(11) 		NOT NULL AUTO_INCREMENT,
				name 		  varchar(100) 	DEFAULT NULL,
				linkedAccount int(11) 		Default null,
				summary	      char(1)		default 'N',
				created 	  datetime 		DEFAULT NULL,
				edited 	      datetime 		DEFAULT NULL,
				deleted 	  datetime 		DEFAULT NULL,
				user_id 	  int(11) 		DEFAULT NULL,
				accountType_id int(11)	DEFAULT NULL,

				PRIMARY KEY (id),
				KEY FK_accounts_user (user_id),
				KEY FK_accounts_accountTypes (accountType_id)
			);

		</cfquery>	

		<!--- Create the transactions table --->
		<cfquery datasource="#this.datasource#">

			create table transactions (
                id              int(11)         NOT NULL AUTO_INCREMENT,
                name            varchar(100)    DEFAULT NULL,
                transactionDate date            DEFAULT NULL,
                amount          decimal(10,2)   DEFAULT NULL,
                note            varchar(200)    DEFAULT NULL,
                verifiedDate    datetime        DEFAULT NULL,
                created         datetime        DEFAULT NULL,
                edited          datetime        DEFAULT NULL,
                deleted         datetime        DEFAULT NULL,
                account_id      int(11)         DEFAULT NULL,
                category_id     int(11)         DEFAULT NULL,

                PRIMARY KEY (id),
                KEY FK_transactions_account (account_id),
                KEY FK_transactions_category (category_id)

            );

		</cfquery>	

		<!--- Create the Category Types table --->
		<cfquery datasource="#this.datasource#">

			CREATE TABLE categoryTypes (
				id          int(11)     NOT NULL AUTO_INCREMENT,
				name        varchar(50) DEFAULT NULL,
				multiplier  int(11)     DEFAULT NULL,
				created     datetime    DEFAULT now(),
				edited      datetime    DEFAULT NULL,

				PRIMARY KEY (id)
			);
		</cfquery>

		<!--- Create the categories table --->
		<cfquery datasource="#this.datasource#">

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

		<!--- Create the accounts types table --->
		<cfquery datasource="#this.datasource#">

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
		<cfquery datasource="#this.datasource#">
			Drop Table if exists accountTypes;
		</cfquery>
		
		<!--- Drop the categories table --->
		<cfquery datasource="#this.datasource#">
			Drop Table if exists categories;
		</cfquery>

		<!--- Drop the categoryTypes table --->
		<cfquery datasource="#this.datasource#">
			Drop Table if exists categoryTypes;
		</cfquery>	

		<!--- Drop the transactions table --->
		<cfquery datasource="#this.datasource#">
			Drop Table if exists transactions;
		</cfquery>

		<!--- Drop the accounts table --->
		<cfquery datasource="#this.datasource#">
			Drop Table if exists accounts;
		</cfquery>


		<!--- Drop the users table --->
		<cfquery datasource="#this.datasource#">
			Drop table if exists users;
		</cfquery>	

	</cffunction>
</cfcomponent>