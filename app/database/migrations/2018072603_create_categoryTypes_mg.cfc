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

			CREATE TABLE categorytypes (
                id          int(11)     NOT NULL AUTO_INCREMENT,
                name        varchar(50) DEFAULT NULL,
                multiplier  int(11)     DEFAULT NULL,
                created     datetime    DEFAULT now(),
                edited      datetime    DEFAULT NULL,

                PRIMARY KEY (id)
            );

            <!---Pre-populate with some basic types --->
            Insert Into categoryTypes (name,multiplier)
            values 
                ('Bills',-1),
                ('Expenses',-1),
                ('Income',1),
                ('Transfer From',-1),
                ('Transfer Into',1);

		</cfquery>	
	</cffunction>

    <cffunction 
        name="migrate_down" 
        access="public" 
        output="true" 
        returntype="void">

		<cfquery name="migrate_up" datasource="#variables.datasource#">

			Drop Table if exists categorytypes;

		</cfquery>	
    </cffunction>
    
</cfcomponent>










