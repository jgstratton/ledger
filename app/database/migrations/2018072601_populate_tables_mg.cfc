<cfcomponent output="true" extends="migration_base">

	<cffunction 
		name="migrate_up" 
		access="public" 
		output="true" 
		returntype="void">

		<!--- Create the default user --->
		<cfquery datasource="#this.datasource#">
			Insert into users (username)
			values ('defaultUser')
		</cfquery>	

		<!---Pre-populate with some basic types --->
		<cfquery datasource="#this.datasource#">
			
			Insert Into categoryTypes (name,multiplier)
			values 
				('Bills',-1),
				('Expenses',-1),
				('Income',1),
				('Transfer From',-1),
				('Transfer Into',1);

		</cfquery>

		<!--- Insert some starting categories --->
		<cfquery datasource="#this.datasource#">
			Insert Into categories(name,categoryType_id)
			Values 
				('Clothing',                2),
				('Credit Card Payments',    2),
				('Dining Out',              2),
				('Entertainment',           2),
				('Fees',                    2),
				('Gifts',                   2),
				('Groceries',               2),
				('Healthcare',              2),
				('Household',               2),
				('Miscellaneous',           2),
				('Taxes',                   2),
				('Utilities',               1),
				('Income/Interest',         3),
				('Not an Expense',          3),
				('Wages & Salary',          3),
				('Smoking/Drinking',        2),
				('Gas',                     2),
				('Returns/Deposits',        3),
				('Bills',                   1),
				('Savings',                 2),
				('Transfer From',           4),
				('Transfer Into',           5),
				('Vacation/Trips',          2),
				('Insurance',               2)

		</cfquery>

		<!---Pre-populate with some basic types --->
		<cfquery datasource="#this.datasource#">
	
			Insert Into accountTypes (name)
			values 
				('Checking Account'),
				('Credit Card'),
				('Loans'),
				('Savings Accounts'),
				('Other');

		</cfquery>

	</cffunction>

	<cffunction 
		name="migrate_down" 
		access="public" 
		output="true" 
		returntype="void">


		<cfquery datasource="#this.datasource#">
			Delete From accountTypes
		</cfquery>

		<cfquery datasource="#this.datasource#">
			Delete From categories
		</cfquery>

		<cfquery datasource="#this.datasource#">
			Delete From categoryTypes
		</cfquery>

		<cfquery datasource="#this.datasource#">
			Delete From users
		</cfquery>

	</cffunction>
</cfcomponent>