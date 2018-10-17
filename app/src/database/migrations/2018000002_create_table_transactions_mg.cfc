<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the transactions table --->
		<cfquery>

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
		
	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Drop the transactions table --->
		<cfquery>
			Drop Table if exists transactions;
		</cfquery>

	</cffunction>
</cfcomponent>