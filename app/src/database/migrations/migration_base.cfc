<cfcomponent output="false">

	<cfproperty name="datasource" type="string" />

	<cffunction name="init" access="public" output="false" returntype="any" hint="Constructor">
		<cfargument name="datasource" type="string" required="true" />
		<cfset this.datasource = arguments.datasource />
		<cfreturn this />
    </cffunction>

    <cffunction 
        name="migrate_up" 
        access="public" 
        output="false"
        returntype="void">
	
	</cffunction>

    <cffunction 
        name="migrate_down" 
        access="public" 
        output="false" 
        returntype="void">
	
	</cffunction>


</cfcomponent>