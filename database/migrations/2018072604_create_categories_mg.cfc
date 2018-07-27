<cfcomponent output="true">

	<cfproperty name="datasource" type="string" />

	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="datasource" type="string" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfreturn this />
	</cffunction>

    <cffunction 
        name="migrate_up" 
        access="public" 
        output="true" 
        returntype="void">

		<cfquery name="migrate_up" datasource="#variables.datasource#">

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

            <!--- Insert some starting categories --->
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
	</cffunction>

    <cffunction 
        name="migrate_down" 
        access="public" 
        output="true" 
        returntype="void">

		<cfquery name="migrate_up" datasource="#variables.datasource#">

			Drop Table if exists categories;

		</cfquery>	
    </cffunction>
    
</cfcomponent>






